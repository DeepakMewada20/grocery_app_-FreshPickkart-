BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class AdminAuditLogRow as table admin_audit_log
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
-- Class AppUserRow as table app_user
--
CREATE TABLE "app_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "firebaseUid" text,
    "phoneNumber" text NOT NULL,
    "name" text,
    "email" text,
    "role" text NOT NULL DEFAULT 'customer'::text,
    "fcmToken" text,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "app_user_firebase_uid_idx" ON "app_user" USING btree ("firebaseUid");

--
-- Class BannerRow as table banner
--
CREATE TABLE "banner" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "title" text NOT NULL,
    "imageUrl" text NOT NULL,
    "actionType" text NOT NULL,
    "offerId" text,
    "externalUrl" text,
    "linkedProductId" uuid,
    "comboOfferId" uuid,
    "couponId" uuid,
    "linkedCategoryId" uuid,
    "linkedSubCategoryId" uuid,
    "priority" bigint NOT NULL DEFAULT 0,
    "isBaseImage" boolean NOT NULL DEFAULT false,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Class BannerLinkedProductRow as table banner_linked_product
--
CREATE TABLE "banner_linked_product" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "bannerId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "banner_linked_product_unique_idx" ON "banner_linked_product" USING btree ("bannerId", "productId");
CREATE INDEX "banner_linked_product_banner_sort_idx" ON "banner_linked_product" USING btree ("bannerId", "sortOrder", "id");

--
-- Class BannerPlacementRow as table banner_placement
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
-- Class BogoOfferRow as table bogo_offer
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
-- Class BogoOfferRewardRow as table bogo_offer_reward
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
-- Class CategoryRow as table category
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
-- Class CategoryOfferRow as table category_offer
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
-- Class CategoryOfferProductExclusionRow as table category_offer_product_exclusion
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
-- Class CategoryOfferProductScopeRow as table category_offer_product_scope
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
-- Class ComboOfferRow as table combo_offer
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
-- Class ComboOfferItemRow as table combo_offer_item
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
-- Class CouponRow as table coupon
--
CREATE TABLE "coupon" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "code" text NOT NULL,
    "description" text,
    "couponType" text NOT NULL,
    "couponCategory" text NOT NULL DEFAULT 'All'::text,
    "discountValue" double precision,
    "minOrderAmount" double precision NOT NULL DEFAULT 0,
    "maxDiscountAmount" double precision,
    "maxUsageTotal" bigint,
    "maxUsagePerUser" bigint,
    "loyaltyRequiredOrders" bigint,
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
-- Class CouponProductScopeRow as table coupon_product_scope
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
-- Class CustomerOrderRow as table customer_order
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
    "deliveryPersonName" text,
    "deliveryPersonPhone" text,
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
-- Class DeliveryConfigRow as table delivery_config
--
CREATE TABLE "delivery_config" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "configKey" text NOT NULL,
    "baseDeliveryFee" double precision NOT NULL,
    "freeDeliveryThreshold" double precision,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "delivery_config_key_idx" ON "delivery_config" USING btree ("configKey");

--
-- Class DeliveryRuleRow as table delivery_rule
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
-- Class DeliverySlabRow as table delivery_slab
--
CREATE TABLE "delivery_slab" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "configId" uuid NOT NULL,
    "minOrderAmount" double precision NOT NULL,
    "maxOrderAmount" double precision NOT NULL,
    "fee" double precision NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "delivery_slab_config_sort_idx" ON "delivery_slab" USING btree ("configId", "sortOrder", "id");

