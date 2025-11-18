const express = require("express");
const app = express();

const PORT = process.env.PORT;

const dbConnectionString = process.env.DB_CONNECTION_STRING || "not-set";

app.get("/health", (req, res) => {
    res.json({ status: "ok", time: new Date().toISOString() });
});

app.get("/api/message", (req, res) => {
    res.json({
        message: "Hello from the backend API",
        dbConnectionStringConfigured: dbConnectionString !== "not-set"
    });
});

app.listen(PORT, () => {
    console.log(`Backend listening on port ${PORT}`);
});