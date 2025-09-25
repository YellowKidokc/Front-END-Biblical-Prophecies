
-- Required extensions
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Table with hashes for dedupe
CREATE TABLE IF NOT EXISTS notes (
  uid TEXT PRIMARY KEY,
  title TEXT,
  created_at TIMESTAMPTZ,
  source_app TEXT,
  classification TEXT,
  tags TEXT[],
  body_md TEXT,
  source_path TEXT,
  content_hash TEXT,
  simhash64 BIGINT
);

-- Exact dedupe
CREATE UNIQUE INDEX IF NOT EXISTS notes_content_hash_uidx ON notes(content_hash);

-- Similarity search for near duplicates
CREATE INDEX IF NOT EXISTS notes_body_trgm_idx ON notes USING gin (body_md gin_trgm_ops);

-- Example UPSERT using JSONB parameters (pseudo-code, adapt in your loader):
-- INSERT INTO notes (uid,title,created_at,source_app,classification,tags,body_md,source_path,content_hash,simhash64)
-- VALUES (...)
-- ON CONFLICT (content_hash) DO NOTHING;
