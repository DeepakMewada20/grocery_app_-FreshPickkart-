BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "category" ADD COLUMN "isFreeDelivery" boolean NOT NULL DEFAULT false;
CREATE INDEX IF NOT EXISTS category_is_free_delivery_idx ON "category" ("isFreeDelivery");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "isFreeDelivery" boolean NOT NULL DEFAULT false;
CREATE INDEX IF NOT EXISTS product_is_free_delivery_idx ON "product" ("isFreeDelivery");

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260603153928415', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260603153928415', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
