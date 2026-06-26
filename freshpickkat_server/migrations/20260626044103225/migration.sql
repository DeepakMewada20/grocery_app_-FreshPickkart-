BEGIN;

--
-- Fix existing rows: update 0.5 (treated as 0.5%) to 50.0 (treated as 50%)
--
UPDATE "fresh_points_settings" SET "redemptionPercentageLimit" = 50.0 WHERE "redemptionPercentageLimit" < 1.0;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "fresh_points_settings" ALTER COLUMN "redemptionPercentageLimit" SET DEFAULT 50.0;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260626044103225', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260626044103225', "timestamp" = now();

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
