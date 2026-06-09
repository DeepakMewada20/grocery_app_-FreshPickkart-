# Contributing Guidelines

## Database

### ✅ Do
- Always use admin panel or backend API endpoints to create/update/delete records.
- Run `serverpod generate` after any `.spy.yaml` changes.
- Run `serverpod create-migration` after any schema changes.
- Backup before migrations: `bash scripts/backup_db.sh`

### ❌ Don't
- **Never** delete or modify data directly via `psql`, `pgAdmin`, `DBeaver`, or any SQL client.
- Many foreign key constraints have been intentionally removed. Direct SQL deletes can create orphaned rows and cause runtime crashes.
- Runtime safety is enforced by `DependencyChecker` (API-level), soft-delete patterns, and snapshot columns — not by DB-level constraints.

### Database Users
- The app connects as `postgres` (superuser). For production, create a dedicated app user with limited privileges:
  ```sql
  -- See scripts/setup_db_permissions.sql
  ```
- Grant `DELETE` only on junction tables where hard-delete is safe (e.g., `combo_offer_item`, `banner_placement`, `category_offer_product_scope`).
- `DELETE` from core tables (`product`, `category`, `customer_order`, `app_user`, etc.) should never happen directly.
