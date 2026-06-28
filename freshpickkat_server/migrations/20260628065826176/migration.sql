BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "order_item" ADD COLUMN "isRewardProduct" boolean NOT NULL DEFAULT false;
ALTER TABLE "order_item" ADD COLUMN "quantityEditable" boolean NOT NULL DEFAULT true;
ALTER TABLE "order_item" ADD COLUMN "priceEditable" boolean NOT NULL DEFAULT true;
ALTER TABLE "order_item" ADD COLUMN "originalUnitPrice" double precision;
ALTER TABLE "order_item" ADD COLUMN "rewardValue" double precision;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "shop_more_get_more_offer" ADD COLUMN "updatedBy" text;
ALTER TABLE "shop_more_get_more_offer" ADD COLUMN "activatedBy" text;
ALTER TABLE "shop_more_get_more_offer" ADD COLUMN "deactivatedBy" text;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260628065826176', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260628065826176', "timestamp" = now();

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
