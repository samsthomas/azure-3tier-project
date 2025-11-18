const API_URL = "__API_URL__";

async function loadMessage() {
    const statusEl = document.getElementById("status");

    try {
        const res = await fetch(API_URL);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();
        statusEl.textContent = data.message;
    } catch (err) {
        console.error(err);
        statusEl.textContent = "Failed to load backend message.";
    }
}

async function loadDbRows() {
    const dbEL = document.getElementById("dbrows");

    try {
        const res = await fetch(API_URL.replace("/message", "/dbrows"));
        const data = await res.json();

        if (!data.ok) throw new Error(data.error);

        if (data.rows.length === 0) {
            dbEL.textContent = "DB has no rows yet.";
        } else {
            const latest = data.rows[0];
            dbEL.textContent = `Latest DB Message: "${latest.message}" at ${latest.created_at}`;
        }
    } catch (err) {
        console.error(err);
        dbEL.textContent = "Failed to load DB rows.";
    }
}

loadMessage();
loadDbRows();