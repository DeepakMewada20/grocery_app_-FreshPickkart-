BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "coupon" ADD COLUMN "assignedUserId" uuid;
ALTER TABLE "coupon" ADD COLUMN "assignedPhone" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "referral" ADD COLUMN "fraudScore" bigint NOT NULL DEFAULT 0;
ALTER TABLE "referral" ADD COLUMN "fraudBreakdown" text;
ALTER TABLE "referral" ADD COLUMN "holdExpiresAt" timestamp without time zone;
ALTER TABLE "referral" ADD COLUMN "scheduledReleaseAt" timestamp without time zone;
ALTER TABLE "referral" ADD COLUMN "attempts" bigint NOT NULL DEFAULT 0;
ALTER TABLE "referral" ADD COLUMN "lastError" text;
ALTER TABLE "referral" ADD COLUMN "dailyShareCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "referral" ADD COLUMN "monthlyShareCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "referral" ADD COLUMN "lastShareDate" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "referral_settings" ADD COLUMN "enableFraudScoring" boolean NOT NULL DEFAULT true;
ALTER TABLE "referral_settings" ADD COLUMN "autoApproveThreshold" bigint NOT NULL DEFAULT 40;
ALTER TABLE "referral_settings" ADD COLUMN "manualReviewThreshold" bigint NOT NULL DEFAULT 69;
ALTER TABLE "referral_settings" ADD COLUMN "autoRejectThreshold" bigint NOT NULL DEFAULT 90;
ALTER TABLE "referral_settings" ADD COLUMN "enableRewardHold" boolean NOT NULL DEFAULT true;
ALTER TABLE "referral_settings" ADD COLUMN "holdDurationHours" bigint NOT NULL DEFAULT 72;
ALTER TABLE "referral_settings" ADD COLUMN "enableAutoReject" boolean NOT NULL DEFAULT true;
ALTER TABLE "referral_settings" ADD COLUMN "minimumActualPaymentForQualification" double precision NOT NULL DEFAULT 0;
ALTER TABLE "referral_settings" ADD COLUMN "maxRewardedPerDay" bigint NOT NULL DEFAULT 3;
ALTER TABLE "referral_settings" ADD COLUMN "maxPendingReferrals" bigint NOT NULL DEFAULT 50;
ALTER TABLE "referral_settings" ADD COLUMN "maxSharesPerDay" bigint NOT NULL DEFAULT 100;
ALTER TABLE "referral_settings" ADD COLUMN "maxSharesPerMonth" bigint NOT NULL DEFAULT 1000;
ALTER TABLE "referral_settings" ADD COLUMN "referralVelocityScore" bigint NOT NULL DEFAULT 30;
ALTER TABLE "referral_settings" ADD COLUMN "velocityTimeWindowHours" bigint NOT NULL DEFAULT 24;
ALTER TABLE "referral_settings" ADD COLUMN "velocityThreshold" bigint NOT NULL DEFAULT 3;
ALTER TABLE "referral_settings" ADD COLUMN "newAccountScore" bigint NOT NULL DEFAULT 20;
ALTER TABLE "referral_settings" ADD COLUMN "newAccountHours" bigint NOT NULL DEFAULT 48;
ALTER TABLE "referral_settings" ADD COLUMN "autoReversalWindowDays" bigint NOT NULL DEFAULT 30;
ALTER TABLE "referral_settings" ADD COLUMN "termsText" text;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260621101601760', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260621101601760', "timestamp" = now();

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

--
-- MIGRATION VERSION FOR _repair
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20260621103522654', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260621103522654', "timestamp" = now();


COMMIT;
