BEGIN;

-- Preserve existing complaint rows and extend the table in place.
ALTER TABLE "complaint" DROP CONSTRAINT IF EXISTS "complaint_fk_2";
DROP INDEX IF EXISTS "complaint_order_item_idx";

ALTER TABLE "complaint" ALTER COLUMN "orderItemId" DROP NOT NULL;
ALTER TABLE "complaint" ADD COLUMN IF NOT EXISTS "complaintType" text NOT NULL DEFAULT 'product'::text;
ALTER TABLE "complaint" ADD COLUMN IF NOT EXISTS "title" text NOT NULL DEFAULT ''::text;
ALTER TABLE "complaint" ADD COLUMN IF NOT EXISTS "selectedProducts" json NOT NULL DEFAULT '[]'::json;
ALTER TABLE "complaint" ADD COLUMN IF NOT EXISTS "adminNote" text;
ALTER TABLE "complaint" ADD COLUMN IF NOT EXISTS "resolutionType" text;

UPDATE "complaint" c
SET
  "complaintType" = COALESCE(NULLIF(c."complaintType", ''), 'product'),
  "title" = COALESCE(NULLIF(c."title", ''), c."issueType", 'Product complaint'),
  "selectedProducts" = CASE
    WHEN c."orderItemId" IS NOT NULL AND oi."id" IS NOT NULL THEN json_build_array(
      json_build_object(
        '__className__', 'ComplaintProductItem',
        'orderItemId', oi."id"::text,
        'productId', oi."productId"::text,
        'variantId', oi."productVariantId"::text,
        'productName', oi."productNameSnapshot",
        'productImage', COALESCE(oi."productImageUrlSnapshot", ''),
        'variantLabel', oi."variantLabelSnapshot",
        'quantity', oi."quantity",
        'unitPrice', oi."unitPrice",
        'totalPrice', oi."totalPrice"
      )
    )
    ELSE COALESCE(c."selectedProducts", '[]'::json)
  END
FROM "order_item" oi
WHERE c."orderItemId" = oi."id";

UPDATE "complaint"
SET
  "complaintType" = COALESCE(NULLIF("complaintType", ''), 'product'),
  "title" = COALESCE(NULLIF("title", ''), "issueType", 'Product complaint'),
  "selectedProducts" = COALESCE("selectedProducts", '[]'::json);

ALTER TABLE "complaint" ALTER COLUMN "selectedProducts" DROP DEFAULT;

CREATE INDEX IF NOT EXISTS "complaint_order_item_idx" ON "complaint" USING btree ("orderItemId");
CREATE INDEX IF NOT EXISTS "complaint_order_type_idx" ON "complaint" USING btree ("orderId", "complaintType", "status");

ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_2"
    FOREIGN KEY("orderItemId")
    REFERENCES "order_item"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "orderType" text NOT NULL DEFAULT 'regular'::text;
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "sourceOrderNumber" text;
ALTER TABLE "customer_order" ADD COLUMN IF NOT EXISTS "complaintId" text;

ALTER TABLE "refund_record" DROP CONSTRAINT IF EXISTS "refund_record_fk_3";
ALTER TABLE "refund_record" ADD COLUMN IF NOT EXISTS "source" text NOT NULL DEFAULT 'order'::text;
ALTER TABLE "refund_record" ADD COLUMN IF NOT EXISTS "reason" text NOT NULL DEFAULT ''::text;
ALTER TABLE "refund_record" ADD COLUMN IF NOT EXISTS "complaintId" uuid;
CREATE INDEX IF NOT EXISTS "refund_record_complaint_idx" ON "refund_record" USING btree ("complaintId");

ALTER TABLE ONLY "refund_record"
    ADD CONSTRAINT "refund_record_fk_3"
    FOREIGN KEY("complaintId")
    REFERENCES "complaint"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260521144827857', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260521144827857', "timestamp" = now();

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();

COMMIT;
