BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_notification_preference" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "adminUserId" uuid NOT NULL,
    "adminFirebaseUid" text NOT NULL,
    "preferenceKey" text NOT NULL,
    "pushEnabled" boolean NOT NULL DEFAULT true,
    "soundEnabled" boolean NOT NULL DEFAULT true,
    "critical" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "admin_notification_preference_admin_key_idx" ON "admin_notification_preference" USING btree ("adminUserId", "preferenceKey");
CREATE INDEX "admin_notification_preference_firebase_idx" ON "admin_notification_preference" USING btree ("adminFirebaseUid");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "notification_campaign" ADD COLUMN "status" text NOT NULL DEFAULT 'queued'::text;
ALTER TABLE "notification_campaign" ADD COLUMN "priority" text NOT NULL DEFAULT 'normal'::text;
ALTER TABLE "notification_campaign" ADD COLUMN "scheduledAt" timestamp without time zone;
ALTER TABLE "notification_campaign" ADD COLUMN "creatorAdminFirebaseUid" text;
ALTER TABLE "notification_campaign" ADD COLUMN "targetMetadataJson" text;
ALTER TABLE "notification_campaign" ADD COLUMN "recipientCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "notification_campaign" ADD COLUMN "successCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "notification_campaign" ADD COLUMN "failureCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "notification_campaign" ADD COLUMN "lastError" text;
ALTER TABLE "notification_campaign" ADD COLUMN "sentAt" timestamp without time zone;
CREATE INDEX "notification_campaign_status_created_idx" ON "notification_campaign" USING btree ("status", "createdAt", "id");
CREATE INDEX "notification_campaign_scheduled_idx" ON "notification_campaign" USING btree ("scheduledAt", "status");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "notification_outbox" ADD COLUMN "status" text NOT NULL DEFAULT 'queued'::text;
ALTER TABLE "notification_outbox" ADD COLUMN "maxAttempts" bigint NOT NULL DEFAULT 5;
ALTER TABLE "notification_outbox" ADD COLUMN "nextAttemptAt" timestamp without time zone;
DROP INDEX "notification_outbox_pending_idx";
CREATE INDEX "notification_outbox_pending_idx" ON "notification_outbox" USING btree ("processedAt", "nextAttemptAt", "createdAt", "id");
CREATE INDEX "notification_outbox_status_idx" ON "notification_outbox" USING btree ("status", "nextAttemptAt");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "admin_notification_preference"
    ADD CONSTRAINT "admin_notification_preference_fk_0"
    FOREIGN KEY("adminUserId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260517150232481', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260517150232481', "timestamp" = now();

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
