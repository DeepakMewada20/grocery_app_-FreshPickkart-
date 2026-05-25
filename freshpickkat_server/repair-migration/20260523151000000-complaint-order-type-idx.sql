BEGIN;

-- Only drop and recreate if the index doesn't already have 4 elements
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE tablename = 'complaint'
          AND indexname = 'complaint_order_type_idx'
          AND indexdef LIKE '%"selectedField"%'
    ) THEN
        DROP INDEX IF EXISTS "complaint_order_type_idx";
        CREATE INDEX "complaint_order_type_idx" ON "complaint" USING btree ("orderId", "complaintType", "selectedField", "status");
    END IF;
END $$;

--
-- MIGRATION VERSION FOR _repair
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20260523151000000-complaint-order-type-idx', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260523151000000-complaint-order-type-idx', "timestamp" = now();

COMMIT;
