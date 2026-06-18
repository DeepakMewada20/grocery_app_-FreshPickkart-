BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auto_refund_job" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "orderNumber" text NOT NULL,
    "customerId" uuid NOT NULL,
    "gatewayPaymentId" text NOT NULL,
    "paymentTransactionId" uuid NOT NULL,
    "gatewayOrderId" text,
    "amount" double precision NOT NULL,
    "currency" text NOT NULL DEFAULT 'INR'::text,
    "jobStatus" text NOT NULL DEFAULT 'PENDING'::text,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "nextRetryAt" timestamp without time zone,
    "lastError" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "auto_refund_job_gateway_payment_idx" ON "auto_refund_job" USING btree ("gatewayPaymentId");
CREATE INDEX "auto_refund_job_status_idx" ON "auto_refund_job" USING btree ("jobStatus");
CREATE INDEX "auto_refund_job_order_idx" ON "auto_refund_job" USING btree ("orderId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "paymentSessionId" uuid;
ALTER TABLE "customer_order" ADD COLUMN "paymentLinkId" uuid;
ALTER TABLE "customer_order" ADD COLUMN "paymentLinkUrl" text;
ALTER TABLE "customer_order" ADD COLUMN "paymentLinkExpiresAt" timestamp without time zone;
ALTER TABLE "customer_order" ADD COLUMN "linkStatus" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "payment_link" ADD COLUMN "linkStatus" text NOT NULL DEFAULT 'ACTIVE'::text;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auto_refund_job"
    ADD CONSTRAINT "auto_refund_job_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "auto_refund_job"
    ADD CONSTRAINT "auto_refund_job_fk_1"
    FOREIGN KEY("customerId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "auto_refund_job"
    ADD CONSTRAINT "auto_refund_job_fk_2"
    FOREIGN KEY("paymentTransactionId")
    REFERENCES "payment_transaction"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260618161604824', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260618161604824', "timestamp" = now();

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
