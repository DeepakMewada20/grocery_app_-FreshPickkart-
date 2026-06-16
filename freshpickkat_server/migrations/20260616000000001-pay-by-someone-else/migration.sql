BEGIN;

-- Create payment_link table
CREATE TABLE IF NOT EXISTS "payment_link" (
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

CREATE UNIQUE INDEX IF NOT EXISTS "payment_link_token_idx" ON "payment_link" USING btree ("token");
CREATE INDEX IF NOT EXISTS "payment_link_order_idx" ON "payment_link" USING btree ("orderId");

-- Add columns to customer_order
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "paymentMode" text NOT NULL DEFAULT 'standard';
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "paymentExpiresAt" timestamp without time zone;
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "paidByName" text;
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "paidByPhone" text;
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "paidByEmail" text;

-- Add foreign key
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'payment_link_fk_0'
    ) THEN
        ALTER TABLE ONLY "payment_link"
            ADD CONSTRAINT "payment_link_fk_0"
            FOREIGN KEY ("orderId")
            REFERENCES "customer_order"("id")
            ON DELETE CASCADE;
    END IF;
END $$;

END;
