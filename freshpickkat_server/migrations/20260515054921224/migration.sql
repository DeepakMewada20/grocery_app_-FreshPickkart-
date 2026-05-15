BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_campaign" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "title" text NOT NULL,
    "body" text NOT NULL,
    "type" text NOT NULL,
    "topic" text NOT NULL,
    "imageUrl" text,
    "targetAudience" text NOT NULL,
    "entityType" text,
    "entityId" text,
    "dataJson" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "notification_campaign_created_idx" ON "notification_campaign" USING btree ("createdAt", "id");
CREATE INDEX "notification_campaign_topic_idx" ON "notification_campaign" USING btree ("topic", "createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_outbox" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "dedupeKey" text NOT NULL,
    "campaignId" uuid NOT NULL,
    "payloadJson" text NOT NULL,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "lastError" text,
    "processedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "notification_outbox_dedupe_idx" ON "notification_outbox" USING btree ("dedupeKey");
CREATE INDEX "notification_outbox_pending_idx" ON "notification_outbox" USING btree ("processedAt", "createdAt", "id");
CREATE INDEX "notification_outbox_campaign_idx" ON "notification_outbox" USING btree ("campaignId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_preference" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "firebaseUid" text NOT NULL,
    "trackOrderNotifications" boolean NOT NULL DEFAULT true,
    "couponNotifications" boolean NOT NULL DEFAULT true,
    "offerNotifications" boolean NOT NULL DEFAULT true,
    "announcementNotifications" boolean NOT NULL DEFAULT true,
    "importantAlerts" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "notification_preference_user_idx" ON "notification_preference" USING btree ("userId");
CREATE INDEX "notification_preference_firebase_idx" ON "notification_preference" USING btree ("firebaseUid");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_user_state" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "campaignId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "isRead" boolean NOT NULL DEFAULT false,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "readAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "notification_user_state_campaign_user_idx" ON "notification_user_state" USING btree ("campaignId", "userId");
CREATE INDEX "notification_user_state_user_deleted_idx" ON "notification_user_state" USING btree ("userId", "isDeleted", "updatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_fcm_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "firebaseUid" text NOT NULL,
    "fcmToken" text NOT NULL,
    "deviceId" text NOT NULL,
    "platform" text NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "user_fcm_token_user_device_idx" ON "user_fcm_token" USING btree ("userId", "deviceId");
CREATE INDEX "user_fcm_token_firebase_idx" ON "user_fcm_token" USING btree ("firebaseUid", "isActive", "updatedAt");
CREATE INDEX "user_fcm_token_token_idx" ON "user_fcm_token" USING btree ("fcmToken");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_outbox"
    ADD CONSTRAINT "notification_outbox_fk_0"
    FOREIGN KEY("campaignId")
    REFERENCES "notification_campaign"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_preference"
    ADD CONSTRAINT "notification_preference_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_user_state"
    ADD CONSTRAINT "notification_user_state_fk_0"
    FOREIGN KEY("campaignId")
    REFERENCES "notification_campaign"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "notification_user_state"
    ADD CONSTRAINT "notification_user_state_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_fcm_token"
    ADD CONSTRAINT "user_fcm_token_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260515054921224', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260515054921224', "timestamp" = now();

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
