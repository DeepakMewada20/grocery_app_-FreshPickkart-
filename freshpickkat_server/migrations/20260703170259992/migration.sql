BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" ADD COLUMN "codOrdersPlaced" bigint NOT NULL DEFAULT 0;
ALTER TABLE "app_user" ADD COLUMN "codOrdersDelivered" bigint NOT NULL DEFAULT 0;
ALTER TABLE "app_user" ADD COLUMN "codOrdersRejected" bigint NOT NULL DEFAULT 0;
ALTER TABLE "app_user" ADD COLUMN "isCodBlocked" boolean NOT NULL DEFAULT false;
ALTER TABLE "app_user" ADD COLUMN "codBlockedReason" text;
ALTER TABLE "app_user" ADD COLUMN "codBlockedAt" timestamp without time zone;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "cod_failure_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "reason" text NOT NULL,
    "failureNote" text,
    "recordedBy" text,
    "recordedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "cod_failure_record_order_idx" ON "cod_failure_record" USING btree ("orderId");
CREATE INDEX "cod_failure_record_user_idx" ON "cod_failure_record" USING btree ("userId", "recordedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cod_settings" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "maximumAllowedCodFailures" bigint NOT NULL DEFAULT 3,
    "enableAutoBlocking" boolean NOT NULL DEFAULT true,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "codFailureReason" text;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "cod_failure_record"
    ADD CONSTRAINT "cod_failure_record_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "cod_failure_record"
    ADD CONSTRAINT "cod_failure_record_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260703170259992', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260703170259992', "timestamp" = now();

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
