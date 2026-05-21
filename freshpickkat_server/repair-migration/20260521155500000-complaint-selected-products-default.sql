BEGIN;

ALTER TABLE "complaint" ALTER COLUMN "selectedProducts" DROP DEFAULT;

--
-- MIGRATION VERSION FOR _repair
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20260521155500000-complaint-selected-products-default', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260521155500000-complaint-selected-products-default', "timestamp" = now();

COMMIT;
