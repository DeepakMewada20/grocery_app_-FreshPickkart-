BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" ADD COLUMN "referralCode" text;
CREATE UNIQUE INDEX "app_user_referral_code_idx" ON "app_user" USING btree ("referralCode");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "referral" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "referrerUserId" uuid NOT NULL,
    "inviteeUserId" uuid,
    "inviteePhone" text NOT NULL,
    "referralCodeUsed" text NOT NULL,
    "status" text NOT NULL DEFAULT 'LINK_SHARED'::text,
    "qualifyingOrderId" uuid,
    "qualifyingOrderAmount" double precision NOT NULL DEFAULT 0.0,
    "rewardPointsIssued" bigint NOT NULL DEFAULT 0,
    "inviteeCouponIssued" boolean NOT NULL DEFAULT false,
    "rewardIssuedAt" timestamp without time zone,
    "fraudNotes" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "referral_referrer_idx" ON "referral" USING btree ("referrerUserId");
CREATE UNIQUE INDEX "referral_invitee_idx" ON "referral" USING btree ("inviteeUserId");
CREATE INDEX "referral_code_status_idx" ON "referral" USING btree ("referralCodeUsed", "status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "referral_settings" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "isEnabled" boolean NOT NULL DEFAULT true,
    "inviteeCouponEnabled" boolean NOT NULL DEFAULT true,
    "inviteeCouponAmount" double precision NOT NULL DEFAULT 50.0,
    "inviteeCouponCodeTemplate" text NOT NULL DEFAULT 'WELCOME{CODE}'::text,
    "referrerPointsEnabled" boolean NOT NULL DEFAULT true,
    "referrerRewardPoints" bigint NOT NULL DEFAULT 50,
    "minimumQualifyingAmount" double precision NOT NULL DEFAULT 0.0,
    "rewardTriggerStatus" text NOT NULL DEFAULT 'DELIVERED'::text,
    "maxRewardedPerMonth" bigint NOT NULL DEFAULT 20,
    "enableFraudProtection" boolean NOT NULL DEFAULT true,
    "enableReferralExpiry" boolean NOT NULL DEFAULT false,
    "referralExpiryDays" bigint NOT NULL DEFAULT 90,
    "shareMessageTemplate" text NOT NULL DEFAULT 'Join FreshPickKat using my referral code {CODE}. Get ₹50 OFF on your first order!'::text,
    "lastUpdatedBy" uuid,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "referral"
    ADD CONSTRAINT "referral_fk_0"
    FOREIGN KEY("referrerUserId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260621071625270', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260621071625270', "timestamp" = now();

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
