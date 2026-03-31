require("dotenv").config();
const express = require("express");
const cors = require("cors");
const router = require("./routes");

const app = express();
const PORT = process.env.BOOKING_PORT || 5001;

app.use(cors());
app.use(express.json());
app.use(express.static("public"));
app.use("/api", router);

app.listen(PORT, async () => {
  const db = require("./db");
  try {
    await db.execute("SELECT 1");
    console.log(`✅ Booking Agent გაეშვა: http://localhost:${PORT}`);
    console.log(`✅ MariaDB კავშირი წარმატებულია`);
  } catch (err) {
    console.error("❌ MariaDB შეცდომა:", err.message);
  }
});
