BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "freeDeliveryReason" text;
ALTER TABLE "customer_order" ADD COLUMN "couponSnapshot" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "order_item" ADD COLUMN "mrpSnapshot" double precision;
ALTER TABLE "order_item" ADD COLUMN "skuSnapshot" text;
ALTER TABLE "order_item" ADD COLUMN "productSlugSnapshot" text;
ALTER TABLE "order_item" ADD COLUMN "categoryNameSnapshot" text;
ALTER TABLE "order_item" ADD COLUMN "productStatusSnapshot" text;
ALTER TABLE "order_item" ADD COLUMN "appliedOfferSnapshot" text;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260609030232881', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260609030232881', "timestamp" = now();

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
