BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "order_item" ADD COLUMN "rewardOfferId" text;
ALTER TABLE "order_item" ADD COLUMN "rewardOfferName" text;
ALTER TABLE "order_item" ADD COLUMN "rewardThreshold" double precision;
ALTER TABLE "order_item" ADD COLUMN "rewardSource" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "shop_more_get_more_offer" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "minimumOrderAmount" double precision NOT NULL DEFAULT 0,
    "freeProductId" uuid NOT NULL,
    "freeVariantId" uuid,
    "freeQuantity" bigint NOT NULL DEFAULT 1,
    "priority" bigint NOT NULL DEFAULT 0,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdBy" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260627142045538', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260627142045538', "timestamp" = now();

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
