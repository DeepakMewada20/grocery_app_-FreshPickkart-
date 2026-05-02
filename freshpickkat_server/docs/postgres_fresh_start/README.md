# PostgreSQL Fresh-Start Backend Blueprint

This design pack implements the approved PostgreSQL-first backend blueprint without changing the current Firestore-backed runtime.

## Included

- `schema.sql`
  Fresh-start PostgreSQL schema with:
  - `pgcrypto`
  - `pg_trgm`
  - UUID primary keys using `gen_random_uuid()`
  - normalized relations
  - deactivation rules
  - trigram search projection
  - async search rebuild queue
  - composite indexes aligned to browse, order, and payment access patterns
  - selective `INCLUDE` indexes where useful

- `query_examples.sql`
  Query patterns for:
  - category browse
  - subcategory browse through join table
  - user order history
  - trigram search with minimum-length guardrail and similarity threshold
  - async search rebuild enqueue flow
  - atomic order transaction boundary

- `serverpod_model_blueprints.md`
  Serverpod-compatible table model blueprints for the relational entities.
  These are intentionally kept out of `lib/src/protocol/` so the current runtime is not broken during design adoption.

## Important Decisions Captured

- Firestore-style `searchKeywords` and prefix arrays are removed.
- Product-to-subcategory is many-to-many via `product_sub_category`.
- Search uses `ILIKE` + trigram similarity ranking.
- Search rejects very short input before query execution.
- Product create may write the search projection synchronously.
- Product update / category update / subcategory remapping enqueue async rebuild work instead of rebuilding search text inside the main write transaction.
- Order/payment/idempotency writes are atomic and must commit or roll back as one unit.

## Notes

- PostgreSQL-specific features such as `pg_trgm`, trigram GIN indexes, partial indexes, and `INCLUDE` indexes are represented in raw SQL because they are beyond standard Serverpod model-index generation.
- The model blueprints can be split into individual `.spy.yaml` files later when you are ready to replace the existing protocol layer.
