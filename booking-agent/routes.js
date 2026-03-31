const express = require("express");
const Anthropic = require("@anthropic-ai/sdk");
const db = require("./db");

const router = express.Router();
const ai = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

let toursCache = null;
let cacheTime = null;

async function getTours() {
  if (toursCache && Date.now() - cacheTime < 5 * 60 * 1000) {
    return toursCache;
  }
  const [rows] = await db.execute(`
    SELECT
      t.tour_id,
      tt.tour_name,
      tt.description        AS description,
      t.price               AS base_price,
      c.symbol              AS currency,
      ct.category_name,
      dlt.difficulty_level_name,
      t.time_interval_value AS duration_days,
      e.event_id,
      e.event_price,
      e.start_date_time,
      e.end_date_time,
      e.max_client_amount
    FROM tours t
    JOIN tour_translations tt ON tt.tour_id = t.tour_id AND tt.language_id = 2
    LEFT JOIN currency c ON c.currency_id = t.currency_id
    LEFT JOIN category_translations ct ON ct.category_id = t.category_id AND ct.language_id = 2
    LEFT JOIN difficulty_level_translations dlt ON dlt.difficulty_level_id = t.difficulty_level_id AND dlt.language_id = 1
    LEFT JOIN events e ON e.tour_id = t.tour_id
      AND e.is_deleted = 0
      AND e.active_status = 1
      AND e.start_date_time > NOW()
    WHERE t.is_deleted = 0
    ORDER BY t.tour_id, e.start_date_time
  `);

  const map = {};
  for (const row of rows) {
    if (!map[row.tour_id]) {
      map[row.tour_id] = {
        tour_id: row.tour_id,
        name: row.tour_name,
        description: (row.description || "").replace(/<[^>]+>/g, "").trim(),
        price: row.base_price,
        currency: row.currency || "₾",
        category: row.category_name || "",
        difficulty: row.difficulty_level_name || "",
        duration_days: row.duration_days,
        events: [],
      };
    }
    if (row.event_id) {
      map[row.tour_id].events.push({
        event_id: row.event_id,
        price: row.event_price || row.base_price,
        start: row.start_date_time,
        end: row.end_date_time,
        spots: row.max_client_amount,
      });
    }
  }

  toursCache = Object.values(map);
  cacheTime = Date.now();
  return toursCache;
}

function formatToursForAI(tours) {
  return tours
    .map((t) => {
      const freeEvents = t.events.filter((e) => e.spots > 0);
      if (freeEvents.length === 0) return null;

      const eventLines = freeEvents
        .map((e) => {
          const start = new Date(e.start).toLocaleString("ka-GE", { dateStyle: "medium", timeStyle: "short" });
          const end = new Date(e.end).toLocaleString("ka-GE", { dateStyle: "medium", timeStyle: "short" });
          return `    • ${start} → ${end} | ₾${e.price}/კაცი | ადგილი: ${e.spots} | event_id:${e.event_id}`;
        })
        .join("\n");

      return [
        `[tour_id:${t.tour_id}] ${t.name}`,
        `  კატეგორია: ${t.category || "—"} | სიძნელე: ${t.difficulty || "—"} | ხანგრძლივობა: ${t.duration_days ? t.duration_days + " დღე" : "—"}`,
        `  ფასი: ${t.price}${t.currency}/კაცი`,
        `  აღწერა: ${t.description || "—"}`,
        `  თარიღები:`,
        eventLines,
      ].join("\n");
    })
    .filter(Boolean)
    .join("\n\n");
}

