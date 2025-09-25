
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    try {
      if (url.pathname === "/api/stats") {
        return json({ ok: true, uptime: env.__START_TIME ? (Date.now()-env.__START_TIME) : null });
      }
      if (url.pathname === "/api/feeds" && request.method === "GET") {
        const feeds = await env.DB.prepare("SELECT id, name, url, type, categories, frequency, active FROM feeds ORDER BY created_at DESC").all();
        return json(feeds.results || []);
      }
      if (url.pathname === "/api/articles/recent") {
        const limit = Number(url.searchParams.get("limit") || 25);
        const rows = await env.DB.prepare("SELECT id, title, url, score, published_at FROM articles WHERE score >= 5 ORDER BY published_at DESC LIMIT ?").bind(limit).all();
        return json(rows.results || []);
      }
      if (url.pathname === "/api/ingest-now" && request.method === "POST") {
        // enqueue a task (KV flag) for your scheduled scraper (not included here)
        await env.KV.put("ingest_trigger", String(Date.now()));
        return json({ ok: true, message: "Ingestion triggered" });
      }
      return new Response("Not Found", { status: 404 });
    } catch (e) {
      return json({ ok:false, error: e.message }, 500);
    }
  }
}
function json(data, status=200){ return new Response(JSON.stringify(data), { status, headers: { "content-type":"application/json; charset=utf-8", "access-control-allow-origin":"*" } }); }
