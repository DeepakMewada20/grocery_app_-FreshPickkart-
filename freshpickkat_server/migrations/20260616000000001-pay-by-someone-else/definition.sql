BEGIN;

--
-- Class PaymentLinkRow as table payment_link
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
-- Add payment_mode to customer_order
--
ALTER TABLE "customer_order"
    ADD COLUMN "paymentMode" text NOT NULL DEFAULT 'standard';

--
-- Add payment_expires_at to customer_order
--
ALTER TABLE "customer_order"
    ADD COLUMN "paymentExpiresAt" timestamp without time zone;

--
-- Add paid_by fields to customer_order (payer may not be a registered user)
--
ALTER TABLE "customer_order"
    ADD COLUMN "paidByName" text;
ALTER TABLE "customer_order"
    ADD COLUMN "paidByPhone" text;
ALTER TABLE "customer_order"
    ADD COLUMN "paidByEmail" text;

--
-- Foreign key for payment_link -> customer_order
--
ALTER TABLE ONLY "payment_link"
    ADD CONSTRAINT "payment_link_fk_0"
    FOREIGN KEY ("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE CASCADE;

END;
