const express = require("express");
const sql = require("mssql");
const app = express();
const cors = require("cors");

const dbConnectionString = process.env.DB_CONNECTION_STRING || "";

const PORT = process.env.PORT;

app.use(cors({
    origin: `https://${process.env.FRONTEND_HOSTNAME}`,    
}));

app.get("/health", (req, res) => {
    res.json({ status: "ok", time: new Date().toISOString() });
});

app.get("/api/message", (req, res) => {
    res.json({
        message: "Hello from the backend API",
        dbConnectionStringConfigured: dbConnectionString.length > 0
    });
});

app.listen(PORT, () => {
    console.log(`Backend listening on port ${PORT}`);
});

app.get("/api/dbinit", async (req, res) => {
    try {
        const pool = await sql.connect(dbConnectionString);

        await pool.request().query(`
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Messages' AND xtypes='U')
            CREATE TABLE Messages (
                id INT IDENTITY(1,1) PRIMARY KEY,
                message NVARCHAR(255),
                created_at DATETIME DEFAULT GETDATE()
            );
        `);

        await pool.request()
            .input("Msg", sql.NVarChar, "Hello from backend at " + new Date().toISOString())
            .query("INSERT INTO Messages (message) VALUES (@msg)");

        res.json({ ok:true, message: "Table ready & row inserted. "});
    } catch (err) {
        console.error("DBINIT ERROR", err);
        res.status(500).json({ ok: false, error: err.message })
    }
});

app.get("/api/dbrows", async (req, res) => {
    try {
        const pool = await sql.connect(dbConnectionString);
        const result = await pool.request().query("SELECT TOP 10 * FROM Messages ORDER By id DESC");
        res.json({ ok: true, rows: result.recordset });
    } catch (err) {
        console.error("DBROWS ERROR:", err);
        res.status(500).json({ ok: false, error: err.message });
    }
});