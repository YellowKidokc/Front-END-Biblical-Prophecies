
-- Minimal tables for feeds and articles
CREATE TABLE IF NOT EXISTS feeds (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT DEFAULT 'rss',
  categories TEXT,
  frequency INTEGER DEFAULT 60,
  active INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  feed_id INTEGER,
  title TEXT,
  url TEXT,
  score REAL DEFAULT 0,
  published_at INTEGER,
  raw JSON,
  FOREIGN KEY(feed_id) REFERENCES feeds(id)
);

CREATE INDEX IF NOT EXISTS idx_articles_score_time ON articles(score, published_at DESC);
