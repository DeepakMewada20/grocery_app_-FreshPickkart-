BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_audit_log" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "actorUserId" uuid,
    "action" text NOT NULL,
    "entityType" text NOT NULL,
    "entityId" uuid,
    "metadata" json,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "firebaseUid" text,
    "phoneNumber" text NOT NULL,
    "name" text,
    "email" text,
    "role" text NOT NULL DEFAULT 'customer'::text,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "app_user_firebase_uid_idx" ON "app_user" USING btree ("firebaseUid");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "banner" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "title" text NOT NULL,
    "imageUrl" text NOT NULL,
    "actionType" text NOT NULL,
    "externalUrl" text,
    "linkedProductId" uuid,
    "linkedCategoryId" uuid,
    "linkedSubCategoryId" uuid,
    "priority" bigint NOT NULL DEFAULT 0,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "banner_placement" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "bannerId" uuid NOT NULL,
    "placementKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "banner_placement_unique_idx" ON "banner_placement" USING btree ("bannerId", "placementKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bogo_offer" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "triggerProductId" uuid NOT NULL,
    "triggerVariantId" uuid,
    "minTriggerQuantity" bigint NOT NULL DEFAULT 1,
    "triggerBaseQuantity" double precision,
    "triggerBaseUnit" text,
    "title" text NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bogo_offer_reward" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "bogoOfferId" uuid NOT NULL,
    "rewardProductId" uuid NOT NULL,
    "rewardVariantId" uuid,
    "quantity" bigint NOT NULL DEFAULT 1,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "bogo_offer_reward_unique_idx" ON "bogo_offer_reward" USING btree ("bogoOfferId", "rewardProductId", "rewardVariantId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "category" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "slug" text NOT NULL,
    "imageUrl" text,
    "displayOrder" bigint NOT NULL DEFAULT 0,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "category_slug_idx" ON "category" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "category_offer" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "categoryId" uuid NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "discountType" text NOT NULL,
    "discountValue" double precision NOT NULL,
    "maxDiscountAmount" double precision,
    "minOrderAmount" double precision,
    "priority" bigint NOT NULL DEFAULT 0,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "category_offer_product_exclusion" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "categoryOfferId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "category_offer_product_exclusion_unique_idx" ON "category_offer_product_exclusion" USING btree ("categoryOfferId", "productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "category_offer_product_scope" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "categoryOfferId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "category_offer_product_scope_unique_idx" ON "category_offer_product_scope" USING btree ("categoryOfferId", "productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "combo_offer" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "description" text,
    "discountType" text NOT NULL,
    "discountValue" double precision NOT NULL,
    "minQuantityPerProduct" bigint NOT NULL DEFAULT 1,
    "maxUsagePerUser" bigint,
    "maxUsageTotal" bigint,
    "usedCount" bigint NOT NULL DEFAULT 0,
    "priority" bigint NOT NULL DEFAULT 0,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "combo_offer_item" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "comboOfferId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "productVariantId" uuid,
    "quantity" bigint NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "combo_offer_item_unique_idx" ON "combo_offer_item" USING btree ("comboOfferId", "productId", "productVariantId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "coupon" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "code" text NOT NULL,
    "description" text,
    "couponType" text NOT NULL,
    "discountValue" double precision,
    "minOrderAmount" double precision NOT NULL DEFAULT 0,
    "maxDiscountAmount" double precision,
    "maxUsageTotal" bigint,
    "maxUsagePerUser" bigint,
    "usedCount" bigint NOT NULL DEFAULT 0,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "coupon_code_idx" ON "coupon" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "coupon_product_scope" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "couponId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "coupon_product_scope_unique_idx" ON "coupon_product_scope" USING btree ("couponId", "productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customer_order" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "orderNumber" text NOT NULL,
    "orderStatus" text NOT NULL,
    "paymentStatus" text NOT NULL,
    "refundStatus" text NOT NULL,
    "couponId" uuid,
    "itemCount" bigint NOT NULL,
    "totalAmount" double precision NOT NULL,
    "discountAmount" double precision NOT NULL DEFAULT 0,
    "deliveryFee" double precision NOT NULL DEFAULT 0,
    "finalAmount" double precision NOT NULL,
    "placedAt" timestamp without time zone,
    "confirmedAt" timestamp without time zone,
    "packedAt" timestamp without time zone,
    "outForDeliveryAt" timestamp without time zone,
    "deliveredAt" timestamp without time zone,
    "cancelledAt" timestamp without time zone,
    "cancellationReason" text,
    "deliveryOtp" text,
    "orderedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "customer_order_order_number_idx" ON "customer_order" USING btree ("orderNumber");
CREATE INDEX "customer_order_user_ordered_idx" ON "customer_order" USING btree ("userId", "orderedAt", "id");
CREATE INDEX "customer_order_status_ordered_idx" ON "customer_order" USING btree ("orderStatus", "orderedAt", "id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "delivery_rule" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "description" text,
    "ruleType" text NOT NULL,
    "deliveryFee" double precision NOT NULL,
    "priority" bigint NOT NULL DEFAULT 0,
    "targetUserType" text,
    "targetOrderCount" bigint,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "free_delivery_rule" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "description" text,
    "ruleType" text NOT NULL,
    "minOrderAmount" double precision,
    "minItemsCount" bigint,
    "couponId" uuid,
    "userId" uuid,
    "waivedAmount" double precision NOT NULL DEFAULT 0,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "idempotency_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "scope" text NOT NULL,
    "idempotencyKey" text NOT NULL,
    "userId" uuid,
    "orderId" uuid,
    "paymentTransactionId" uuid,
    "requestHash" text,
    "responseReference" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "idempotency_scope_key_idx" ON "idempotency_record" USING btree ("scope", "idempotencyKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_address" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "recipientName" text,
    "phoneNumber" text,
    "streetLine1" text NOT NULL,
    "streetLine2" text,
    "landmark" text,
    "city" text NOT NULL,
    "state" text NOT NULL,
    "postalCode" text NOT NULL,
    "country" text NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "order_address_order_idx" ON "order_address" USING btree ("orderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_item" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "productVariantId" uuid,
    "comboOfferId" uuid,
    "bogoOfferId" uuid,
    "productNameSnapshot" text NOT NULL,
    "productImageUrlSnapshot" text,
    "variantLabelSnapshot" text,
    "quantity" bigint NOT NULL,
    "unitPrice" double precision NOT NULL,
    "totalPrice" double precision NOT NULL,
    "isFreeItem" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "order_item_order_idx" ON "order_item" USING btree ("orderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payment_transaction" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "idempotencyKey" text NOT NULL,
    "gatewayName" text NOT NULL,
    "gatewayOrderId" text,
    "gatewayPaymentId" text,
    "amount" double precision NOT NULL,
    "currencyCode" text NOT NULL DEFAULT 'INR'::text,
    "paymentStatus" text NOT NULL,
    "gatewayStatus" text,
    "failureReason" text,
    "paidAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "payment_transaction_idempotency_idx" ON "payment_transaction" USING btree ("idempotencyKey");
CREATE UNIQUE INDEX "payment_transaction_gateway_order_idx" ON "payment_transaction" USING btree ("gatewayOrderId");
CREATE UNIQUE INDEX "payment_transaction_gateway_payment_idx" ON "payment_transaction" USING btree ("gatewayPaymentId");
CREATE INDEX "payment_transaction_order_idx" ON "payment_transaction" USING btree ("orderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "categoryId" uuid NOT NULL,
    "name" text NOT NULL,
    "slug" text NOT NULL,
    "shortDescription" text,
    "description" text,
    "primaryImageUrl" text,
    "countryOfOrigin" text,
    "baseUnit" text,
    "baseQuantity" double precision,
    "quantityDescription" text,
    "mostSearchCount" bigint NOT NULL DEFAULT 0,
    "mostPurchaseCount" bigint NOT NULL DEFAULT 0,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "product_slug_idx" ON "product" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product_search_document" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "productId" uuid NOT NULL,
    "searchText" text NOT NULL,
    "builtAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sourceCreatedAt" timestamp without time zone NOT NULL,
    "sourceUpdatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "product_search_document_product_idx" ON "product_search_document" USING btree ("productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product_search_rebuild_job" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "productId" uuid NOT NULL,
    "reason" text NOT NULL,
    "jobStatus" text NOT NULL DEFAULT 'pending'::text,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "scheduledAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "startedAt" timestamp without time zone,
    "finishedAt" timestamp without time zone,
    "lastError" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "product_search_rebuild_job_status_scheduled_idx" ON "product_search_rebuild_job" USING btree ("jobStatus", "scheduledAt", "id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product_sub_category" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "productId" uuid NOT NULL,
    "subCategoryId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "product_sub_category_unique_idx" ON "product_sub_category" USING btree ("productId", "subCategoryId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product_variant" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "productId" uuid NOT NULL,
    "label" text NOT NULL,
    "sku" text,
    "quantityValue" double precision NOT NULL,
    "quantityUnit" text NOT NULL,
    "quantityDescription" text,
    "salePrice" double precision NOT NULL,
    "listPrice" double precision NOT NULL,
    "isAvailable" boolean NOT NULL DEFAULT true,
    "isDefault" boolean NOT NULL DEFAULT false,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "product_variant_sku_idx" ON "product_variant" USING btree ("sku");
CREATE INDEX "product_variant_product_sort_idx" ON "product_variant" USING btree ("productId", "sortOrder", "id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "refund_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "paymentTransactionId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "gatewayRefundId" text,
    "amount" double precision NOT NULL,
    "refundStatus" text NOT NULL,
    "failureReason" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "refund_record_gateway_refund_idx" ON "refund_record" USING btree ("gatewayRefundId");
CREATE INDEX "refund_record_order_idx" ON "refund_record" USING btree ("orderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sub_category" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "categoryId" uuid NOT NULL,
    "name" text NOT NULL,
    "slug" text NOT NULL,
    "imageUrl" text,
    "displayOrder" bigint NOT NULL DEFAULT 0,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "sub_category_category_slug_idx" ON "sub_category" USING btree ("categoryId", "slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_address" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "label" text,
    "recipientName" text,
    "phoneNumber" text,
    "streetLine1" text NOT NULL,
    "streetLine2" text,
    "landmark" text,
    "city" text NOT NULL,
    "state" text NOT NULL,
    "postalCode" text NOT NULL,
    "country" text NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "isDefault" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "user_address_user_id_idx" ON "user_address" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "admin_audit_log"
    ADD CONSTRAINT "admin_audit_log_fk_0"
    FOREIGN KEY("actorUserId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_0"
    FOREIGN KEY("linkedProductId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_1"
    FOREIGN KEY("linkedCategoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_2"
    FOREIGN KEY("linkedSubCategoryId")
    REFERENCES "sub_category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "banner_placement"
    ADD CONSTRAINT "banner_placement_fk_0"
    FOREIGN KEY("bannerId")
    REFERENCES "banner"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "bogo_offer"
    ADD CONSTRAINT "bogo_offer_fk_0"
    FOREIGN KEY("triggerProductId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "bogo_offer"
    ADD CONSTRAINT "bogo_offer_fk_1"
    FOREIGN KEY("triggerVariantId")
    REFERENCES "product_variant"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "bogo_offer_reward"
    ADD CONSTRAINT "bogo_offer_reward_fk_0"
    FOREIGN KEY("bogoOfferId")
    REFERENCES "bogo_offer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "bogo_offer_reward"
    ADD CONSTRAINT "bogo_offer_reward_fk_1"
    FOREIGN KEY("rewardProductId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "bogo_offer_reward"
    ADD CONSTRAINT "bogo_offer_reward_fk_2"
    FOREIGN KEY("rewardVariantId")
    REFERENCES "product_variant"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "category_offer"
    ADD CONSTRAINT "category_offer_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "category_offer_product_exclusion"
    ADD CONSTRAINT "category_offer_product_exclusion_fk_0"
    FOREIGN KEY("categoryOfferId")
    REFERENCES "category_offer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "category_offer_product_exclusion"
    ADD CONSTRAINT "category_offer_product_exclusion_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "category_offer_product_scope"
    ADD CONSTRAINT "category_offer_product_scope_fk_0"
    FOREIGN KEY("categoryOfferId")
    REFERENCES "category_offer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "category_offer_product_scope"
    ADD CONSTRAINT "category_offer_product_scope_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "combo_offer_item"
    ADD CONSTRAINT "combo_offer_item_fk_0"
    FOREIGN KEY("comboOfferId")
    REFERENCES "combo_offer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "combo_offer_item"
    ADD CONSTRAINT "combo_offer_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "combo_offer_item"
    ADD CONSTRAINT "combo_offer_item_fk_2"
    FOREIGN KEY("productVariantId")
    REFERENCES "product_variant"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "coupon_product_scope"
    ADD CONSTRAINT "coupon_product_scope_fk_0"
    FOREIGN KEY("couponId")
    REFERENCES "coupon"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "coupon_product_scope"
    ADD CONSTRAINT "coupon_product_scope_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "customer_order"
    ADD CONSTRAINT "customer_order_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "customer_order"
    ADD CONSTRAINT "customer_order_fk_1"
    FOREIGN KEY("couponId")
    REFERENCES "coupon"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "free_delivery_rule"
    ADD CONSTRAINT "free_delivery_rule_fk_0"
    FOREIGN KEY("couponId")
    REFERENCES "coupon"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "free_delivery_rule"
    ADD CONSTRAINT "free_delivery_rule_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "idempotency_record"
    ADD CONSTRAINT "idempotency_record_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "idempotency_record"
    ADD CONSTRAINT "idempotency_record_fk_1"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "idempotency_record"
    ADD CONSTRAINT "idempotency_record_fk_2"
    FOREIGN KEY("paymentTransactionId")
    REFERENCES "payment_transaction"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_address"
    ADD CONSTRAINT "order_address_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_2"
    FOREIGN KEY("productVariantId")
    REFERENCES "product_variant"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_3"
    FOREIGN KEY("comboOfferId")
    REFERENCES "combo_offer"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "order_item"
    ADD CONSTRAINT "order_item_fk_4"
    FOREIGN KEY("bogoOfferId")
    REFERENCES "bogo_offer"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "payment_transaction"
    ADD CONSTRAINT "payment_transaction_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "payment_transaction"
    ADD CONSTRAINT "payment_transaction_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product_search_document"
    ADD CONSTRAINT "product_search_document_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product_search_rebuild_job"
    ADD CONSTRAINT "product_search_rebuild_job_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product_sub_category"
    ADD CONSTRAINT "product_sub_category_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "product_sub_category"
    ADD CONSTRAINT "product_sub_category_fk_1"
    FOREIGN KEY("subCategoryId")
    REFERENCES "sub_category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product_variant"
    ADD CONSTRAINT "product_variant_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "refund_record"
    ADD CONSTRAINT "refund_record_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "refund_record"
    ADD CONSTRAINT "refund_record_fk_1"
    FOREIGN KEY("paymentTransactionId")
    REFERENCES "payment_transaction"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "refund_record"
    ADD CONSTRAINT "refund_record_fk_2"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "sub_category"
    ADD CONSTRAINT "sub_category_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_address"
    ADD CONSTRAINT "user_address_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260429105446214', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260429105446214', "timestamp" = now();

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
