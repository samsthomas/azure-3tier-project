const API_URL = "https://api-3tier-dev.azurewebsites.net/api/message";

async function loadMessage() {
    const statusEl = document.getElementById("status");

    try {
        const res = await fetch(API_URL);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();
        statusEl.textContent = data.message + ` (DB config: ${data.dbConnectionStringConfigured})`;
    } catch (err) {
        console.error(err);
        statusEl.textContent = "Failed to load backend message.";
    }
}

loadMessage();