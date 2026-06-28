BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "banner" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "banner" ALTER COLUMN "endsAt" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "bogo_offer" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "bogo_offer" ALTER COLUMN "endsAt" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "category_offer" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "category_offer" ALTER COLUMN "endsAt" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "combo_offer" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "combo_offer" ALTER COLUMN "endsAt" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "coupon" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "coupon" ALTER COLUMN "endsAt" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "free_delivery_rule" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "free_delivery_rule" ALTER COLUMN "endsAt" DROP NOT NULL;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260628163015105', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260628163015105', "timestamp" = now();

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