--
-- Class FreeDeliveryRuleRow as table free_delivery_rule
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
-- Class IdempotencyRecordRow as table idempotency_record
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
-- Class OrderAddressRow as table order_address
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
-- Class OrderItemRow as table order_item
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
-- Class PaymentTransactionRow as table payment_transaction
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
-- Class ProductRow as table product
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
    "stock" double precision,
    "discountType" text,
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
-- Class ProductSearchDocumentRow as table product_search_document
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
-- Class ProductSearchRebuildJobRow as table product_search_rebuild_job
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
-- Class ProductSubCategoryRow as table product_sub_category
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
-- Class ProductVariantRow as table product_variant
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
-- Class RefundRecordRow as table refund_record
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
-- Class SubCategoryRow as table sub_category
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
-- Class UserAddressRow as table user_address
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
-- Class UserCartItemRow as table user_cart_item
--
CREATE TABLE "user_cart_item" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "productId" text NOT NULL,
    "variantId" text,
    "quantity" bigint NOT NULL,
    "bogoFreeProductId" text,
    "comboId" text,
    "comboName" text,
    "comboDiscountType" text,
    "comboDiscountValue" double precision,
    "comboItemQuantity" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "user_cart_item_user_id_idx" ON "user_cart_item" USING btree ("userId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FacebookAccount as table serverpod_auth_idp_facebook_account
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class MicrosoftAccount as table serverpod_auth_idp_microsoft_account
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "nonce" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "nonce", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "admin_audit_log" table
--
ALTER TABLE ONLY "admin_audit_log"
    ADD CONSTRAINT "admin_audit_log_fk_0"
    FOREIGN KEY("actorUserId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "banner" table
--
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_0"
    FOREIGN KEY("linkedProductId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_1"
    FOREIGN KEY("comboOfferId")
    REFERENCES "combo_offer"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_2"
    FOREIGN KEY("couponId")
    REFERENCES "coupon"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_3"
    FOREIGN KEY("linkedCategoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_4"
    FOREIGN KEY("linkedSubCategoryId")
    REFERENCES "sub_category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "banner_linked_product" table
--
ALTER TABLE ONLY "banner_linked_product"
    ADD CONSTRAINT "banner_linked_product_fk_0"
    FOREIGN KEY("bannerId")
    REFERENCES "banner"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner_linked_product"
    ADD CONSTRAINT "banner_linked_product_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "banner_placement" table
--
ALTER TABLE ONLY "banner_placement"
    ADD CONSTRAINT "banner_placement_fk_0"
    FOREIGN KEY("bannerId")
    REFERENCES "banner"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "bogo_offer" table
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
-- Foreign relations for "bogo_offer_reward" table
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
-- Foreign relations for "category_offer" table
--
ALTER TABLE ONLY "category_offer"
    ADD CONSTRAINT "category_offer_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "category_offer_product_exclusion" table
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
-- Foreign relations for "category_offer_product_scope" table
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
-- Foreign relations for "combo_offer_item" table
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
-- Foreign relations for "coupon_product_scope" table
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
-- Foreign relations for "customer_order" table
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
-- Foreign relations for "delivery_slab" table
--
ALTER TABLE ONLY "delivery_slab"
    ADD CONSTRAINT "delivery_slab_fk_0"
    FOREIGN KEY("configId")
    REFERENCES "delivery_config"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "free_delivery_rule" table
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
-- Foreign relations for "idempotency_record" table
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
-- Foreign relations for "order_address" table
--
ALTER TABLE ONLY "order_address"
    ADD CONSTRAINT "order_address_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "order_item" table
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
-- Foreign relations for "payment_transaction" table
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
-- Foreign relations for "product" table
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "product_search_document" table
--
ALTER TABLE ONLY "product_search_document"
    ADD CONSTRAINT "product_search_document_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "product_search_rebuild_job" table
--
ALTER TABLE ONLY "product_search_rebuild_job"
    ADD CONSTRAINT "product_search_rebuild_job_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "product_sub_category" table
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
-- Foreign relations for "product_variant" table
--
ALTER TABLE ONLY "product_variant"
    ADD CONSTRAINT "product_variant_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "refund_record" table
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
-- Foreign relations for "sub_category" table
--
ALTER TABLE ONLY "sub_category"
    ADD CONSTRAINT "sub_category_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_address" table
--
ALTER TABLE ONLY "user_address"
    ADD CONSTRAINT "user_address_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_cart_item" table
--
ALTER TABLE ONLY "user_cart_item"
    ADD CONSTRAINT "user_cart_item_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_facebook_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_microsoft_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260503061040672', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260503061040672', "timestamp" = now();

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
