BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_notification_outbox" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "dedupeKey" text NOT NULL,
    "eventType" text NOT NULL,
    "orderId" text NOT NULL,
    "userId" text,
    "status" text,
    "payloadJson" text NOT NULL,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "lastError" text,
    "processedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "order_notification_outbox_dedupe_idx" ON "order_notification_outbox" USING btree ("dedupeKey");
CREATE INDEX "order_notification_outbox_pending_idx" ON "order_notification_outbox" USING btree ("processedAt", "createdAt", "id");
CREATE INDEX "order_notification_outbox_user_pending_idx" ON "order_notification_outbox" USING btree ("userId", "processedAt", "createdAt", "id");


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260509095315375', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260509095315375', "timestamp" = now();

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
