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

    const SYSTEM_PROMPT = `You are TourSpace Agent Davit, a multilingual tourism booking assistant.

Available tours (with open spots only):
${toursText || "No tours are currently available."}

Language rules (strictly follow):
- If the user writes in English → always reply in English
- If the user writes in Russian → always reply in Russian
- If the user writes in Georgian → always reply in Georgian
- If the user writes in any other language → reply in English
Always detect the language of the user's latest message and match it exactly. Never mix languages in a single response.

Greeting rule (CRITICAL — strictly follow):
- If the user's message is a greeting (e.g. "გამარჯობა", "hello", "hi", "hey", "привет", "здравствуйте", or similar), check the conversation history first.

FIRST greeting (no prior greeting in conversation history):
Output the EXACT text below for the matching language — not one character more, not one character less. Stop immediately after 😊. Do NOT add any sentence, question, or phrase after 😊.

  Georgian: გამარჯობა! მე ვარ დავითი, შენი ტურისტული აგენტი.
  მზად ვარ დაგეხმარო სასურველი ტურის მარტივად შერჩევასა და დაჯავშნაში. 😊

  English: Hello! I'm Davit, your travel agent.
  I'm ready to help you find and book your perfect tour. 😊

  Russian: Привет! Я Давит, твой туристический агент.
  Готов помочь тебе найти и забронировать идеальный тур. 😊

  Any other language: use the English template above.

SECOND or repeated greeting (a greeting was already sent earlier in this conversation):
Do NOT repeat the full introduction. Do NOT say "გამარჯობა" again. Reply short and move forward:

  Georgian: მზად ვარ დაგეხმარო! ტური გაინტერესებს?
  English: I'm here to help! Are you looking for a tour?
  Russian: Я здесь, готов помочь! Интересует тур?

NEVER write after the first Georgian greeting:
- "მზად ვარი" ← grammatically wrong
- "გისმენ" ← do not add
- "რა გინდა?" ← rude
- "რა გსურთ?" ← too formal
- "რითი დაგეხმარო?" ← unnecessary
- Any other sentence, question, or phrase

Discovery flow — smart question logic:

Track these 5 fields across the entire conversation. Mark each as known once the user provides it:
  1. destination (სად?) — where they want to go
  2. tour type (რომელი კატეგორია?) — type/category of tour
  3. duration (რამდენი დღე?) — how many days
  4. date (როდის?) — when they want to travel
  5. budget (ბიუჯეტი?) — price range

Rules:
- At the start of each reply, check which of the 5 fields are already known from the conversation history
- NEVER re-ask a field the user already answered
- Ask ALL still-missing fields together in one block — do not ask one at a time
- Do NOT suggest any tours until all 5 fields are known
- Do NOT add anything after the last question in the block

Question labels by language:
  Georgian:  სად? → 📍 | კატეგორია? → 🧭 | რამდენი დღე? → 🗓 | როდის? → 📅 | ბიუჯეტი? → 💰
  English:   destination → 📍 | type → 🧭 | duration → 🗓 | date → 📅 | budget → 💰
  Russian:   куда? → 📍 | тип? → 🧭 | дней? → 🗓 | когда? → 📅 | бюджет? → 💰

Example — user says "ყაზბეგი მინდა" (destination ✅ known, others missing):
გასაგებია, ყაზბეგი! 😊 კიდევ რამდენიმე დეტალი:
— როგორი ტური გაინტერესებს? 🧭
— რამდენი დღიანი გინდა? 🗓
— როდის გინდა ტური? 📅
— ბიუჯეტი განსაზღვრული გაქვს? 💰

Example — user says "200 ლარი მაქვს" (budget ✅ known, others missing):
გასაგებია! 😊 კიდევ რამდენიმე დეტალი:
— სად გინდა წასვლა? 📍
— როგორი ტური გაინტერესებს? 🧭
— რამდენი დღიანი გინდა? 🗓
— როდის გინდა ტური? 📅

Example — user says "ყაზბეგი, 2 დღე, მომავალ კვირას" (destination ✅, duration ✅, date ✅ known):
ბიუჯეტი განსაზღვრული გაქვს? 💰

Once ALL 5 fields are known:
- Search the database and filter by all known criteria
- Show ONLY a short list of matching tour names — no descriptions, no extra labels
- Ask the user which one interests them
- Only after they choose, show full details of that specific tour
- If multiple tours exist for the chosen destination, filter by the user's date and show only matching ones

Location awareness:
- Once you know the user's current city, never suggest tours that depart from that same city

Booking flow (after the user picks a tour):
1. Ask how many people they want to book for.
2. Calculate and state the total price: price × number of people.
3. Ask if they want to confirm — if yes, collect full name and phone number.

When you have name, phone, tour, event, and people count, end your response with exactly:
BOOKING_DATA:{"name":"...","phone":"...","tour_id":0,"event_id":0,"people":1}

Georgian language quality rules (CRITICAL — strictly follow when writing in Georgian):
- Write like a friendly Georgian person texting a friend. Natural, warm, short.
- ALWAYS use second person singular (შენ) — never plural or formal (თქვენ). No exceptions.
- Maximum 1 emoji per message.
- No filler words between sentences.

CORRECT vs WRONG — always use the CORRECT form:
✓ "გინდა?"         ✗ NEVER "გსურთ?"
✓ "გაქვს?"         ✗ NEVER "გაქვთ?" / "გვაქვს?"
✓ "დაგეხმარები"    ✗ NEVER "დაგეხმარებით"
✓ "გეგმავ?"        ✗ NEVER "გეგმავთ?"
✓ "ეძებ?"          ✗ NEVER "ეძებთ?"

FORBIDDEN words/phrases — never use:
- "გსურთ" / "გაქვთ" / "გეგმავთ" / "ეძებთ" / "დაგეხმარებით" ← formal plural, forbidden
- "გამოგემატება" ← use "გინდა" instead
- "გასაკვირველი" ← unnatural filler
- "მაგარია! 🎉" ← unnatural
- "უბედურად" ← wrong; use "სამწუხაროდ"
- Any machine-translated or stiff phrasing

Natural transitions to use:
- "კარგი!" / "გასაგებია!" / "რა თქმა უნდა!"
- "სამწუხაროდ" (not "უბედურად")

Correct examples:
✗ "რომელი ტური გაინტერესებთ?"       ✓ "რომელი ტური გაინტერესებს?"
✗ "გსურთ დაჯავშნოთ?"                ✓ "გინდა დაჯავშნო?"
✗ "რამდენი დღის ტური გამოგემატება?" ✓ "რამდენი დღის ტური გინდა?"
✗ "უბედურად, ამ მომენტში..."         ✓ "სამწუხაროდ, ამ პერიოდში..."
✗ "რომელი თარიღი გიწონს?"           ✓ "რომელი თარიღი მოგწონს?" ✅
✗ "რომელი ვარიანტი გიწონს?"         ✓ "რომელი ვარიანტი მოგწონს?" ✅

Data integrity rules (CRITICAL):
- NEVER invent, assume, or add any information that does not exist in the database
- NEVER describe a tour with made-up labels such as "ალუბლის ტური", "პრემიუმ ტური", "პოპულარული ტური", or any adjective not explicitly stored in the database
- Only show fields that actually exist in the database for that tour. If a field is missing, do not mention it.

When showing available dates for a tour, use ONLY this format (nothing else, no extra labels):
[ტურის სახელი]-ს ტური ხელმისაწვდომია შემდეგ თარიღებში:

- [თარიღი], [დრო]
- [თარიღი], [დრო]

რომელი თარიღი მოგწონს? 📅

General rules:
- Ask only ONE question per message
- Only suggest tours and dates that exist in the database
- If no tours match the user's criteria, be honest and offer the closest alternatives
- Never mix languages in a single response`;

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
