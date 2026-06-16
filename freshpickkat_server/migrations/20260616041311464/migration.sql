BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "paymentMode" text NOT NULL DEFAULT 'standard'::text;
ALTER TABLE "customer_order" ADD COLUMN "paymentExpiresAt" timestamp without time zone;
ALTER TABLE "customer_order" ADD COLUMN "paidByName" text;
ALTER TABLE "customer_order" ADD COLUMN "paidByPhone" text;
ALTER TABLE "customer_order" ADD COLUMN "paidByEmail" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "payment_link" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "isUsed" boolean NOT NULL DEFAULT false,
    "usedAt" timestamp without time zone,
    "paidByName" text,
    "paidByPhone" text,
    "paidByEmail" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "payment_link_token_idx" ON "payment_link" USING btree ("token");
CREATE INDEX "payment_link_order_idx" ON "payment_link" USING btree ("orderId");


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260616041311464', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260616041311464', "timestamp" = now();

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
