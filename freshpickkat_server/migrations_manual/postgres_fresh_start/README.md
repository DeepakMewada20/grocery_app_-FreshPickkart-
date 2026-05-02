# Post-Generation SQL Pack

This folder is the migration-ready companion to the new Serverpod `*Row` models.

## Intended Flow

1. Run Serverpod generation after the new `.spy.yaml` files are accepted.
2. Let Serverpod create the base relational migration for the row tables.
3. Apply `010_post_serverpod_generate.sql` after the generated migration to add PostgreSQL-specific features that the model generator does not express well:
   - `pg_trgm`
   - trigram GIN index
   - partial unique index for active search rebuild jobs
   - `INCLUDE` indexes for index-only scans

## Why Manual SQL Exists

Serverpod model generation is suitable for the base relational schema and basic btree indexes. The following features should remain in raw SQL:

- `CREATE EXTENSION IF NOT EXISTS pg_trgm`
- `USING gin (... gin_trgm_ops)`
- `CREATE UNIQUE INDEX ... WHERE ...`
- `INCLUDE (...)`

This split keeps the model layer generator-friendly while preserving the PostgreSQL optimization plan.
