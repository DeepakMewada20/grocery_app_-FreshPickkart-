BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "delivery_rule" DROP COLUMN "ruleType";
ALTER TABLE "delivery_rule" RENAME COLUMN "priority" TO "sortOrder";
ALTER TABLE "delivery_rule" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "delivery_rule" ALTER COLUMN "endsAt" DROP NOT NULL;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260707080601754', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260707080601754', "timestamp" = now();

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
