-- This script ensures that required PostgreSQL extensions are installed.
-- It is run automatically on database initialization by docker-compose.

CREATE EXTENSION IF NOT EXISTS pg_trgm;