// ============================================================
// POST /chat
// ============================================================
router.post("/chat", async (req, res) => {
  const { messages } = req.body;
  if (!messages || !Array.isArray(messages)) {
    return res.status(400).json({ error: "messages array საჭიროა" });
  }

  const cleanMessages = messages.filter(
    (m) => m.content && m.content.toString().trim() !== "",
  );
  if (cleanMessages.length === 0) {
    return res.status(400).json({ error: "შეტყობინება ცარიელია" });
  }

  try {
    const tours = await getTours();
    const toursText = formatToursForAI(tours);

    const SYSTEM_PROMPT = `შენ ხარ პროფესიონალი ტური ბუქინგ აგენტი.

ხელმისაწვდომი ტურები (მხოლოდ თავისუფალი ადგილებით):
${toursText || "ამჟამად ხელმისაწვდომი ტური არ არის."}

საუბრის სტრუქტურა:
1. პირველი შეტყობინება: კითხვა "სად გინდათ მოგზაურობა? მიუთითეთ ქალაქი, რეგიონი ან ინტერესი."
2. მომხმარებლის პასუხის მიხედვით მირჩიე მხოლოდ შესაფერისი ტურები სადაც ადგილები თავისუფალია.
3. კითხვა: "რამდენი ადამიანისთვის გსურთ დაჯავშნოთ?"
4. დაუთვალე ჯამური ფასი: ფასი × ადამიანების რაოდენობა და მიუთითე.
5. კითხვა: "გსურთ დაჯავშნოთ?" — თუ კი, გამოიკითხე სახელი/გვარი და ტელეფონი.

როცა ყველაფერი გაქვს, დაასრულე პასუხი ზუსტად ასე:
BOOKING_DATA:{"name":"...","phone":"...","tour_id":0,"event_id":0,"people":1}

წესები:
- მხოლოდ ბაზაში არსებული ტურები და თარიღები შესთავაზე
- თუ მომხმარებლის ინტერესი არ ემთხვევა ვერცერთ ტურს, გულწრფელად უთხარი
- ერთდროულად მაქსიმუმ 2 კითხვა დასვი
- ქართულად პასუხობ ქართულზე, ინგლისურად — ინგლისურზე`;

    const response = await ai.messages.create({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 1024,
      system: SYSTEM_PROMPT,
      messages: cleanMessages,
    });

    const aiText = response.content[0].text;
    let booking = null;
    const match = aiText.match(/BOOKING_DATA:(\{.*?\})/s);
    if (match) {
      try {
        booking = await saveBooking(JSON.parse(match[1]));
      } catch (e) {
        console.error("Booking parse error:", e.message);
      }
    }

    res.json({
      text: aiText.replace(/BOOKING_DATA:.*$/s, "").trim(),
      booking,
    });
  } catch (err) {
    console.error("Error:", err.message);
    res.status(500).json({ error: "სერვისთან კავშირი ვერ დამყარდა" });
  }
});

// ============================================================
// შენახვა bookings + clients ცხრილებში
// ============================================================
async function saveBooking(data) {
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    const [[event]] = await conn.execute(
      "SELECT event_price FROM events WHERE event_id = ?",
      [data.event_id],
    );
    const price = event ? event.event_price * (data.people || 1) : null;

    const [bookingResult] = await conn.execute(
      `INSERT INTO bookings
        (event_id, waiting, total_price, client_count, payment_status_id, submit_status, created_at, is_deleted)
       VALUES (?, 0, ?, ?, 1, 1, NOW(), 0)`,
      [data.event_id || null, price, data.people || 1],
    );
    const bookingId = bookingResult.insertId;

    const [clientResult] = await conn.execute(
      `INSERT INTO clients (booking_id, phone, contact_person, created_at, is_deleted)
       VALUES (?, ?, 1, NOW(), 0)`,
      [bookingId, data.phone || null],
    );
    const clientId = clientResult.insertId;

    const nameParts = (data.name || "").trim().split(" ");
    const firstName = nameParts[0] || "";
    const lastName = nameParts.slice(1).join(" ") || "";

    await conn.execute(
      `INSERT INTO client_translations (client_id, language_id, first_name, last_name)
       VALUES (?, 2, ?, ?)`,
      [clientId, firstName, lastName],
    );

    await conn.commit();
    console.log(
      `✅ ჯავშანი #${bookingId}: ${data.name} — event_id:${data.event_id}`,
    );
    return { id: bookingId, ...data, total_price: price };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

// ============================================================
// GET /bookings
// ============================================================
router.get("/bookings", async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT
        b.booking_id, b.total_price, b.client_count, b.created_at,
        ps.payment_status,
        e.start_date_time, e.end_date_time,
        tt.tour_name,
        ct.first_name, ct.last_name,
        cl.phone
      FROM bookings b
      LEFT JOIN events e ON e.event_id = b.event_id
      LEFT JOIN tours t ON t.tour_id = e.tour_id
      LEFT JOIN tour_translations tt ON tt.tour_id = t.tour_id AND tt.language_id = 2
      LEFT JOIN payment_status ps ON ps.payment_status_id = b.payment_status_id
      LEFT JOIN clients cl ON cl.booking_id = b.booking_id AND cl.is_deleted = 0
      LEFT JOIN client_translations ct ON ct.client_id = cl.client_id AND ct.language_id = 2
      WHERE b.is_deleted = 0
      ORDER BY b.created_at DESC
      LIMIT 100
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get("/tours", async (req, res) => {
  try {
    const tours = await getTours();
    res.json(tours);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
