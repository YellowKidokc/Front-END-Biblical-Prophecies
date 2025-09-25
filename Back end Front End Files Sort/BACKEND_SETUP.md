
# Cloudflare Worker Backend (Minimal API)

## Deploy
1. Install wrangler: `npm i -g wrangler`
2. Create D1 & KV:
   - `wrangler d1 create prophecy` → put id into wrangler.toml
   - `wrangler kv namespace create KV` → put id into wrangler.toml
3. Push:
   - `wrangler deploy`
4. Initialize DB:
   - `wrangler d1 execute prophecy --file=schema.sql`

## Endpoints
- `GET /api/stats`
- `GET /api/feeds`
- `GET /api/articles/recent?limit=25`
- `POST /api/ingest-now` → sets KV flag for your scheduled scraper
