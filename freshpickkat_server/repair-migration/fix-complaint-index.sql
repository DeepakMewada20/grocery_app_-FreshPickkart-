-- ============================================================
-- FIX: complaint_order_type_idx (3 elements -> 4 elements)
-- 
-- Run this on your REMOTE/PRODUCTION database directly:
--   psql -d your_database -f fix-complaint-index.sql
--
-- Or via docker on your server:
--   docker exec -i <postgres_container> psql -U postgres -d freshpickkat < fix-complaint-index.sql
-- ============================================================

BEGIN;

-- Drop old 3-element index and create new 4-element index
DROP INDEX IF EXISTS "complaint_order_type_idx";
CREATE INDEX "complaint_order_type_idx" ON "complaint" USING btree ("orderId", "complaintType", "selectedField", "status");

-- Clean up any stale _repair migration entry
DELETE FROM "serverpod_migrations" WHERE "module" = '_repair';

-- Record the repair migration
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20260523151000000-complaint-order-type-idx', now());

COMMIT;
