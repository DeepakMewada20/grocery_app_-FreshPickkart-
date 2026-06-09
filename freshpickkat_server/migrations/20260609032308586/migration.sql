BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "order_item" DROP CONSTRAINT "order_item_fk_1";
ALTER TABLE "order_item" DROP CONSTRAINT "order_item_fk_2";
ALTER TABLE "order_item" DROP CONSTRAINT "order_item_fk_3";
ALTER TABLE "order_item" DROP CONSTRAINT "order_item_fk_4";

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260609032308586', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260609032308586', "timestamp" = now();

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
