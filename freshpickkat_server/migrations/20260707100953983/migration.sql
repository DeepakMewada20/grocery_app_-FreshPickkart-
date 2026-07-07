BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payment_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "customerId" uuid NOT NULL,
    "createdByAdminId" text NOT NULL,
    "paymentMethod" text NOT NULL DEFAULT 'cod_online'::text,
    "collectionMode" text NOT NULL DEFAULT 'upi_qr'::text,
    "amount" double precision NOT NULL,
    "currency" text NOT NULL DEFAULT 'INR'::text,
    "status" text NOT NULL,
    "razorpayQrId" text,
    "qrImageUrl" text,
    "gatewayPaymentId" text,
    "gatewaySignature" text,
    "gatewayTransactionReference" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone NOT NULL,
    "paidAt" timestamp without time zone,
    "expiredAt" timestamp without time zone,
    "cancelledAt" timestamp without time zone,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "payment_session_order_idx" ON "payment_session" USING btree ("orderId");
CREATE UNIQUE INDEX "payment_session_razorpay_qr_idx" ON "payment_session" USING btree ("razorpayQrId");
CREATE INDEX "payment_session_status_idx" ON "payment_session" USING btree ("orderId", "status");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "payment_session"
    ADD CONSTRAINT "payment_session_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "payment_session"
    ADD CONSTRAINT "payment_session_fk_1"
    FOREIGN KEY("customerId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260707100953983', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260707100953983', "timestamp" = now();

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
