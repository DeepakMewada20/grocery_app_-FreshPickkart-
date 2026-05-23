BEGIN;

DROP INDEX IF EXISTS "complaint_order_type_idx";
CREATE INDEX "complaint_order_type_idx" ON "complaint" USING btree ("orderId", "complaintType", "selectedField", "status");

--
-- MIGRATION VERSION FOR _repair
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20260523151000000-complaint-order-type-idx', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260523151000000-complaint-order-type-idx', "timestamp" = now();

COMMIT;
