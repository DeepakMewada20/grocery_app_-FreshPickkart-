BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" ADD COLUMN "currentFreshPoints" bigint NOT NULL DEFAULT 0;
ALTER TABLE "app_user" ADD COLUMN "totalEarned" bigint NOT NULL DEFAULT 0;
ALTER TABLE "app_user" ADD COLUMN "totalRedeemed" bigint NOT NULL DEFAULT 0;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "freshPointsUsed" bigint NOT NULL DEFAULT 0;
ALTER TABLE "customer_order" ADD COLUMN "freshPointsValue" double precision NOT NULL DEFAULT 0;
ALTER TABLE "customer_order" ADD COLUMN "actualPaymentAmount" double precision NOT NULL DEFAULT 0;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "fresh_points_settings" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "isEnabled" boolean NOT NULL DEFAULT true,
    "redemptionPercentageLimit" double precision NOT NULL DEFAULT 0.50,
    "allowRedemptionOnCOD" boolean NOT NULL DEFAULT true,
    "minimumOrderForRedemption" double precision NOT NULL DEFAULT 0,
    "enablePointExpiry" boolean NOT NULL DEFAULT false,
    "pointExpiryDays" bigint NOT NULL DEFAULT 90,
    "enableAdminAdjustments" boolean NOT NULL DEFAULT true,
    "lastUpdatedBy" uuid,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fresh_points_transaction" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "transactionType" text NOT NULL,
    "points" bigint NOT NULL,
    "balanceBefore" bigint NOT NULL DEFAULT 0,
    "balanceAfter" bigint NOT NULL DEFAULT 0,
    "referenceType" text,
    "referenceId" uuid,
    "description" text,
    "createdBy" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "fresh_points_transaction_user_idx" ON "fresh_points_transaction" USING btree ("userId", "createdAt", "id");
CREATE INDEX "fresh_points_transaction_type_idx" ON "fresh_points_transaction" USING btree ("transactionType");
CREATE INDEX "fresh_points_transaction_ref_idx" ON "fresh_points_transaction" USING btree ("referenceType", "referenceId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "fresh_points_transaction"
    ADD CONSTRAINT "fresh_points_transaction_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260621054723557', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260621054723557', "timestamp" = now();

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
