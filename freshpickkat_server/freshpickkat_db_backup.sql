--
-- PostgreSQL database dump
--

\restrict ZAhK7ahDBwBuFUA5aa9EAOaXGU6FcuzVuAlGDYvM6F5zQ8x6QSrOBoxtOEyB2fx

-- Dumped from database version 16.12 (Debian 16.12-1.pgdg12+1)
-- Dumped by pg_dump version 16.12 (Debian 16.12-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: gen_random_uuid_v7(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gen_random_uuid_v7() RETURNS uuid
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.gen_random_uuid_v7() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "actorUserId" uuid,
    action text NOT NULL,
    "entityType" text NOT NULL,
    "entityId" uuid,
    metadata json,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.admin_audit_log OWNER TO postgres;

--
-- Name: app_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_user (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "firebaseUid" text,
    "phoneNumber" text NOT NULL,
    name text,
    email text,
    role text DEFAULT 'customer'::text NOT NULL,
    "fcmToken" text,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.app_user OWNER TO postgres;

--
-- Name: banner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banner (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    "imageUrl" text NOT NULL,
    "actionType" text NOT NULL,
    "offerId" text,
    "externalUrl" text,
    "linkedProductId" uuid,
    "comboOfferId" uuid,
    "couponId" uuid,
    "linkedCategoryId" uuid,
    "linkedSubCategoryId" uuid,
    priority bigint DEFAULT 0 NOT NULL,
    "isBaseImage" boolean DEFAULT false NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.banner OWNER TO postgres;

--
-- Name: banner_linked_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banner_linked_product (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "bannerId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "sortOrder" bigint DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.banner_linked_product OWNER TO postgres;

--
-- Name: banner_placement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banner_placement (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "bannerId" uuid NOT NULL,
    "placementKey" text NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.banner_placement OWNER TO postgres;

--
-- Name: bogo_offer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bogo_offer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "triggerProductId" uuid NOT NULL,
    "triggerVariantId" uuid,
    "minTriggerQuantity" bigint DEFAULT 1 NOT NULL,
    "triggerBaseQuantity" double precision,
    "triggerBaseUnit" text,
    title text NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.bogo_offer OWNER TO postgres;

--
-- Name: bogo_offer_reward; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bogo_offer_reward (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "bogoOfferId" uuid NOT NULL,
    "rewardProductId" uuid NOT NULL,
    "rewardVariantId" uuid,
    "freeQuantity" bigint DEFAULT 1 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.bogo_offer_reward OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    "imageUrl" text,
    "displayOrder" bigint DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_offer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_offer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "categoryId" uuid NOT NULL,
    name text NOT NULL,
    description text,
    "discountType" text NOT NULL,
    "discountValue" double precision NOT NULL,
    "maxDiscountAmount" double precision,
    "minOrderAmount" double precision,
    priority bigint DEFAULT 0 NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.category_offer OWNER TO postgres;

--
-- Name: category_offer_product_exclusion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_offer_product_exclusion (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "categoryOfferId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.category_offer_product_exclusion OWNER TO postgres;

--
-- Name: category_offer_product_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_offer_product_scope (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "categoryOfferId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.category_offer_product_scope OWNER TO postgres;

--
-- Name: combo_offer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.combo_offer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    "discountType" text NOT NULL,
    "discountValue" double precision NOT NULL,
    "minQuantityPerProduct" bigint DEFAULT 1 NOT NULL,
    "maxUsagePerUser" bigint,
    "maxUsageTotal" bigint,
    "usedCount" bigint DEFAULT 0 NOT NULL,
    priority bigint DEFAULT 0 NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.combo_offer OWNER TO postgres;

--
-- Name: combo_offer_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.combo_offer_item (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "comboOfferId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "productVariantId" uuid,
    quantity bigint NOT NULL,
    "sortOrder" bigint DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.combo_offer_item OWNER TO postgres;

--
-- Name: coupon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    description text,
    "couponType" text NOT NULL,
    "couponCategory" text DEFAULT 'All'::text NOT NULL,
    "discountValue" double precision,
    "minOrderAmount" double precision DEFAULT 0 NOT NULL,
    "maxDiscountAmount" double precision,
    "maxUsageTotal" bigint,
    "maxUsagePerUser" bigint,
    "loyaltyRequiredOrders" bigint,
    "usedCount" bigint DEFAULT 0 NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.coupon OWNER TO postgres;

--
-- Name: coupon_product_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_product_scope (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "couponId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.coupon_product_scope OWNER TO postgres;

--
-- Name: customer_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_order (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "userId" uuid NOT NULL,
    "orderNumber" text NOT NULL,
    "orderStatus" text NOT NULL,
    "paymentStatus" text NOT NULL,
    "refundStatus" text NOT NULL,
    "couponId" uuid,
    "itemCount" bigint NOT NULL,
    "totalAmount" double precision NOT NULL,
    "discountAmount" double precision DEFAULT 0 NOT NULL,
    "deliveryFee" double precision DEFAULT 0 NOT NULL,
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
    "analyticsProcessedAt" timestamp without time zone,
    "orderedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.customer_order OWNER TO postgres;

--
-- Name: delivery_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "configKey" text NOT NULL,
    "baseDeliveryFee" double precision NOT NULL,
    "freeDeliveryThreshold" double precision,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.delivery_config OWNER TO postgres;

--
-- Name: delivery_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_rule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    "ruleType" text NOT NULL,
    "deliveryFee" double precision NOT NULL,
    priority bigint DEFAULT 0 NOT NULL,
    "targetUserType" text,
    "targetOrderCount" bigint,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.delivery_rule OWNER TO postgres;

--
-- Name: delivery_slab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_slab (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "configId" uuid NOT NULL,
    "minOrderAmount" double precision NOT NULL,
    "maxOrderAmount" double precision NOT NULL,
    fee double precision NOT NULL,
    "sortOrder" bigint DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.delivery_slab OWNER TO postgres;

--
-- Name: free_delivery_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.free_delivery_rule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    "ruleType" text NOT NULL,
    "minOrderAmount" double precision,
    "minItemsCount" bigint,
    "couponId" uuid,
    "userId" uuid,
    "waivedAmount" double precision DEFAULT 0 NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.free_delivery_rule OWNER TO postgres;

--
-- Name: idempotency_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idempotency_record (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    scope text NOT NULL,
    "idempotencyKey" text NOT NULL,
    "userId" uuid,
    "orderId" uuid,
    "paymentTransactionId" uuid,
    "requestHash" text,
    "responseReference" text,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "expiresAt" timestamp without time zone
);


ALTER TABLE public.idempotency_record OWNER TO postgres;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_address (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "recipientName" text,
    "phoneNumber" text,
    "streetLine1" text NOT NULL,
    "streetLine2" text,
    landmark text,
    city text NOT NULL,
    state text NOT NULL,
    "postalCode" text NOT NULL,
    country text NOT NULL,
    latitude double precision,
    longitude double precision,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.order_address OWNER TO postgres;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "productVariantId" uuid,
    "comboOfferId" uuid,
    "bogoOfferId" uuid,
    "productNameSnapshot" text NOT NULL,
    "productImageUrlSnapshot" text,
    "variantLabelSnapshot" text,
    quantity bigint NOT NULL,
    "unitPrice" double precision NOT NULL,
    "totalPrice" double precision NOT NULL,
    "isFreeItem" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- Name: order_notification_outbox; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_notification_outbox (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "dedupeKey" text NOT NULL,
    "eventType" text NOT NULL,
    "orderId" text NOT NULL,
    "userId" text,
    status text,
    "payloadJson" text NOT NULL,
    "attemptCount" bigint DEFAULT 0 NOT NULL,
    "lastError" text,
    "processedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.order_notification_outbox OWNER TO postgres;

--
-- Name: order_tracking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_tracking (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "trackingEnabled" boolean DEFAULT false NOT NULL,
    "userLatitude" double precision,
    "userLongitude" double precision,
    "userAddress" text,
    "userLocationType" text,
    "riderLatitude" double precision,
    "riderLongitude" double precision,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.order_tracking OWNER TO postgres;

--
-- Name: payment_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_transaction (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "idempotencyKey" text NOT NULL,
    "gatewayName" text NOT NULL,
    "gatewayOrderId" text,
    "gatewayPaymentId" text,
    amount double precision NOT NULL,
    "currencyCode" text DEFAULT 'INR'::text NOT NULL,
    "paymentStatus" text NOT NULL,
    "gatewayStatus" text,
    "failureReason" text,
    "paidAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.payment_transaction OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "categoryId" uuid NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    "shortDescription" text,
    description text,
    "primaryImageUrl" text,
    "countryOfOrigin" text,
    "baseUnit" text,
    "baseQuantity" double precision,
    "quantityDescription" text,
    stock double precision,
    "stockUnit" text,
    "discountType" text,
    "mostSearchCount" bigint DEFAULT 0 NOT NULL,
    "mostPurchaseCount" bigint DEFAULT 0 NOT NULL,
    "last7DaysSold" bigint DEFAULT 0 NOT NULL,
    "last7DaysViews" bigint DEFAULT 0 NOT NULL,
    "reorderCount" bigint DEFAULT 0 NOT NULL,
    "trendingScore" double precision DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_search_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_search_document (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "productId" uuid NOT NULL,
    "searchText" text NOT NULL,
    "builtAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "sourceCreatedAt" timestamp without time zone NOT NULL,
    "sourceUpdatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.product_search_document OWNER TO postgres;

--
-- Name: product_search_rebuild_job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_search_rebuild_job (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "productId" uuid NOT NULL,
    reason text NOT NULL,
    "jobStatus" text DEFAULT 'pending'::text NOT NULL,
    "attemptCount" bigint DEFAULT 0 NOT NULL,
    "scheduledAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "startedAt" timestamp without time zone,
    "finishedAt" timestamp without time zone,
    "lastError" text,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product_search_rebuild_job OWNER TO postgres;

--
-- Name: product_sub_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sub_category (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "productId" uuid NOT NULL,
    "subCategoryId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product_sub_category OWNER TO postgres;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "productId" uuid NOT NULL,
    label text NOT NULL,
    sku text,
    "quantityValue" double precision NOT NULL,
    "quantityUnit" text NOT NULL,
    "quantityDescription" text,
    "salePrice" double precision NOT NULL,
    "listPrice" double precision NOT NULL,
    "isAvailable" boolean DEFAULT true NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    "sortOrder" bigint DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product_variant OWNER TO postgres;

--
-- Name: refund_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund_record (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "paymentTransactionId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "gatewayRefundId" text,
    amount double precision NOT NULL,
    "refundStatus" text NOT NULL,
    "failureReason" text,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.refund_record OWNER TO postgres;

--
-- Name: serverpod_auth_core_jwt_refresh_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_jwt_refresh_token (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    method text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.serverpod_auth_core_jwt_refresh_token OWNER TO postgres;

--
-- Name: serverpod_auth_core_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_profile (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    email text,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "imageId" uuid
);


ALTER TABLE public.serverpod_auth_core_profile OWNER TO postgres;

--
-- Name: serverpod_auth_core_profile_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_profile_image (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "storageId" text NOT NULL,
    path text NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.serverpod_auth_core_profile_image OWNER TO postgres;

--
-- Name: serverpod_auth_core_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_session (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "lastUsedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    method text NOT NULL
);


ALTER TABLE public.serverpod_auth_core_session OWNER TO postgres;

--
-- Name: serverpod_auth_core_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_user (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    blocked boolean NOT NULL
);


ALTER TABLE public.serverpod_auth_core_user OWNER TO postgres;

--
-- Name: serverpod_auth_idp_anonymous_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_anonymous_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_anonymous_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_apple_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_apple_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    email text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);


ALTER TABLE public.serverpod_auth_idp_apple_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_email_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_email_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_email_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_email_account_password_reset_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_email_account_password_reset_request (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);


ALTER TABLE public.serverpod_auth_idp_email_account_password_reset_request OWNER TO postgres;

--
-- Name: serverpod_auth_idp_email_account_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_email_account_request (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);


ALTER TABLE public.serverpod_auth_idp_email_account_request OWNER TO postgres;

--
-- Name: serverpod_auth_idp_facebook_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_facebook_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    email text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);


ALTER TABLE public.serverpod_auth_idp_facebook_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_firebase_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_firebase_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    created timestamp without time zone NOT NULL,
    email text,
    phone text,
    "userIdentifier" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_firebase_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_github_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_github_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    email text,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_github_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_google_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_google_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    created timestamp without time zone NOT NULL,
    email text NOT NULL,
    "userIdentifier" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_google_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_microsoft_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_microsoft_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    email text,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_microsoft_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_passkey_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_passkey_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_passkey_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_passkey_challenge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_passkey_challenge (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    challenge bytea NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_passkey_challenge OWNER TO postgres;

--
-- Name: serverpod_auth_idp_rate_limited_request_attempt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_rate_limited_request_attempt (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    domain text NOT NULL,
    source text NOT NULL,
    nonce text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);


ALTER TABLE public.serverpod_auth_idp_rate_limited_request_attempt OWNER TO postgres;

--
-- Name: serverpod_auth_idp_secret_challenge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_secret_challenge (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "challengeCodeHash" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_secret_challenge OWNER TO postgres;

--
-- Name: serverpod_cloud_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_cloud_storage (
    id bigint NOT NULL,
    "storageId" text NOT NULL,
    path text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    expiration timestamp without time zone,
    "byteData" bytea NOT NULL,
    verified boolean NOT NULL
);


ALTER TABLE public.serverpod_cloud_storage OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_direct_upload; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_cloud_storage_direct_upload (
    id bigint NOT NULL,
    "storageId" text NOT NULL,
    path text NOT NULL,
    expiration timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);


ALTER TABLE public.serverpod_cloud_storage_direct_upload OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_direct_upload_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_cloud_storage_direct_upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_cloud_storage_direct_upload_id_seq OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_direct_upload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_cloud_storage_direct_upload_id_seq OWNED BY public.serverpod_cloud_storage_direct_upload.id;


--
-- Name: serverpod_cloud_storage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_cloud_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_cloud_storage_id_seq OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_cloud_storage_id_seq OWNED BY public.serverpod_cloud_storage.id;


--
-- Name: serverpod_future_call; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_future_call (
    id bigint NOT NULL,
    name text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    identifier text
);


ALTER TABLE public.serverpod_future_call OWNER TO postgres;

--
-- Name: serverpod_future_call_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_future_call_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_future_call_id_seq OWNER TO postgres;

--
-- Name: serverpod_future_call_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_future_call_id_seq OWNED BY public.serverpod_future_call.id;


--
-- Name: serverpod_health_connection_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_health_connection_info (
    id bigint NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    active bigint NOT NULL,
    closing bigint NOT NULL,
    idle bigint NOT NULL,
    granularity bigint NOT NULL
);


ALTER TABLE public.serverpod_health_connection_info OWNER TO postgres;

--
-- Name: serverpod_health_connection_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_health_connection_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_health_connection_info_id_seq OWNER TO postgres;

--
-- Name: serverpod_health_connection_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_health_connection_info_id_seq OWNED BY public.serverpod_health_connection_info.id;


--
-- Name: serverpod_health_metric; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_health_metric (
    id bigint NOT NULL,
    name text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    value double precision NOT NULL,
    granularity bigint NOT NULL
);


ALTER TABLE public.serverpod_health_metric OWNER TO postgres;

--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_health_metric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_health_metric_id_seq OWNER TO postgres;

--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_health_metric_id_seq OWNED BY public.serverpod_health_metric.id;


--
-- Name: serverpod_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_log (
    id bigint NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    reference text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    message text NOT NULL,
    error text,
    "stackTrace" text,
    "order" bigint NOT NULL
);


ALTER TABLE public.serverpod_log OWNER TO postgres;

--
-- Name: serverpod_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_log_id_seq OWNED BY public.serverpod_log.id;


--
-- Name: serverpod_message_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_message_log (
    id bigint NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    endpoint text NOT NULL,
    "messageName" text NOT NULL,
    duration double precision NOT NULL,
    error text,
    "stackTrace" text,
    slow boolean NOT NULL,
    "order" bigint NOT NULL
);


ALTER TABLE public.serverpod_message_log OWNER TO postgres;

--
-- Name: serverpod_message_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_message_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_message_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_message_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_message_log_id_seq OWNED BY public.serverpod_message_log.id;


--
-- Name: serverpod_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_method (
    id bigint NOT NULL,
    endpoint text NOT NULL,
    method text NOT NULL
);


ALTER TABLE public.serverpod_method OWNER TO postgres;

--
-- Name: serverpod_method_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_method_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_method_id_seq OWNER TO postgres;

--
-- Name: serverpod_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_method_id_seq OWNED BY public.serverpod_method.id;


--
-- Name: serverpod_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_migrations (
    id bigint NOT NULL,
    module text NOT NULL,
    version text NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.serverpod_migrations OWNER TO postgres;

--
-- Name: serverpod_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_migrations_id_seq OWNER TO postgres;

--
-- Name: serverpod_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_migrations_id_seq OWNED BY public.serverpod_migrations.id;


--
-- Name: serverpod_query_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_query_log (
    id bigint NOT NULL,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    query text NOT NULL,
    duration double precision NOT NULL,
    "numRows" bigint,
    error text,
    "stackTrace" text,
    slow boolean NOT NULL,
    "order" bigint NOT NULL
);


ALTER TABLE public.serverpod_query_log OWNER TO postgres;

--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_query_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_query_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_query_log_id_seq OWNED BY public.serverpod_query_log.id;


--
-- Name: serverpod_readwrite_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_readwrite_test (
    id bigint NOT NULL,
    number bigint NOT NULL
);


ALTER TABLE public.serverpod_readwrite_test OWNER TO postgres;

--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_readwrite_test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_readwrite_test_id_seq OWNER TO postgres;

--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_readwrite_test_id_seq OWNED BY public.serverpod_readwrite_test.id;


--
-- Name: serverpod_runtime_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_runtime_settings (
    id bigint NOT NULL,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);


ALTER TABLE public.serverpod_runtime_settings OWNER TO postgres;

--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_runtime_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_runtime_settings_id_seq OWNER TO postgres;

--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_runtime_settings_id_seq OWNED BY public.serverpod_runtime_settings.id;


--
-- Name: serverpod_session_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_session_log (
    id bigint NOT NULL,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    module text,
    endpoint text,
    method text,
    duration double precision,
    "numQueries" bigint,
    slow boolean,
    error text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    touched timestamp without time zone NOT NULL
);


ALTER TABLE public.serverpod_session_log OWNER TO postgres;

--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_session_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_session_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_session_log_id_seq OWNED BY public.serverpod_session_log.id;


--
-- Name: sub_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_category (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "categoryId" uuid NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    "imageUrl" text,
    "displayOrder" bigint DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    "deactivatedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.sub_category OWNER TO postgres;

--
-- Name: user_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_address (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "userId" uuid NOT NULL,
    label text,
    "recipientName" text,
    "phoneNumber" text,
    "streetLine1" text NOT NULL,
    "streetLine2" text,
    landmark text,
    city text NOT NULL,
    state text NOT NULL,
    "postalCode" text NOT NULL,
    country text NOT NULL,
    latitude double precision,
    longitude double precision,
    "isDefault" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_address OWNER TO postgres;

--
-- Name: user_cart_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_cart_item (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "userId" uuid NOT NULL,
    "productId" text NOT NULL,
    "variantId" text,
    quantity bigint NOT NULL,
    "bogoFreeProductId" text,
    "comboId" text,
    "comboName" text,
    "comboDiscountType" text,
    "comboDiscountValue" double precision,
    "comboItemQuantity" bigint,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_cart_item OWNER TO postgres;

--
-- Name: serverpod_cloud_storage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage ALTER COLUMN id SET DEFAULT nextval('public.serverpod_cloud_storage_id_seq'::regclass);


--
-- Name: serverpod_cloud_storage_direct_upload id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage_direct_upload ALTER COLUMN id SET DEFAULT nextval('public.serverpod_cloud_storage_direct_upload_id_seq'::regclass);


--
-- Name: serverpod_future_call id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_future_call ALTER COLUMN id SET DEFAULT nextval('public.serverpod_future_call_id_seq'::regclass);


--
-- Name: serverpod_health_connection_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_connection_info ALTER COLUMN id SET DEFAULT nextval('public.serverpod_health_connection_info_id_seq'::regclass);


--
-- Name: serverpod_health_metric id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_metric ALTER COLUMN id SET DEFAULT nextval('public.serverpod_health_metric_id_seq'::regclass);


--
-- Name: serverpod_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_log_id_seq'::regclass);


--
-- Name: serverpod_message_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_message_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_message_log_id_seq'::regclass);


--
-- Name: serverpod_method id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_method ALTER COLUMN id SET DEFAULT nextval('public.serverpod_method_id_seq'::regclass);


--
-- Name: serverpod_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_migrations ALTER COLUMN id SET DEFAULT nextval('public.serverpod_migrations_id_seq'::regclass);


--
-- Name: serverpod_query_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_query_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_query_log_id_seq'::regclass);


--
-- Name: serverpod_readwrite_test id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_readwrite_test ALTER COLUMN id SET DEFAULT nextval('public.serverpod_readwrite_test_id_seq'::regclass);


--
-- Name: serverpod_runtime_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_runtime_settings ALTER COLUMN id SET DEFAULT nextval('public.serverpod_runtime_settings_id_seq'::regclass);


--
-- Name: serverpod_session_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_session_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_session_log_id_seq'::regclass);


--
-- Data for Name: admin_audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_audit_log (id, "actorUserId", action, "entityType", "entityId", metadata, "createdAt") FROM stdin;
04610b43-c399-4ad5-a570-33538d1690ed	1099e310-6238-423a-b5e9-3244a6060b3f	create	category	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	{"name":"Fruits"}	2026-05-12 05:16:33.520942
7ad47c98-08b9-4c41-b2d6-80629235e8d2	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	d80729c8-922c-4c59-846d-c75b88b05758	{"category":"Fruits"}	2026-05-12 05:22:27.18014
7a9291d7-7c09-4f67-bd40-060c6df49fee	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	f8218f8b-b55a-44b6-b24a-909a2ffdf45d	{"category":"Fruits"}	2026-05-12 05:23:52.649638
99e99784-f226-45c5-9946-66cbe38955ec	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	a49587a8-6cb8-4501-ba05-6c78e0d71a5c	{"category":"Fruits"}	2026-05-12 05:25:02.879131
9bb7e363-0f53-4d33-bb4c-2da8ae817fff	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	1ed3786a-e5e8-47df-b55c-9d938c3b42a8	{"category":"Fruits"}	2026-05-12 05:25:23.627805
313bd273-502f-41a4-97ba-4310299b28a0	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	e256adbd-eddf-4d95-bf26-75c711f103f5	{"category":"Fruits"}	2026-05-12 05:25:55.209801
763658e2-6be7-42bb-b15e-7c6dc7966ec8	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	2ac7c676-2d3f-4c58-98c1-75219953084f	{"category":"Fruits"}	2026-05-12 05:26:20.911765
48e72ebf-8570-40fc-9f66-312cdab9dd7d	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	187cf555-03eb-425b-8687-87fed20b2310	{"category":"Fruits"}	2026-05-12 05:27:01.864235
42537961-f223-4e48-af87-f9c2c29b9dee	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	d1d558ff-042e-4b80-9270-3872f54bb799	{"category":"Fruits"}	2026-05-12 05:27:47.337965
6d0d2e1c-3268-4a5e-8d95-135df89f5a5b	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	4f1ca6d2-cb62-4db8-81cc-9710f07230b8	{"category":"Fruits"}	2026-05-12 05:28:09.850448
aea6582a-badb-49d4-9ceb-57fbdc66f7d9	1099e310-6238-423a-b5e9-3244a6060b3f	create	category	0829417b-f54d-4baa-9732-d228d58ae666	{"name":"Vagetables"}	2026-05-12 05:29:15.182112
3a71300b-8e4b-4dd1-b1db-a73183d4122a	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	ed71183a-1324-4336-9f82-ac9e95f575eb	{"category":"Vagetables"}	2026-05-12 05:32:57.747475
7809594e-37e7-4450-85ec-16b4bfedc8f7	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	8acd4d20-a95b-417f-a274-a06934c39267	{"category":"Vagetables"}	2026-05-12 05:33:30.418018
563d3401-147e-437b-976d-7c8367e73582	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	4d362f94-2716-4ac4-a672-8b4e39aac5fe	{"category":"Vagetables"}	2026-05-12 05:34:06.546312
68b4de71-d0d0-4ca5-a712-41a0b95f923c	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	bc0f5199-b695-4375-a684-39ee96ad8038	{"category":"Vagetables"}	2026-05-12 05:34:56.059659
3c366a55-8949-4a1a-b837-e3e4b113ea3e	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	1e1306a2-1b26-44a4-a40f-d3994b77c846	{"category":"Vagetables"}	2026-05-12 05:35:23.242138
bd8372b5-48eb-4290-89fb-696d63819fed	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	86e60c53-9134-4ff3-b5d4-4ebd9b9062e7	{"category":"Fruits"}	2026-05-12 05:36:46.614732
3c4363ff-7069-441a-8c6c-8ac8b179845a	1099e310-6238-423a-b5e9-3244a6060b3f	update	sub_category	86e60c53-9134-4ff3-b5d4-4ebd9b9062e7	{"old_category":"Fruits","new_category":"Vagetables","old_name":"Salad & Sprouts","new_name":"Salad & Sprouts"}	2026-05-12 05:37:10.550824
b2ada4a1-5602-465e-bbac-64ecc31537d0	1099e310-6238-423a-b5e9-3244a6060b3f	create	sub_category	b20b4e9f-8de9-4b27-8cca-e43575f215fe	{"category":"Vagetables"}	2026-05-12 05:37:51.374479
d887e11d-f138-44b5-b8eb-67462b6c0380	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	e21dff30-ca90-4740-ac4e-2c7a1b8bebb2	{"category":"Vagetables"}	2026-05-12 05:47:26.96029
d6a0e019-d3e1-448b-a408-4ad2a4218d55	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	ba950235-2571-4a2a-b24b-97b277b98e8f	{"category":"Vagetables"}	2026-05-12 05:48:55.913667
bd9e3d7c-3834-41af-a131-0c9c8a0f104c	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	8269290d-8a0d-411f-92fe-59b1f150ec89	{"category":"Vagetables"}	2026-05-12 05:56:07.899979
218ada83-746f-4145-bc53-6e3ef802c4ba	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	143aedf4-0ec5-4d57-aa96-36c117a95113	{"category":"Fruits"}	2026-05-12 07:03:49.001835
c5055a4a-d892-41ac-8daa-15d19a720272	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	4af359d4-045b-4280-a180-68ef83104b7e	{"category":"Vagetables"}	2026-05-12 07:05:38.663836
2e635c66-6777-444d-953e-33102eb46064	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	f19c30d4-80b1-4782-b7ad-9262f7e7a327	{"category":"Fruits"}	2026-05-12 07:06:43.389461
1ef5ce93-9234-4773-b68a-a48a51edfdce	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	ca8e3571-1b75-4c23-9257-72c9369747fb	{"category":"Vagetables"}	2026-05-12 07:07:28.014649
8d5f5bad-bef7-47af-9939-7a1c9fb197ed	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	b8beb637-e69e-40f5-90cf-32bca177c8db	{"category":"Vagetables"}	2026-05-12 07:08:14.706091
f255ffa9-7c50-4097-aa97-fb88272332d4	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	b8beb637-e69e-40f5-90cf-32bca177c8db	{"name":"Onion"}	2026-05-12 07:08:27.534004
f48df0ff-0ded-4ebf-b9a7-797f08601ea0	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	b8beb637-e69e-40f5-90cf-32bca177c8db	{"name":"Onion"}	2026-05-12 07:08:42.355877
91d0c4a5-8200-4a11-b020-be82a50ab373	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	5f9c241a-b32d-458e-9824-ced57f751570	{"category":"Vagetables"}	2026-05-12 07:10:27.777592
50de6b75-2d62-462a-bf8e-6057d818af87	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	{"category":"Fruits"}	2026-05-12 07:47:16.164519
f9193691-a6ba-4884-9cf9-3dc8d85e743c	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	e8e44a39-39d7-42e3-b105-d0e184b6846d	{"category":"Vagetables"}	2026-05-12 07:48:23.422325
a6a8b4e9-0cb2-47c9-81e5-26711a82ec00	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	f2460837-a87f-47b0-8e17-7253dfb8194b	{"category":"Vagetables"}	2026-05-12 07:49:24.774274
aeb681c4-aca0-41f4-852f-34727840805c	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	{"category":"Vagetables"}	2026-05-12 07:52:00.034056
f821a40a-fbf7-48b6-96c6-5389b677084d	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	{"category":"Vagetables"}	2026-05-12 07:55:27.679908
9775ba42-fecb-499b-8d7f-46f63df56bc3	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	287343ff-b9b5-415f-870f-f26ea5510d92	{"category":"Vagetables"}	2026-05-12 07:56:23.993671
803bf686-db8c-4df7-9744-d84819d7400b	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	9c320e33-d76d-4369-ad42-3ab2bbab548b	{"category":"Fruits"}	2026-05-12 07:57:58.669459
20404232-bf5a-49ee-a4f7-a4112b4e8b80	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	1ce6273a-4ec3-4825-aedb-b68d88c2153c	{"category":"Vagetables"}	2026-05-12 07:58:52.785653
3f15210c-3a13-4c4d-bf27-ef6922d3326f	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	ae6a7239-9e09-4128-9461-847e64e852e6	{"category":"Fruits"}	2026-05-12 08:00:21.364281
3dccfeef-7472-4a9a-9322-ccab207c1e84	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	b8beb637-e69e-40f5-90cf-32bca177c8db	{"name":"Onion"}	2026-05-12 08:00:57.530702
b8b1d059-0c4e-460a-ac69-c10b13992ec7	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	248a8e70-e6da-470c-9f2b-8a6c17b3e1c9	{"category":"Vagetables"}	2026-05-12 08:06:54.472322
4d4a9423-1033-48b3-aa10-ab05cd4b8390	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	95d2678c-e460-4a01-966c-1d112903ca2b	{"category":"Vagetables"}	2026-05-12 08:08:03.908215
bfe342b3-4186-472f-ad1e-9b95f77680eb	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	7a5f93a3-fb0b-4ebc-b153-003a1b2a2a42	{"category":"Vagetables"}	2026-05-12 08:09:04.905231
64b9b411-3352-40d2-9ce0-9617f0a81628	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	ce906a6b-d97f-4061-9bec-351844d247d2	{"category":"Fruits"}	2026-05-12 08:10:06.98069
3c81da53-843e-46b4-8081-c76ea44d15d1	1099e310-6238-423a-b5e9-3244a6060b3f	create	product	87b3fc3f-e12c-44f5-92a0-17da34844c84	{"category":"Fruits"}	2026-05-12 08:11:02.945595
0a52280c-5163-4d78-bae8-feb9d9289cef	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	{"name":"Banana"}	2026-05-12 08:20:28.219969
fb173e0b-9a0e-421e-a69d-8297cd72d3fa	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	1ce6273a-4ec3-4825-aedb-b68d88c2153c	{"name":"Cucumber Kakdi"}	2026-05-12 08:40:09.489692
1e050b67-bac7-4dc0-8a6b-7ba5d8adca1b	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	b8beb637-e69e-40f5-90cf-32bca177c8db	{"name":"Onion"}	2026-05-12 08:42:05.251144
3f80b349-c677-42f6-bda1-b142d60877a7	1099e310-6238-423a-b5e9-3244a6060b3f	upsert	combo_offer	\N	\N	2026-05-12 08:44:24.725723
26f7fdb4-56a9-4a3d-aee3-2faa3da16d79	1099e310-6238-423a-b5e9-3244a6060b3f	upsert	combo_offer	\N	\N	2026-05-12 08:45:38.953793
9c886df6-1c8b-4643-a0f2-18032c323af2	1099e310-6238-423a-b5e9-3244a6060b3f	upsert	category_offer	\N	\N	2026-05-12 08:46:21.291499
eae10832-9199-48ac-8859-0106a8002d1e	1099e310-6238-423a-b5e9-3244a6060b3f	create	coupon	\N	{"entityRef":"2-ORDER"}	2026-05-12 08:52:53.955498
88570e0f-1307-4995-8b24-948f86000e50	1099e310-6238-423a-b5e9-3244a6060b3f	create	coupon	\N	{"entityRef":"SAVE30"}	2026-05-12 08:54:04.36171
7f0aad3b-3ed6-4306-81f6-f501a914bb2a	1099e310-6238-423a-b5e9-3244a6060b3f	create	coupon	\N	{"entityRef":"SAVE 10%"}	2026-05-12 09:09:50.945846
6546f3a9-a2c6-4ab2-92ed-00e1ce7f3199	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	ce906a6b-d97f-4061-9bec-351844d247d2	{"name":"Apple Shimla Small"}	2026-05-12 09:40:23.270858
af8c0f5a-ab73-4b42-8441-02beebc5b20d	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	248a8e70-e6da-470c-9f2b-8a6c17b3e1c9	{"name":"Arbi"}	2026-05-12 09:40:33.725031
8484fd80-b4d6-4e55-9e0e-c8ca98054f3b	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	5f9c241a-b32d-458e-9824-ced57f751570	{"name":"Bhindi"}	2026-05-12 09:45:15.982826
a81c6635-7903-4f0a-9429-bda1d38bcf1e	1099e310-6238-423a-b5e9-3244a6060b3f	update	product	87b3fc3f-e12c-44f5-92a0-17da34844c84	{"name":"Apple Shimla Small"}	2026-05-12 10:04:41.742878
\.


--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_user (id, "firebaseUid", "phoneNumber", name, email, role, "fcmToken", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
1099e310-6238-423a-b5e9-3244a6060b3f	i6FzAy0qIkZN6pSEv8bd8CAUVz93		deepak20	mewadadeepak367@gmail.com	ADMIN_SELLER	\N	active	\N	2026-05-11 19:44:28.557067	2026-05-12 12:40:05.960847
d8035b52-e2b1-4f74-ad99-7223008bc246	vjOMlEdMhmceW0YDV48rx2MDz1s2	+918815086850	Deepak Mewada	\N	user	\N	active	\N	2026-05-12 09:25:55.549149	2026-05-12 12:41:17.622076
\.


--
-- Data for Name: banner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banner (id, title, "imageUrl", "actionType", "offerId", "externalUrl", "linkedProductId", "comboOfferId", "couponId", "linkedCategoryId", "linkedSubCategoryId", priority, "isBaseImage", "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	Home Top Image Offer Banner	https://firebasestorage.googleapis.com/v0/b/freshpickkart-a6824.firebasestorage.app/o/banners%2Fi6FzAy0qIkZN6pSEv8bd8CAUVz93%2F1778573519448_scaled_1000126707.png?alt=media&token=0204ed95-5f0f-44a4-a0b0-74e31ac7a4a5	offer	\N	\N	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	\N	\N	\N	\N	1	t	2026-05-12 08:11:24.898531	2026-06-11 08:11:24.898533	active	\N	2026-05-12 08:12:23.718435	2026-05-12 08:12:23.718435
b7a4b69b-cc1c-4696-ae7a-f39b2d116f85	Home Top Product Banner	https://file.milkbasket.com/banners/Frame+5_1723618465.png	product	\N	\N	9c320e33-d76d-4369-ad42-3ab2bbab548b	\N	\N	\N	\N	1	f	2026-05-12 08:12:26.52192	2026-06-11 08:12:26.521926	active	\N	2026-05-12 08:15:29.692113	2026-05-12 08:15:29.692113
40c6e391-9646-46a2-bcbb-a5dba5ead151	Home Top Category Banner	https://file.milkbasket.com/banners/Citrus+Fruits+L2+banner_1717053329.png	category	\N	\N	\N	\N	\N	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	\N	1	f	2026-05-12 08:15:33.858048	2026-06-11 08:15:33.85805	active	\N	2026-05-12 08:16:04.003977	2026-05-12 08:16:04.003977
204c0708-d0b0-47ee-bb8a-4f4f972b2551	Home Middle Offer Banner	https://file.milkbasket.com/banners/Melons+%281%29_1743760724.png	offer	\N	\N	\N	\N	\N	\N	\N	1	f	2026-05-12 08:16:08.472376	2026-06-11 08:16:08.472378	active	\N	2026-05-12 08:16:56.629232	2026-05-12 08:16:56.629232
e97d64b7-6bfb-4843-a945-87cff18d6828	Checkout Page Product Banner	https://file.milkbasket.com/banners/mango+%281%29_1739360614.png	product	\N	\N	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	\N	\N	\N	\N	1	f	2026-05-12 09:18:44.652306	2026-06-11 09:18:44.652307	active	\N	2026-05-12 09:20:59.498534	2026-05-12 09:20:59.498534
a4665f8b-3fe5-4988-b1d0-4ca9a2145ef5	Home Top Combo Banner	https://file.milkbasket.com/banners/IND01-Atta_1774511926.png	combo	\N	\N	\N	ee06d35e-8d36-4929-9df6-dcdc6c4cdb5c	\N	\N	\N	1	f	2026-05-12 09:21:02.711334	2026-06-11 09:21:02.711336	active	\N	2026-05-12 09:21:28.281521	2026-05-12 09:21:28.281521
7406be4b-291a-4cd9-ac60-513e51003156	Home Middle Combo Banner	https://file.milkbasket.com/banners/IND01-Hot+Beverages_1774510961.png	combo	\N	\N	\N	33bb6c70-acd7-42ee-bad9-19ec54d5528f	\N	\N	\N	1	f	2026-05-12 09:21:39.404033	2026-06-11 09:21:39.404034	active	\N	2026-05-12 09:22:02.559885	2026-05-12 09:22:02.559885
8a011251-df32-47d7-a8c2-fa8211afc564	Cart Page Offer Banner	https://file.milkbasket.com/banners/IND01-Biscuits+%26+Rusks_1774511207.png	offer	\N	\N	\N	\N	\N	\N	\N	1	f	2026-05-12 09:22:10.973283	2026-06-11 09:22:10.973284	active	\N	2026-05-12 09:22:28.678664	2026-05-12 09:22:28.678664
e6dc0dca-8c44-4163-a902-4cb8adc5ade9	Home Top Coupon Banner	https://file.milkbasket.com/banners/Frame+114_1729252188.png	coupon	\N	\N	\N	\N	5ebe6947-b368-4496-a31d-c74c72c7608b	\N	\N	1	f	2026-05-12 09:22:37.436088	2026-06-11 09:22:37.43609	active	\N	2026-05-12 09:22:54.588631	2026-05-12 09:22:54.588631
\.


--
-- Data for Name: banner_linked_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banner_linked_product (id, "bannerId", "productId", "sortOrder", "createdAt") FROM stdin;
c235bb49-dcc3-4637-836f-c031ad6dee5b	ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	0	2026-05-12 08:12:23.739751
971d9997-b88c-4774-9f6b-1860d1b11878	ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	e8e44a39-39d7-42e3-b105-d0e184b6846d	1	2026-05-12 08:12:23.742355
8ae031ba-e191-4cd9-a280-1ec1ab58aa96	ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	ca8e3571-1b75-4c23-9257-72c9369747fb	2	2026-05-12 08:12:23.743828
63f9215e-b35c-4e53-bae6-6c6c7e8f3769	ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	8269290d-8a0d-411f-92fe-59b1f150ec89	3	2026-05-12 08:12:23.747477
4b8483b8-c13a-4e06-8cf2-fb1ab5cf0fcb	ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	9c320e33-d76d-4369-ad42-3ab2bbab548b	4	2026-05-12 08:12:23.750038
\.


--
-- Data for Name: banner_placement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banner_placement (id, "bannerId", "placementKey", "createdAt") FROM stdin;
2bd6c246-e94a-4ab3-989d-3e12c27af69b	ce973cd9-e585-4f1f-a5bc-b52d2f86ce8c	home_top_image	2026-05-12 08:12:23.733222
bafe4160-942d-4592-9f4b-40338821ead0	b7a4b69b-cc1c-4696-ae7a-f39b2d116f85	home_top	2026-05-12 08:15:29.698979
404eea9e-3e37-4974-9ae2-6a8337c1e270	b7a4b69b-cc1c-4696-ae7a-f39b2d116f85	cart_page	2026-05-12 08:15:29.702353
477ba638-8b0d-4d9c-8a64-daa55a102393	40c6e391-9646-46a2-bcbb-a5dba5ead151	home_top	2026-05-12 08:16:04.007392
0f2cb7b9-77e5-4a00-acab-b9b22471877c	40c6e391-9646-46a2-bcbb-a5dba5ead151	home_middle	2026-05-12 08:16:04.008722
3bda6a46-5d4b-41f0-b1e8-88af0aa9576f	40c6e391-9646-46a2-bcbb-a5dba5ead151	category_page	2026-05-12 08:16:04.009932
36b84783-29e8-4581-8027-422083328904	204c0708-d0b0-47ee-bb8a-4f4f972b2551	home_middle	2026-05-12 08:16:56.632478
8352ed78-2a2c-4fa1-8b85-1e1544625fe1	204c0708-d0b0-47ee-bb8a-4f4f972b2551	product_page	2026-05-12 08:16:56.633843
6f883a47-a8c2-4583-ab0b-4a1329dd651d	204c0708-d0b0-47ee-bb8a-4f4f972b2551	cart_page	2026-05-12 08:16:56.635966
6a2ad8fe-0f7c-4316-aac5-f3e59261b056	e97d64b7-6bfb-4843-a945-87cff18d6828	checkout_page	2026-05-12 09:20:59.505861
b9083de3-93da-48ad-8655-128ff0859782	e97d64b7-6bfb-4843-a945-87cff18d6828	product_page	2026-05-12 09:20:59.509158
9013ddba-3370-45f3-ba02-7954b2485b59	a4665f8b-3fe5-4988-b1d0-4ca9a2145ef5	home_top	2026-05-12 09:21:28.287105
96592a90-49fe-4840-bc22-f856db7b37d3	a4665f8b-3fe5-4988-b1d0-4ca9a2145ef5	product_page	2026-05-12 09:21:28.289311
1a6d9fce-c1a7-42d2-82b6-e46be61d3b0a	a4665f8b-3fe5-4988-b1d0-4ca9a2145ef5	cart_page	2026-05-12 09:21:28.291428
82d9299d-00e3-4d03-88b4-c33a6b4cbf57	a4665f8b-3fe5-4988-b1d0-4ca9a2145ef5	category_page	2026-05-12 09:21:28.293411
3343e878-e8a2-4f94-9e98-a6667f33250a	7406be4b-291a-4cd9-ac60-513e51003156	home_middle	2026-05-12 09:22:02.564538
400b425a-aad6-4d61-b152-44e38e7446c4	7406be4b-291a-4cd9-ac60-513e51003156	home_top	2026-05-12 09:22:02.566694
e4536fa7-d515-47ce-90a6-00b1616da023	7406be4b-291a-4cd9-ac60-513e51003156	checkout_page	2026-05-12 09:22:02.568818
ec6df885-4f0e-46e0-ab02-1331878c6ca6	8a011251-df32-47d7-a8c2-fa8211afc564	cart_page	2026-05-12 09:22:28.682436
debe3524-98d5-48a0-bf49-a1a506d7c713	8a011251-df32-47d7-a8c2-fa8211afc564	product_page	2026-05-12 09:22:28.683887
1618d89a-5518-4ee6-bb8e-f44a831b7d88	e6dc0dca-8c44-4163-a902-4cb8adc5ade9	home_top	2026-05-12 09:22:54.592164
\.


--
-- Data for Name: bogo_offer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bogo_offer (id, "triggerProductId", "triggerVariantId", "minTriggerQuantity", "triggerBaseQuantity", "triggerBaseUnit", title, "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
28c07847-9184-4234-badc-b75ff9500f78	87b3fc3f-e12c-44f5-92a0-17da34844c84	8def6c42-bcfb-492b-aa78-88fcce546c83	1	1	kg	Buy 1 x 1 kg, Get 2 FREE	2026-05-12 08:40:35.097535	2027-05-12 08:40:35.097536	active	\N	2026-05-12 08:41:01.375809	2026-05-12 08:41:01.375809
756a8105-9383-4f12-8865-e4cd4d7bf0ef	ba950235-2571-4a2a-b24b-97b277b98e8f	377f922d-276c-478f-8b77-6119421d3f6d	1	5	kg	Buy 1 x 5 kg, Get 1 x 500 gm FREE	2026-05-12 08:42:45.778122	2027-05-12 08:42:45.778125	active	\N	2026-05-12 08:42:55.644306	2026-05-12 08:42:55.644306
04764d0d-bafe-425d-9c9d-652dd50036b5	8269290d-8a0d-411f-92fe-59b1f150ec89	a37939ba-6e39-4112-9b2e-268213fa37ff	1	250	gm	Buy 1 x 250 gm, Get 1 x 100 gm FREE	2026-05-12 08:43:06.8774	2027-05-12 08:43:06.877402	active	\N	2026-05-12 08:43:38.852753	2026-05-12 08:43:38.852753
\.


--
-- Data for Name: bogo_offer_reward; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bogo_offer_reward (id, "bogoOfferId", "rewardProductId", "rewardVariantId", "freeQuantity", "createdAt") FROM stdin;
d8c23fcc-c045-46bf-9cdc-dcf4309a7eec	28c07847-9184-4234-badc-b75ff9500f78	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	f04be243-aa9d-4c2a-9505-886a52803a53	1	2026-05-12 08:41:01.390145
20b8a913-675d-48b6-bf81-9556a610e0a4	28c07847-9184-4234-badc-b75ff9500f78	1ce6273a-4ec3-4825-aedb-b68d88c2153c	55ff11c1-f41d-40a3-a501-9a239c4a1661	1	2026-05-12 08:41:01.396119
21586369-c068-47e2-aac0-ec916c654bb9	756a8105-9383-4f12-8865-e4cd4d7bf0ef	b8beb637-e69e-40f5-90cf-32bca177c8db	e5933bf8-f444-4831-8c22-44b5b3fa26ad	1	2026-05-12 08:42:55.648157
7449d423-46c2-471f-94ff-befde4c9ca7c	04764d0d-bafe-425d-9c9d-652dd50036b5	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	b8651e29-7e30-496a-824b-363c5dbf6f1c	1	2026-05-12 08:43:38.856584
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, name, slug, "imageUrl", "displayOrder", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Fruits	fruits	https://file.milkbasket.com/categories/Fruits_1729078697.png	0	active	\N	2026-05-12 05:16:33.510326	2026-05-12 05:16:33.510331
0829417b-f54d-4baa-9732-d228d58ae666	Vegetables	vagetables	https://file.milkbasket.com/categories/Vegetables_1729079289.png	0	active	\N	2026-05-12 05:29:15.164805	2026-05-12 05:29:15.164816
\.


--
-- Data for Name: category_offer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_offer (id, "categoryId", name, description, "discountType", "discountValue", "maxDiscountAmount", "minOrderAmount", priority, "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
01911e70-2b2c-4518-8f69-eb81b88fdf9c	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Fruits 5% OFF	\N	percentage	5	50	300	0	2026-05-12 08:45:56.072201	2026-06-11 08:45:56.072203	active	\N	2026-05-12 08:46:21.271346	2026-05-12 08:46:21.271346
\.


--
-- Data for Name: category_offer_product_exclusion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_offer_product_exclusion (id, "categoryOfferId", "productId", "createdAt") FROM stdin;
\.


--
-- Data for Name: category_offer_product_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_offer_product_scope (id, "categoryOfferId", "productId", "createdAt") FROM stdin;
\.


--
-- Data for Name: combo_offer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.combo_offer (id, name, description, "discountType", "discountValue", "minQuantityPerProduct", "maxUsagePerUser", "maxUsageTotal", "usedCount", priority, "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
ee06d35e-8d36-4929-9df6-dcdc6c4cdb5c	Apple Shimla Small + Banana Combo • more ₹10 OFF	\N	flat	10	1	0	\N	0	0	2026-05-12 08:43:44.93409	2026-06-11 08:43:44.934092	active	\N	2026-05-12 08:44:24.708635	2026-05-12 08:44:24.708635
33bb6c70-acd7-42ee-bad9-19ec54d5528f	Cucumber Kakdi + Carrot Red + Tomato - Hybrid Combo • more 10% OFF	\N	percentage	10	1	0	\N	0	0	2026-05-12 08:44:28.921068	2026-06-11 08:44:28.92107	active	\N	2026-05-12 08:45:38.933089	2026-05-12 08:45:38.933089
\.


--
-- Data for Name: combo_offer_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.combo_offer_item (id, "comboOfferId", "productId", "productVariantId", quantity, "sortOrder", "createdAt") FROM stdin;
2d7b8dc7-4a2c-455b-b0ed-10e326770937	ee06d35e-8d36-4929-9df6-dcdc6c4cdb5c	87b3fc3f-e12c-44f5-92a0-17da34844c84	8def6c42-bcfb-492b-aa78-88fcce546c83	1	0	2026-05-12 08:44:24.715799
38c488fc-8bd6-4d0c-87b4-32c90e216e90	ee06d35e-8d36-4929-9df6-dcdc6c4cdb5c	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	957488fe-7e21-4848-bce2-d00923802b25	1	1	2026-05-12 08:44:24.719917
30543282-7729-4d77-8b39-28b8804d8db4	33bb6c70-acd7-42ee-bad9-19ec54d5528f	1ce6273a-4ec3-4825-aedb-b68d88c2153c	8cf9afbd-d7dd-4af0-a046-397033428a40	1	0	2026-05-12 08:45:38.941137
9469d4a7-bee7-400c-a968-a969a84a78b3	33bb6c70-acd7-42ee-bad9-19ec54d5528f	e8e44a39-39d7-42e3-b105-d0e184b6846d	e5fa0fc6-426d-4d97-8dc0-800f5e4ef6f9	1	1	2026-05-12 08:45:38.943825
58db3425-f804-44d4-8d0a-74415614c145	33bb6c70-acd7-42ee-bad9-19ec54d5528f	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	8f1ccfc5-7e27-4e01-bcd1-7ed3ee130dac	1	2	2026-05-12 08:45:38.945642
\.


--
-- Data for Name: coupon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon (id, code, description, "couponType", "couponCategory", "discountValue", "minOrderAmount", "maxDiscountAmount", "maxUsageTotal", "maxUsagePerUser", "loyaltyRequiredOrders", "usedCount", "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
42c6e5df-fa6b-43c4-9194-90dcfc6b1b2a	2-ORDER	save ₹15 on your 2nd order	LOYALTY	All	15	2	15	100	\N	2	0	2026-05-12 08:49:58.988588	2026-06-11 08:49:58.988631	active	\N	2026-05-12 08:52:53.942588	2026-05-12 08:52:53.942588
e6dc1826-b4ad-456e-8695-5eec70f111e4	SAVE30	save ₹30 on ₹350 order amount	FLAT_DISCOUNT	All	30	350	30	50	\N	\N	0	2026-05-12 08:53:01.108881	2026-06-11 08:53:01.108883	active	\N	2026-05-12 08:54:04.351511	2026-05-12 08:54:04.351511
5ebe6947-b368-4496-a31d-c74c72c7608b	SAVE 10%	save 10% on upto ₹800 order	PERCENTAGE_DISCOUNT	All	10	800	80	200	\N	\N	0	2026-05-12 09:07:33.867938	2026-06-11 09:07:33.86794	active	\N	2026-05-12 09:09:50.935694	2026-05-12 09:09:50.935694
\.


--
-- Data for Name: coupon_product_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon_product_scope (id, "couponId", "productId", "createdAt") FROM stdin;
\.


--
-- Data for Name: customer_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_order (id, "userId", "orderNumber", "orderStatus", "paymentStatus", "refundStatus", "couponId", "itemCount", "totalAmount", "discountAmount", "deliveryFee", "finalAmount", "placedAt", "confirmedAt", "packedAt", "outForDeliveryAt", "deliveredAt", "cancelledAt", "cancellationReason", "deliveryPersonName", "deliveryPersonPhone", "deliveryOtp", "analyticsProcessedAt", "orderedAt", "createdAt", "updatedAt") FROM stdin;
fb1bfbf3-4cc0-4c99-ad9e-3d1c55f0546d	d8035b52-e2b1-4f74-ad99-7223008bc246	ORD1778588194296965	placed	pending	none	\N	1	10	0	40	50	2026-05-12 12:16:34.296121	\N	\N	\N	\N	\N	\N	\N	\N	7757	\N	2026-05-12 12:16:34.296121	2026-05-12 12:16:34.296121	2026-05-12 12:16:34.296121
bd0fe494-9161-4743-92ea-3baeb79b876c	d8035b52-e2b1-4f74-ad99-7223008bc246	ORD1778588295040235	placed	pending	none	\N	1	10	0	40	50	2026-05-12 12:18:15.040321	\N	\N	\N	\N	\N	\N	\N	\N	1055	\N	2026-05-12 12:18:15.040321	2026-05-12 12:18:15.040321	2026-05-12 12:18:15.040321
75d33100-e256-4079-92fd-f56de62b6644	d8035b52-e2b1-4f74-ad99-7223008bc246	ORD1778589449692645	cancelled	paid	none	\N	1	10	0	40	50	2026-05-12 12:37:29.692883	2026-05-12 12:37:47.776362	\N	\N	\N	2026-05-12 12:37:56.28773	user_cancelled	\N	\N	6265	2026-05-12 12:37:47.797227	2026-05-12 12:37:29.692883	2026-05-12 12:37:29.692883	2026-05-12 12:37:56.28773
ea0c4f0b-55df-42e5-a09d-124d95f7d10b	d8035b52-e2b1-4f74-ad99-7223008bc246	ORD1778589508415883	confirmed	paid	none	\N	1	30	0	40	70	2026-05-12 12:38:28.415323	2026-05-12 12:38:44.429223	\N	\N	\N	\N	\N	\N	\N	3188	2026-05-12 12:38:44.445464	2026-05-12 12:38:28.415323	2026-05-12 12:38:28.415323	2026-05-12 12:38:44.445465
\.


--
-- Data for Name: delivery_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_config (id, "configKey", "baseDeliveryFee", "freeDeliveryThreshold", "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: delivery_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_rule (id, name, description, "ruleType", "deliveryFee", priority, "targetUserType", "targetOrderCount", "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: delivery_slab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_slab (id, "configId", "minOrderAmount", "maxOrderAmount", fee, "sortOrder", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: free_delivery_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.free_delivery_rule (id, name, description, "ruleType", "minOrderAmount", "minItemsCount", "couponId", "userId", "waivedAmount", "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: idempotency_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idempotency_record (id, scope, "idempotencyKey", "userId", "orderId", "paymentTransactionId", "requestHash", "responseReference", "createdAt", "expiresAt") FROM stdin;
3ac64b78-f181-4a31-abce-ea365e5debee	order_create	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778588195403658_4xk4uvir	d8035b52-e2b1-4f74-ad99-7223008bc246	fb1bfbf3-4cc0-4c99-ad9e-3d1c55f0546d	51a86f97-db33-4d50-8c34-4d49ecacd9bc	{"__className__":"Order","orderId":"","userId":"vjOMlEdMhmceW0YDV48rx2MDz1s2","userName":"Deepak Mewada","userPhone":"+918815086850","items":[{"__className__":"OrderItem","productId":"f2460837-a87f-47b0-8e17-7253dfb8194b","variantId":"8c66e829-a706-4d79-b243-8f88221249f9","variantLabel":"1 pc (1 pc)","productName":"Lauki (Long)","productImage":"https://file.milkbasket.com/products/58633_0_1747310703.png","quantity":1,"unitPrice":10.0,"totalPrice":10.0,"isFreeItem":false}],"itemCount":1,"totalAmount":10.0,"discountAmount":0.0,"deliveryFee":40.0,"finalAmount":50.0,"status":"placed","paymentStatus":"pending","refundStatus":"none","deliveryAddress":{"__className__":"Address","street":"Dashrath Bag","city":"Indore","state":"Madhya Pradesh","zipCode":"452015","country":"India","latitude":22.749833128979862,"longitude":75.83644174039364},"orderedAt":"2026-05-12T12:16:35.401582Z"}	ORD1778588194296965	2026-05-12 12:16:34.296121	\N
87fb7028-278d-4a78-8b94-d363a7d127a2	order_create	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778588296251496_na2w5rdm	d8035b52-e2b1-4f74-ad99-7223008bc246	bd0fe494-9161-4743-92ea-3baeb79b876c	6f8547cd-1501-46ed-a6a4-d502e9dfa58a	{"__className__":"Order","orderId":"","userId":"vjOMlEdMhmceW0YDV48rx2MDz1s2","userName":"Deepak Mewada","userPhone":"+918815086850","items":[{"__className__":"OrderItem","productId":"f2460837-a87f-47b0-8e17-7253dfb8194b","variantId":"8c66e829-a706-4d79-b243-8f88221249f9","variantLabel":"1 pc (1 pc)","productName":"Lauki (Long)","productImage":"https://file.milkbasket.com/products/58633_0_1747310703.png","quantity":1,"unitPrice":10.0,"totalPrice":10.0,"isFreeItem":false}],"itemCount":1,"totalAmount":10.0,"discountAmount":0.0,"deliveryFee":40.0,"finalAmount":50.0,"status":"placed","paymentStatus":"pending","refundStatus":"none","deliveryAddress":{"__className__":"Address","street":"Dashrath Bag","city":"Indore","state":"Madhya Pradesh","zipCode":"452015","country":"India","latitude":22.749833128979862,"longitude":75.83644174039364},"orderedAt":"2026-05-12T12:18:16.251428Z"}	ORD1778588295040235	2026-05-12 12:18:15.040321	\N
0159112b-db50-48c4-b4b1-1ef365b93796	order_create	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778589450877417_3hiptnkj	d8035b52-e2b1-4f74-ad99-7223008bc246	75d33100-e256-4079-92fd-f56de62b6644	c15f4183-9767-4f1e-b9bc-ff6ad2751d6c	{"__className__":"Order","orderId":"","userId":"vjOMlEdMhmceW0YDV48rx2MDz1s2","userName":"Deepak Mewada","userPhone":"+918815086850","items":[{"__className__":"OrderItem","productId":"f2460837-a87f-47b0-8e17-7253dfb8194b","variantId":"8c66e829-a706-4d79-b243-8f88221249f9","variantLabel":"1 pc (1 pc)","productName":"Lauki (Long)","productImage":"https://file.milkbasket.com/products/58633_0_1747310703.png","quantity":1,"unitPrice":10.0,"totalPrice":10.0,"isFreeItem":false}],"itemCount":1,"totalAmount":10.0,"discountAmount":0.0,"deliveryFee":40.0,"finalAmount":50.0,"status":"placed","paymentStatus":"pending","refundStatus":"none","deliveryAddress":{"__className__":"Address","street":"Dashrath Bag","city":"Indore","state":"Madhya Pradesh","zipCode":"452015","country":"India","latitude":22.749833128979862,"longitude":75.83644174039364},"orderedAt":"2026-05-12T12:37:30.877213Z"}	ORD1778589449692645	2026-05-12 12:37:29.692883	\N
b1cd51bd-45df-4d65-80cd-125fa3f2e5ae	order_create	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778589509506978_p3qst4yv	d8035b52-e2b1-4f74-ad99-7223008bc246	ea0c4f0b-55df-42e5-a09d-124d95f7d10b	50f7f40d-7509-41fd-8be1-f3001cef91cd	{"__className__":"Order","orderId":"","userId":"vjOMlEdMhmceW0YDV48rx2MDz1s2","userName":"Deepak Mewada","userPhone":"+918815086850","items":[{"__className__":"OrderItem","productId":"f19c30d4-80b1-4782-b7ad-9262f7e7a327","variantId":"c6ed8efe-0b33-47cc-b122-d74f4f037652","variantLabel":"500 gm (500 gm)","productName":"Orange - Kinnow","productImage":"https://file.milkbasket.com/products/58861_0_1765013278.jpeg","quantity":1,"unitPrice":30.0,"totalPrice":30.0,"isFreeItem":false}],"itemCount":1,"totalAmount":30.0,"discountAmount":0.0,"deliveryFee":40.0,"finalAmount":70.0,"status":"placed","paymentStatus":"pending","refundStatus":"none","deliveryAddress":{"__className__":"Address","street":"Dashrath Bag","city":"Indore","state":"Madhya Pradesh","zipCode":"452015","country":"India","latitude":22.749833128979862,"longitude":75.83644174039364},"orderedAt":"2026-05-12T12:38:29.506909Z"}	ORD1778589508415883	2026-05-12 12:38:28.415323	\N
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, "orderId", "recipientName", "phoneNumber", "streetLine1", "streetLine2", landmark, city, state, "postalCode", country, latitude, longitude, "createdAt") FROM stdin;
61373926-0ada-44af-be42-9dbec317cbee	fb1bfbf3-4cc0-4c99-ad9e-3d1c55f0546d	Deepak Mewada	+918815086850	Dashrath Bag	\N	\N	Indore	Madhya Pradesh	452015	India	22.749833128979862	75.83644174039364	2026-05-12 12:16:34.296121
c89ba7b7-4c1e-4bb2-9574-f4b204f99861	bd0fe494-9161-4743-92ea-3baeb79b876c	Deepak Mewada	+918815086850	Dashrath Bag	\N	\N	Indore	Madhya Pradesh	452015	India	22.749833128979862	75.83644174039364	2026-05-12 12:18:15.040321
5f4dbb2c-57f3-45b9-b078-f423597b786c	75d33100-e256-4079-92fd-f56de62b6644	Deepak Mewada	+918815086850	Dashrath Bag	\N	\N	Indore	Madhya Pradesh	452015	India	22.749833128979862	75.83644174039364	2026-05-12 12:37:29.692883
5e0f227f-6ebb-40b9-b187-f825b0ca4051	ea0c4f0b-55df-42e5-a09d-124d95f7d10b	Deepak Mewada	+918815086850	Dashrath Bag	\N	\N	Indore	Madhya Pradesh	452015	India	22.749833128979862	75.83644174039364	2026-05-12 12:38:28.415323
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, "orderId", "productId", "productVariantId", "comboOfferId", "bogoOfferId", "productNameSnapshot", "productImageUrlSnapshot", "variantLabelSnapshot", quantity, "unitPrice", "totalPrice", "isFreeItem", "createdAt") FROM stdin;
416b85a1-0433-414f-8ab7-535ac6cb95ef	fb1bfbf3-4cc0-4c99-ad9e-3d1c55f0546d	f2460837-a87f-47b0-8e17-7253dfb8194b	8c66e829-a706-4d79-b243-8f88221249f9	\N	\N	Lauki (Long)	https://file.milkbasket.com/products/58633_0_1747310703.png	1 pc (1 pc)	1	10	10	f	2026-05-12 12:16:34.296121
0a150624-0ba0-4315-963c-452bb29be1c1	bd0fe494-9161-4743-92ea-3baeb79b876c	f2460837-a87f-47b0-8e17-7253dfb8194b	8c66e829-a706-4d79-b243-8f88221249f9	\N	\N	Lauki (Long)	https://file.milkbasket.com/products/58633_0_1747310703.png	1 pc (1 pc)	1	10	10	f	2026-05-12 12:18:15.040321
9dd9f373-0846-4dd2-85e0-751cf981c224	75d33100-e256-4079-92fd-f56de62b6644	f2460837-a87f-47b0-8e17-7253dfb8194b	8c66e829-a706-4d79-b243-8f88221249f9	\N	\N	Lauki (Long)	https://file.milkbasket.com/products/58633_0_1747310703.png	1 pc (1 pc)	1	10	10	f	2026-05-12 12:37:29.692883
ce7ce41e-a8a7-4d15-8692-0fceeb1d2f6c	ea0c4f0b-55df-42e5-a09d-124d95f7d10b	f19c30d4-80b1-4782-b7ad-9262f7e7a327	c6ed8efe-0b33-47cc-b122-d74f4f037652	\N	\N	Orange - Kinnow	https://file.milkbasket.com/products/58861_0_1765013278.jpeg	500 gm (500 gm)	1	30	30	f	2026-05-12 12:38:28.415323
\.


--
-- Data for Name: order_notification_outbox; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_notification_outbox (id, "dedupeKey", "eventType", "orderId", "userId", status, "payloadJson", "attemptCount", "lastError", "processedAt", "createdAt", "updatedAt") FROM stdin;
090016ab-e228-4a07-9b8c-d5489e946434	order_paid:ORD1778589449692645	order_paid	ORD1778589449692645	d8035b52-e2b1-4f74-ad99-7223008bc246	confirmed	{"__className__":"OrderRealtimeEvent","eventType":"order_paid","orderId":"ORD1778589449692645","status":"confirmed","userId":"d8035b52-e2b1-4f74-ad99-7223008bc246","createdAt":"2026-05-12T12:37:47.802370Z","amount":50.0,"itemCount":1}	0	\N	2026-05-12 12:37:49.096646	2026-05-12 12:37:47.806217	2026-05-12 12:37:49.096713
af360fab-6692-4767-ab29-034588b6a389	order_status_changed:ORD1778589449692645:cancelled	order_status_changed	ORD1778589449692645	vjOMlEdMhmceW0YDV48rx2MDz1s2	cancelled	{"__className__":"OrderRealtimeEvent","eventType":"order_status_changed","orderId":"ORD1778589449692645","status":"cancelled","userId":"vjOMlEdMhmceW0YDV48rx2MDz1s2","createdAt":"2026-05-12T12:37:56.302425Z"}	0	\N	2026-05-12 12:38:44.462026	2026-05-12 12:37:56.304053	2026-05-12 12:38:44.462029
fbdd8256-e72d-452b-961e-39292497c9c8	order_paid:ORD1778589508415883	order_paid	ORD1778589508415883	d8035b52-e2b1-4f74-ad99-7223008bc246	confirmed	{"__className__":"OrderRealtimeEvent","eventType":"order_paid","orderId":"ORD1778589508415883","status":"confirmed","userId":"d8035b52-e2b1-4f74-ad99-7223008bc246","createdAt":"2026-05-12T12:38:44.449021Z","amount":70.0,"itemCount":1}	0	\N	2026-05-12 12:38:45.621189	2026-05-12 12:38:44.451016	2026-05-12 12:38:45.621192
\.


--
-- Data for Name: order_tracking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_tracking (id, "orderId", "trackingEnabled", "userLatitude", "userLongitude", "userAddress", "userLocationType", "riderLatitude", "riderLongitude", "createdAt", "updatedAt") FROM stdin;
935e192f-5b7a-412e-99a7-4009776b733b	75d33100-e256-4079-92fd-f56de62b6644	f	22.749833128979862	75.83644174039364	Dashrath Bag, Indore, Madhya Pradesh, 452015, India	saved	\N	\N	2026-05-12 12:37:31.694721	2026-05-12 12:37:31.694721
7c41d20e-b700-4706-992b-22182edb55b7	ea0c4f0b-55df-42e5-a09d-124d95f7d10b	f	22.749833128979862	75.83644174039364	Dashrath Bag, Indore, Madhya Pradesh, 452015, India	saved	\N	\N	2026-05-12 12:38:33.686403	2026-05-12 12:38:33.686403
\.


--
-- Data for Name: payment_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_transaction (id, "orderId", "userId", "idempotencyKey", "gatewayName", "gatewayOrderId", "gatewayPaymentId", amount, "currencyCode", "paymentStatus", "gatewayStatus", "failureReason", "paidAt", "createdAt", "updatedAt") FROM stdin;
51a86f97-db33-4d50-8c34-4d49ecacd9bc	fb1bfbf3-4cc0-4c99-ad9e-3d1c55f0546d	d8035b52-e2b1-4f74-ad99-7223008bc246	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778588195403658_4xk4uvir	razorpay	\N	\N	50	INR	pending	\N	\N	\N	2026-05-12 12:16:34.296121	2026-05-12 12:16:34.296121
6f8547cd-1501-46ed-a6a4-d502e9dfa58a	bd0fe494-9161-4743-92ea-3baeb79b876c	d8035b52-e2b1-4f74-ad99-7223008bc246	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778588296251496_na2w5rdm	razorpay	\N	\N	50	INR	pending	\N	\N	\N	2026-05-12 12:18:15.040321	2026-05-12 12:18:15.040321
c15f4183-9767-4f1e-b9bc-ff6ad2751d6c	75d33100-e256-4079-92fd-f56de62b6644	d8035b52-e2b1-4f74-ad99-7223008bc246	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778589450877417_3hiptnkj	razorpay	order_SoSHtSODdxrBPc	pay_SoSHz9oKp5xJCG	50	INR	paid	captured	\N	2026-05-12 12:37:47.776362	2026-05-12 12:37:29.692883	2026-05-12 12:37:47.776362
50f7f40d-7509-41fd-8be1-f3001cef91cd	ea0c4f0b-55df-42e5-a09d-124d95f7d10b	d8035b52-e2b1-4f74-ad99-7223008bc246	vjOMlEdMhmceW0YDV48rx2MDz1s2_1778589509506978_p3qst4yv	razorpay	order_SoSJ0diAX9lrac	pay_SoSJ3BFEXKeuIL	70	INR	paid	captured	\N	2026-05-12 12:38:44.429223	2026-05-12 12:38:28.415323	2026-05-12 12:38:44.429223
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, "categoryId", name, slug, "shortDescription", description, "primaryImageUrl", "countryOfOrigin", "baseUnit", "baseQuantity", "quantityDescription", stock, "stockUnit", "discountType", "mostSearchCount", "mostPurchaseCount", "last7DaysSold", "last7DaysViews", "reorderCount", "trendingScore", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
87b3fc3f-e12c-44f5-92a0-17da34844c84	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Apple Shimla Small	apple-shimla-small-18	\N	\N	https://file.milkbasket.com/products/53398_0_1746601057.png	India	kg	1	1 kg	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 08:11:02.918109	2026-05-12 12:37:10.345987
e21dff30-ca90-4740-ac4e-2c7a1b8bebb2	0829417b-f54d-4baa-9732-d228d58ae666	potato	potato	\N	\N	https://file.milkbasket.com/products/67512_0_1716290184.jpeg	India	kg	1	1 kg	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 05:47:26.81981	2026-05-12 12:37:10.345987
ba950235-2571-4a2a-b24b-97b277b98e8f	0829417b-f54d-4baa-9732-d228d58ae666	Potato	potato-85	\N	\N	https://file.milkbasket.com/products/67512_0_1716290184.jpeg	India	kg	5	5 kg	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 05:48:55.821814	2026-05-12 12:37:10.345987
8269290d-8a0d-411f-92fe-59b1f150ec89	0829417b-f54d-4baa-9732-d228d58ae666	Mushroom	mushroom	\N	\N	https://file.milkbasket.com/products/5048_0_1749640067.png	India	gm	250	250 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 05:56:07.805281	2026-05-12 12:37:10.345987
adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	0829417b-f54d-4baa-9732-d228d58ae666	Ginger	ginger	\N	\N	https://file.milkbasket.com/products/45576_0_1748843263.png	India	gm	100	100 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:55:27.645035	2026-05-12 12:37:10.345987
287343ff-b9b5-415f-870f-f26ea5510d92	0829417b-f54d-4baa-9732-d228d58ae666	Broccoli	broccoli	\N	\N	https://file.milkbasket.com/products/58613_0_1748848811.png	India	pc	1	1 pc	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:56:23.96382	2026-05-12 12:37:10.345987
6ae1fa39-b840-4bff-8c69-97f85dabcb8c	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Banana	banana	\N	\N	https://file.milkbasket.com/products/45423_0_1746452920.png	India	pc	12	12 pc	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:47:16.132908	2026-05-12 12:37:10.345987
9c320e33-d76d-4369-ad42-3ab2bbab548b	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Tender Coconut	tender-coconut	\N	\N	https://file.milkbasket.com/products/46044_0_1746595857.jpeg	India	pc	1	1 pc	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:57:58.636065	2026-05-12 12:37:10.345987
ae6a7239-9e09-4128-9461-847e64e852e6	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Curate Avocado Hass Kenya	curate-avocado-hass-kenya	\N	\N	https://file.milkbasket.com/products/76698_0_1739342841.jpeg	India	pc	1	1 pc	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 08:00:21.325649	2026-05-12 12:37:10.345987
1ce6273a-4ec3-4825-aedb-b68d88c2153c	0829417b-f54d-4baa-9732-d228d58ae666	Cucumber Kakdi	cucumber-kakdi	\N	\N	https://file.milkbasket.com/products/66709_0_1693994505.jpeg	India	gm	500	500 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:58:52.75101	2026-05-12 12:37:10.345987
143aedf4-0ec5-4d57-aa96-36c117a95113	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Curate Pomegranate kesar Medium	curate-pomegranate-kesar-medium	\N	\N	https://file.milkbasket.com/products/78286_0_1764999379.jpeg	India	gm	250	250 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:03:48.953324	2026-05-12 12:37:10.345987
4af359d4-045b-4280-a180-68ef83104b7e	0829417b-f54d-4baa-9732-d228d58ae666	Raw Banana	raw-banana	\N	\N	https://file.milkbasket.com/products/43255_0_1746614619.png	India	pc	6	6 pc	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:05:38.62074	2026-05-12 12:37:10.345987
b8beb637-e69e-40f5-90cf-32bca177c8db	0829417b-f54d-4baa-9732-d228d58ae666	Onion	onion	\N	\N	https://file.milkbasket.com/products/67514_0_1750148186.png	India	kg	1	1 kg	\N	\N	percentage	1	0	0	1	0	0.2	active	\N	2026-05-12 07:08:14.672338	2026-05-12 12:37:10.345987
f19c30d4-80b1-4782-b7ad-9262f7e7a327	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Orange - Kinnow	orange-kinnow	\N	\N	https://file.milkbasket.com/products/58861_0_1765013278.jpeg	India	gm	500	500 gm	\N	\N	percentage	0	1	0	0	0	0	active	\N	2026-05-12 07:06:43.357197	2026-05-12 12:42:10.225537
f2460837-a87f-47b0-8e17-7253dfb8194b	0829417b-f54d-4baa-9732-d228d58ae666	Lauki (Long)	lauki-long	\N	\N	https://file.milkbasket.com/products/58633_0_1747310703.png	India	pc	1	1 pc	\N	\N	percentage	0	1	0	0	0	0	active	\N	2026-05-12 07:49:24.743344	2026-05-12 12:42:10.225537
5f9c241a-b32d-458e-9824-ced57f751570	0829417b-f54d-4baa-9732-d228d58ae666	Bhindi	bhindi	\N	\N	https://file.milkbasket.com/products/58532_0_1747309198.png	India	gm	500	500 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:10:27.748272	2026-05-12 12:37:10.345987
ca8e3571-1b75-4c23-9257-72c9369747fb	0829417b-f54d-4baa-9732-d228d58ae666	Cauliflower	cauliflower	\N	\N	https://file.milkbasket.com/products/74369_0_1748848362.png	India	pc	1	1 pc	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:07:27.985255	2026-05-12 12:37:10.345987
e8e44a39-39d7-42e3-b105-d0e184b6846d	0829417b-f54d-4baa-9732-d228d58ae666	Carrot Red	carrot-red	\N	\N	https://file.milkbasket.com/products/58642_0_1764999489.jpeg	India	kg	1	1 kg	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:48:23.369788	2026-05-12 12:37:10.345987
6ba57f78-4393-4d92-a9ae-c3c28c653ffc	0829417b-f54d-4baa-9732-d228d58ae666	Tomato - Hybrid	tomato-hybrid	\N	\N	https://file.milkbasket.com/products/46229_0_1750229324.png	India	gm	500	500 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 07:51:59.995092	2026-05-12 12:37:10.345987
ce906a6b-d97f-4061-9bec-351844d247d2	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Apple Shimla Small	apple-shimla-small	\N	\N	https://file.milkbasket.com/products/53398_0_1746601057.png	India	gm	500	500 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 08:10:06.951516	2026-05-12 12:37:10.345987
248a8e70-e6da-470c-9f2b-8a6c17b3e1c9	0829417b-f54d-4baa-9732-d228d58ae666	Arbi	arbi	\N	\N	https://file.milkbasket.com/products/58541_0_1748849596.png	India	gm	500	500 gm	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 08:06:54.444502	2026-05-12 12:37:10.345987
95d2678c-e460-4a01-966c-1d112903ca2b	0829417b-f54d-4baa-9732-d228d58ae666	Capsicum Green	capsicum-green	\N	\N	https://file.milkbasket.com/products/58518_0_1748847803.png	India	kg	1	1 kg	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 08:08:03.882394	2026-05-12 12:37:10.345987
7a5f93a3-fb0b-4ebc-b153-003a1b2a2a42	0829417b-f54d-4baa-9732-d228d58ae666	French Beans	french-beans	\N	\N	https://file.milkbasket.com/products/45416_0_1748847859.png	India	kg	1	1 kg	\N	\N	percentage	0	0	0	0	0	0	active	\N	2026-05-12 08:09:04.882168	2026-05-12 12:37:10.345987
\.


--
-- Data for Name: product_search_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_search_document (id, "productId", "searchText", "builtAt", "sourceCreatedAt", "sourceUpdatedAt") FROM stdin;
988e2caa-7c6c-43a8-b9ce-2f154f24aa57	e21dff30-ca90-4740-ac4e-2c7a1b8bebb2	potato Vegetables Onion, Potato & Tomato	2026-05-12 05:47:26.952073	2026-05-12 05:47:26.81981	2026-05-12 05:47:26.81981
5796b64e-4deb-4a73-9cc9-c52d16436218	ba950235-2571-4a2a-b24b-97b277b98e8f	Potato Vegetables Onion, Potato & Tomato	2026-05-12 05:48:55.90826	2026-05-12 05:48:55.821814	2026-05-12 05:48:55.821814
201fdf57-a095-482b-b3be-25b881989174	8269290d-8a0d-411f-92fe-59b1f150ec89	Mushroom Vegetables Root Vegetables & Raw Banana	2026-05-12 05:56:07.893409	2026-05-12 05:56:07.805281	2026-05-12 05:56:07.805281
bb2fe65b-f6f8-46b7-a293-cabaef7c190f	143aedf4-0ec5-4d57-aa96-36c117a95113	Curate Pomegranate kesar Medium Fruits Citrus & Pomegranate	2026-05-12 07:03:48.996064	2026-05-12 07:03:48.953324	2026-05-12 07:03:48.953324
dfc03765-5cf7-4426-963f-a832114a7ebc	4af359d4-045b-4280-a180-68ef83104b7e	Raw Banana Vegetables Root Vegetables & Raw Banana	2026-05-12 07:05:38.659402	2026-05-12 07:05:38.62074	2026-05-12 07:05:38.62074
30191201-c1e9-40a1-bf5e-b7b9b21e5aa6	f19c30d4-80b1-4782-b7ad-9262f7e7a327	Orange - Kinnow Fruits Citrus & Pomegranate	2026-05-12 07:06:43.38587	2026-05-12 07:06:43.357197	2026-05-12 07:06:43.357197
0419fd03-d8ba-4cb4-a5ed-6a7fcf2669ce	ca8e3571-1b75-4c23-9257-72c9369747fb	Cauliflower Vegetables Cauliflower & Brinjal	2026-05-12 07:07:28.011051	2026-05-12 07:07:27.985255	2026-05-12 07:07:27.985255
26ac01ed-159f-4155-98d7-949995f39074	e8e44a39-39d7-42e3-b105-d0e184b6846d	Carrot Red Vegetables Root Vegetables & Raw Banana Salad & Sprouts	2026-05-12 07:48:23.417667	2026-05-12 07:48:23.369788	2026-05-12 07:48:23.369788
6ff297ad-77c4-436d-bda5-68321fc1d26e	f2460837-a87f-47b0-8e17-7253dfb8194b	Lauki (Long) Vegetables Bhind, Gourds & Drumsticks	2026-05-12 07:49:24.770295	2026-05-12 07:49:24.743344	2026-05-12 07:49:24.743344
4c7ccf65-5205-4df7-8183-4d281de81214	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	Tomato - Hybrid Vegetables Salad & Sprouts Onion, Potato & Tomato	2026-05-12 07:52:00.030266	2026-05-12 07:51:59.995092	2026-05-12 07:51:59.995092
de40d518-0ee1-416d-b69d-c44d3032178b	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	Ginger Vegetables Condiments & Leafy Root Vegetables & Raw Banana	2026-05-12 07:55:27.675144	2026-05-12 07:55:27.645035	2026-05-12 07:55:27.645035
a8b350e3-c73f-4268-b1fd-b23b8b78a7f3	287343ff-b9b5-415f-870f-f26ea5510d92	Broccoli Vegetables Cauliflower & Brinjal	2026-05-12 07:56:23.990164	2026-05-12 07:56:23.96382	2026-05-12 07:56:23.96382
c88e9e6f-3243-4a26-8f93-36980b194ac7	9c320e33-d76d-4369-ad42-3ab2bbab548b	Tender Coconut Fruits Coconut & Dates	2026-05-12 07:57:58.665512	2026-05-12 07:57:58.636065	2026-05-12 07:57:58.636065
fb00cc59-f8b7-470c-9134-f823b3797ac6	ae6a7239-9e09-4128-9461-847e64e852e6	Curate Avocado Hass Kenya Fruits Kiwi & Avocado	2026-05-12 08:00:21.361178	2026-05-12 08:00:21.325649	2026-05-12 08:00:21.325649
658b7937-f7f1-4604-846b-e2525ae0f9e3	95d2678c-e460-4a01-966c-1d112903ca2b	Capsicum Green Vegetables Beans & Capsicum	2026-05-12 08:08:03.904591	2026-05-12 08:08:03.882394	2026-05-12 08:08:03.882394
2b279a6b-825c-47ad-b21b-5100a2382f80	7a5f93a3-fb0b-4ebc-b153-003a1b2a2a42	French Beans Vegetables Beans & Capsicum	2026-05-12 08:09:04.901698	2026-05-12 08:09:04.882168	2026-05-12 08:09:04.882168
73481a95-d187-48ba-8da1-33f9cb9cdf26	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	Banana Fruits Banana, Papaya & Pineapple	2026-05-12 08:20:28.214478	2026-05-12 07:47:16.132908	2026-05-12 08:20:28.189481
fac34803-2719-430e-9fae-8f7e33909433	1ce6273a-4ec3-4825-aedb-b68d88c2153c	Cucumber Kakdi Vegetables Salad & Sprouts	2026-05-12 08:40:09.483633	2026-05-12 07:58:52.75101	2026-05-12 08:40:09.422667
fe6df017-5685-4cc0-a6d6-879e653f0487	b8beb637-e69e-40f5-90cf-32bca177c8db	Onion Vegetables Onion, Potato & Tomato	2026-05-12 08:42:05.247212	2026-05-12 07:08:14.672338	2026-05-12 08:42:05.21852
c373cf99-abc5-469f-af77-fcaed9053d60	ce906a6b-d97f-4061-9bec-351844d247d2	Apple Shimla Small Fruits Apple & Pear	2026-05-12 09:40:23.266925	2026-05-12 08:10:06.951516	2026-05-12 09:40:23.233785
48f4e4d7-6250-40a0-8108-47a5e5d55d4f	248a8e70-e6da-470c-9f2b-8a6c17b3e1c9	Arbi Vegetables Root Vegetables & Raw Banana	2026-05-12 09:40:33.720025	2026-05-12 08:06:54.444502	2026-05-12 09:40:33.697661
b1d8edcc-d36c-446e-8f52-bf6b52602228	5f9c241a-b32d-458e-9824-ced57f751570	Bhindi Vegetables Bhind, Gourds & Drumsticks	2026-05-12 09:45:15.978662	2026-05-12 07:10:27.748272	2026-05-12 09:45:15.954833
0d93ba5f-e3fb-4a4a-ad49-c7cc5e7c5a89	87b3fc3f-e12c-44f5-92a0-17da34844c84	Apple Shimla Small Fruits Apple & Pear	2026-05-12 10:04:41.736684	2026-05-12 08:11:02.918109	2026-05-12 10:04:41.702778
\.


--
-- Data for Name: product_search_rebuild_job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_search_rebuild_job (id, "productId", reason, "jobStatus", "attemptCount", "scheduledAt", "startedAt", "finishedAt", "lastError", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: product_sub_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sub_category (id, "productId", "subCategoryId", "createdAt") FROM stdin;
58529321-2cbc-48b3-8654-fecd1d4bd937	e21dff30-ca90-4740-ac4e-2c7a1b8bebb2	b20b4e9f-8de9-4b27-8cca-e43575f215fe	2026-05-12 05:47:26.911285
7dcadbce-9676-482b-830d-df34b053dfc2	ba950235-2571-4a2a-b24b-97b277b98e8f	b20b4e9f-8de9-4b27-8cca-e43575f215fe	2026-05-12 05:48:55.883078
f5981cf9-9521-4f1e-94c9-ab9a44756fd3	8269290d-8a0d-411f-92fe-59b1f150ec89	bc0f5199-b695-4375-a684-39ee96ad8038	2026-05-12 05:56:07.869502
c8fe9c8d-e43c-4499-acab-08bdc82ffedd	143aedf4-0ec5-4d57-aa96-36c117a95113	1ed3786a-e5e8-47df-b55c-9d938c3b42a8	2026-05-12 07:03:48.978025
916872e8-4169-41af-a048-d1c62a1e2e3f	4af359d4-045b-4280-a180-68ef83104b7e	bc0f5199-b695-4375-a684-39ee96ad8038	2026-05-12 07:05:38.643013
e771372d-0609-4267-9605-5fa67fa1b269	f19c30d4-80b1-4782-b7ad-9262f7e7a327	1ed3786a-e5e8-47df-b55c-9d938c3b42a8	2026-05-12 07:06:43.372225
671671d2-7c76-47a9-8abc-fe1fb08f07ba	ca8e3571-1b75-4c23-9257-72c9369747fb	1e1306a2-1b26-44a4-a40f-d3994b77c846	2026-05-12 07:07:27.998331
627a8702-7e13-4d51-95e8-0996cee3077b	e8e44a39-39d7-42e3-b105-d0e184b6846d	bc0f5199-b695-4375-a684-39ee96ad8038	2026-05-12 07:48:23.383719
61ea2bfa-29b4-4539-b574-6d2d8a8b86f4	e8e44a39-39d7-42e3-b105-d0e184b6846d	86e60c53-9134-4ff3-b5d4-4ebd9b9062e7	2026-05-12 07:48:23.38535
739fa291-d912-41ed-a958-34f14de89fe0	f2460837-a87f-47b0-8e17-7253dfb8194b	ed71183a-1324-4336-9f82-ac9e95f575eb	2026-05-12 07:49:24.759319
163fd5a7-b5bb-42cb-8e05-1d0a5d7c681c	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	86e60c53-9134-4ff3-b5d4-4ebd9b9062e7	2026-05-12 07:52:00.012267
f32f382f-8c5f-4522-9000-8c2379c71bd1	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	b20b4e9f-8de9-4b27-8cca-e43575f215fe	2026-05-12 07:52:00.014661
24b2a48b-8190-4120-a9c6-71d7fc59da92	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	8acd4d20-a95b-417f-a274-a06934c39267	2026-05-12 07:55:27.660263
18dddf70-155e-4329-9908-0a2707a9ccc7	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	bc0f5199-b695-4375-a684-39ee96ad8038	2026-05-12 07:55:27.662082
5b4b409e-67cb-41e7-8894-748bfde921ab	287343ff-b9b5-415f-870f-f26ea5510d92	1e1306a2-1b26-44a4-a40f-d3994b77c846	2026-05-12 07:56:23.97834
05a0221c-92df-4b95-97c1-42b0b5e33ca9	9c320e33-d76d-4369-ad42-3ab2bbab548b	e256adbd-eddf-4d95-bf26-75c711f103f5	2026-05-12 07:57:58.65317
aa92e3a9-1e6c-4826-8b05-25bdbdebbbf1	ae6a7239-9e09-4128-9461-847e64e852e6	187cf555-03eb-425b-8687-87fed20b2310	2026-05-12 08:00:21.346262
4ef46e97-ad6d-4e29-8b41-d2b4f11565bf	95d2678c-e460-4a01-966c-1d112903ca2b	4d362f94-2716-4ac4-a672-8b4e39aac5fe	2026-05-12 08:08:03.891328
bdf0ce80-9213-4c8e-b1aa-53b6870921dc	7a5f93a3-fb0b-4ebc-b153-003a1b2a2a42	4d362f94-2716-4ac4-a672-8b4e39aac5fe	2026-05-12 08:09:04.891128
f5e1b6b8-d029-4887-83ec-538c4c1f1279	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	f8218f8b-b55a-44b6-b24a-909a2ffdf45d	2026-05-12 08:20:28.204951
e092bcd6-66b6-4bff-babc-20f5f5b20849	1ce6273a-4ec3-4825-aedb-b68d88c2153c	86e60c53-9134-4ff3-b5d4-4ebd9b9062e7	2026-05-12 08:40:09.463071
4d96cead-76ff-4be0-a227-af84f9e35f16	b8beb637-e69e-40f5-90cf-32bca177c8db	b20b4e9f-8de9-4b27-8cca-e43575f215fe	2026-05-12 08:42:05.233206
196d243b-a58e-45a4-a2ed-552cf34cfa44	ce906a6b-d97f-4061-9bec-351844d247d2	d80729c8-922c-4c59-846d-c75b88b05758	2026-05-12 09:40:23.24775
73fb22d1-0428-4c10-aadf-146603b60e31	248a8e70-e6da-470c-9f2b-8a6c17b3e1c9	bc0f5199-b695-4375-a684-39ee96ad8038	2026-05-12 09:40:33.709236
fb167a4d-5baf-48e7-9fc2-527bb2db2823	5f9c241a-b32d-458e-9824-ced57f751570	ed71183a-1324-4336-9f82-ac9e95f575eb	2026-05-12 09:45:15.969326
ab13fc3a-a0a8-4be8-9139-c0c3ddfb8316	87b3fc3f-e12c-44f5-92a0-17da34844c84	d80729c8-922c-4c59-846d-c75b88b05758	2026-05-12 10:04:41.716008
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, "productId", label, sku, "quantityValue", "quantityUnit", "quantityDescription", "salePrice", "listPrice", "isAvailable", "isDefault", "sortOrder", "createdAt", "updatedAt") FROM stdin;
98f75465-c446-43e2-999f-b46f04eb1f18	e21dff30-ca90-4740-ac4e-2c7a1b8bebb2	1.0 kg	e21dff30-ca90-4740-ac4e-2c7a1b8bebb2-default	1	kg	\N	15	20	t	t	0	2026-05-12 05:47:26.872527	2026-05-12 05:47:26.872528
377f922d-276c-478f-8b77-6119421d3f6d	ba950235-2571-4a2a-b24b-97b277b98e8f	5.0 kg	ba950235-2571-4a2a-b24b-97b277b98e8f-default	5	kg	\N	60	100	t	t	0	2026-05-12 05:48:55.862602	2026-05-12 05:48:55.862603
a37939ba-6e39-4112-9b2e-268213fa37ff	8269290d-8a0d-411f-92fe-59b1f150ec89	250.0 gm	8269290d-8a0d-411f-92fe-59b1f150ec89-default	250	gm	\N	25	35	t	t	0	2026-05-12 05:56:07.832253	2026-05-12 05:56:07.832254
21b727dc-8932-4e22-9439-973355c64d32	8269290d-8a0d-411f-92fe-59b1f150ec89	500.0 gm	variant_1778565354553	500	gm	\N	45	70	t	f	1	2026-05-12 05:56:07.841041	2026-05-12 05:56:07.841042
e2190c61-802d-4c3c-b793-aa591f7134a7	143aedf4-0ec5-4d57-aa96-36c117a95113	250.0 gm	143aedf4-0ec5-4d57-aa96-36c117a95113-default	250	gm	\N	20	30	t	t	0	2026-05-12 07:03:48.965902	2026-05-12 07:03:48.965902
460d98ad-922d-4054-98a6-ac9685e8d6f5	143aedf4-0ec5-4d57-aa96-36c117a95113	1.0 kg	variant_1778569410560	1	kg	\N	70	120	t	f	1	2026-05-12 07:03:48.968889	2026-05-12 07:03:48.968889
9c755a6c-b984-4e96-9c84-433f2bfc8d37	4af359d4-045b-4280-a180-68ef83104b7e	6.0 pc	4af359d4-045b-4280-a180-68ef83104b7e-default	6	pc	\N	15	20	t	t	0	2026-05-12 07:05:38.630672	2026-05-12 07:05:38.630672
c16b7507-7b51-4a4d-845f-ffc47d32085f	4af359d4-045b-4280-a180-68ef83104b7e	12.0 pc	variant_1778569503607	12	pc	\N	25	40	t	f	1	2026-05-12 07:05:38.632967	2026-05-12 07:05:38.632967
c6ed8efe-0b33-47cc-b122-d74f4f037652	f19c30d4-80b1-4782-b7ad-9262f7e7a327	500.0 gm	f19c30d4-80b1-4782-b7ad-9262f7e7a327-default	500	gm	\N	30	45	t	t	0	2026-05-12 07:06:43.366914	2026-05-12 07:06:43.366915
3b0d0573-d0e1-4fad-93af-df1a00fdeaef	ca8e3571-1b75-4c23-9257-72c9369747fb	1.0 pc	ca8e3571-1b75-4c23-9257-72c9369747fb-default	1	pc	\N	30	40	t	t	0	2026-05-12 07:07:27.992651	2026-05-12 07:07:27.992652
e5fa0fc6-426d-4d97-8dc0-800f5e4ef6f9	e8e44a39-39d7-42e3-b105-d0e184b6846d	1.0 kg	e8e44a39-39d7-42e3-b105-d0e184b6846d-default	1	kg	\N	20	25	t	t	0	2026-05-12 07:48:23.37825	2026-05-12 07:48:23.37825
8c66e829-a706-4d79-b243-8f88221249f9	f2460837-a87f-47b0-8e17-7253dfb8194b	1.0 pc	f2460837-a87f-47b0-8e17-7253dfb8194b-default	1	pc	\N	10	20	t	t	0	2026-05-12 07:49:24.752557	2026-05-12 07:49:24.752557
8b218f23-24c3-4f23-b735-00d2def0a28a	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	500.0 gm	6ba57f78-4393-4d92-a9ae-c3c28c653ffc-default	500	gm	\N	20	30	t	t	0	2026-05-12 07:52:00.0035	2026-05-12 07:52:00.0035
8f1ccfc5-7e27-4e01-bcd1-7ed3ee130dac	6ba57f78-4393-4d92-a9ae-c3c28c653ffc	1.0 kg	variant_1778572312662	1	kg	\N	30	60	t	f	1	2026-05-12 07:52:00.006492	2026-05-12 07:52:00.006493
b8651e29-7e30-496a-824b-363c5dbf6f1c	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	100.0 gm	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0-default	100	gm	\N	10	15	t	t	0	2026-05-12 07:55:27.651523	2026-05-12 07:55:27.651523
aa74ea63-5090-44b3-a40f-faf5407650bf	adb70c6c-eb03-4f4d-9ae7-fe06f4c606b0	250.0 gm	variant_1778572487863	250	gm	\N	20	38	t	f	1	2026-05-12 07:55:27.654926	2026-05-12 07:55:27.654926
f6658327-f332-40af-8ffa-e4622efb43af	287343ff-b9b5-415f-870f-f26ea5510d92	1.0 pc	287343ff-b9b5-415f-870f-f26ea5510d92-default	1	pc	\N	30	40	t	t	0	2026-05-12 07:56:23.973488	2026-05-12 07:56:23.973488
10fee1d4-0981-41c5-8260-bf66e1c1ea36	9c320e33-d76d-4369-ad42-3ab2bbab548b	1.0 pc	9c320e33-d76d-4369-ad42-3ab2bbab548b-default	1	pc	\N	40	55	t	t	0	2026-05-12 07:57:58.646421	2026-05-12 07:57:58.646421
20c9291c-057c-4b96-bd1b-000c51ca8315	ae6a7239-9e09-4128-9461-847e64e852e6	1.0 pc	ae6a7239-9e09-4128-9461-847e64e852e6-default	1	pc	\N	45	60	t	t	0	2026-05-12 08:00:21.334699	2026-05-12 08:00:21.334699
65dbafb4-1136-40b1-a67e-7902ad77c477	ae6a7239-9e09-4128-9461-847e64e852e6	2.0 pc	variant_1778572799147	2	pc	\N	80	120	t	f	1	2026-05-12 08:00:21.338235	2026-05-12 08:00:21.338235
7751cd32-fac3-4521-8c04-97ff18218afe	95d2678c-e460-4a01-966c-1d112903ca2b	1.0 kg	95d2678c-e460-4a01-966c-1d112903ca2b-default	1	kg	\N	40	55	t	t	0	2026-05-12 08:08:03.886781	2026-05-12 08:08:03.886781
3c680c00-9de1-4633-9bc0-e1d5f40c4c2d	7a5f93a3-fb0b-4ebc-b153-003a1b2a2a42	1.0 kg	7a5f93a3-fb0b-4ebc-b153-003a1b2a2a42-default	1	kg	\N	30	40	t	t	0	2026-05-12 08:09:04.887055	2026-05-12 08:09:04.887055
957488fe-7e21-4848-bce2-d00923802b25	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	12.0 pc	6ae1fa39-b840-4bff-8c69-97f85dabcb8c-default	12	pc	\N	20	30	t	t	0	2026-05-12 08:20:28.197299	2026-05-12 08:20:28.197299
f04be243-aa9d-4c2a-9505-886a52803a53	6ae1fa39-b840-4bff-8c69-97f85dabcb8c	6.0 pc	variant_1778574002054	6	pc	\N	8	15	t	f	1	2026-05-12 08:20:28.198718	2026-05-12 08:20:28.198719
8cf9afbd-d7dd-4af0-a046-397033428a40	1ce6273a-4ec3-4825-aedb-b68d88c2153c	500 gm	1ce6273a-4ec3-4825-aedb-b68d88c2153c-default	500	gm	500 gm	25	35	t	t	0	2026-05-12 08:40:09.437289	2026-05-12 08:40:09.43729
55ff11c1-f41d-40a3-a501-9a239c4a1661	1ce6273a-4ec3-4825-aedb-b68d88c2153c	200.0 gm	variant_1778575170070	200	gm	\N	9	14	t	f	1	2026-05-12 08:40:09.442218	2026-05-12 08:40:09.442219
9ba4a426-27af-4f45-a391-c350e7dc16bc	b8beb637-e69e-40f5-90cf-32bca177c8db	1 kg	b8beb637-e69e-40f5-90cf-32bca177c8db-default	1	kg	1 kg	10	20	t	t	0	2026-05-12 08:42:05.224548	2026-05-12 08:42:05.224548
e5933bf8-f444-4831-8c22-44b5b3fa26ad	b8beb637-e69e-40f5-90cf-32bca177c8db	500.0 gm	variant_1778575304476	500	gm	\N	5	10	t	f	1	2026-05-12 08:42:05.226937	2026-05-12 08:42:05.226937
c6e9f007-7d0f-4911-a845-ed3cd8138615	ce906a6b-d97f-4061-9bec-351844d247d2	500 gm	ce906a6b-d97f-4061-9bec-351844d247d2-default	500	gm	500 gm	50	70	t	t	0	2026-05-12 09:40:23.238802	2026-05-12 09:40:23.238803
1e36b8d8-bb8d-4520-89bf-d2b2a75d7a2c	248a8e70-e6da-470c-9f2b-8a6c17b3e1c9	500 gm	248a8e70-e6da-470c-9f2b-8a6c17b3e1c9-default	500	gm	500 gm	30	40	t	t	0	2026-05-12 09:40:33.702191	2026-05-12 09:40:33.702191
d4262082-2f6d-486b-aa16-f8820671e58e	5f9c241a-b32d-458e-9824-ced57f751570	500 gm	5f9c241a-b32d-458e-9824-ced57f751570-default	500	gm	500 gm	20	30	t	t	0	2026-05-12 09:45:15.959935	2026-05-12 09:45:15.959936
91b3c2b9-05ba-4eaa-b215-43a62224c6e4	5f9c241a-b32d-458e-9824-ced57f751570	1.0 kg	7fa899a7-4ae8-4cab-9b1f-abbe9ebb9a68	1	kg	\N	40	60	t	f	1	2026-05-12 09:45:15.961859	2026-05-12 09:45:15.961859
8def6c42-bcfb-492b-aa78-88fcce546c83	87b3fc3f-e12c-44f5-92a0-17da34844c84	1 kg	87b3fc3f-e12c-44f5-92a0-17da34844c84-default	1	kg	1 kg	90	140	t	t	0	2026-05-12 08:11:02.926321	2026-05-12 10:04:41.708042
\.


--
-- Data for Name: refund_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund_record (id, "orderId", "paymentTransactionId", "userId", "gatewayRefundId", amount, "refundStatus", "failureReason", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_jwt_refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_jwt_refresh_token (id, "authUserId", "scopeNames", "extraClaims", method, "fixedSecret", "rotatingSecretHash", "lastUpdatedAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_profile (id, "authUserId", "userName", "fullName", email, "createdAt", "imageId") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_profile_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_profile_image (id, "userProfileId", "createdAt", "storageId", path, url) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_session (id, "authUserId", "scopeNames", "createdAt", "lastUsedAt", "expiresAt", "expireAfterUnusedFor", "sessionKeyHash", "sessionKeySalt", method) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_user (id, "createdAt", "scopeNames", blocked) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_anonymous_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_anonymous_account (id, "authUserId", "createdAt") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_apple_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_apple_account (id, "userIdentifier", "refreshToken", "refreshTokenRequestedWithBundleIdentifier", "lastRefreshedAt", "authUserId", "createdAt", email, "isEmailVerified", "isPrivateEmail", "firstName", "lastName") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_email_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_email_account (id, "authUserId", "createdAt", email, "passwordHash") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_email_account_password_reset_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_email_account_password_reset_request (id, "emailAccountId", "createdAt", "challengeId", "setPasswordChallengeId") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_email_account_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_email_account_request (id, "createdAt", email, "challengeId", "createAccountChallengeId") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_facebook_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_facebook_account (id, "authUserId", "createdAt", "userIdentifier", email, "fullName", "firstName", "lastName") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_firebase_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_firebase_account (id, "authUserId", created, email, phone, "userIdentifier") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_github_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_github_account (id, "authUserId", "userIdentifier", email, created) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_google_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_google_account (id, "authUserId", created, email, "userIdentifier") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_microsoft_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_microsoft_account (id, "authUserId", "userIdentifier", email, created) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_passkey_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_passkey_account (id, "authUserId", "createdAt", "keyId", "keyIdBase64", "clientDataJSON", "attestationObject", "originalChallenge") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_passkey_challenge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_passkey_challenge (id, "createdAt", challenge) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_rate_limited_request_attempt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_rate_limited_request_attempt (id, domain, source, nonce, "ipAddress", "attemptedAt", "extraData") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_secret_challenge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_secret_challenge (id, "challengeCodeHash") FROM stdin;
\.


--
-- Data for Name: serverpod_cloud_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_cloud_storage (id, "storageId", path, "addedTime", expiration, "byteData", verified) FROM stdin;
\.


--
-- Data for Name: serverpod_cloud_storage_direct_upload; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_cloud_storage_direct_upload (id, "storageId", path, expiration, "authKey") FROM stdin;
\.


--
-- Data for Name: serverpod_future_call; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_future_call (id, name, "time", "serializedObject", "serverId", identifier) FROM stdin;
\.


--
-- Data for Name: serverpod_health_connection_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_health_connection_info (id, "serverId", "timestamp", active, closing, idle, granularity) FROM stdin;
1	default	2026-05-11 19:44:00	0	0	0	1
2	default	2026-05-11 19:45:00	0	0	0	1
3	default	2026-05-11 19:46:00	0	0	0	1
4	default	2026-05-11 19:49:00	0	0	0	1
5	default	2026-05-11 19:54:00	0	0	0	1
6	default	2026-05-11 19:59:00	0	0	0	1
7	default	2026-05-11 20:04:00	0	0	0	1
8	default	2026-05-11 20:09:00	0	0	0	1
9	default	2026-05-11 20:14:00	0	0	0	1
10	default	2026-05-11 20:19:00	0	0	0	1
11	default	2026-05-12 05:11:00	0	0	0	1
12	default	2026-05-12 05:12:00	0	0	0	1
13	default	2026-05-12 05:14:00	0	0	0	1
14	default	2026-05-12 05:15:00	0	0	0	1
15	default	2026-05-12 05:17:00	0	0	0	1
16	default	2026-05-12 05:22:00	0	0	0	1
17	default	2026-05-12 05:23:00	0	0	0	1
18	default	2026-05-12 05:24:00	0	0	2	1
19	default	2026-05-12 05:25:00	0	0	2	1
20	default	2026-05-12 05:26:00	0	0	0	1
21	default	2026-05-12 05:27:00	0	0	2	1
22	default	2026-05-12 05:28:00	0	0	0	1
23	default	2026-05-12 05:30:00	0	0	0	1
24	default	2026-05-12 05:32:00	0	0	0	1
25	default	2026-05-12 05:33:00	0	0	0	1
26	default	2026-05-12 05:35:00	0	0	2	1
27	default	2026-05-12 05:37:00	0	0	2	1
28	default	2026-05-12 05:38:00	0	0	0	1
29	default	2026-05-12 05:40:00	0	0	0	1
30	default	2026-05-12 05:42:00	0	0	0	1
31	default	2026-05-12 05:47:00	0	0	0	1
32	default	2026-05-12 05:48:00	0	0	0	1
33	default	2026-05-12 05:49:00	0	0	1	1
34	default	2026-05-12 05:51:00	0	0	0	1
35	default	2026-05-12 05:57:00	0	0	0	1
36	default	2026-05-12 06:02:00	0	0	0	1
37	default	2026-05-12 06:07:00	0	0	0	1
38	default	2026-05-12 06:12:00	0	0	0	1
39	default	2026-05-12 06:16:00	0	0	0	1
40	default	2026-05-12 06:21:00	0	0	0	1
41	default	2026-05-12 06:27:00	0	0	0	1
42	default	2026-05-12 06:32:00	0	0	0	1
43	default	2026-05-12 06:37:00	0	0	0	1
44	default	2026-05-12 06:42:00	0	0	0	1
45	default	2026-05-12 06:47:00	0	0	0	1
46	default	2026-05-12 06:52:00	0	0	0	1
47	default	2026-05-12 06:56:00	0	0	0	1
48	default	2026-05-12 07:02:00	0	0	0	1
49	default	2026-05-12 07:04:00	0	0	1	1
50	default	2026-05-12 07:05:00	0	0	0	1
51	default	2026-05-12 07:07:00	0	0	0	1
52	default	2026-05-12 07:08:00	0	0	0	1
53	default	2026-05-12 07:11:00	0	0	0	1
54	default	2026-05-12 07:12:00	0	0	0	1
55	default	2026-05-12 07:16:00	0	0	0	1
56	default	2026-05-12 07:22:00	0	0	0	1
57	default	2026-05-12 07:27:00	0	0	0	1
58	default	2026-05-12 07:32:00	0	0	0	1
59	default	2026-05-12 07:36:00	0	0	0	1
60	default	2026-05-12 07:42:00	0	0	0	1
61	default	2026-05-12 07:45:00	0	0	1	1
62	default	2026-05-12 07:46:00	0	0	0	1
63	default	2026-05-12 07:47:00	0	0	0	1
64	default	2026-05-12 07:48:00	0	0	0	1
65	default	2026-05-12 07:50:00	0	0	0	1
66	default	2026-05-12 07:51:00	1	0	0	1
67	default	2026-05-12 07:52:00	0	0	0	1
68	default	2026-05-12 07:56:00	0	0	0	1
69	default	2026-05-12 07:58:00	0	0	1	1
70	default	2026-05-12 08:00:00	0	0	2	1
71	default	2026-05-12 08:02:00	0	0	0	1
72	default	2026-05-12 08:07:00	0	0	1	1
73	default	2026-05-12 08:08:00	0	0	0	1
74	default	2026-05-12 08:09:00	0	0	0	1
75	default	2026-05-12 08:11:00	0	0	0	1
76	default	2026-05-12 08:12:00	0	0	0	1
77	default	2026-05-12 08:15:00	0	0	0	1
78	default	2026-05-12 08:16:00	0	0	1	1
79	default	2026-05-12 08:20:00	0	0	3	1
80	default	2026-05-12 08:21:00	0	0	0	1
81	default	2026-05-12 08:27:00	0	0	0	1
82	default	2026-05-12 08:32:00	0	0	0	1
83	default	2026-05-12 08:37:00	0	0	0	1
84	default	2026-05-12 08:38:00	0	0	0	1
85	default	2026-05-12 08:40:00	0	0	0	1
86	default	2026-05-12 08:41:00	0	0	1	1
87	default	2026-05-12 08:43:00	0	0	1	1
88	default	2026-05-12 08:44:00	0	0	0	1
89	default	2026-05-12 08:46:00	0	0	0	1
90	default	2026-05-12 08:48:00	0	0	0	1
91	default	2026-05-12 08:53:00	0	0	1	1
92	default	2026-05-12 08:54:00	0	0	0	1
93	default	2026-05-12 08:57:00	0	0	0	1
94	default	2026-05-12 09:03:00	0	0	0	1
95	default	2026-05-12 09:07:00	0	0	5	1
96	default	2026-05-12 09:08:00	0	0	0	1
97	default	2026-05-12 09:10:00	0	0	1	1
98	default	2026-05-12 09:11:00	0	0	0	1
99	default	2026-05-12 09:13:00	0	0	0	1
100	default	2026-05-12 09:18:00	0	0	0	1
101	default	2026-05-12 09:20:00	0	0	1	1
102	default	2026-05-12 09:21:00	0	0	0	1
103	default	2026-05-12 09:22:00	0	0	1	1
104	default	2026-05-12 09:25:00	0	0	0	1
105	default	2026-05-12 09:26:00	0	0	0	1
106	default	2026-05-12 09:28:00	0	0	0	1
107	default	2026-05-12 09:30:00	0	0	0	1
108	default	2026-05-12 09:32:00	0	0	0	1
109	default	2026-05-12 09:35:00	0	0	0	1
110	default	2026-05-12 09:37:00	0	0	0	1
111	default	2026-05-12 09:39:00	0	0	0	1
112	default	2026-05-12 09:40:00	0	0	1	1
113	default	2026-05-12 09:43:00	0	0	0	1
114	default	2026-05-12 09:46:00	0	0	0	1
115	default	2026-05-12 09:48:00	0	0	0	1
116	default	2026-05-12 09:53:00	0	0	0	1
117	default	2026-05-12 09:58:00	0	0	0	1
118	default	2026-05-12 10:03:00	0	0	0	1
119	default	2026-05-12 10:05:00	0	0	1	1
120	default	2026-05-12 10:08:00	0	0	0	1
121	default	2026-05-12 10:13:00	0	0	0	1
122	default	2026-05-12 10:18:00	0	0	0	1
123	default	2026-05-12 10:20:00	0	0	1	1
124	default	2026-05-12 10:21:00	0	0	1	1
125	default	2026-05-12 10:23:00	0	0	0	1
126	default	2026-05-12 10:26:00	0	0	8	1
127	default	2026-05-12 10:28:00	0	0	0	1
128	default	2026-05-12 10:30:00	0	0	1	1
129	default	2026-05-12 10:31:00	0	0	0	1
130	default	2026-05-12 10:33:00	0	0	1	1
131	default	2026-05-12 10:37:00	0	0	0	1
132	default	2026-05-12 10:40:00	0	0	0	1
133	default	2026-05-12 10:42:00	0	0	5	1
134	default	2026-05-12 10:45:00	0	0	0	1
135	default	2026-05-12 10:46:00	0	0	0	1
136	default	2026-05-12 10:52:00	0	0	0	1
137	default	2026-05-12 10:55:00	0	0	0	1
138	default	2026-05-12 10:56:00	0	0	0	1
139	default	2026-05-12 11:02:00	0	0	0	1
140	default	2026-05-12 11:07:00	0	0	0	1
141	default	2026-05-12 11:12:00	0	0	0	1
142	default	2026-05-12 11:17:00	0	0	0	1
143	default	2026-05-12 11:22:00	0	0	0	1
144	default	2026-05-12 11:27:00	0	0	0	1
145	default	2026-05-12 11:31:00	0	0	1	1
146	default	2026-05-12 11:33:00	0	0	1	1
147	default	2026-05-12 11:35:00	0	0	1	1
148	default	2026-05-12 11:36:00	0	0	0	1
149	default	2026-05-12 11:37:00	0	0	0	1
150	default	2026-05-12 11:41:00	0	0	1	1
151	default	2026-05-12 11:43:00	0	0	0	1
152	default	2026-05-12 11:47:00	0	0	0	1
153	default	2026-05-12 11:49:00	0	0	0	1
154	default	2026-05-12 11:52:00	0	0	0	1
155	default	2026-05-12 11:54:00	0	0	0	1
156	default	2026-05-12 11:57:00	0	0	0	1
157	default	2026-05-12 12:02:00	0	0	0	1
158	default	2026-05-12 12:05:00	0	0	1	1
159	default	2026-05-12 12:06:00	0	0	0	1
160	default	2026-05-12 12:12:00	0	0	0	1
161	default	2026-05-12 12:13:00	0	0	0	1
162	default	2026-05-12 12:17:00	0	0	0	1
163	default	2026-05-12 12:19:00	0	0	0	1
164	default	2026-05-12 12:22:00	0	0	0	1
165	default	2026-05-12 12:27:00	0	0	0	1
166	default	2026-05-12 12:32:00	0	0	0	1
167	default	2026-05-12 12:38:00	0	0	1	1
168	default	2026-05-12 12:39:00	0	0	2	1
169	default	2026-05-12 12:40:00	0	0	0	1
170	default	2026-05-12 12:42:00	0	0	0	1
171	default	2026-05-12 12:47:00	0	0	0	1
172	default	2026-05-12 12:52:00	0	0	0	1
173	default	2026-05-12 12:58:00	0	0	0	1
174	default	2026-05-12 13:02:00	0	0	0	1
\.


--
-- Data for Name: serverpod_health_metric; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_health_metric (id, name, "serverId", "timestamp", "isHealthy", value, granularity) FROM stdin;
1	serverpod_database	default	2026-05-11 19:44:00	t	0.004667	1
2	serverpod_cpu	default	2026-05-11 19:44:00	t	0	1
3	serverpod_memory	default	2026-05-11 19:44:00	t	0.43475649581436937	1
4	serverpod_database	default	2026-05-11 19:45:00	t	0.00762	1
5	serverpod_cpu	default	2026-05-11 19:45:00	t	0.071875	1
6	serverpod_memory	default	2026-05-11 19:45:00	t	0.41732014562656716	1
7	serverpod_database	default	2026-05-11 19:46:00	t	0.003804	1
8	serverpod_cpu	default	2026-05-11 19:46:00	t	0.018625	1
9	serverpod_memory	default	2026-05-11 19:46:00	t	0.3924963583056386	1
10	serverpod_database	default	2026-05-11 19:49:00	t	0.002681	1
11	serverpod_cpu	default	2026-05-11 19:49:00	t	0.020875	1
12	serverpod_memory	default	2026-05-11 19:49:00	t	0.35326701706599967	1
13	serverpod_database	default	2026-05-11 19:54:00	t	0.00295	1
14	serverpod_cpu	default	2026-05-11 19:54:00	t	0.006	1
15	serverpod_memory	default	2026-05-11 19:54:00	t	0.33268294492027417	1
16	serverpod_database	default	2026-05-11 19:59:00	t	0.002613	1
17	serverpod_cpu	default	2026-05-11 19:59:00	t	0.005875	1
18	serverpod_memory	default	2026-05-11 19:59:00	t	0.3336760406386306	1
19	serverpod_database	default	2026-05-11 20:04:00	t	0.002332	1
20	serverpod_cpu	default	2026-05-11 20:04:00	t	0.006125	1
21	serverpod_memory	default	2026-05-11 20:04:00	t	0.35609950324610434	1
22	serverpod_database	default	2026-05-11 20:09:00	t	0.002664	1
23	serverpod_cpu	default	2026-05-11 20:09:00	t	0.00625	1
24	serverpod_memory	default	2026-05-11 20:09:00	t	0.39392625131090697	1
25	serverpod_database	default	2026-05-11 20:14:00	t	0.003185	1
26	serverpod_cpu	default	2026-05-11 20:14:00	t	0.006	1
27	serverpod_memory	default	2026-05-11 20:14:00	t	0.4003442869181273	1
28	serverpod_database	default	2026-05-11 20:19:00	t	0.003207	1
29	serverpod_cpu	default	2026-05-11 20:19:00	t	0.006	1
30	serverpod_memory	default	2026-05-11 20:19:00	t	0.3816382370696671	1
31	serverpod_database	default	2026-05-12 05:11:00	t	0.081017	1
32	serverpod_cpu	default	2026-05-12 05:11:00	t	0	1
33	serverpod_memory	default	2026-05-12 05:11:00	t	0.39198673125906236	1
34	serverpod_database	default	2026-05-12 05:12:00	t	0.014295	1
35	serverpod_cpu	default	2026-05-12 05:12:00	t	0.09475	1
36	serverpod_memory	default	2026-05-12 05:12:00	t	0.261636289182319	1
37	serverpod_database	default	2026-05-12 05:14:00	t	0.004793	1
38	serverpod_cpu	default	2026-05-12 05:14:00	t	0.013875	1
39	serverpod_memory	default	2026-05-12 05:14:00	t	0.2845243522088384	1
40	serverpod_database	default	2026-05-12 05:15:00	t	0.005011	1
41	serverpod_cpu	default	2026-05-12 05:15:00	t	0.012875	1
42	serverpod_memory	default	2026-05-12 05:15:00	t	0.274179782168069	1
44	serverpod_database	default	2026-05-12 05:17:00	t	0.007122	1
45	serverpod_cpu	default	2026-05-12 05:17:00	t	0.018125	1
46	serverpod_memory	default	2026-05-12 05:17:00	t	0.2672399628104388	1
47	serverpod_database	default	2026-05-12 05:22:00	t	0.016895	1
48	serverpod_cpu	default	2026-05-12 05:22:00	t	0	1
49	serverpod_memory	default	2026-05-12 05:22:00	t	0.22509471233462364	1
50	serverpod_database	default	2026-05-12 05:23:00	t	0.00884	1
51	serverpod_cpu	default	2026-05-12 05:23:00	t	0.015	1
52	serverpod_memory	default	2026-05-12 05:23:00	t	0.21349950164957854	1
53	serverpod_database	default	2026-05-12 05:24:00	t	0.007082	1
54	serverpod_cpu	default	2026-05-12 05:24:00	t	0.0135	1
55	serverpod_memory	default	2026-05-12 05:24:00	t	0.20836043999062534	1
56	serverpod_database	default	2026-05-12 05:25:00	t	0.006898	1
57	serverpod_cpu	default	2026-05-12 05:25:00	t	0.01475	1
58	serverpod_memory	default	2026-05-12 05:25:00	t	0.20938392555906676	1
59	serverpod_database	default	2026-05-12 05:26:00	t	0.008416	1
60	serverpod_cpu	default	2026-05-12 05:26:00	t	0.013375	1
61	serverpod_memory	default	2026-05-12 05:26:00	t	0.20198928095889318	1
62	serverpod_database	default	2026-05-12 05:27:00	t	0.008536	1
63	serverpod_cpu	default	2026-05-12 05:27:00	t	0.017125	1
64	serverpod_memory	default	2026-05-12 05:27:00	t	0.2073209866050618	1
65	serverpod_database	default	2026-05-12 05:28:00	t	0.006717	1
66	serverpod_cpu	default	2026-05-12 05:28:00	t	0.013375	1
67	serverpod_memory	default	2026-05-12 05:28:00	t	0.2055871907201228	1
68	serverpod_database	default	2026-05-12 05:30:00	t	0.020633	1
69	serverpod_cpu	default	2026-05-12 05:30:00	t	0.01325	1
70	serverpod_memory	default	2026-05-12 05:30:00	t	0.19297982646588424	1
71	serverpod_database	default	2026-05-12 05:32:00	t	0.007226	1
72	serverpod_cpu	default	2026-05-12 05:32:00	t	0.00975	1
73	serverpod_memory	default	2026-05-12 05:32:00	t	0.19476770689268855	1
75	serverpod_database	default	2026-05-12 05:33:00	t	0.006172	1
76	serverpod_cpu	default	2026-05-12 05:33:00	t	0.01	1
77	serverpod_memory	default	2026-05-12 05:33:00	t	0.2454840695269663	1
78	serverpod_database	default	2026-05-12 05:35:00	t	0.00675	1
79	serverpod_cpu	default	2026-05-12 05:35:00	t	0.0105	1
80	serverpod_memory	default	2026-05-12 05:35:00	t	0.24526000499638148	1
82	serverpod_database	default	2026-05-12 05:37:00	t	0.004091	1
83	serverpod_cpu	default	2026-05-12 05:37:00	t	0.01025	1
84	serverpod_memory	default	2026-05-12 05:37:00	t	0.24512196064190625	1
85	serverpod_database	default	2026-05-12 05:38:00	t	0.004485	1
86	serverpod_cpu	default	2026-05-12 05:38:00	t	0.011375	1
87	serverpod_memory	default	2026-05-12 05:38:00	t	0.2559759555579593	1
88	serverpod_database	default	2026-05-12 05:40:00	t	0.007021	1
89	serverpod_cpu	default	2026-05-12 05:40:00	t	0.009625	1
90	serverpod_memory	default	2026-05-12 05:40:00	t	0.2592509033406219	1
91	serverpod_database	default	2026-05-12 05:42:00	t	0.006548	1
92	serverpod_cpu	default	2026-05-12 05:42:00	t	0.010625	1
93	serverpod_memory	default	2026-05-12 05:42:00	t	0.259339498971106	1
94	serverpod_database	default	2026-05-12 05:47:00	t	0.009964	1
95	serverpod_cpu	default	2026-05-12 05:47:00	t	0.00875	1
96	serverpod_memory	default	2026-05-12 05:47:00	t	0.25062055573154496	1
97	serverpod_database	default	2026-05-12 05:48:00	t	0.007885	1
98	serverpod_cpu	default	2026-05-12 05:48:00	t	0.010125	1
99	serverpod_memory	default	2026-05-12 05:48:00	t	0.24816975334873456	1
100	serverpod_database	default	2026-05-12 05:49:00	t	0.006772	1
101	serverpod_cpu	default	2026-05-12 05:49:00	t	0.010375	1
102	serverpod_memory	default	2026-05-12 05:49:00	t	0.2454227737128523	1
103	serverpod_database	default	2026-05-12 05:51:00	t	0.006577	1
104	serverpod_cpu	default	2026-05-12 05:51:00	t	0.009125	1
105	serverpod_memory	default	2026-05-12 05:51:00	t	0.1902477844653743	1
106	serverpod_database	default	2026-05-12 05:57:00	t	0.005922	1
107	serverpod_cpu	default	2026-05-12 05:57:00	t	0.008625	1
108	serverpod_memory	default	2026-05-12 05:57:00	t	0.18243282571127611	1
109	serverpod_database	default	2026-05-12 06:02:00	t	0.002567	1
110	serverpod_cpu	default	2026-05-12 06:02:00	t	0.005375	1
111	serverpod_memory	default	2026-05-12 06:02:00	t	0.11367798063773402	1
112	serverpod_database	default	2026-05-12 06:07:00	t	0.003546	1
113	serverpod_cpu	default	2026-05-12 06:07:00	t	0.004875	1
114	serverpod_memory	default	2026-05-12 06:07:00	t	0.10193184832634097	1
115	serverpod_database	default	2026-05-12 06:12:00	t	0.003143	1
116	serverpod_cpu	default	2026-05-12 06:12:00	t	0.004625	1
117	serverpod_memory	default	2026-05-12 06:12:00	t	0.10339419132020367	1
118	serverpod_database	default	2026-05-12 06:16:00	t	0.002657	1
119	serverpod_cpu	default	2026-05-12 06:16:00	t	0.00475	1
120	serverpod_memory	default	2026-05-12 06:16:00	t	0.10566625716942112	1
121	serverpod_database	default	2026-05-12 06:21:00	t	0.006145	1
122	serverpod_cpu	default	2026-05-12 06:21:00	t	0.00475	1
123	serverpod_memory	default	2026-05-12 06:21:00	t	0.10892060131708736	1
124	serverpod_database	default	2026-05-12 06:27:00	t	0.00601	1
125	serverpod_cpu	default	2026-05-12 06:27:00	t	0.00475	1
126	serverpod_memory	default	2026-05-12 06:27:00	t	0.1037624812957626	1
127	serverpod_database	default	2026-05-12 06:32:00	t	0.00522	1
128	serverpod_cpu	default	2026-05-12 06:32:00	t	0.00475	1
129	serverpod_memory	default	2026-05-12 06:32:00	t	0.10276938608894075	1
130	serverpod_database	default	2026-05-12 06:37:00	t	0.00482	1
131	serverpod_cpu	default	2026-05-12 06:37:00	t	0.00575	1
132	serverpod_memory	default	2026-05-12 06:37:00	t	0.10421473108393148	1
133	serverpod_database	default	2026-05-12 06:42:00	t	0.002431	1
134	serverpod_cpu	default	2026-05-12 06:42:00	t	0.006125	1
135	serverpod_memory	default	2026-05-12 06:42:00	t	0.10661505456100093	1
136	serverpod_database	default	2026-05-12 06:47:00	t	0.002987	1
137	serverpod_cpu	default	2026-05-12 06:47:00	t	0.006	1
138	serverpod_memory	default	2026-05-12 06:47:00	t	0.10846062516579487	1
139	serverpod_database	default	2026-05-12 06:52:00	t	0.003081	1
140	serverpod_cpu	default	2026-05-12 06:52:00	t	0.006125	1
141	serverpod_memory	default	2026-05-12 06:52:00	t	0.10931928165426585	1
142	serverpod_database	default	2026-05-12 06:56:00	t	0.002066	1
143	serverpod_cpu	default	2026-05-12 06:56:00	t	0.00525	1
144	serverpod_memory	default	2026-05-12 06:56:00	t	0.11811806397943757	1
145	serverpod_database	default	2026-05-12 07:02:00	t	0.00182	1
146	serverpod_cpu	default	2026-05-12 07:02:00	t	0.005375	1
147	serverpod_memory	default	2026-05-12 07:02:00	t	0.121499635573206	1
149	serverpod_database	default	2026-05-12 07:04:00	t	0.002451	1
150	serverpod_cpu	default	2026-05-12 07:04:00	t	0.005625	1
151	serverpod_memory	default	2026-05-12 07:04:00	t	0.13196731233307837	1
152	serverpod_database	default	2026-05-12 07:05:00	t	0.003842	1
153	serverpod_cpu	default	2026-05-12 07:05:00	t	0.005625	1
154	serverpod_memory	default	2026-05-12 07:05:00	t	0.13289499099878696	1
155	serverpod_database	default	2026-05-12 07:07:00	t	0.002076	1
156	serverpod_cpu	default	2026-05-12 07:07:00	t	0.005875	1
157	serverpod_memory	default	2026-05-12 07:07:00	t	0.13328336951846728	1
159	serverpod_database	default	2026-05-12 07:08:00	t	0.002265	1
160	serverpod_cpu	default	2026-05-12 07:08:00	t	0.0065	1
161	serverpod_memory	default	2026-05-12 07:08:00	t	0.13353009804754803	1
162	serverpod_database	default	2026-05-12 07:11:00	t	0.003325	1
163	serverpod_cpu	default	2026-05-12 07:11:00	t	0.005375	1
164	serverpod_memory	default	2026-05-12 07:11:00	t	0.13399367983496488	1
166	serverpod_database	default	2026-05-12 07:12:00	t	0.002187	1
167	serverpod_cpu	default	2026-05-12 07:12:00	t	0.005625	1
168	serverpod_memory	default	2026-05-12 07:12:00	t	0.1344825010752522	1
169	serverpod_database	default	2026-05-12 07:16:00	t	0.003521	1
170	serverpod_cpu	default	2026-05-12 07:16:00	t	0.006125	1
171	serverpod_memory	default	2026-05-12 07:16:00	t	0.13171646307699836	1
172	serverpod_database	default	2026-05-12 07:22:00	t	0.001927	1
173	serverpod_cpu	default	2026-05-12 07:22:00	t	0.007375	1
174	serverpod_memory	default	2026-05-12 07:22:00	t	0.13260241938183945	1
175	serverpod_database	default	2026-05-12 07:27:00	t	0.001843	1
176	serverpod_cpu	default	2026-05-12 07:27:00	t	0.00725	1
177	serverpod_memory	default	2026-05-12 07:27:00	t	0.13187614124821972	1
178	serverpod_database	default	2026-05-12 07:32:00	t	0.001683	1
179	serverpod_cpu	default	2026-05-12 07:32:00	t	0.007375	1
180	serverpod_memory	default	2026-05-12 07:32:00	t	0.13142028582392648	1
181	serverpod_database	default	2026-05-12 07:36:00	t	0.002061	1
182	serverpod_cpu	default	2026-05-12 07:36:00	t	0.007125	1
183	serverpod_memory	default	2026-05-12 07:36:00	t	0.13316489861723854	1
184	serverpod_database	default	2026-05-12 07:42:00	t	0.002583	1
185	serverpod_cpu	default	2026-05-12 07:42:00	t	0.005375	1
186	serverpod_memory	default	2026-05-12 07:42:00	t	0.13338844805694844	1
187	serverpod_database	default	2026-05-12 07:45:00	t	0.002252	1
188	serverpod_cpu	default	2026-05-12 07:45:00	t	0.00625	1
189	serverpod_memory	default	2026-05-12 07:45:00	t	0.13562806318104673	1
190	serverpod_database	default	2026-05-12 07:46:00	t	0.003901	1
191	serverpod_cpu	default	2026-05-12 07:46:00	t	0.00575	1
192	serverpod_memory	default	2026-05-12 07:46:00	t	0.1358701558922533	1
193	serverpod_database	default	2026-05-12 07:47:00	t	0.002024	1
194	serverpod_cpu	default	2026-05-12 07:47:00	t	0.0055	1
195	serverpod_memory	default	2026-05-12 07:47:00	t	0.13620393477919343	1
196	serverpod_database	default	2026-05-12 07:48:00	t	0.00327	1
197	serverpod_cpu	default	2026-05-12 07:48:00	t	0.00575	1
198	serverpod_memory	default	2026-05-12 07:48:00	t	0.13854708316914813	1
199	serverpod_database	default	2026-05-12 07:50:00	t	0.001992	1
200	serverpod_cpu	default	2026-05-12 07:50:00	t	0.005875	1
201	serverpod_memory	default	2026-05-12 07:50:00	t	0.13877887406285655	1
202	serverpod_database	default	2026-05-12 07:51:00	t	0.00361	1
203	serverpod_cpu	default	2026-05-12 07:51:00	t	0.005375	1
204	serverpod_memory	default	2026-05-12 07:51:00	t	0.13983223490204258	1
205	serverpod_database	default	2026-05-12 07:52:00	t	0.002762	1
206	serverpod_cpu	default	2026-05-12 07:52:00	t	0.0055	1
207	serverpod_memory	default	2026-05-12 07:52:00	t	0.14025151887421738	1
208	serverpod_database	default	2026-05-12 07:56:00	t	0.001944	1
209	serverpod_cpu	default	2026-05-12 07:56:00	t	0.005375	1
210	serverpod_memory	default	2026-05-12 07:56:00	t	0.1333580576953289	1
212	serverpod_database	default	2026-05-12 07:58:00	t	0.002326	1
213	serverpod_cpu	default	2026-05-12 07:58:00	t	0.005875	1
214	serverpod_memory	default	2026-05-12 07:58:00	t	0.13229800067476905	1
216	serverpod_database	default	2026-05-12 08:00:00	t	0.003523	1
217	serverpod_cpu	default	2026-05-12 08:00:00	t	0.005625	1
218	serverpod_memory	default	2026-05-12 08:00:00	t	0.12570329220332696	1
219	serverpod_database	default	2026-05-12 08:02:00	t	0.001997	1
220	serverpod_cpu	default	2026-05-12 08:02:00	t	0.005375	1
221	serverpod_memory	default	2026-05-12 08:02:00	t	0.12594950564153282	1
222	serverpod_database	default	2026-05-12 08:07:00	t	0.00251	1
223	serverpod_cpu	default	2026-05-12 08:07:00	t	0.005375	1
224	serverpod_memory	default	2026-05-12 08:07:00	t	0.12720787264893207	1
225	serverpod_database	default	2026-05-12 08:08:00	t	0.003529	1
226	serverpod_cpu	default	2026-05-12 08:08:00	t	0.005625	1
227	serverpod_memory	default	2026-05-12 08:08:00	t	0.12652846778492896	1
228	serverpod_database	default	2026-05-12 08:09:00	t	0.003029	1
229	serverpod_cpu	default	2026-05-12 08:09:00	t	0.0055	1
230	serverpod_memory	default	2026-05-12 08:09:00	t	0.1255837911203484	1
231	serverpod_database	default	2026-05-12 08:11:00	t	0.002042	1
232	serverpod_cpu	default	2026-05-12 08:11:00	t	0.0055	1
233	serverpod_memory	default	2026-05-12 08:11:00	t	0.1255564913039783	1
234	serverpod_database	default	2026-05-12 08:12:00	t	0.002895	1
235	serverpod_cpu	default	2026-05-12 08:12:00	t	0.008125	1
236	serverpod_memory	default	2026-05-12 08:12:00	t	0.10877946641736268	1
238	serverpod_database	default	2026-05-12 08:15:00	t	0.002583	1
239	serverpod_cpu	default	2026-05-12 08:15:00	t	0.005375	1
240	serverpod_memory	default	2026-05-12 08:15:00	t	0.10534587064522859	1
241	serverpod_database	default	2026-05-12 08:16:00	t	0.002116	1
242	serverpod_cpu	default	2026-05-12 08:16:00	t	0.005375	1
243	serverpod_memory	default	2026-05-12 08:16:00	t	0.10537832137034776	1
244	serverpod_database	default	2026-05-12 08:20:00	t	0.002121	1
245	serverpod_cpu	default	2026-05-12 08:20:00	t	0.00575	1
246	serverpod_memory	default	2026-05-12 08:20:00	t	0.10469273541584574	1
248	serverpod_database	default	2026-05-12 08:21:00	t	0.002537	1
249	serverpod_cpu	default	2026-05-12 08:21:00	t	0.006125	1
250	serverpod_memory	default	2026-05-12 08:21:00	t	0.10481326668057413	1
251	serverpod_database	default	2026-05-12 08:27:00	t	0.001936	1
252	serverpod_cpu	default	2026-05-12 08:27:00	t	0.005125	1
253	serverpod_memory	default	2026-05-12 08:27:00	t	0.09644613050857498	1
254	serverpod_database	default	2026-05-12 08:32:00	t	0.001816	1
255	serverpod_cpu	default	2026-05-12 08:32:00	t	0.005125	1
256	serverpod_memory	default	2026-05-12 08:32:00	t	0.09641110432908126	1
257	serverpod_database	default	2026-05-12 08:37:00	t	0.002557	1
258	serverpod_cpu	default	2026-05-12 08:37:00	t	0.008125	1
259	serverpod_memory	default	2026-05-12 08:37:00	t	0.1651551324942503	1
260	serverpod_database	default	2026-05-12 08:38:00	t	0.002236	1
261	serverpod_cpu	default	2026-05-12 08:38:00	t	0	1
262	serverpod_memory	default	2026-05-12 08:38:00	t	0.26141892083310797	1
263	serverpod_database	default	2026-05-12 08:40:00	t	0.002207	1
264	serverpod_cpu	default	2026-05-12 08:40:00	t	0.10425	1
265	serverpod_memory	default	2026-05-12 08:40:00	t	0.33445983707675625	1
266	serverpod_database	default	2026-05-12 08:41:00	t	0.002195	1
267	serverpod_cpu	default	2026-05-12 08:41:00	t	0.01025	1
268	serverpod_memory	default	2026-05-12 08:41:00	t	0.3265382545115522	1
270	serverpod_database	default	2026-05-12 08:43:00	t	0.001914	1
271	serverpod_cpu	default	2026-05-12 08:43:00	t	0.0105	1
272	serverpod_memory	default	2026-05-12 08:43:00	t	0.30070696222581067	1
273	serverpod_database	default	2026-05-12 08:44:00	t	0.002564	1
274	serverpod_cpu	default	2026-05-12 08:44:00	t	0.008	1
275	serverpod_memory	default	2026-05-12 08:44:00	t	0.30043963006173363	1
277	serverpod_database	default	2026-05-12 08:46:00	t	0.001983	1
278	serverpod_cpu	default	2026-05-12 08:46:00	t	0.007875	1
279	serverpod_memory	default	2026-05-12 08:46:00	t	0.290319124551549	1
281	serverpod_database	default	2026-05-12 08:48:00	t	0.00235	1
282	serverpod_cpu	default	2026-05-12 08:48:00	t	0.006	1
283	serverpod_memory	default	2026-05-12 08:48:00	t	0.29259788658214025	1
284	serverpod_database	default	2026-05-12 08:53:00	t	0.002115	1
285	serverpod_cpu	default	2026-05-12 08:53:00	t	0.0065	1
286	serverpod_memory	default	2026-05-12 08:53:00	t	0.28791055962048107	1
287	serverpod_database	default	2026-05-12 08:54:00	t	0.002479	1
288	serverpod_cpu	default	2026-05-12 08:54:00	t	0.00675	1
289	serverpod_memory	default	2026-05-12 08:54:00	t	0.26689691228775037	1
290	serverpod_database	default	2026-05-12 08:57:00	t	0.008015	1
291	serverpod_cpu	default	2026-05-12 08:57:00	t	0.00575	1
292	serverpod_memory	default	2026-05-12 08:57:00	t	0.21022352368516617	1
293	serverpod_database	default	2026-05-12 09:03:00	t	0.004385	1
294	serverpod_cpu	default	2026-05-12 09:03:00	t	0.00725	1
295	serverpod_memory	default	2026-05-12 09:03:00	t	0.23999680643657556	1
296	serverpod_database	default	2026-05-12 09:07:00	t	0.002507	1
297	serverpod_cpu	default	2026-05-12 09:07:00	t	0.02875	1
298	serverpod_memory	default	2026-05-12 09:07:00	t	0.3700320128978755	1
299	serverpod_database	default	2026-05-12 09:08:00	t	0.002171	1
300	serverpod_cpu	default	2026-05-12 09:08:00	t	0.008625	1
301	serverpod_memory	default	2026-05-12 09:08:00	t	0.36635271877841047	1
302	serverpod_database	default	2026-05-12 09:10:00	t	0.002194	1
303	serverpod_cpu	default	2026-05-12 09:10:00	t	0.00725	1
304	serverpod_memory	default	2026-05-12 09:10:00	t	0.22348968916841153	1
305	serverpod_database	default	2026-05-12 09:11:00	t	0.002163	1
306	serverpod_cpu	default	2026-05-12 09:11:00	t	0.006	1
307	serverpod_memory	default	2026-05-12 09:11:00	t	0.23083282468109437	1
308	serverpod_database	default	2026-05-12 09:13:00	t	0.001898	1
309	serverpod_cpu	default	2026-05-12 09:13:00	t	0.005375	1
310	serverpod_memory	default	2026-05-12 09:13:00	t	0.23204019769187778	1
311	serverpod_database	default	2026-05-12 09:18:00	t	0.00201	1
312	serverpod_cpu	default	2026-05-12 09:18:00	t	0.0065	1
313	serverpod_memory	default	2026-05-12 09:18:00	t	0.2278813539678738	1
314	serverpod_database	default	2026-05-12 09:20:00	t	0.002561	1
315	serverpod_cpu	default	2026-05-12 09:20:00	t	0.007625	1
316	serverpod_memory	default	2026-05-12 09:20:00	t	0.2215313136620128	1
317	serverpod_database	default	2026-05-12 09:21:00	t	0.002742	1
318	serverpod_cpu	default	2026-05-12 09:21:00	t	0.007375	1
319	serverpod_memory	default	2026-05-12 09:21:00	t	0.21786953263229467	1
320	serverpod_database	default	2026-05-12 09:22:00	t	0.002338	1
321	serverpod_cpu	default	2026-05-12 09:22:00	t	0.0075	1
322	serverpod_memory	default	2026-05-12 09:22:00	t	0.2185911749480402	1
323	serverpod_database	default	2026-05-12 09:25:00	t	0.034225	1
324	serverpod_cpu	default	2026-05-12 09:25:00	t	0.0685	1
325	serverpod_memory	default	2026-05-12 09:25:00	t	0.35728196847128757	1
327	serverpod_database	default	2026-05-12 09:26:00	t	0.002511	1
328	serverpod_cpu	default	2026-05-12 09:26:00	t	0.012375	1
329	serverpod_memory	default	2026-05-12 09:26:00	t	0.4122298026429313	1
330	serverpod_database	default	2026-05-12 09:28:00	t	0.002708	1
331	serverpod_cpu	default	2026-05-12 09:28:00	t	0.008125	1
332	serverpod_memory	default	2026-05-12 09:28:00	t	0.3648764683309253	1
333	serverpod_database	default	2026-05-12 09:30:00	t	0.002893	1
334	serverpod_cpu	default	2026-05-12 09:30:00	t	0.00725	1
335	serverpod_memory	default	2026-05-12 09:30:00	t	0.2882180688728009	1
336	serverpod_database	default	2026-05-12 09:32:00	t	0.00271	1
337	serverpod_cpu	default	2026-05-12 09:32:00	t	0.006875	1
338	serverpod_memory	default	2026-05-12 09:32:00	t	0.2739201763671156	1
339	serverpod_database	default	2026-05-12 09:35:00	t	0.002422	1
340	serverpod_cpu	default	2026-05-12 09:35:00	t	0.006375	1
341	serverpod_memory	default	2026-05-12 09:35:00	t	0.2615708726412057	1
342	serverpod_database	default	2026-05-12 09:37:00	t	0.00216	1
343	serverpod_cpu	default	2026-05-12 09:37:00	t	0.005875	1
344	serverpod_memory	default	2026-05-12 09:37:00	t	0.2657575312724547	1
345	serverpod_database	default	2026-05-12 09:39:00	t	0.002136	1
346	serverpod_cpu	default	2026-05-12 09:39:00	t	0.0135	1
347	serverpod_memory	default	2026-05-12 09:39:00	t	0.2525397843314507	1
348	serverpod_database	default	2026-05-12 09:40:00	t	0.002358	1
349	serverpod_cpu	default	2026-05-12 09:40:00	t	0.01175	1
350	serverpod_memory	default	2026-05-12 09:40:00	t	0.2820024672852908	1
351	serverpod_database	default	2026-05-12 09:43:00	t	0.001913	1
352	serverpod_cpu	default	2026-05-12 09:43:00	t	0.0065	1
353	serverpod_memory	default	2026-05-12 09:43:00	t	0.2770246290701837	1
354	serverpod_database	default	2026-05-12 09:46:00	t	0.002039	1
355	serverpod_cpu	default	2026-05-12 09:46:00	t	0.006625	1
356	serverpod_memory	default	2026-05-12 09:46:00	t	0.2672121479031938	1
357	serverpod_database	default	2026-05-12 09:48:00	t	0.001996	1
358	serverpod_cpu	default	2026-05-12 09:48:00	t	0.007125	1
359	serverpod_memory	default	2026-05-12 09:48:00	t	0.2735771258444271	1
360	serverpod_database	default	2026-05-12 09:53:00	t	0.002678	1
361	serverpod_cpu	default	2026-05-12 09:53:00	t	0.007125	1
362	serverpod_memory	default	2026-05-12 09:53:00	t	0.2792477612862849	1
363	serverpod_database	default	2026-05-12 09:58:00	t	0.002004	1
364	serverpod_cpu	default	2026-05-12 09:58:00	t	0.006125	1
365	serverpod_memory	default	2026-05-12 09:58:00	t	0.27023933697502583	1
366	serverpod_database	default	2026-05-12 10:03:00	t	0.003292	1
367	serverpod_cpu	default	2026-05-12 10:03:00	t	0	1
368	serverpod_memory	default	2026-05-12 10:03:00	t	0.3073068216060018	1
370	serverpod_database	default	2026-05-12 10:05:00	t	0.002182	1
371	serverpod_cpu	default	2026-05-12 10:05:00	t	0.017125	1
372	serverpod_memory	default	2026-05-12 10:05:00	t	0.3909385213286254	1
374	serverpod_database	default	2026-05-12 10:08:00	t	0.007062	1
375	serverpod_cpu	default	2026-05-12 10:08:00	t	0.015	1
376	serverpod_memory	default	2026-05-12 10:08:00	t	0.3825193609782606	1
377	serverpod_database	default	2026-05-12 10:13:00	t	0.002531	1
378	serverpod_cpu	default	2026-05-12 10:13:00	t	0.00975	1
379	serverpod_memory	default	2026-05-12 10:13:00	t	0.2775598084892127	1
380	serverpod_database	default	2026-05-12 10:18:00	t	0.002496	1
381	serverpod_cpu	default	2026-05-12 10:18:00	t	0	1
382	serverpod_memory	default	2026-05-12 10:18:00	t	0.30809954646248466	1
383	serverpod_database	default	2026-05-12 10:20:00	t	0.003022	1
384	serverpod_cpu	default	2026-05-12 10:20:00	t	0.06525	1
385	serverpod_memory	default	2026-05-12 10:20:00	t	0.45128965877804994	1
386	serverpod_database	default	2026-05-12 10:21:00	t	0.002189	1
387	serverpod_cpu	default	2026-05-12 10:21:00	t	0.0115	1
388	serverpod_memory	default	2026-05-12 10:21:00	t	0.45068442700003347	1
389	serverpod_database	default	2026-05-12 10:23:00	t	0.006433	1
390	serverpod_cpu	default	2026-05-12 10:23:00	t	0.00725	1
391	serverpod_memory	default	2026-05-12 10:23:00	t	0.353427028363479	1
392	serverpod_database	default	2026-05-12 10:26:00	t	0.002629	1
393	serverpod_cpu	default	2026-05-12 10:26:00	t	0.009	1
394	serverpod_memory	default	2026-05-12 10:26:00	t	0.29016356710732694	1
395	serverpod_database	default	2026-05-12 10:28:00	t	0.002448	1
396	serverpod_cpu	default	2026-05-12 10:28:00	t	0.007375	1
397	serverpod_memory	default	2026-05-12 10:28:00	t	0.26316404871729493	1
398	serverpod_database	default	2026-05-12 10:30:00	t	0.002971	1
399	serverpod_cpu	default	2026-05-12 10:30:00	t	0	1
400	serverpod_memory	default	2026-05-12 10:30:00	t	0.3450238358302363	1
401	serverpod_database	default	2026-05-12 10:31:00	t	0.00261	1
402	serverpod_cpu	default	2026-05-12 10:31:00	t	0.019625	1
403	serverpod_memory	default	2026-05-12 10:31:00	t	0.32817984912988274	1
404	serverpod_database	default	2026-05-12 10:33:00	t	0.00233	1
405	serverpod_cpu	default	2026-05-12 10:33:00	t	0	1
406	serverpod_memory	default	2026-05-12 10:33:00	t	0.3999484909125092	1
407	serverpod_database	default	2026-05-12 10:37:00	t	0.002982	1
408	serverpod_cpu	default	2026-05-12 10:37:00	t	0.009875	1
409	serverpod_memory	default	2026-05-12 10:37:00	t	0.38556354804896453	1
411	serverpod_database	default	2026-05-12 10:40:00	t	0.002784	1
412	serverpod_cpu	default	2026-05-12 10:40:00	t	0.013625	1
413	serverpod_memory	default	2026-05-12 10:40:00	t	0.3331360535282437	1
414	serverpod_database	default	2026-05-12 10:42:00	t	0.002809	1
415	serverpod_cpu	default	2026-05-12 10:42:00	t	0	1
416	serverpod_memory	default	2026-05-12 10:42:00	t	0.3954883190266843	1
418	serverpod_database	default	2026-05-12 10:45:00	t	0.074202	1
419	serverpod_cpu	default	2026-05-12 10:45:00	t	0.050375	1
420	serverpod_memory	default	2026-05-12 10:45:00	t	0.4300473110968603	1
422	serverpod_database	default	2026-05-12 10:46:00	t	0.002946	1
423	serverpod_cpu	default	2026-05-12 10:46:00	t	0.01075	1
424	serverpod_memory	default	2026-05-12 10:46:00	t	0.4005774168707714	1
425	serverpod_database	default	2026-05-12 10:52:00	t	0.003033	1
426	serverpod_cpu	default	2026-05-12 10:52:00	t	0.01125	1
427	serverpod_memory	default	2026-05-12 10:52:00	t	0.3214249473963444	1
428	serverpod_database	default	2026-05-12 10:55:00	t	0.00425	1
429	serverpod_cpu	default	2026-05-12 10:55:00	t	0.038125	1
430	serverpod_memory	default	2026-05-12 10:55:00	t	0.358768005645396	1
432	serverpod_database	default	2026-05-12 10:56:00	t	0.002299	1
433	serverpod_cpu	default	2026-05-12 10:56:00	t	0.008125	1
434	serverpod_memory	default	2026-05-12 10:56:00	t	0.32591396437116416	1
435	serverpod_database	default	2026-05-12 11:02:00	t	0.002905	1
436	serverpod_cpu	default	2026-05-12 11:02:00	t	0.011125	1
437	serverpod_memory	default	2026-05-12 11:02:00	t	0.2258771353736083	1
438	serverpod_database	default	2026-05-12 11:07:00	t	0.006163	1
439	serverpod_cpu	default	2026-05-12 11:07:00	t	0.013	1
440	serverpod_memory	default	2026-05-12 11:07:00	t	0.3162101673787798	1
442	serverpod_database	default	2026-05-12 11:12:00	t	0.003057	1
443	serverpod_cpu	default	2026-05-12 11:12:00	t	0.01375	1
444	serverpod_memory	default	2026-05-12 11:12:00	t	0.25727037892660215	1
445	serverpod_database	default	2026-05-12 11:17:00	t	0.00324	1
446	serverpod_cpu	default	2026-05-12 11:17:00	t	0.008125	1
447	serverpod_memory	default	2026-05-12 11:17:00	t	0.24510753809740884	1
448	serverpod_database	default	2026-05-12 11:22:00	t	0.002441	1
449	serverpod_cpu	default	2026-05-12 11:22:00	t	0.008875	1
450	serverpod_memory	default	2026-05-12 11:22:00	t	0.19785619177863453	1
451	serverpod_database	default	2026-05-12 11:27:00	t	0.002585	1
452	serverpod_cpu	default	2026-05-12 11:27:00	t	0.0115	1
453	serverpod_memory	default	2026-05-12 11:27:00	t	0.19772587378728293	1
454	serverpod_database	default	2026-05-12 11:31:00	t	0.00219	1
455	serverpod_cpu	default	2026-05-12 11:31:00	t	0.016125	1
456	serverpod_memory	default	2026-05-12 11:31:00	t	0.3235574236184619	1
457	serverpod_database	default	2026-05-12 11:33:00	t	0.003071	1
458	serverpod_cpu	default	2026-05-12 11:33:00	t	0.012125	1
459	serverpod_memory	default	2026-05-12 11:33:00	t	0.30971281108269527	1
460	serverpod_database	default	2026-05-12 11:35:00	t	0.002291	1
461	serverpod_cpu	default	2026-05-12 11:35:00	t	0.01175	1
462	serverpod_memory	default	2026-05-12 11:35:00	t	0.32766012243710096	1
463	serverpod_database	default	2026-05-12 11:36:00	t	0.003182	1
464	serverpod_cpu	default	2026-05-12 11:36:00	t	0.0085	1
465	serverpod_memory	default	2026-05-12 11:36:00	t	0.3186707564882134	1
466	serverpod_database	default	2026-05-12 11:37:00	t	0.001884	1
467	serverpod_cpu	default	2026-05-12 11:37:00	t	0.007125	1
468	serverpod_memory	default	2026-05-12 11:37:00	t	0.32095312415492905	1
469	serverpod_database	default	2026-05-12 11:41:00	t	0.002247	1
470	serverpod_cpu	default	2026-05-12 11:41:00	t	0.010125	1
471	serverpod_memory	default	2026-05-12 11:41:00	t	0.30962833617921043	1
473	serverpod_database	default	2026-05-12 11:43:00	t	0.001934	1
474	serverpod_cpu	default	2026-05-12 11:43:00	t	0.00775	1
475	serverpod_memory	default	2026-05-12 11:43:00	t	0.3010603145659973	1
476	serverpod_database	default	2026-05-12 11:47:00	t	0.001671	1
477	serverpod_cpu	default	2026-05-12 11:47:00	t	0.0065	1
478	serverpod_memory	default	2026-05-12 11:47:00	t	0.29750155171126064	1
479	serverpod_database	default	2026-05-12 11:49:00	t	0.002602	1
480	serverpod_cpu	default	2026-05-12 11:49:00	t	0.007625	1
481	serverpod_memory	default	2026-05-12 11:49:00	t	0.29572139764758	1
482	serverpod_database	default	2026-05-12 11:52:00	t	0.002117	1
483	serverpod_cpu	default	2026-05-12 11:52:00	t	0.00725	1
484	serverpod_memory	default	2026-05-12 11:52:00	t	0.2723579057435208	1
485	serverpod_database	default	2026-05-12 11:54:00	t	0.002229	1
486	serverpod_cpu	default	2026-05-12 11:54:00	t	0.007125	1
487	serverpod_memory	default	2026-05-12 11:54:00	t	0.24460532449437392	1
489	serverpod_database	default	2026-05-12 11:57:00	t	0.003479	1
490	serverpod_cpu	default	2026-05-12 11:57:00	t	0.005625	1
491	serverpod_memory	default	2026-05-12 11:57:00	t	0.2339717884727813	1
492	serverpod_database	default	2026-05-12 12:02:00	t	0.002534	1
493	serverpod_cpu	default	2026-05-12 12:02:00	t	0.006875	1
494	serverpod_memory	default	2026-05-12 12:02:00	t	0.23566128654247825	1
495	serverpod_database	default	2026-05-12 12:05:00	t	0.002038	1
496	serverpod_cpu	default	2026-05-12 12:05:00	t	0.009	1
497	serverpod_memory	default	2026-05-12 12:05:00	t	0.26132723465737445	1
499	serverpod_database	default	2026-05-12 12:06:00	t	0.001926	1
500	serverpod_cpu	default	2026-05-12 12:06:00	t	0.00775	1
501	serverpod_memory	default	2026-05-12 12:06:00	t	0.26127933120600805	1
502	serverpod_database	default	2026-05-12 12:12:00	t	0.004365	1
503	serverpod_cpu	default	2026-05-12 12:12:00	t	0.007	1
504	serverpod_memory	default	2026-05-12 12:12:00	t	0.260889407413703	1
506	serverpod_database	default	2026-05-12 12:13:00	t	0.002033	1
507	serverpod_cpu	default	2026-05-12 12:13:00	t	0.009875	1
508	serverpod_memory	default	2026-05-12 12:13:00	t	0.2785961713295268	1
509	serverpod_database	default	2026-05-12 12:17:00	t	0.002064	1
510	serverpod_cpu	default	2026-05-12 12:17:00	t	0.0095	1
511	serverpod_memory	default	2026-05-12 12:17:00	t	0.28014247413599946	1
512	serverpod_database	default	2026-05-12 12:19:00	t	0.00211	1
513	serverpod_cpu	default	2026-05-12 12:19:00	t	0.0075	1
514	serverpod_memory	default	2026-05-12 12:19:00	t	0.2861911862800395	1
515	serverpod_database	default	2026-05-12 12:22:00	t	0.00265	1
516	serverpod_cpu	default	2026-05-12 12:22:00	t	0.007125	1
517	serverpod_memory	default	2026-05-12 12:22:00	t	0.21795349244490458	1
518	serverpod_database	default	2026-05-12 12:27:00	t	0.002308	1
519	serverpod_cpu	default	2026-05-12 12:27:00	t	0.005875	1
520	serverpod_memory	default	2026-05-12 12:27:00	t	0.19580406973300266	1
521	serverpod_database	default	2026-05-12 12:32:00	t	0.00297	1
522	serverpod_cpu	default	2026-05-12 12:32:00	t	0.006375	1
523	serverpod_memory	default	2026-05-12 12:32:00	t	0.13203324396506655	1
524	serverpod_database	default	2026-05-12 12:38:00	t	0.001913	1
525	serverpod_cpu	default	2026-05-12 12:38:00	t	0	1
526	serverpod_memory	default	2026-05-12 12:38:00	t	0.2627370383819965	1
527	serverpod_database	default	2026-05-12 12:39:00	t	0.002014	1
528	serverpod_cpu	default	2026-05-12 12:39:00	t	0.012625	1
529	serverpod_memory	default	2026-05-12 12:39:00	t	0.27144774016755907	1
530	serverpod_database	default	2026-05-12 12:40:00	t	0.047195	1
531	serverpod_cpu	default	2026-05-12 12:40:00	t	0.24225	1
532	serverpod_memory	default	2026-05-12 12:40:00	t	0.40627329176549976	1
534	serverpod_database	default	2026-05-12 12:42:00	t	0.001866	1
535	serverpod_cpu	default	2026-05-12 12:42:00	t	0.0115	1
536	serverpod_memory	default	2026-05-12 12:42:00	t	0.3810080843512817	1
538	serverpod_database	default	2026-05-12 12:47:00	t	0.002294	1
539	serverpod_cpu	default	2026-05-12 12:47:00	t	0.006125	1
540	serverpod_memory	default	2026-05-12 12:47:00	t	0.35502793080269185	1
541	serverpod_database	default	2026-05-12 12:52:00	t	0.003288	1
542	serverpod_cpu	default	2026-05-12 12:52:00	t	0.006125	1
543	serverpod_memory	default	2026-05-12 12:52:00	t	0.26076063469497607	1
544	serverpod_database	default	2026-05-12 12:58:00	t	0.00674	1
545	serverpod_cpu	default	2026-05-12 12:58:00	t	0.0065	1
546	serverpod_memory	default	2026-05-12 12:58:00	t	0.21464300339187342	1
547	serverpod_database	default	2026-05-12 13:02:00	t	0.002186	1
548	serverpod_cpu	default	2026-05-12 13:02:00	t	0.007625	1
549	serverpod_memory	default	2026-05-12 13:02:00	t	0.26394492648365486	1
\.


--
-- Data for Name: serverpod_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_log (id, "sessionLogId", "messageId", reference, "serverId", "time", "logLevel", message, error, "stackTrace", "order") FROM stdin;
\.


--
-- Data for Name: serverpod_message_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_message_log (id, "sessionLogId", "serverId", "messageId", endpoint, "messageName", duration, error, "stackTrace", slow, "order") FROM stdin;
\.


--
-- Data for Name: serverpod_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_method (id, endpoint, method) FROM stdin;
\.


--
-- Data for Name: serverpod_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_migrations (id, module, version, "timestamp") FROM stdin;
1	freshpickkat	20260509120035765	2026-05-11 19:43:45.047083
2	serverpod	20260129180959368	2026-05-11 19:43:45.047083
3	serverpod_auth_idp	20260213194423028	2026-05-11 19:43:45.047083
4	serverpod_auth_core	20260129181112269	2026-05-11 19:43:45.047083
\.


--
-- Data for Name: serverpod_query_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_query_log (id, "serverId", "sessionLogId", "messageId", query, duration, "numRows", error, "stackTrace", slow, "order") FROM stdin;
1	default	284	\N	INSERT INTO "bogo_offer_reward" ("bogoOfferId", "rewardProductId", "rewardVariantId", "freeQuantity", "createdAt") VALUES ('3f4ea034-2b85-46d0-b090-720f783f3769', 'b8beb637-e69e-40f5-90cf-32bca177c8db', 'variant_1778575304476', 1, '2026-05-12T08:42:27.097890Z') RETURNING *	0.001854	\N	DatabaseQueryException: { message: invalid input syntax for type uuid: "variant_1778575304476", code: 22P02, position: 204 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:34)\n#3      PostgresDatabaseConnection._mappedResultsQuery (package:serverpod/src/database/adapters/postgres/database_connection.dart:660:24)\n#4      PostgresDatabaseConnection.insert (package:serverpod/src/database/adapters/postgres/database_connection.dart:197:19)\n#5      PostgresDatabaseConnection.insertRow (package:serverpod/src/database/adapters/postgres/database_connection.dart:212:24)\n#6      Database.insertRow (package:serverpod/src/database/database.dart:354:32)\n#7      BogoOfferRewardRowRepository.insertRow (package:freshpickkat_server/src/generated/bogo_offer_reward_row.dart:437:23)\n#8      PostgresOfferService._syncBogoRewards (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:797:35)\n<asynchronous suspension>\n#9      PostgresOfferService.upsertBogoOffer.<anonymous closure> (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:75:7)\n<asynchronous suspension>\n#10     PgConnectionImplementation.runTx.<anonymous closure> (package:postgres/src/v3/connection.dart:591:24)\n<asynchronous suspension>\n#11     Pool.withResource (package:pool/pool.dart:127:14)\n<asynchronous suspension>\n#12     PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:16)\n<asynchronous suspension>\n#13     Database.transaction (package:serverpod/src/database/database.dart:514:12)\n<asynchronous suspension>\n#14     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#15     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#16     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#17     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#18     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#19     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#20     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
2	default	285	\N	INSERT INTO "bogo_offer_reward" ("bogoOfferId", "rewardProductId", "rewardVariantId", "freeQuantity", "createdAt") VALUES ('5225ecd0-cf21-4381-9375-c241708e67f5', 'b8beb637-e69e-40f5-90cf-32bca177c8db', 'variant_1778575304476', 1, '2026-05-12T08:42:33.435206Z') RETURNING *	0.000603	\N	DatabaseQueryException: { message: invalid input syntax for type uuid: "variant_1778575304476", code: 22P02, position: 204 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:34)\n#3      PostgresDatabaseConnection._mappedResultsQuery (package:serverpod/src/database/adapters/postgres/database_connection.dart:660:24)\n#4      PostgresDatabaseConnection.insert (package:serverpod/src/database/adapters/postgres/database_connection.dart:197:19)\n#5      PostgresDatabaseConnection.insertRow (package:serverpod/src/database/adapters/postgres/database_connection.dart:212:24)\n#6      Database.insertRow (package:serverpod/src/database/database.dart:354:32)\n#7      BogoOfferRewardRowRepository.insertRow (package:freshpickkat_server/src/generated/bogo_offer_reward_row.dart:437:23)\n#8      PostgresOfferService._syncBogoRewards (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:797:35)\n<asynchronous suspension>\n#9      PostgresOfferService.upsertBogoOffer.<anonymous closure> (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:75:7)\n<asynchronous suspension>\n#10     PgConnectionImplementation.runTx.<anonymous closure> (package:postgres/src/v3/connection.dart:591:24)\n<asynchronous suspension>\n#11     Pool.withResource (package:pool/pool.dart:127:14)\n<asynchronous suspension>\n#12     PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:16)\n<asynchronous suspension>\n#13     Database.transaction (package:serverpod/src/database/database.dart:514:12)\n<asynchronous suspension>\n#14     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#15     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#16     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#17     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#18     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#19     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#20     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
3	default	362	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.006852	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
4	default	363	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.003303	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
41	default	498	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000469	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
5	default	364	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002618	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
6	default	365	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.00224	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
7	default	367	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.003082	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
8	default	368	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002981	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
9	default	369	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001839	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
10	default	370	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002068	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
11	default	371	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002057	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
12	default	372	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002488	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
13	default	373	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002728	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
14	default	374	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002028	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
15	default	375	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001608	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
16	default	376	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001616	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
17	default	377	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.005197	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
18	default	395	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.00324	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
19	default	396	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002235	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
20	default	397	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001627	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
21	default	398	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001793	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
22	default	408	\N	DELETE FROM "product_variant" WHERE "product_variant"."productId" = '87b3fc3f-e12c-44f5-92a0-17da34844c84' RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.003709	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
23	default	409	\N	DELETE FROM "product_variant" WHERE "product_variant"."productId" = '87b3fc3f-e12c-44f5-92a0-17da34844c84' RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.001514	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
24	default	412	\N	DELETE FROM "product_variant" WHERE "product_variant"."productId" = '87b3fc3f-e12c-44f5-92a0-17da34844c84' RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.001765	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
25	default	415	\N	DELETE FROM "product_variant" WHERE "product_variant"."productId" = '87b3fc3f-e12c-44f5-92a0-17da34844c84' RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.001456	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
26	default	416	\N	DELETE FROM "product_variant" WHERE "product_variant"."productId" = '6ae1fa39-b840-4bff-8c69-97f85dabcb8c' RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.003725	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "combo_offer_item_fk_2" on table "combo_offer_item", code: 23503, detail: Key (id)=(957488fe-7e21-4848-bce2-d00923802b25) is still referenced from table "combo_offer_item"., table: combo_offer_item, constraint: combo_offer_item_fk_2 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
27	default	419	\N	DELETE FROM "product_variant" WHERE "product_variant"."productId" = '6ae1fa39-b840-4bff-8c69-97f85dabcb8c' RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.001782	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "combo_offer_item_fk_2" on table "combo_offer_item", code: 23503, detail: Key (id)=(957488fe-7e21-4848-bce2-d00923802b25) is still referenced from table "combo_offer_item"., table: combo_offer_item, constraint: combo_offer_item_fk_2 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
28	default	427	\N	DELETE FROM "product_variant" WHERE "product_variant"."id" IN ('f04be243-aa9d-4c2a-9505-886a52803a53') RETURNING "product_variant"."id" AS "product_variant.id", "product_variant"."productId" AS "product_variant.productId", "product_variant"."label" AS "product_variant.label", "product_variant"."sku" AS "product_variant.sku", "product_variant"."quantityValue" AS "product_variant.quantityValue", "product_variant"."quantityUnit" AS "product_variant.quantityUnit", "product_variant"."quantityDescription" AS "product_variant.quantityDescription", "product_variant"."salePrice" AS "product_variant.salePrice", "product_variant"."listPrice" AS "product_variant.listPrice", "product_variant"."isAvailable" AS "product_variant.isAvailable", "product_variant"."isDefault" AS "product_variant.isDefault", "product_variant"."sortOrder" AS "product_variant.sortOrder", "product_variant"."createdAt" AS "product_variant.createdAt", "product_variant"."updatedAt" AS "product_variant.updatedAt"	0.006039	\N	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_reward_fk_2" on table "bogo_offer_reward", code: 23503, detail: Key (id)=(f04be243-aa9d-4c2a-9505-886a52803a53) is still referenced from table "bogo_offer_reward"., table: bogo_offer_reward, constraint: bogo_offer_reward_fk_2 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 442:18               PostgresDatabaseConnection.deleteRow\npackage:serverpod/src/database/database.dart 384:12                                            Database.deleteRow\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 733:11  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 429:12               PostgresDatabaseConnection.delete\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 442:24               PostgresDatabaseConnection.deleteRow\npackage:serverpod/src/database/database.dart 384:38                                            Database.deleteRow\npackage:freshpickkat_server/src/generated/product_variant_row.dart 729:23                      ProductVariantRowRepository.deleteRow\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 733:38  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	f	1
29	default	427	\N	UPDATE "product_variant" AS t SET "id" = data."id", "productId" = data."productId", "label" = data."label", "sku" = data."sku", "quantityValue" = data."quantityValue", "quantityUnit" = data."quantityUnit", "quantityDescription" = data."quantityDescription", "salePrice" = data."salePrice", "listPrice" = data."listPrice", "isAvailable" = data."isAvailable", "isDefault" = data."isDefault", "sortOrder" = data."sortOrder", "createdAt" = data."createdAt", "updatedAt" = data."updatedAt" FROM (VALUES ('f04be243-aa9d-4c2a-9505-886a52803a53'::uuid, '6ae1fa39-b840-4bff-8c69-97f85dabcb8c'::uuid, '6.0 pc'::text, 'variant_1778574002054'::text, 6.0::double precision, 'pc'::text, NULL::text, 8.0::double precision, 15.0::double precision, FALSE::boolean, FALSE::boolean, 1::bigint, '2026-05-12T08:20:28.198718Z'::timestamp without time zone, '2026-05-12T10:03:39.448402Z'::timestamp without time zone)) AS data("id", "productId", "label", "sku", "quantityValue", "quantityUnit", "quantityDescription", "salePrice", "listPrice", "isAvailable", "isDefault", "sortOrder", "createdAt", "updatedAt") WHERE data.id = t.id RETURNING *	0.003584	\N	DatabaseQueryException: { message: current transaction is aborted, commands ignored until end of transaction block, code: 25P02 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:34)\n#3      PostgresDatabaseConnection._mappedResultsQuery (package:serverpod/src/database/adapters/postgres/database_connection.dart:660:24)\n#4      PostgresDatabaseConnection.update (package:serverpod/src/database/adapters/postgres/database_connection.dart:266:19)\n#5      PostgresDatabaseConnection.updateRow (package:serverpod/src/database/adapters/postgres/database_connection.dart:282:25)\n#6      Database.updateRow (package:serverpod/src/database/database.dart:273:32)\n#7      ProductVariantRowRepository.updateRow (package:freshpickkat_server/src/generated/product_variant_row.dart:660:23)\n#8      PostgresProductCompatService._replaceProductVariants (package:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart:740:38)\n<asynchronous suspension>\n#9      PostgresProductCompatService.updateProduct.<anonymous closure> (package:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart:387:7)\n<asynchronous suspension>\n#10     PgConnectionImplementation.runTx.<anonymous closure> (package:postgres/src/v3/connection.dart:591:24)\n<asynchronous suspension>\n#11     Pool.withResource (package:pool/pool.dart:127:14)\n<asynchronous suspension>\n#12     PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:16)\n<asynchronous suspension>\n#13     Database.transaction (package:serverpod/src/database/database.dart:514:12)\n<asynchronous suspension>\n#14     ProductEndpoint.updateProduct (package:freshpickkat_server/src/endpoints/product_endpoint.dart:136:5)\n<asynchronous suspension>\n#15     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#16     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#17     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#18     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#19     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#20     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#21     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	2
30	default	457	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.002717	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
31	default	458	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001596	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
32	default	459	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001572	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
33	default	460	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001607	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
34	default	461	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001731	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
35	default	462	\N	      SELECT COUNT(*) AS "totalCount"\n      FROM product_search_document psd\n      JOIN product p ON p.id = psd."productId"\n      JOIN category c ON c.id = p."categoryId"\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND psd."searchText" ILIKE '%' || @query || '%'\n        AND similarity(psd."searchText", @query) > @threshold::float8\n        AND (@categoryId::uuid IS NULL OR p."categoryId" = @categoryId::uuid)\n        AND (\n          @subCategoryId::uuid IS NULL OR EXISTS (\n            SELECT 1\n            FROM product_sub_category psc\n            JOIN sub_category sc ON sc.id = psc."subCategoryId"\n            WHERE psc."productId" = p.id\n              AND psc."subCategoryId" = @subCategoryId::uuid\n              AND sc.status = 'active'\n          )\n        )\n      	0.001677	\N	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
36	default	492	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND (\n          p."discountType" IS NOT NULL\n          OR EXISTS (\n            SELECT 1\n            FROM category_offer co\n            WHERE co."categoryId" = p."categoryId"\n              AND co.status = 'active'\n              AND NOW() BETWEEN co."startsAt" AND co."endsAt"\n          )\n        )\n        \n        \n      	0.002594	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
37	default	493	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND p."mostPurchaseCount" > 0\n        \n      	0.000752	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
38	default	494	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        \n        \n      	0.000383	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
39	default	495	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        \n        \n      	0.000464	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
40	default	496	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.00041	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
42	default	500	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.001149	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
43	default	502	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000542	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
44	default	503	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND (\n          p."discountType" IS NOT NULL\n          OR EXISTS (\n            SELECT 1\n            FROM category_offer co\n            WHERE co."categoryId" = p."categoryId"\n              AND co.status = 'active'\n              AND NOW() BETWEEN co."startsAt" AND co."endsAt"\n          )\n        )\n        \n        \n      	0.000471	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
45	default	504	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000504	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
46	default	505	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000423	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
47	default	506	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND (\n          p."discountType" IS NOT NULL\n          OR EXISTS (\n            SELECT 1\n            FROM category_offer co\n            WHERE co."categoryId" = p."categoryId"\n              AND co.status = 'active'\n              AND NOW() BETWEEN co."startsAt" AND co."endsAt"\n          )\n        )\n        \n        \n      	0.000408	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
48	default	508	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000396	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
49	default	519	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000539	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
50	default	521	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000384	\N	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
51	default	528	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.003477	\N	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
52	default	529	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND (\n          p."discountType" IS NOT NULL\n          OR EXISTS (\n            SELECT 1\n            FROM category_offer co\n            WHERE co."categoryId" = p."categoryId"\n              AND co.status = 'active'\n              AND NOW() BETWEEN co."startsAt" AND co."endsAt"\n          )\n        )\n        \n        \n      	0.000655	\N	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
53	default	530	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      \n      WHERE p.status = 'active'\n        AND c.status = 'active'\n        AND p."mostPurchaseCount" > 0\n        \n      	0.000494	\N	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
54	default	531	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.000709	\N	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
55	default	545	\N	      SELECT COUNT(DISTINCT p.id) AS "totalCount"\n      FROM product p\n      JOIN category c ON c.id = p."categoryId"\n      \n      JOIN bogo_offer bo ON bo."triggerProductId" = p.id\n      WHERE p.status = 'active'\n        AND c.status = 'active'\n                AND bo.status = 'active'\n        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"\n        \n        \n      	0.00053	\N	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	f	1
\.


--
-- Data for Name: serverpod_readwrite_test; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_readwrite_test (id, number) FROM stdin;
\.


--
-- Data for Name: serverpod_runtime_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_runtime_settings (id, "logSettings", "logSettingsOverrides", "logServiceCalls", "logMalformedCalls") FROM stdin;
1	{"__className__":"serverpod.LogSettings","logLevel":0,"logAllSessions":true,"logAllQueries":false,"logSlowSessions":true,"logStreamingSessionsContinuously":true,"logSlowQueries":true,"logFailedSessions":true,"logFailedQueries":true,"slowSessionDuration":1.0,"slowQueryDuration":1.0}	[]	f	f
\.


--
-- Data for Name: serverpod_session_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_session_log (id, "serverId", "time", module, endpoint, method, duration, "numQueries", slow, error, "stackTrace", "authenticatedUserId", "userId", "isOpen", touched) FROM stdin;
1	default	2026-05-11 19:43:46.531892	\N	InternalSession	\N	0.041154	3	f	\N	\N	\N	\N	f	2026-05-11 19:43:46.573102
2	default	2026-05-11 19:43:46.527004	\N	InternalSession	\N	0.053926	3	f	\N	\N	\N	\N	f	2026-05-11 19:43:46.580934
3	default	2026-05-11 19:43:46.531486	\N	InternalSession	\N	0.057139	3	f	\N	\N	\N	\N	f	2026-05-11 19:43:46.58863
4	default	2026-05-11 19:43:46.531727	\N	InternalSession	\N	0.076092	4	f	\N	\N	\N	\N	f	2026-05-11 19:43:46.607822
5	default	2026-05-11 19:44:20.939483	\N	orderRealtime	watchAdminOrders	4.220875	1	f	Exception: Access denied: ADMIN_SELLER role required.	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:51:7)\n<asynchronous suspension>\n#1      OrderRealtimeEndpoint.watchAdminOrders (package:freshpickkat_server/src/endpoints/order_realtime_endpoint.dart:19:5)\n<asynchronous suspension>\n#2      _StreamController._add (dart:async/stream_controller.dart:661:3)\n<asynchronous suspension>\n	\N	\N	f	2026-05-11 19:44:25.160408
6	default	2026-05-11 19:44:21.018888	\N	orderRealtime	watchDashboardUpdates	4.162	1	f	Exception: Access denied: ADMIN_SELLER role required.	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:51:7)\n<asynchronous suspension>\n#1      OrderRealtimeEndpoint.watchDashboardUpdates (package:freshpickkat_server/src/endpoints/order_realtime_endpoint.dart:32:5)\n<asynchronous suspension>\n#2      _StreamController._add (dart:async/stream_controller.dart:661:3)\n<asynchronous suspension>\n	\N	\N	f	2026-05-11 19:44:25.180911
7	default	2026-05-11 19:44:21.762211	\N	admin	getDashboardStats	3.415036	1	t	Exception: Access denied: ADMIN_SELLER role required.	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:51:7)\n<asynchronous suspension>\n#1      AdminEndpoint.getDashboardStats (package:freshpickkat_server/src/endpoints/admin_endpoint.dart:55:5)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-11 19:44:25.177258
8	default	2026-05-11 19:44:21.765002	\N	admin	getAnalytics	3.41056	1	t	Exception: Access denied: ADMIN_SELLER role required.	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:51:7)\n<asynchronous suspension>\n#1      AdminEndpoint.getAnalytics (package:freshpickkat_server/src/endpoints/admin_endpoint.dart:68:5)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-11 19:44:25.175577
9	default	2026-05-11 19:44:27.983817	\N	admin	getAnalytics	0.501759	1	f	Exception: Access denied: ADMIN_SELLER role required.	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:51:7)\n<asynchronous suspension>\n#1      AdminEndpoint.getAnalytics (package:freshpickkat_server/src/endpoints/admin_endpoint.dart:68:5)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-11 19:44:28.485585
10	default	2026-05-11 19:44:27.981032	\N	admin	getDashboardStats	0.516272	1	f	Exception: Access denied: ADMIN_SELLER role required.	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:51:7)\n<asynchronous suspension>\n#1      AdminEndpoint.getDashboardStats (package:freshpickkat_server/src/endpoints/admin_endpoint.dart:55:5)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-11 19:44:28.497322
11	default	2026-05-11 19:44:28.013421	\N	admin	completeFirebaseSetup	0.553788	3	f	\N	\N	\N	\N	f	2026-05-11 19:44:28.567222
12	default	2026-05-11 19:44:28.61947	\N	admin	firebaseLogin	0.323347	1	f	\N	\N	\N	\N	f	2026-05-11 19:44:28.942836
14	default	2026-05-11 19:44:30.455443	\N	admin	getDashboardStats	0.404295	3	f	\N	\N	\N	\N	f	2026-05-11 19:44:30.859759
13	default	2026-05-11 19:44:30.457751	\N	admin	getAnalytics	0.396437	3	f	\N	\N	\N	\N	f	2026-05-11 19:44:30.854211
15	default	2026-05-11 19:45:25.43562	\N	subCategory	getSubCategories	0.024667	1	f	\N	\N	\N	\N	f	2026-05-11 19:45:25.460305
16	default	2026-05-11 19:45:25.444187	\N	category	getCategories	0.025383	1	f	\N	\N	\N	\N	f	2026-05-11 19:45:25.46959
18	default	2026-05-11 19:45:25.44679	\N	category	getCategories	0.025837	1	f	\N	\N	\N	\N	f	2026-05-11 19:45:25.472632
17	default	2026-05-11 19:45:25.447834	\N	subCategory	getSubCategories	0.015008	1	f	\N	\N	\N	\N	f	2026-05-11 19:45:25.462853
56	default	2026-05-12 05:16:33.055892	\N	category	uploadCategory	0.476594	4	f	\N	\N	\N	\N	f	2026-05-12 05:16:33.532499
19	default	2026-05-11 19:45:25.449225	\N	product	getProductsPage	0.400708	2	f	\N	\N	\N	\N	f	2026-05-11 19:45:25.84995
121	default	2026-05-12 05:40:16.658171	\N	order	getOrdersPage	0.396778	3	f	\N	\N	\N	\N	f	2026-05-12 05:40:17.054975
20	default	2026-05-11 19:48:46.535522	\N	InternalSession	\N	0.0197	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:46.555226
58	default	2026-05-12 05:16:33.910168	\N	category	getCategories	0.047841	2	f	\N	\N	\N	\N	f	2026-05-12 05:16:33.958025
21	default	2026-05-11 19:48:49.061999	\N	category	getCategories	0.003748	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:49.06575
189	default	2026-05-12 07:47:16.130082	\N	product	uploadProduct	0.037735	15	f	\N	\N	\N	\N	f	2026-05-12 07:47:16.167824
23	default	2026-05-11 19:48:49.078994	\N	freeDelivery	getDeliveryConfig	0.025268	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:49.104272
60	default	2026-05-12 05:21:13.595256	\N	InternalSession	\N	0.046168	3	f	\N	\N	\N	\N	f	2026-05-12 05:21:13.641485
24	default	2026-05-11 19:48:49.199987	\N	freeDelivery	getDeliveryConfig	0.004782	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:49.20478
122	default	2026-05-12 05:40:21.235809	\N	categoryOffer	getCategoryOffersPage	0.023811	1	f	\N	\N	\N	\N	f	2026-05-12 05:40:21.259646
25	default	2026-05-11 19:48:49.000871	\N	categoryOffer	getCategoryOffersPage	0.911641	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:49.912529
63	default	2026-05-12 05:21:13.595081	\N	InternalSession	\N	0.093706	4	f	\N	\N	\N	\N	f	2026-05-12 05:21:13.688791
28	default	2026-05-11 19:48:49.087483	\N	product	getProductsPage	1.078221	2	t	\N	\N	\N	\N	f	2026-05-11 19:48:50.165712
30	default	2026-05-11 19:48:49.454299	\N	banner	getBannersPage	0.768374	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:50.222687
66	default	2026-05-12 05:22:27.607481	\N	subCategory	getSubCategories	0.038264	2	f	\N	\N	\N	\N	f	2026-05-12 05:22:27.645778
31	default	2026-05-11 19:48:50.36181	\N	freeDelivery	getDeliveryRulesPage	0.292032	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:50.653852
123	default	2026-05-12 05:40:21.510645	\N	comboOffer	getComboOffersPage	0.023378	1	f	\N	\N	\N	\N	f	2026-05-12 05:40:21.534044
69	default	2026-05-12 05:23:52.972787	\N	subCategory	getSubCategories	0.011715	2	f	\N	\N	\N	\N	f	2026-05-12 05:23:52.984512
71	default	2026-05-12 05:25:03.197921	\N	subCategory	getSubCategories	0.026768	2	f	\N	\N	\N	\N	f	2026-05-12 05:25:03.2247
124	default	2026-05-12 05:40:21.819333	\N	bogo	getOffersPage	0.022587	1	f	\N	\N	\N	\N	f	2026-05-12 05:40:21.841948
75	default	2026-05-12 05:25:23.89808	\N	subCategory	getSubCategories	0.027337	2	f	\N	\N	\N	\N	f	2026-05-12 05:25:23.92544
78	default	2026-05-12 05:25:55.578704	\N	subCategory	getSubCategories	0.038225	2	f	\N	\N	\N	\N	f	2026-05-12 05:25:55.616954
125	default	2026-05-12 05:41:13.594846	\N	InternalSession	\N	0.025838	3	f	\N	\N	\N	\N	f	2026-05-12 05:41:13.620691
82	default	2026-05-12 05:26:21.1901	\N	subCategory	getSubCategories	0.027935	2	f	\N	\N	\N	\N	f	2026-05-12 05:26:21.218054
85	default	2026-05-12 05:27:02.08419	\N	subCategory	getSubCategories	0.034043	2	f	\N	\N	\N	\N	f	2026-05-12 05:27:02.118255
126	default	2026-05-12 05:46:13.594918	\N	InternalSession	\N	0.025132	3	f	\N	\N	\N	\N	f	2026-05-12 05:46:13.620057
104	default	2026-05-12 05:34:06.982161	\N	subCategory	getSubCategories	0.032281	2	f	\N	\N	\N	\N	f	2026-05-12 05:34:07.014459
107	default	2026-05-12 05:34:56.373106	\N	subCategory	getSubCategories	0.01976	2	f	\N	\N	\N	\N	f	2026-05-12 05:34:56.39288
127	default	2026-05-12 05:47:26.271466	\N	product	uploadProduct	0.695715	16	f	\N	\N	\N	\N	f	2026-05-12 05:47:26.967191
110	default	2026-05-12 05:35:23.630633	\N	subCategory	getSubCategories	0.024989	2	f	\N	\N	\N	\N	f	2026-05-12 05:35:23.655635
111	default	2026-05-12 05:36:13.594883	\N	InternalSession	\N	0.028036	3	f	\N	\N	\N	\N	f	2026-05-12 05:36:13.622925
128	default	2026-05-12 05:48:55.807384	\N	product	uploadProduct	0.112499	16	f	\N	\N	\N	\N	f	2026-05-12 05:48:55.919894
112	default	2026-05-12 05:36:46.574315	\N	subCategory	uploadSubCategory	0.052026	4	f	\N	\N	\N	\N	f	2026-05-12 05:36:46.626353
113	default	2026-05-12 05:36:46.840442	\N	category	getCategories	0.021349	2	f	\N	\N	\N	\N	f	2026-05-12 05:36:46.86181
129	default	2026-05-12 05:51:13.595024	\N	InternalSession	\N	0.028835	3	f	\N	\N	\N	\N	f	2026-05-12 05:51:13.623865
115	default	2026-05-12 05:37:10.506887	\N	subCategory	updateSubCategory	0.055244	6	f	\N	\N	\N	\N	f	2026-05-12 05:37:10.562142
116	default	2026-05-12 05:37:10.8164	\N	category	getCategories	0.020994	2	f	\N	\N	\N	\N	f	2026-05-12 05:37:10.837405
130	default	2026-05-12 05:56:07.308926	\N	product	uploadProduct	0.59649	17	f	\N	\N	\N	\N	f	2026-05-12 05:56:07.905425
118	default	2026-05-12 05:37:51.337774	\N	subCategory	uploadSubCategory	0.045969	4	f	\N	\N	\N	\N	f	2026-05-12 05:37:51.383757
119	default	2026-05-12 05:37:51.720513	\N	category	getCategories	0.016825	2	f	\N	\N	\N	\N	f	2026-05-12 05:37:51.737354
131	default	2026-05-12 05:56:13.59494	\N	InternalSession	\N	0.028045	3	f	\N	\N	\N	\N	f	2026-05-12 05:56:13.622991
132	default	2026-05-12 06:01:13.595034	\N	InternalSession	\N	0.013729	3	f	\N	\N	\N	\N	f	2026-05-12 06:01:13.608766
133	default	2026-05-12 06:06:13.597326	\N	InternalSession	\N	0.010194	3	f	\N	\N	\N	\N	f	2026-05-12 06:06:13.607523
134	default	2026-05-12 06:11:13.594816	\N	InternalSession	\N	0.016178	3	f	\N	\N	\N	\N	f	2026-05-12 06:11:13.610997
135	default	2026-05-12 06:16:13.594742	\N	InternalSession	\N	0.013634	3	f	\N	\N	\N	\N	f	2026-05-12 06:16:13.60838
136	default	2026-05-12 06:21:13.59643	\N	InternalSession	\N	0.047658	3	f	\N	\N	\N	\N	f	2026-05-12 06:21:13.644091
137	default	2026-05-12 06:21:13.595359	\N	InternalSession	\N	0.062523	4	f	\N	\N	\N	\N	f	2026-05-12 06:21:13.657884
138	default	2026-05-12 06:21:13.596638	\N	InternalSession	\N	0.076337	3	f	\N	\N	\N	\N	f	2026-05-12 06:21:13.673137
139	default	2026-05-12 06:26:13.594732	\N	InternalSession	\N	0.005782	1	f	\N	\N	\N	\N	f	2026-05-12 06:26:13.600517
140	default	2026-05-12 06:31:13.59481	\N	InternalSession	\N	0.003051	1	f	\N	\N	\N	\N	f	2026-05-12 06:31:13.597863
141	default	2026-05-12 06:36:13.59747	\N	InternalSession	\N	0.003151	1	f	\N	\N	\N	\N	f	2026-05-12 06:36:13.600625
142	default	2026-05-12 06:41:13.594916	\N	InternalSession	\N	0.006503	1	f	\N	\N	\N	\N	f	2026-05-12 06:41:13.601421
143	default	2026-05-12 06:46:13.594751	\N	InternalSession	\N	0.023367	1	f	\N	\N	\N	\N	f	2026-05-12 06:46:13.618121
144	default	2026-05-12 06:51:13.594691	\N	InternalSession	\N	0.002373	1	f	\N	\N	\N	\N	f	2026-05-12 06:51:13.597066
145	default	2026-05-12 06:56:13.594761	\N	InternalSession	\N	0.002549	1	f	\N	\N	\N	\N	f	2026-05-12 06:56:13.597314
146	default	2026-05-12 07:01:13.594731	\N	InternalSession	\N	0.002199	1	f	\N	\N	\N	\N	f	2026-05-12 07:01:13.596932
149	default	2026-05-12 07:02:17.751818	\N	admin	getAnalytics	0.320679	4	f	\N	\N	\N	\N	f	2026-05-12 07:02:18.072507
151	default	2026-05-12 07:02:20.805652	\N	category	getCategories	0.013316	2	f	\N	\N	\N	\N	f	2026-05-12 07:02:20.818975
154	default	2026-05-12 07:02:20.813093	\N	subCategory	getSubCategories	0.049839	2	f	\N	\N	\N	\N	f	2026-05-12 07:02:20.862938
155	default	2026-05-12 07:02:20.566486	\N	admin	completeFirebaseSetup	0.403802	3	f	\N	\N	\N	\N	f	2026-05-12 07:02:20.970295
156	default	2026-05-12 07:02:21.000773	\N	admin	firebaseLogin	0.002788	1	f	\N	\N	\N	\N	f	2026-05-12 07:02:21.003564
157	default	2026-05-12 07:02:21.052082	\N	product	getProductsPage	0.035929	9	f	\N	\N	\N	\N	f	2026-05-12 07:02:21.088018
158	default	2026-05-12 07:02:27.087055	\N	categoryOffer	getCategoryOffersPage	0.005507	1	f	\N	\N	\N	\N	f	2026-05-12 07:02:27.092566
159	default	2026-05-12 07:02:27.362645	\N	comboOffer	getComboOffersPage	0.007862	1	f	\N	\N	\N	\N	f	2026-05-12 07:02:27.370522
160	default	2026-05-12 07:02:27.803771	\N	bogo	getOffersPage	0.005566	1	f	\N	\N	\N	\N	f	2026-05-12 07:02:27.809342
161	default	2026-05-12 07:03:48.947609	\N	product	uploadProduct	0.059111	16	f	\N	\N	\N	\N	f	2026-05-12 07:03:49.006726
162	default	2026-05-12 07:05:38.616727	\N	product	uploadProduct	0.049988	16	f	\N	\N	\N	\N	f	2026-05-12 07:05:38.666719
22	default	2026-05-11 19:48:49.063301	\N	subCategory	getSubCategories	0.025105	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:49.088409
190	default	2026-05-12 07:48:23.366016	\N	product	uploadProduct	0.061665	16	f	\N	\N	\N	\N	f	2026-05-12 07:48:23.427685
26	default	2026-05-11 19:48:49.005259	\N	coupon	fetchCoupons	1.108825	1	t	\N	\N	\N	\N	f	2026-05-11 19:48:50.114102
57	default	2026-05-12 05:16:33.913714	\N	subCategory	getSubCategories	0.04524	2	f	\N	\N	\N	\N	f	2026-05-12 05:16:33.958958
29	default	2026-05-11 19:48:49.341484	\N	bogo	getOffersPage	0.832257	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:50.173759
32	default	2026-05-11 19:48:50.372629	\N	freeDelivery	getDeliveryRulesPage	0.285064	1	f	\N	\N	\N	\N	f	2026-05-11 19:48:50.657697
61	default	2026-05-12 05:21:13.589844	\N	InternalSession	\N	0.066594	3	f	\N	\N	\N	\N	f	2026-05-12 05:21:13.656443
150	default	2026-05-12 07:02:17.74892	\N	admin	getDashboardStats	0.325648	3	f	\N	\N	\N	\N	f	2026-05-12 07:02:18.074583
64	default	2026-05-12 05:22:26.17919	\N	subCategory	uploadSubCategory	1.020074	5	t	\N	\N	\N	\N	f	2026-05-12 05:22:27.199341
191	default	2026-05-12 07:48:33.202661	\N	categoryOffer	getCategoryOffersPage	0.003309	1	f	\N	\N	\N	\N	f	2026-05-12 07:48:33.205973
65	default	2026-05-12 05:22:27.588526	\N	category	getCategories	0.035932	2	f	\N	\N	\N	\N	f	2026-05-12 05:22:27.62448
152	default	2026-05-12 07:02:20.808615	\N	subCategory	getSubCategories	0.011708	2	f	\N	\N	\N	\N	f	2026-05-12 07:02:20.820327
67	default	2026-05-12 05:23:52.612852	\N	subCategory	uploadSubCategory	0.046424	4	f	\N	\N	\N	\N	f	2026-05-12 05:23:52.659294
68	default	2026-05-12 05:23:52.966919	\N	category	getCategories	0.011895	2	f	\N	\N	\N	\N	f	2026-05-12 05:23:52.978824
192	default	2026-05-12 07:48:33.26905	\N	comboOffer	getComboOffersPage	0.002483	1	f	\N	\N	\N	\N	f	2026-05-12 07:48:33.271535
70	default	2026-05-12 05:25:02.844676	\N	subCategory	uploadSubCategory	0.040642	4	f	\N	\N	\N	\N	f	2026-05-12 05:25:02.885327
72	default	2026-05-12 05:25:03.192363	\N	category	getCategories	0.030401	2	f	\N	\N	\N	\N	f	2026-05-12 05:25:03.222779
163	default	2026-05-12 07:06:13.594747	\N	InternalSession	\N	0.002297	1	f	\N	\N	\N	\N	f	2026-05-12 07:06:13.597046
73	default	2026-05-12 05:25:23.58575	\N	subCategory	uploadSubCategory	0.05359	4	f	\N	\N	\N	\N	f	2026-05-12 05:25:23.639357
193	default	2026-05-12 07:48:33.386279	\N	bogo	getOffersPage	0.005071	1	f	\N	\N	\N	\N	f	2026-05-12 07:48:33.391354
74	default	2026-05-12 05:25:23.894773	\N	category	getCategories	0.024141	2	f	\N	\N	\N	\N	f	2026-05-12 05:25:23.918926
164	default	2026-05-12 07:06:43.354006	\N	product	uploadProduct	0.038091	15	f	\N	\N	\N	\N	f	2026-05-12 07:06:43.392101
76	default	2026-05-12 05:25:55.171285	\N	subCategory	uploadSubCategory	0.049626	4	f	\N	\N	\N	\N	f	2026-05-12 05:25:55.220928
77	default	2026-05-12 05:25:55.573907	\N	category	getCategories	0.030231	2	f	\N	\N	\N	\N	f	2026-05-12 05:25:55.604157
194	default	2026-05-12 07:49:24.735902	\N	product	uploadProduct	0.0417	15	f	\N	\N	\N	\N	f	2026-05-12 07:49:24.777607
79	default	2026-05-12 05:26:13.595208	\N	InternalSession	\N	0.010247	1	f	\N	\N	\N	\N	f	2026-05-12 05:26:13.605464
165	default	2026-05-12 07:07:27.696388	\N	product	uploadProduct	0.320878	16	f	\N	\N	\N	\N	f	2026-05-12 07:07:28.017276
80	default	2026-05-12 05:26:20.871228	\N	subCategory	uploadSubCategory	0.053372	4	f	\N	\N	\N	\N	f	2026-05-12 05:26:20.924616
81	default	2026-05-12 05:26:21.186392	\N	category	getCategories	0.02543	2	f	\N	\N	\N	\N	f	2026-05-12 05:26:21.211838
195	default	2026-05-12 07:51:13.594775	\N	InternalSession	\N	0.003081	1	f	\N	\N	\N	\N	f	2026-05-12 07:51:13.597859
83	default	2026-05-12 05:27:01.81138	\N	subCategory	uploadSubCategory	0.065333	4	f	\N	\N	\N	\N	f	2026-05-12 05:27:01.876733
172	default	2026-05-12 07:08:35.966713	\N	categoryOffer	getCategoryOffersPage	0.002572	1	f	\N	\N	\N	\N	f	2026-05-12 07:08:35.969287
84	default	2026-05-12 05:27:02.076539	\N	category	getCategories	0.033199	2	f	\N	\N	\N	\N	f	2026-05-12 05:27:02.109757
86	default	2026-05-12 05:27:46.456632	\N	subCategory	uploadSubCategory	0.892021	5	f	\N	\N	\N	\N	f	2026-05-12 05:27:47.348673
196	default	2026-05-12 07:51:59.67238	\N	product	uploadProduct	0.366352	18	f	\N	\N	\N	\N	f	2026-05-12 07:52:00.038736
87	default	2026-05-12 05:27:47.650932	\N	category	getCategories	0.024989	2	f	\N	\N	\N	\N	f	2026-05-12 05:27:47.675939
89	default	2026-05-12 05:28:09.822239	\N	subCategory	uploadSubCategory	0.033643	4	f	\N	\N	\N	\N	f	2026-05-12 05:28:09.855891
148	default	2026-05-12 07:02:17.896054	\N	orderRealtime	watchDashboardUpdates	615.114323	0	f	\N	\N	\N	\N	f	2026-05-12 07:12:33.010381
90	default	2026-05-12 05:28:10.08277	\N	category	getCategories	0.01056	2	f	\N	\N	\N	\N	f	2026-05-12 05:28:10.09334
197	default	2026-05-12 07:55:27.641681	\N	product	uploadProduct	0.0419	17	f	\N	\N	\N	\N	f	2026-05-12 07:55:27.683585
92	default	2026-05-12 05:29:15.150921	\N	category	uploadCategory	0.041007	3	f	\N	\N	\N	\N	f	2026-05-12 05:29:15.191944
177	default	2026-05-12 07:16:13.594849	\N	InternalSession	\N	0.010687	3	f	\N	\N	\N	\N	f	2026-05-12 07:16:13.605539
93	default	2026-05-12 05:29:15.505187	\N	category	getCategories	0.014379	2	f	\N	\N	\N	\N	f	2026-05-12 05:29:15.519584
95	default	2026-05-12 05:31:13.594743	\N	InternalSession	\N	0.004075	1	f	\N	\N	\N	\N	f	2026-05-12 05:31:13.598824
179	default	2026-05-12 07:21:13.594733	\N	InternalSession	\N	0.029789	4	f	\N	\N	\N	\N	f	2026-05-12 07:21:13.624523
96	default	2026-05-12 05:32:57.335027	\N	subCategory	uploadSubCategory	0.424491	5	f	\N	\N	\N	\N	f	2026-05-12 05:32:57.759537
198	default	2026-05-12 07:55:30.147129	\N	comboOffer	getComboOffersPage	0.002128	1	f	\N	\N	\N	\N	f	2026-05-12 07:55:30.14926
97	default	2026-05-12 05:32:58.020999	\N	category	getCategories	0.010998	2	f	\N	\N	\N	\N	f	2026-05-12 05:32:58.032003
180	default	2026-05-12 07:21:13.595077	\N	InternalSession	\N	0.036518	3	f	\N	\N	\N	\N	f	2026-05-12 07:21:13.631597
114	default	2026-05-12 05:36:46.851357	\N	subCategory	getSubCategories	0.053983	2	f	\N	\N	\N	\N	f	2026-05-12 05:36:46.905358
117	default	2026-05-12 05:37:10.821753	\N	subCategory	getSubCategories	0.026004	2	f	\N	\N	\N	\N	f	2026-05-12 05:37:10.847779
181	default	2026-05-12 07:26:13.594814	\N	InternalSession	\N	0.005544	1	f	\N	\N	\N	\N	f	2026-05-12 07:26:13.600361
120	default	2026-05-12 05:37:51.732178	\N	subCategory	getSubCategories	0.021153	2	f	\N	\N	\N	\N	f	2026-05-12 05:37:51.753349
182	default	2026-05-12 07:31:13.59482	\N	InternalSession	\N	0.003372	1	f	\N	\N	\N	\N	f	2026-05-12 07:31:13.598194
205	default	2026-05-12 08:00:21.320473	\N	product	uploadProduct	0.046836	16	f	\N	\N	\N	\N	f	2026-05-12 08:00:21.367312
183	default	2026-05-12 07:36:13.59488	\N	InternalSession	\N	0.003	1	f	\N	\N	\N	\N	f	2026-05-12 07:36:13.597882
184	default	2026-05-12 07:41:13.594818	\N	InternalSession	\N	0.005525	1	f	\N	\N	\N	\N	f	2026-05-12 07:41:13.600345
185	default	2026-05-12 07:45:42.842438	\N	product	uploadProduct	0.269539	1	f	Endpoint dispatch error: Product image URL is required	#0      ValidationService.validateProduct (package:freshpickkat_server/src/services/business/validation_service.dart:25:7)\n#1      ProductEndpoint.uploadProduct (package:freshpickkat_server/src/endpoints/product_endpoint.dart:100:23)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 07:45:43.111992
199	default	2026-05-12 07:55:30.169911	\N	categoryOffer	getCategoryOffersPage	0.002698	1	f	\N	\N	\N	\N	f	2026-05-12 07:55:30.172612
27	default	2026-05-11 19:48:49.067222	\N	comboOffer	getComboOffersPage	1.083335	1	t	\N	\N	\N	\N	f	2026-05-11 19:48:50.150572
153	default	2026-05-12 07:02:20.812241	\N	category	getCategories	0.037897	2	f	\N	\N	\N	\N	f	2026-05-12 07:02:20.850143
33	default	2026-05-11 19:53:46.531237	\N	InternalSession	\N	0.006747	1	f	\N	\N	\N	\N	f	2026-05-11 19:53:46.537989
298	default	2026-05-12 08:43:38.848002	\N	bogo	upsertOffer	0.012266	4	f	\N	\N	\N	\N	f	2026-05-12 08:43:38.860278
34	default	2026-05-11 19:58:46.531366	\N	InternalSession	\N	0.00531	1	f	\N	\N	\N	\N	f	2026-05-11 19:58:46.536679
166	default	2026-05-12 07:08:14.669257	\N	product	uploadProduct	0.042095	15	f	\N	\N	\N	\N	f	2026-05-12 07:08:14.711359
35	default	2026-05-11 20:03:46.531255	\N	InternalSession	\N	0.003215	1	f	\N	\N	\N	\N	f	2026-05-11 20:03:46.534473
200	default	2026-05-12 07:55:30.296333	\N	bogo	getOffersPage	0.002363	1	f	\N	\N	\N	\N	f	2026-05-12 07:55:30.298699
36	default	2026-05-11 20:08:46.531302	\N	InternalSession	\N	0.00305	1	f	\N	\N	\N	\N	f	2026-05-11 20:08:46.534357
59	default	2026-05-12 05:20:01.201963	\N	InternalSession	\N	0.028377	3	f	\N	\N	\N	\N	f	2026-05-12 05:20:01.230344
37	default	2026-05-11 20:13:46.531281	\N	InternalSession	\N	0.004365	1	f	\N	\N	\N	\N	f	2026-05-11 20:13:46.53565
43	default	2026-05-12 05:11:28.375121	\N	orderRealtime	watchAdminOrders	564.901367	1	f	\N	\N	\N	\N	f	2026-05-12 05:20:53.276513
38	default	2026-05-11 20:18:46.531555	\N	InternalSession	\N	0.003141	1	f	\N	\N	\N	\N	f	2026-05-11 20:18:46.534699
44	default	2026-05-12 05:11:28.482599	\N	orderRealtime	watchDashboardUpdates	564.794541	1	f	\N	\N	\N	\N	f	2026-05-12 05:20:53.277147
167	default	2026-05-12 07:08:21.729545	\N	categoryOffer	getCategoryOffersPage	0.006656	1	f	\N	\N	\N	\N	f	2026-05-12 07:08:21.736204
62	default	2026-05-12 05:21:13.594787	\N	InternalSession	\N	0.069218	3	f	\N	\N	\N	\N	f	2026-05-12 05:21:13.664011
39	default	2026-05-12 05:10:01.202145	\N	InternalSession	\N	0.050017	3	f	\N	\N	\N	\N	f	2026-05-12 05:10:01.252225
40	default	2026-05-12 05:10:01.195974	\N	InternalSession	\N	0.069661	3	f	\N	\N	\N	\N	f	2026-05-12 05:10:01.265639
41	default	2026-05-12 05:10:01.201491	\N	InternalSession	\N	0.074024	3	f	\N	\N	\N	\N	f	2026-05-12 05:10:01.275519
42	default	2026-05-12 05:10:01.201857	\N	InternalSession	\N	0.099016	4	f	\N	\N	\N	\N	f	2026-05-12 05:10:01.300878
88	default	2026-05-12 05:27:47.654413	\N	subCategory	getSubCategories	0.027209	2	f	\N	\N	\N	\N	f	2026-05-12 05:27:47.681637
168	default	2026-05-12 07:08:21.741634	\N	comboOffer	getComboOffersPage	0.00654	1	f	\N	\N	\N	\N	f	2026-05-12 07:08:21.748177
91	default	2026-05-12 05:28:10.086374	\N	subCategory	getSubCategories	0.014604	2	f	\N	\N	\N	\N	f	2026-05-12 05:28:10.100997
201	default	2026-05-12 07:56:13.594695	\N	InternalSession	\N	0.002	1	f	\N	\N	\N	\N	f	2026-05-12 07:56:13.596698
45	default	2026-05-12 05:11:28.721572	\N	admin	getAnalytics	0.617144	3	f	\N	\N	\N	\N	f	2026-05-12 05:11:29.338737
46	default	2026-05-12 05:11:28.717027	\N	admin	getDashboardStats	0.62485	3	f	\N	\N	\N	\N	f	2026-05-12 05:11:29.341888
94	default	2026-05-12 05:29:15.509424	\N	subCategory	getSubCategories	0.013914	2	f	\N	\N	\N	\N	f	2026-05-12 05:29:15.523344
47	default	2026-05-12 05:11:30.683129	\N	admin	completeFirebaseSetup	0.313827	3	f	\N	\N	\N	\N	f	2026-05-12 05:11:30.996977
169	default	2026-05-12 07:08:21.779153	\N	bogo	getOffersPage	0.003504	1	f	\N	\N	\N	\N	f	2026-05-12 07:08:21.78266
48	default	2026-05-12 05:11:31.031308	\N	admin	firebaseLogin	0.308457	1	f	\N	\N	\N	\N	f	2026-05-12 05:11:31.339771
98	default	2026-05-12 05:32:58.027305	\N	subCategory	getSubCategories	0.014104	2	f	\N	\N	\N	\N	f	2026-05-12 05:32:58.041417
99	default	2026-05-12 05:33:30.348886	\N	subCategory	uploadSubCategory	0.079982	4	f	\N	\N	\N	\N	f	2026-05-12 05:33:30.428884
170	default	2026-05-12 07:08:27.487738	\N	product	updateProduct	0.049697	15	f	\N	\N	\N	\N	f	2026-05-12 07:08:27.537439
50	default	2026-05-12 05:13:22.865557	\N	subCategory	getSubCategories	0.025822	1	f	\N	\N	\N	\N	f	2026-05-12 05:13:22.891396
49	default	2026-05-12 05:13:22.851312	\N	category	getCategories	0.035523	1	f	\N	\N	\N	\N	f	2026-05-12 05:13:22.886866
100	default	2026-05-12 05:33:30.774421	\N	category	getCategories	0.021195	2	f	\N	\N	\N	\N	f	2026-05-12 05:33:30.795626
202	default	2026-05-12 07:56:23.960798	\N	product	uploadProduct	0.035364	15	f	\N	\N	\N	\N	f	2026-05-12 07:56:23.996166
51	default	2026-05-12 05:13:23.161529	\N	subCategory	getSubCategories	0.011997	1	f	\N	\N	\N	\N	f	2026-05-12 05:13:23.173537
52	default	2026-05-12 05:13:23.159796	\N	category	getCategories	0.011947	1	f	\N	\N	\N	\N	f	2026-05-12 05:13:23.171755
101	default	2026-05-12 05:33:30.800911	\N	subCategory	getSubCategories	0.046807	2	f	\N	\N	\N	\N	f	2026-05-12 05:33:30.847734
53	default	2026-05-12 05:13:23.210901	\N	product	getProductsPage	13.865859	0	t	Exception: Invalid or expired Firebase token. HandshakeException: Connection terminated during handshake	#0      PostgresAdminGuardService.ensureAdminSeller (package:freshpickkat_server/src/services/postgres/postgres_admin_guard_service.dart:23:7)\n<asynchronous suspension>\n#1      ProductEndpoint.getProductsPage (package:freshpickkat_server/src/endpoints/product_endpoint.dart:54:5)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 05:13:37.076799
171	default	2026-05-12 07:08:35.963343	\N	comboOffer	getComboOffersPage	0.005595	1	f	\N	\N	\N	\N	f	2026-05-12 07:08:35.96894
102	default	2026-05-12 05:34:06.509911	\N	subCategory	uploadSubCategory	0.048239	4	f	\N	\N	\N	\N	f	2026-05-12 05:34:06.558175
54	default	2026-05-12 05:14:09.454218	\N	product	getProductsPage	0.229616	2	f	\N	\N	\N	\N	f	2026-05-12 05:14:09.68385
173	default	2026-05-12 07:08:36.022209	\N	bogo	getOffersPage	0.003561	1	f	\N	\N	\N	\N	f	2026-05-12 07:08:36.025772
206	default	2026-05-12 08:00:47.430053	\N	categoryOffer	getCategoryOffersPage	0.004773	1	f	\N	\N	\N	\N	f	2026-05-12 08:00:47.434829
103	default	2026-05-12 05:34:06.978078	\N	category	getCategories	0.028388	2	f	\N	\N	\N	\N	f	2026-05-12 05:34:07.006481
55	default	2026-05-12 05:15:01.202235	\N	InternalSession	\N	0.007235	1	f	\N	\N	\N	\N	f	2026-05-12 05:15:01.209475
174	default	2026-05-12 07:08:42.321786	\N	product	updateProduct	0.036688	15	f	\N	\N	\N	\N	f	2026-05-12 07:08:42.358479
105	default	2026-05-12 05:34:56.024961	\N	subCategory	uploadSubCategory	0.043903	4	f	\N	\N	\N	\N	f	2026-05-12 05:34:56.068876
106	default	2026-05-12 05:34:56.36722	\N	category	getCategories	0.028081	2	f	\N	\N	\N	\N	f	2026-05-12 05:34:56.395312
108	default	2026-05-12 05:35:23.206811	\N	subCategory	uploadSubCategory	0.048302	4	f	\N	\N	\N	\N	f	2026-05-12 05:35:23.255141
175	default	2026-05-12 07:10:27.745132	\N	product	uploadProduct	0.035564	16	f	\N	\N	\N	\N	f	2026-05-12 07:10:27.780701
109	default	2026-05-12 05:35:23.621262	\N	category	getCategories	0.021303	2	f	\N	\N	\N	\N	f	2026-05-12 05:35:23.642592
176	default	2026-05-12 07:11:13.594769	\N	InternalSession	\N	0.009106	3	f	\N	\N	\N	\N	f	2026-05-12 07:11:13.603877
147	default	2026-05-12 07:02:17.889287	\N	orderRealtime	watchAdminOrders	615.120831	0	f	\N	\N	\N	\N	f	2026-05-12 07:12:33.010128
178	default	2026-05-12 07:21:13.595007	\N	InternalSession	\N	0.01214	3	f	\N	\N	\N	\N	f	2026-05-12 07:21:13.60715
186	default	2026-05-12 07:45:51.150673	\N	product	uploadProduct	0.000506	0	f	Endpoint dispatch error: Product image URL is required	#0      ValidationService.validateProduct (package:freshpickkat_server/src/services/business/validation_service.dart:25:7)\n#1      ProductEndpoint.uploadProduct (package:freshpickkat_server/src/endpoints/product_endpoint.dart:100:23)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 07:45:51.151189
187	default	2026-05-12 07:46:04.221048	\N	product	uploadProduct	0.00066	0	f	Endpoint dispatch error: Product image URL is required	#0      ValidationService.validateProduct (package:freshpickkat_server/src/services/business/validation_service.dart:25:7)\n#1      ProductEndpoint.uploadProduct (package:freshpickkat_server/src/endpoints/product_endpoint.dart:100:23)\n<asynchronous suspension>\n#2      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#3      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#4      Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#5      Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#6      _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#7      _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#8      _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 07:46:04.221716
203	default	2026-05-12 07:57:58.372662	\N	product	uploadProduct	0.300246	16	f	\N	\N	\N	\N	f	2026-05-12 07:57:58.672911
188	default	2026-05-12 07:46:13.594728	\N	InternalSession	\N	0.003543	1	f	\N	\N	\N	\N	f	2026-05-12 07:46:13.598274
204	default	2026-05-12 07:58:52.747615	\N	product	uploadProduct	0.04446	15	f	\N	\N	\N	\N	f	2026-05-12 07:58:52.792082
207	default	2026-05-12 08:00:47.431602	\N	comboOffer	getComboOffersPage	0.024592	1	f	\N	\N	\N	\N	f	2026-05-12 08:00:47.456197
208	default	2026-05-12 08:00:47.479471	\N	bogo	getOffersPage	0.003888	1	f	\N	\N	\N	\N	f	2026-05-12 08:00:47.483362
209	default	2026-05-12 08:00:57.494287	\N	product	updateProduct	0.038868	15	f	\N	\N	\N	\N	f	2026-05-12 08:00:57.533158
210	default	2026-05-12 08:01:13.594749	\N	InternalSession	\N	0.007873	3	f	\N	\N	\N	\N	f	2026-05-12 08:01:13.602626
211	default	2026-05-12 08:06:13.594722	\N	InternalSession	\N	0.005123	3	f	\N	\N	\N	\N	f	2026-05-12 08:06:13.599847
212	default	2026-05-12 08:06:54.046743	\N	product	uploadProduct	0.428549	16	f	\N	\N	\N	\N	f	2026-05-12 08:06:54.475297
213	default	2026-05-12 08:08:03.878806	\N	product	uploadProduct	0.033613	15	f	\N	\N	\N	\N	f	2026-05-12 08:08:03.912432
214	default	2026-05-12 08:09:04.87919	\N	product	uploadProduct	0.028744	15	f	\N	\N	\N	\N	f	2026-05-12 08:09:04.907938
215	default	2026-05-12 08:10:06.948173	\N	product	uploadProduct	0.035844	15	f	\N	\N	\N	\N	f	2026-05-12 08:10:06.98402
216	default	2026-05-12 08:11:02.914918	\N	product	uploadProduct	0.033189	16	f	\N	\N	\N	\N	f	2026-05-12 08:11:02.94811
217	default	2026-05-12 08:11:05.720436	\N	categoryOffer	getCategoryOffersPage	0.003417	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:05.723855
218	default	2026-05-12 08:11:05.729663	\N	comboOffer	getComboOffersPage	0.002973	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:05.732639
219	default	2026-05-12 08:11:05.763851	\N	bogo	getOffersPage	0.002175	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:05.766028
220	default	2026-05-12 08:11:13.594732	\N	InternalSession	\N	0.008095	3	f	\N	\N	\N	\N	f	2026-05-12 08:11:13.602828
222	default	2026-05-12 08:11:20.654598	\N	freeDelivery	getDeliveryConfig	0.017918	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.672539
221	default	2026-05-12 08:11:20.659112	\N	categoryOffer	getCategoryOffersPage	0.014312	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.673427
223	default	2026-05-12 08:11:20.660321	\N	freeDelivery	getDeliveryConfig	0.053842	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.714166
224	default	2026-05-12 08:11:20.661287	\N	coupon	fetchCoupons	0.114263	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.775561
225	default	2026-05-12 08:11:20.665584	\N	banner	getBannersPage	0.133417	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.799011
226	default	2026-05-12 08:11:20.669267	\N	bogo	getOffersPage	0.149556	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.818827
227	default	2026-05-12 08:11:20.669981	\N	comboOffer	getComboOffersPage	0.185492	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.855477
228	default	2026-05-12 08:11:20.87728	\N	freeDelivery	getDeliveryRulesPage	0.006585	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.883873
229	default	2026-05-12 08:11:20.969886	\N	freeDelivery	getDeliveryRulesPage	0.004453	1	f	\N	\N	\N	\N	f	2026-05-12 08:11:20.974344
230	default	2026-05-12 08:12:23.473072	\N	banner	createBanner	0.286011	14	f	\N	\N	\N	\N	f	2026-05-12 08:12:23.759087
231	default	2026-05-12 08:12:23.930741	\N	banner	getBannersPage	0.004965	3	f	\N	\N	\N	\N	f	2026-05-12 08:12:23.935711
232	default	2026-05-12 08:15:29.690666	\N	banner	createBanner	0.022069	8	f	\N	\N	\N	\N	f	2026-05-12 08:15:29.712738
233	default	2026-05-12 08:16:03.997136	\N	banner	createBanner	0.024834	11	f	\N	\N	\N	\N	f	2026-05-12 08:16:04.021973
234	default	2026-05-12 08:16:13.594782	\N	InternalSession	\N	0.009624	3	f	\N	\N	\N	\N	f	2026-05-12 08:16:13.604408
235	default	2026-05-12 08:16:56.628173	\N	banner	createBanner	0.017601	9	f	\N	\N	\N	\N	f	2026-05-12 08:16:56.645776
236	default	2026-05-12 08:19:53.898625	\N	comboOffer	getComboOffersPage	0.286898	2	f	\N	\N	\N	\N	f	2026-05-12 08:19:54.185525
237	default	2026-05-12 08:19:53.896322	\N	categoryOffer	getCategoryOffersPage	0.335739	1	f	\N	\N	\N	\N	f	2026-05-12 08:19:54.232064
238	default	2026-05-12 08:19:54.04545	\N	bogo	getOffersPage	0.280204	1	f	\N	\N	\N	\N	f	2026-05-12 08:19:54.325656
239	default	2026-05-12 08:20:28.185531	\N	product	updateProduct	0.037693	16	f	\N	\N	\N	\N	f	2026-05-12 08:20:28.223228
240	default	2026-05-12 08:20:47.883788	\N	categoryOffer	getCategoryOffersPage	0.023657	1	f	\N	\N	\N	\N	f	2026-05-12 08:20:47.907448
241	default	2026-05-12 08:20:47.884973	\N	comboOffer	getComboOffersPage	0.024248	1	f	\N	\N	\N	\N	f	2026-05-12 08:20:47.909223
242	default	2026-05-12 08:20:47.965431	\N	bogo	getOffersPage	0.002102	1	f	\N	\N	\N	\N	f	2026-05-12 08:20:47.967536
243	default	2026-05-12 08:21:13.595134	\N	InternalSession	\N	0.01128	3	f	\N	\N	\N	\N	f	2026-05-12 08:21:13.606417
244	default	2026-05-12 08:21:13.595047	\N	InternalSession	\N	0.013791	3	f	\N	\N	\N	\N	f	2026-05-12 08:21:13.608841
245	default	2026-05-12 08:21:13.594695	\N	InternalSession	\N	0.026859	4	f	\N	\N	\N	\N	f	2026-05-12 08:21:13.621556
246	default	2026-05-12 08:26:13.594781	\N	InternalSession	\N	0.009015	3	f	\N	\N	\N	\N	f	2026-05-12 08:26:13.603798
247	default	2026-05-12 08:31:13.594821	\N	InternalSession	\N	0.005967	3	f	\N	\N	\N	\N	f	2026-05-12 08:31:13.60079
248	default	2026-05-12 08:36:13.595039	\N	InternalSession	\N	0.008791	3	f	\N	\N	\N	\N	f	2026-05-12 08:36:13.603832
411	default	2026-05-12 09:40:25.420466	\N	bogo	getOfferForProduct	0.00622	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:25.426696
299	default	2026-05-12 08:44:24.296716	\N	comboOffer	upsertComboOffer	0.432047	7	f	\N	\N	\N	\N	f	2026-05-12 08:44:24.728765
250	default	2026-05-12 08:37:14.305841	\N	InternalSession	\N	0.043926	3	f	\N	\N	\N	\N	f	2026-05-12 08:37:14.34977
251	default	2026-05-12 08:37:14.305539	\N	InternalSession	\N	0.047394	3	f	\N	\N	\N	\N	f	2026-05-12 08:37:14.352937
255	default	2026-05-12 08:39:09.199781	\N	admin	getDashboardStats	0.794378	3	f	\N	\N	\N	\N	f	2026-05-12 08:39:09.994169
259	default	2026-05-12 08:39:17.745734	\N	subCategory	getSubCategories	0.034129	2	f	\N	\N	\N	\N	f	2026-05-12 08:39:17.779879
261	default	2026-05-12 08:39:17.747476	\N	category	getCategories	0.02947	2	f	\N	\N	\N	\N	f	2026-05-12 08:39:17.776951
303	default	2026-05-12 08:52:14.305714	\N	InternalSession	\N	0.009085	3	f	\N	\N	\N	\N	f	2026-05-12 08:52:14.314803
265	default	2026-05-12 08:39:24.195373	\N	comboOffer	getComboOffersPage	0.013445	1	f	\N	\N	\N	\N	f	2026-05-12 08:39:24.208832
266	default	2026-05-12 08:39:24.199538	\N	bogo	getOffersPage	0.01187	1	f	\N	\N	\N	\N	f	2026-05-12 08:39:24.211416
304	default	2026-05-12 08:52:53.577661	\N	coupon	uploadCoupon	0.381685	6	f	\N	\N	\N	\N	f	2026-05-12 08:52:53.959353
305	default	2026-05-12 08:52:54.198442	\N	coupon	fetchCoupons	0.004801	2	f	\N	\N	\N	\N	f	2026-05-12 08:52:54.203248
306	default	2026-05-12 08:54:04.348129	\N	coupon	uploadCoupon	0.016495	5	f	\N	\N	\N	\N	f	2026-05-12 08:54:04.36463
307	default	2026-05-12 08:57:14.305781	\N	InternalSession	\N	0.006445	3	f	\N	\N	\N	\N	f	2026-05-12 08:57:14.312228
254	default	2026-05-12 08:39:09.210185	\N	orderRealtime	watchDashboardUpdates	1379.770456	1	f	\N	\N	\N	\N	f	2026-05-12 09:02:08.980648
308	default	2026-05-12 09:02:14.306231	\N	InternalSession	\N	0.008688	3	f	\N	\N	\N	\N	f	2026-05-12 09:02:14.314921
311	default	2026-05-12 09:06:42.957939	\N	admin	getDashboardStats	1.623664	3	t	\N	\N	\N	\N	f	2026-05-12 09:06:44.581683
312	default	2026-05-12 09:06:43.004215	\N	admin	getAnalytics	1.628895	4	t	\N	\N	\N	\N	f	2026-05-12 09:06:44.633118
313	default	2026-05-12 09:06:45.094009	\N	admin	completeFirebaseSetup	0.284651	3	f	\N	\N	\N	\N	f	2026-05-12 09:06:45.378665
314	default	2026-05-12 09:06:45.398448	\N	admin	firebaseLogin	0.00383	1	f	\N	\N	\N	\N	f	2026-05-12 09:06:45.402284
315	default	2026-05-12 09:06:47.71414	\N	category	getCategories	0.027907	2	f	\N	\N	\N	\N	f	2026-05-12 09:06:47.742055
318	default	2026-05-12 09:06:47.72118	\N	subCategory	getSubCategories	0.037037	2	f	\N	\N	\N	\N	f	2026-05-12 09:06:47.75822
319	default	2026-05-12 09:06:47.722975	\N	product	getProductsPage	0.136864	10	f	\N	\N	\N	\N	f	2026-05-12 09:06:47.859851
320	default	2026-05-12 09:06:50.172032	\N	freeDelivery	getDeliveryConfig	0.011541	1	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.183591
322	default	2026-05-12 09:06:50.175665	\N	coupon	fetchCoupons	0.024112	2	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.199789
324	default	2026-05-12 09:06:50.178222	\N	categoryOffer	getCategoryOffersPage	0.046886	4	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.225116
326	default	2026-05-12 09:06:50.242317	\N	banner	getBannersPage	0.020815	4	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.263136
327	default	2026-05-12 09:06:50.683555	\N	freeDelivery	getDeliveryRulesPage	0.005497	1	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.689057
329	default	2026-05-12 09:07:14.306238	\N	InternalSession	\N	0.008293	3	f	\N	\N	\N	\N	f	2026-05-12 09:07:14.314533
330	default	2026-05-12 09:09:50.929106	\N	coupon	uploadCoupon	0.02145	5	f	\N	\N	\N	\N	f	2026-05-12 09:09:50.950561
331	default	2026-05-12 09:09:51.21641	\N	coupon	fetchCoupons	0.007313	2	f	\N	\N	\N	\N	f	2026-05-12 09:09:51.223729
309	default	2026-05-12 09:06:43.011147	\N	orderRealtime	watchAdminOrders	199.327454	1	f	\N	\N	\N	\N	f	2026-05-12 09:10:02.338612
332	default	2026-05-12 09:12:14.305776	\N	InternalSession	\N	0.006916	3	f	\N	\N	\N	\N	f	2026-05-12 09:12:14.312695
333	default	2026-05-12 09:17:14.305772	\N	InternalSession	\N	0.005657	3	f	\N	\N	\N	\N	f	2026-05-12 09:17:14.311432
334	default	2026-05-12 09:20:36.089974	\N	product	getProductsPage	0.531571	12	f	\N	\N	\N	\N	f	2026-05-12 09:20:36.621551
335	default	2026-05-12 09:20:59.49239	\N	banner	createBanner	0.030109	8	f	\N	\N	\N	\N	f	2026-05-12 09:20:59.522502
350	default	2026-05-12 09:25:55.304724	\N	banner	getBanners	0.261864	5	f	\N	\N	\N	\N	f	2026-05-12 09:25:55.566599
356	default	2026-05-12 09:25:56.431334	\N	productRanking	getMostSellingProducts	0.22131	9	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.652654
362	default	2026-05-12 09:27:08.82038	\N	product	searchProducts	0.010973	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:27:08.831367
363	default	2026-05-12 09:27:09.183428	\N	product	searchProducts	0.003721	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:27:09.187154
367	default	2026-05-12 09:29:37.837976	\N	product	searchProducts	0.003874	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:37.841855
378	default	2026-05-12 09:32:14.308487	\N	InternalSession	\N	0.012551	3	f	\N	\N	\N	\N	f	2026-05-12 09:32:14.321046
379	default	2026-05-12 09:37:14.306981	\N	InternalSession	\N	0.092638	3	f	\N	\N	\N	\N	f	2026-05-12 09:37:14.399621
249	default	2026-05-12 08:37:14.302251	\N	InternalSession	\N	0.039419	3	f	\N	\N	\N	\N	f	2026-05-12 08:37:14.341719
252	default	2026-05-12 08:37:14.3057	\N	InternalSession	\N	0.068308	4	f	\N	\N	\N	\N	f	2026-05-12 08:37:14.374011
256	default	2026-05-12 08:39:09.08253	\N	admin	getAnalytics	0.952844	4	f	\N	\N	\N	\N	f	2026-05-12 08:39:10.035387
300	default	2026-05-12 08:45:38.931739	\N	comboOffer	upsertComboOffer	0.025325	7	f	\N	\N	\N	\N	f	2026-05-12 08:45:38.957067
257	default	2026-05-12 08:39:11.905764	\N	admin	completeFirebaseSetup	0.277256	3	f	\N	\N	\N	\N	f	2026-05-12 08:39:12.183029
258	default	2026-05-12 08:39:12.218236	\N	admin	firebaseLogin	0.003459	1	f	\N	\N	\N	\N	f	2026-05-12 08:39:12.221699
260	default	2026-05-12 08:39:17.742121	\N	category	getCategories	0.033596	2	f	\N	\N	\N	\N	f	2026-05-12 08:39:17.775728
301	default	2026-05-12 08:46:21.266806	\N	categoryOffer	upsertCategoryOffer	0.02763	6	f	\N	\N	\N	\N	f	2026-05-12 08:46:21.294439
262	default	2026-05-12 08:39:17.751845	\N	subCategory	getSubCategories	0.040423	2	f	\N	\N	\N	\N	f	2026-05-12 08:39:17.792275
263	default	2026-05-12 08:39:17.748488	\N	product	getProductsPage	0.093505	9	f	\N	\N	\N	\N	f	2026-05-12 08:39:17.842008
264	default	2026-05-12 08:39:24.193595	\N	categoryOffer	getCategoryOffersPage	0.011531	1	f	\N	\N	\N	\N	f	2026-05-12 08:39:24.205136
267	default	2026-05-12 08:40:09.369738	\N	product	updateProduct	0.130442	16	f	\N	\N	\N	\N	f	2026-05-12 08:40:09.500196
268	default	2026-05-12 08:40:13.309778	\N	product	getProductsPage	0.025259	9	f	\N	\N	\N	\N	f	2026-05-12 08:40:13.335041
253	default	2026-05-12 08:39:09.206255	\N	orderRealtime	watchAdminOrders	1379.773337	1	f	\N	\N	\N	\N	f	2026-05-12 09:02:08.979737
316	default	2026-05-12 09:06:47.717126	\N	subCategory	getSubCategories	0.037884	2	f	\N	\N	\N	\N	f	2026-05-12 09:06:47.75502
321	default	2026-05-12 09:06:50.173603	\N	freeDelivery	getDeliveryConfig	0.017475	1	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.191081
269	default	2026-05-12 08:40:29.543304	\N	categoryOffer	getCategoryOffersPage	0.011805	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.555113
272	default	2026-05-12 08:40:29.544146	\N	coupon	fetchCoupons	0.017845	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.562005
270	default	2026-05-12 08:40:29.539428	\N	freeDelivery	getDeliveryConfig	0.017454	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.556888
273	default	2026-05-12 08:40:29.547319	\N	bogo	getOffersPage	0.016812	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.564134
271	default	2026-05-12 08:40:29.546868	\N	freeDelivery	getDeliveryConfig	0.012082	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.55896
274	default	2026-05-12 08:40:29.547939	\N	comboOffer	getComboOffersPage	0.016817	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.564758
275	default	2026-05-12 08:40:29.533357	\N	banner	getBannersPage	0.052853	4	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.586219
323	default	2026-05-12 09:06:50.17417	\N	comboOffer	getComboOffersPage	0.043108	3	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.217294
276	default	2026-05-12 08:40:29.907702	\N	freeDelivery	getDeliveryRulesPage	0.004019	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.911729
277	default	2026-05-12 08:40:29.904534	\N	freeDelivery	getDeliveryRulesPage	0.008371	1	f	\N	\N	\N	\N	f	2026-05-12 08:40:29.912908
325	default	2026-05-12 09:06:50.238138	\N	bogo	getOffersPage	0.012215	2	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.250362
278	default	2026-05-12 08:40:50.156231	\N	product	getProductsPage	0.023787	10	f	\N	\N	\N	\N	f	2026-05-12 08:40:50.180025
328	default	2026-05-12 09:06:50.685331	\N	freeDelivery	getDeliveryRulesPage	0.00475	1	f	\N	\N	\N	\N	f	2026-05-12 09:06:50.690083
279	default	2026-05-12 08:41:01.370057	\N	bogo	upsertOffer	0.035278	5	f	\N	\N	\N	\N	f	2026-05-12 08:41:01.405347
280	default	2026-05-12 08:41:35.511827	\N	categoryOffer	getCategoryOffersPage	0.004385	1	f	\N	\N	\N	\N	f	2026-05-12 08:41:35.516215
281	default	2026-05-12 08:41:35.515472	\N	comboOffer	getComboOffersPage	0.003009	1	f	\N	\N	\N	\N	f	2026-05-12 08:41:35.518484
310	default	2026-05-12 09:06:43.029738	\N	orderRealtime	watchDashboardUpdates	199.309118	1	f	\N	\N	\N	\N	f	2026-05-12 09:10:02.33886
282	default	2026-05-12 08:42:05.208041	\N	product	updateProduct	0.048121	16	f	\N	\N	\N	\N	f	2026-05-12 08:42:05.256169
283	default	2026-05-12 08:42:14.306193	\N	InternalSession	\N	0.008314	3	f	\N	\N	\N	\N	f	2026-05-12 08:42:14.314509
336	default	2026-05-12 09:21:28.279789	\N	banner	createBanner	0.026925	10	f	\N	\N	\N	\N	f	2026-05-12 09:21:28.306719
284	default	2026-05-12 08:42:27.089323	\N	bogo	upsertOffer	0.017093	4	f	DatabaseQueryException: { message: invalid input syntax for type uuid: "variant_1778575304476", code: 22P02, position: 204 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:34)\n#3      PostgresDatabaseConnection._mappedResultsQuery (package:serverpod/src/database/adapters/postgres/database_connection.dart:660:24)\n#4      PostgresDatabaseConnection.insert (package:serverpod/src/database/adapters/postgres/database_connection.dart:197:19)\n#5      PostgresDatabaseConnection.insertRow (package:serverpod/src/database/adapters/postgres/database_connection.dart:212:24)\n#6      Database.insertRow (package:serverpod/src/database/database.dart:354:32)\n#7      BogoOfferRewardRowRepository.insertRow (package:freshpickkat_server/src/generated/bogo_offer_reward_row.dart:437:23)\n#8      PostgresOfferService._syncBogoRewards (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:797:35)\n<asynchronous suspension>\n#9      PostgresOfferService.upsertBogoOffer.<anonymous closure> (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:75:7)\n<asynchronous suspension>\n#10     PgConnectionImplementation.runTx.<anonymous closure> (package:postgres/src/v3/connection.dart:591:24)\n<asynchronous suspension>\n#11     Pool.withResource (package:pool/pool.dart:127:14)\n<asynchronous suspension>\n#12     PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:16)\n<asynchronous suspension>\n#13     Database.transaction (package:serverpod/src/database/database.dart:514:12)\n<asynchronous suspension>\n#14     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#15     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#16     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#17     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#18     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#19     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#20     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 08:42:27.106445
337	default	2026-05-12 09:22:02.558195	\N	banner	createBanner	0.024345	9	f	\N	\N	\N	\N	f	2026-05-12 09:22:02.582545
287	default	2026-05-12 08:42:41.833864	\N	comboOffer	getComboOffersPage	0.011291	1	f	\N	\N	\N	\N	f	2026-05-12 08:42:41.845157
338	default	2026-05-12 09:22:14.305807	\N	InternalSession	\N	0.010012	3	f	\N	\N	\N	\N	f	2026-05-12 09:22:14.315822
288	default	2026-05-12 08:42:41.836562	\N	categoryOffer	getCategoryOffersPage	0.012839	1	f	\N	\N	\N	\N	f	2026-05-12 08:42:41.849405
291	default	2026-05-12 08:42:41.839078	\N	coupon	fetchCoupons	0.10064	1	f	\N	\N	\N	\N	f	2026-05-12 08:42:41.939721
293	default	2026-05-12 08:42:41.84229	\N	banner	getBannersPage	0.234783	4	f	\N	\N	\N	\N	f	2026-05-12 08:42:42.077078
339	default	2026-05-12 09:22:28.674883	\N	banner	createBanner	0.017841	8	f	\N	\N	\N	\N	f	2026-05-12 09:22:28.692727
340	default	2026-05-12 09:22:54.584638	\N	banner	createBanner	0.018061	9	f	\N	\N	\N	\N	f	2026-05-12 09:22:54.602702
343	default	2026-05-12 09:24:32.12459	\N	admin	getDashboardStats	0.030181	2	f	\N	\N	\N	\N	f	2026-05-12 09:24:32.154789
345	default	2026-05-12 09:24:33.227692	\N	admin	completeFirebaseSetup	0.299044	3	f	\N	\N	\N	\N	f	2026-05-12 09:24:33.52674
346	default	2026-05-12 09:24:33.542679	\N	admin	firebaseLogin	0.00309	1	f	\N	\N	\N	\N	f	2026-05-12 09:24:33.545772
341	default	2026-05-12 09:24:21.963538	\N	orderRealtime	watchAdminOrders	20.581177	0	f	\N	\N	\N	\N	f	2026-05-12 09:24:42.544736
347	default	2026-05-12 09:25:55.254499	\N	user	getUserByFirebaseUid	0.089494	1	f	\N	\N	\N	\N	f	2026-05-12 09:25:55.344007
349	default	2026-05-12 09:25:55.306437	\N	banner	getBanners	0.25566	5	f	\N	\N	\N	\N	f	2026-05-12 09:25:55.562102
351	default	2026-05-12 09:25:55.309348	\N	product	getProducts	0.313693	9	f	\N	\N	\N	\N	f	2026-05-12 09:25:55.623049
352	default	2026-05-12 09:25:55.528479	\N	user	createOrUpdateUser	0.121592	6	f	\N	\N	\N	\N	f	2026-05-12 09:25:55.650082
353	default	2026-05-12 09:25:56.424749	\N	product	getProductsByIds	0.219486	8	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.644239
354	default	2026-05-12 09:25:56.43244	\N	productRanking	getMostViewedProducts	0.221881	9	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.654327
357	default	2026-05-12 09:25:56.466304	\N	productRanking	getFrequentlyReorderedProducts	0.197799	9	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.664108
358	default	2026-05-12 09:25:56.697133	\N	freeDelivery	getDeliveryConfig	0.003593	1	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.700731
285	default	2026-05-12 08:42:33.426447	\N	bogo	upsertOffer	0.010348	4	f	DatabaseQueryException: { message: invalid input syntax for type uuid: "variant_1778575304476", code: 22P02, position: 204 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:34)\n#3      PostgresDatabaseConnection._mappedResultsQuery (package:serverpod/src/database/adapters/postgres/database_connection.dart:660:24)\n#4      PostgresDatabaseConnection.insert (package:serverpod/src/database/adapters/postgres/database_connection.dart:197:19)\n#5      PostgresDatabaseConnection.insertRow (package:serverpod/src/database/adapters/postgres/database_connection.dart:212:24)\n#6      Database.insertRow (package:serverpod/src/database/database.dart:354:32)\n#7      BogoOfferRewardRowRepository.insertRow (package:freshpickkat_server/src/generated/bogo_offer_reward_row.dart:437:23)\n#8      PostgresOfferService._syncBogoRewards (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:797:35)\n<asynchronous suspension>\n#9      PostgresOfferService.upsertBogoOffer.<anonymous closure> (package:freshpickkat_server/src/services/postgres/postgres_offer_service.dart:75:7)\n<asynchronous suspension>\n#10     PgConnectionImplementation.runTx.<anonymous closure> (package:postgres/src/v3/connection.dart:591:24)\n<asynchronous suspension>\n#11     Pool.withResource (package:pool/pool.dart:127:14)\n<asynchronous suspension>\n#12     PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:16)\n<asynchronous suspension>\n#13     Database.transaction (package:serverpod/src/database/database.dart:514:12)\n<asynchronous suspension>\n#14     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#15     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#16     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#17     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#18     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#19     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#20     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 08:42:33.436803
435	default	2026-05-12 10:04:12.286907	\N	product	getProductsByIds	0.398778	8	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.685692
286	default	2026-05-12 08:42:41.823389	\N	category	getCategories	0.008914	2	f	\N	\N	\N	\N	f	2026-05-12 08:42:41.832312
302	default	2026-05-12 08:47:14.305739	\N	InternalSession	\N	0.008614	3	f	\N	\N	\N	\N	f	2026-05-12 08:47:14.314355
289	default	2026-05-12 08:42:41.837544	\N	freeDelivery	getDeliveryConfig	0.01739	1	f	\N	\N	\N	\N	f	2026-05-12 08:42:41.854937
290	default	2026-05-12 08:42:41.835519	\N	subCategory	getSubCategories	0.102922	2	f	\N	\N	\N	\N	f	2026-05-12 08:42:41.938451
317	default	2026-05-12 09:06:47.719509	\N	category	getCategories	0.037073	2	f	\N	\N	\N	\N	f	2026-05-12 09:06:47.756587
292	default	2026-05-12 08:42:41.843842	\N	bogo	getOffersPage	0.229378	2	f	\N	\N	\N	\N	f	2026-05-12 08:42:42.073228
294	default	2026-05-12 08:42:41.852537	\N	product	getProductsPage	0.256652	10	f	\N	\N	\N	\N	f	2026-05-12 08:42:42.11162
295	default	2026-05-12 08:42:42.396863	\N	freeDelivery	getDeliveryRulesPage	0.004024	1	f	\N	\N	\N	\N	f	2026-05-12 08:42:42.40089
344	default	2026-05-12 09:24:32.128035	\N	admin	getAnalytics	0.055086	3	f	\N	\N	\N	\N	f	2026-05-12 09:24:32.183132
296	default	2026-05-12 08:42:55.641371	\N	bogo	upsertOffer	0.010764	4	f	\N	\N	\N	\N	f	2026-05-12 08:42:55.652144
342	default	2026-05-12 09:24:21.990789	\N	orderRealtime	watchDashboardUpdates	20.554532	0	f	\N	\N	\N	\N	f	2026-05-12 09:24:42.545329
297	default	2026-05-12 08:42:58.99566	\N	product	getProductsPage	0.019465	9	f	\N	\N	\N	\N	f	2026-05-12 08:42:59.015131
348	default	2026-05-12 09:25:55.289796	\N	banner	getBanners	0.27076	5	f	\N	\N	\N	\N	f	2026-05-12 09:25:55.560569
355	default	2026-05-12 09:25:56.427699	\N	productRanking	getTrendingProducts	0.227919	9	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.655622
359	default	2026-05-12 09:25:56.758281	\N	pricing	basketSuggestions	0.232032	31	f	\N	\N	\N	\N	f	2026-05-12 09:25:56.990326
361	default	2026-05-12 09:26:05.538559	\N	product	getProducts	0.276913	8	f	\N	\N	\N	\N	f	2026-05-12 09:26:05.815478
364	default	2026-05-12 09:27:10.589551	\N	product	searchProducts	0.003019	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:27:10.592574
365	default	2026-05-12 09:27:11.88863	\N	product	searchProducts	0.002682	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:27:11.891315
366	default	2026-05-12 09:27:14.305921	\N	InternalSession	\N	0.009777	3	f	\N	\N	\N	\N	f	2026-05-12 09:27:14.315701
368	default	2026-05-12 09:29:37.974743	\N	product	searchProducts	0.003569	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:37.978322
371	default	2026-05-12 09:29:39.509602	\N	product	searchProducts	0.002504	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:39.51211
360	default	2026-05-12 09:25:57.794589	\N	orderRealtime	watchUserOrders	528.220043	1	f	\N	\N	\N	\N	f	2026-05-12 09:34:46.014712
380	default	2026-05-12 09:37:14.306429	\N	InternalSession	\N	0.098524	4	f	\N	\N	\N	\N	f	2026-05-12 09:37:14.404955
381	default	2026-05-12 09:37:14.307342	\N	InternalSession	\N	0.104035	3	f	\N	\N	\N	\N	f	2026-05-12 09:37:14.41138
382	default	2026-05-12 09:39:13.202785	\N	user	getUserByFirebaseUid	0.125644	4	f	\N	\N	\N	\N	f	2026-05-12 09:39:13.328434
369	default	2026-05-12 09:29:39.035449	\N	product	searchProducts	0.002473	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:39.037929
412	default	2026-05-12 09:40:26.957964	\N	product	updateProduct	0.013703	4	f	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	\N	\N	f	2026-05-12 09:40:26.971672
572	default	2026-05-12 10:37:28.969186	\N	product	getProducts	0.018252	8	f	\N	\N	\N	\N	f	2026-05-12 10:37:28.987442
413	default	2026-05-12 09:40:33.69226	\N	product	updateProduct	0.03619	15	f	\N	\N	\N	\N	f	2026-05-12 09:40:33.728453
593	default	2026-05-12 10:45:09.343445	\N	banner	getBanners	0.086935	5	f	\N	\N	\N	\N	f	2026-05-12 10:45:09.43039
414	default	2026-05-12 09:40:35.536336	\N	bogo	getOfferForProduct	0.004439	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:35.540779
436	default	2026-05-12 10:04:12.290749	\N	productRanking	getMostViewedProducts	0.410036	9	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.700793
598	default	2026-05-12 10:45:10.321734	\N	product	getProductsByIds	0.364679	8	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.686419
461	default	2026-05-12 10:05:04.028561	\N	product	searchProducts	0.00223	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:05:04.030797
473	default	2026-05-12 10:19:37.006971	\N	banner	getBanners	0.276941	5	f	\N	\N	\N	\N	f	2026-05-12 10:19:37.283917
610	default	2026-05-12 10:54:20.037038	\N	banner	getBanners	0.204171	5	f	\N	\N	\N	\N	f	2026-05-12 10:54:20.241223
478	default	2026-05-12 10:19:38.159305	\N	productRanking	getMostSellingProducts	0.307606	9	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.466917
494	default	2026-05-12 10:20:51.591403	\N	product	searchProductsWithOfferFilters	0.000948	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:20:51.592359
624	default	2026-05-12 11:11:57.157929	\N	InternalSession	\N	0.012551	3	f	\N	\N	\N	\N	f	2026-05-12 11:11:57.170484
508	default	2026-05-12 10:26:51.797345	\N	product	searchProductsWithOfferFilters	0.000792	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:51.798141
509	default	2026-05-12 10:26:54.87654	\N	product	getProducts	0.028816	9	f	\N	\N	\N	\N	f	2026-05-12 10:26:54.905362
625	default	2026-05-12 11:16:57.158534	\N	InternalSession	\N	0.014572	3	f	\N	\N	\N	\N	f	2026-05-12 11:16:57.17311
511	default	2026-05-12 10:26:54.97578	\N	banner	getBanners	0.079948	5	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.055735
513	default	2026-05-12 10:26:54.979411	\N	banner	getBanners	0.130509	5	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.109926
626	default	2026-05-12 11:21:57.160783	\N	InternalSession	\N	0.008687	3	f	\N	\N	\N	\N	f	2026-05-12 11:21:57.169472
514	default	2026-05-12 10:26:55.282904	\N	productRanking	getTrendingProducts	0.080937	9	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.363848
515	default	2026-05-12 10:26:55.29487	\N	product	getProductsByIds	0.086729	8	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.381604
534	default	2026-05-12 10:30:11.495259	\N	banner	getBanners	0.077371	5	f	\N	\N	\N	\N	f	2026-05-12 10:30:11.572633
562	default	2026-05-12 10:36:25.630254	\N	product	getProductsByIds	0.120683	8	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.750944
370	default	2026-05-12 09:29:39.303413	\N	product	searchProducts	0.002608	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:39.306029
752	default	2026-05-12 12:13:31.182475	\N	user	getUserByFirebaseUid	0.011572	4	f	\N	\N	\N	\N	f	2026-05-12 12:13:31.194053
415	default	2026-05-12 09:40:39.421653	\N	product	updateProduct	0.010075	4	f	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	\N	\N	f	2026-05-12 09:40:39.431733
438	default	2026-05-12 10:04:12.288771	\N	productRanking	getTrendingProducts	0.420567	9	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.709347
462	default	2026-05-12 10:05:05.417413	\N	product	searchProducts	0.002046	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:05:05.419462
479	default	2026-05-12 10:19:38.157774	\N	productRanking	getTrendingProducts	0.308027	9	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.465807
498	default	2026-05-12 10:20:59.169717	\N	product	searchProductsWithOfferFilters	0.000897	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:20:59.170619
499	default	2026-05-12 10:22:36.01015	\N	InternalSession	\N	0.076831	4	f	\N	\N	\N	\N	f	2026-05-12 10:22:36.086985
510	default	2026-05-12 10:26:54.977892	\N	bogo	getActiveOffers	0.057473	2	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.035374
512	default	2026-05-12 10:26:54.978903	\N	banner	getBanners	0.125769	5	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.104675
518	default	2026-05-12 10:26:55.298834	\N	productRanking	getFrequentlyReorderedProducts	0.10048	9	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.39932
519	default	2026-05-12 10:26:57.164598	\N	product	searchProductsWithOfferFilters	0.000958	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:57.16556
520	default	2026-05-12 10:27:09.540091	\N	product	searchProductsWithOfferFilters	0.021607	11	f	\N	\N	\N	\N	f	2026-05-12 10:27:09.561703
535	default	2026-05-12 10:30:11.490063	\N	banner	getBanners	0.081508	5	f	\N	\N	\N	\N	f	2026-05-12 10:30:11.571583
539	default	2026-05-12 10:30:12.503127	\N	productRanking	getMostViewedProducts	0.467314	9	f	\N	\N	\N	\N	f	2026-05-12 10:30:12.970447
543	default	2026-05-12 10:30:12.515048	\N	pricing	basketSuggestions	0.50329	31	f	\N	\N	\N	\N	f	2026-05-12 10:30:13.01835
545	default	2026-05-12 10:30:19.051484	\N	product	searchProductsWithOfferFilters	0.001039	1	f	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:30:19.052528
372	default	2026-05-12 09:29:39.683907	\N	product	searchProducts	0.003152	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:39.687072
416	default	2026-05-12 09:40:58.217806	\N	product	updateProduct	0.013971	4	f	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "combo_offer_item_fk_2" on table "combo_offer_item", code: 23503, detail: Key (id)=(957488fe-7e21-4848-bce2-d00923802b25) is still referenced from table "combo_offer_item"., table: combo_offer_item, constraint: combo_offer_item_fk_2 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	\N	\N	f	2026-05-12 09:40:58.231785
574	default	2026-05-12 10:41:57.15362	\N	InternalSession	\N	0.04846	3	f	\N	\N	\N	\N	f	2026-05-12 10:41:57.202082
417	default	2026-05-12 09:42:14.305835	\N	InternalSession	\N	0.008132	3	f	\N	\N	\N	\N	f	2026-05-12 09:42:14.31397
418	default	2026-05-12 09:45:15.639429	\N	product	updateProduct	0.346361	17	f	\N	\N	\N	\N	f	2026-05-12 09:45:15.985793
576	default	2026-05-12 10:41:57.157956	\N	InternalSession	\N	0.073753	5	f	\N	\N	\N	\N	f	2026-05-12 10:41:57.231711
444	default	2026-05-12 10:04:24.54921	\N	admin	getAnalytics	0.019384	3	f	\N	\N	\N	\N	f	2026-05-12 10:04:24.568605
579	default	2026-05-12 10:42:00.069353	\N	banner	getBanners	0.098129	5	f	\N	\N	\N	\N	f	2026-05-12 10:42:00.167488
448	default	2026-05-12 10:04:30.148492	\N	category	getCategories	0.011958	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:30.160455
453	default	2026-05-12 10:04:33.588888	\N	comboOffer	getComboOffersPage	0.014554	3	f	\N	\N	\N	\N	f	2026-05-12 10:04:33.603447
441	default	2026-05-12 10:04:24.472214	\N	orderRealtime	watchDashboardUpdates	34.115818	0	f	\N	\N	\N	\N	f	2026-05-12 10:04:58.588039
581	default	2026-05-12 10:42:00.061337	\N	product	getProducts	0.144168	9	f	\N	\N	\N	\N	f	2026-05-12 10:42:00.205527
480	default	2026-05-12 10:19:38.160204	\N	productRanking	getMostViewedProducts	0.307732	9	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.46794
496	default	2026-05-12 10:20:55.58552	\N	product	searchProductsWithOfferFilters	0.000834	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:20:55.586358
589	default	2026-05-12 10:42:01.142965	\N	pricing	basketSuggestions	0.355916	31	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.498895
497	default	2026-05-12 10:20:57.940391	\N	product	searchProductsWithOfferFilters	0.02953	11	f	\N	\N	\N	\N	f	2026-05-12 10:20:57.969927
592	default	2026-05-12 10:45:09.337758	\N	banner	getBanners	0.09385	5	f	\N	\N	\N	\N	f	2026-05-12 10:45:09.431613
516	default	2026-05-12 10:26:55.297295	\N	productRanking	getMostViewedProducts	0.089059	9	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.386361
602	default	2026-05-12 10:45:10.322899	\N	productRanking	getTrendingProducts	0.379773	9	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.702677
537	default	2026-05-12 10:30:12.508631	\N	freeDelivery	getDeliveryConfig	0.019377	1	f	\N	\N	\N	\N	f	2026-05-12 10:30:12.528016
538	default	2026-05-12 10:30:12.49904	\N	product	getProductsByIds	0.461933	8	f	\N	\N	\N	\N	f	2026-05-12 10:30:12.96098
609	default	2026-05-12 10:54:20.032073	\N	banner	getBanners	0.211653	5	f	\N	\N	\N	\N	f	2026-05-12 10:54:20.243734
567	default	2026-05-12 10:36:25.654899	\N	pricing	basketSuggestions	0.149323	31	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.804239
621	default	2026-05-12 10:56:57.163767	\N	InternalSession	\N	0.037615	3	f	\N	\N	\N	\N	f	2026-05-12 10:56:57.201385
622	default	2026-05-12 11:01:57.161728	\N	InternalSession	\N	0.03887	3	f	\N	\N	\N	\N	f	2026-05-12 11:01:57.200602
623	default	2026-05-12 11:06:57.163554	\N	InternalSession	\N	0.060785	3	f	\N	\N	\N	\N	f	2026-05-12 11:06:57.224342
627	default	2026-05-12 11:26:57.160401	\N	InternalSession	\N	0.007924	3	f	\N	\N	\N	\N	f	2026-05-12 11:26:57.168327
628	default	2026-05-12 11:31:39.113138	\N	user	getUserByFirebaseUid	0.22114	4	f	\N	\N	\N	\N	f	2026-05-12 11:31:39.334355
632	default	2026-05-12 11:31:39.139685	\N	product	getProducts	0.266136	9	f	\N	\N	\N	\N	f	2026-05-12 11:31:39.405836
638	default	2026-05-12 11:31:40.272374	\N	pricing	basketSuggestions	0.365109	31	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.637495
641	default	2026-05-12 11:31:47.879852	\N	product	searchProducts	0.010189	0	f	\N	\N	\N	\N	f	2026-05-12 11:31:47.890056
642	default	2026-05-12 11:31:48.477433	\N	product	searchProducts	0.056239	10	f	\N	\N	\N	\N	f	2026-05-12 11:31:48.533677
643	default	2026-05-12 11:31:50.083342	\N	product	searchProducts	0.004987	2	f	\N	\N	\N	\N	f	2026-05-12 11:31:50.088331
644	default	2026-05-12 11:31:51.552094	\N	product	searchProducts	0.019315	10	f	\N	\N	\N	\N	f	2026-05-12 11:31:51.571559
645	default	2026-05-12 11:31:57.158013	\N	InternalSession	\N	0.007399	3	f	\N	\N	\N	\N	f	2026-05-12 11:31:57.165415
640	default	2026-05-12 11:31:40.724631	\N	orderRealtime	watchUserOrders	527.065032	1	f	\N	\N	\N	\N	f	2026-05-12 11:40:27.789837
679	default	2026-05-12 11:40:33.068484	\N	product	getProducts	0.068579	9	f	\N	\N	\N	\N	f	2026-05-12 11:40:33.137067
680	default	2026-05-12 11:40:34.004208	\N	product	getProductsByIds	0.038439	8	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.042651
373	default	2026-05-12 09:29:39.83384	\N	product	searchProducts	0.003285	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:39.837134
419	default	2026-05-12 09:45:21.615204	\N	product	updateProduct	0.011134	4	f	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "combo_offer_item_fk_2" on table "combo_offer_item", code: 23503, detail: Key (id)=(957488fe-7e21-4848-bce2-d00923802b25) is still referenced from table "combo_offer_item"., table: combo_offer_item, constraint: combo_offer_item_fk_2 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	\N	\N	f	2026-05-12 09:45:21.626353
575	default	2026-05-12 10:41:57.157668	\N	InternalSession	\N	0.057346	3	f	\N	\N	\N	\N	f	2026-05-12 10:41:57.215016
420	default	2026-05-12 09:47:14.305683	\N	InternalSession	\N	0.005463	3	f	\N	\N	\N	\N	f	2026-05-12 09:47:14.311148
421	default	2026-05-12 09:52:14.305799	\N	InternalSession	\N	0.006279	3	f	\N	\N	\N	\N	f	2026-05-12 09:52:14.312081
577	default	2026-05-12 10:42:00.064819	\N	user	getUserByFirebaseUid	0.087879	4	f	\N	\N	\N	\N	f	2026-05-12 10:42:00.152707
422	default	2026-05-12 09:57:14.305696	\N	InternalSession	\N	0.005661	3	f	\N	\N	\N	\N	f	2026-05-12 09:57:14.311359
463	default	2026-05-12 10:07:08.413396	\N	InternalSession	\N	0.015698	3	f	\N	\N	\N	\N	f	2026-05-12 10:07:08.429097
587	default	2026-05-12 10:42:01.084325	\N	productRanking	getMostSellingProducts	0.366082	9	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.450412
464	default	2026-05-12 10:12:08.414548	\N	InternalSession	\N	0.012257	3	f	\N	\N	\N	\N	f	2026-05-12 10:12:08.426807
465	default	2026-05-12 10:17:08.411763	\N	InternalSession	\N	0.009332	3	f	\N	\N	\N	\N	f	2026-05-12 10:17:08.421097
596	default	2026-05-12 10:45:10.364574	\N	freeDelivery	getDeliveryConfig	0.075319	1	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.439903
600	default	2026-05-12 10:45:10.324422	\N	productRanking	getMostViewedProducts	0.38053	9	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.704955
495	default	2026-05-12 10:20:53.537516	\N	product	searchProductsWithOfferFilters	0.000922	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:20:53.538441
617	default	2026-05-12 10:54:21.274611	\N	productRanking	getMostSellingProducts	0.506699	9	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.781321
482	default	2026-05-12 10:19:38.55633	\N	orderRealtime	watchUserOrders	385.972979	1	f	\N	\N	\N	\N	f	2026-05-12 10:26:04.529414
517	default	2026-05-12 10:26:55.296049	\N	productRanking	getMostSellingProducts	0.094624	9	f	\N	\N	\N	\N	f	2026-05-12 10:26:55.390679
521	default	2026-05-12 10:27:12.180648	\N	product	searchProductsWithOfferFilters	0.00078	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:27:12.181432
631	default	2026-05-12 11:31:39.152135	\N	banner	getBanners	0.206387	5	f	\N	\N	\N	\N	f	2026-05-12 11:31:39.358531
540	default	2026-05-12 10:30:12.502335	\N	productRanking	getMostSellingProducts	0.471785	9	f	\N	\N	\N	\N	f	2026-05-12 10:30:12.974124
630	default	2026-05-12 11:31:39.153501	\N	banner	getBanners	0.198572	5	f	\N	\N	\N	\N	f	2026-05-12 11:31:39.352082
635	default	2026-05-12 11:31:40.242056	\N	productRanking	getTrendingProducts	0.375107	9	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.617169
636	default	2026-05-12 11:31:40.243842	\N	productRanking	getMostViewedProducts	0.377205	9	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.621054
639	default	2026-05-12 11:31:40.243108	\N	productRanking	getMostSellingProducts	0.397725	9	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.640842
683	default	2026-05-12 11:40:34.00907	\N	productRanking	getMostViewedProducts	0.039163	9	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.048236
694	default	2026-05-12 11:41:14.747484	\N	product	searchProductsWithOfferFilters	0.020335	10	f	\N	\N	\N	\N	f	2026-05-12 11:41:14.767823
695	default	2026-05-12 11:41:16.406414	\N	product	searchProductsWithOfferFilters	0.019076	10	f	\N	\N	\N	\N	f	2026-05-12 11:41:16.425494
696	default	2026-05-12 11:41:48.691871	\N	user	getUserByFirebaseUid	0.00667	4	f	\N	\N	\N	\N	f	2026-05-12 11:41:48.698544
698	default	2026-05-12 11:41:48.707977	\N	banner	getBanners	0.069139	5	f	\N	\N	\N	\N	f	2026-05-12 11:41:48.777121
700	default	2026-05-12 11:41:48.705495	\N	product	getProducts	0.091531	9	f	\N	\N	\N	\N	f	2026-05-12 11:41:48.797031
732	default	2026-05-12 12:06:57.160474	\N	InternalSession	\N	0.008594	3	f	\N	\N	\N	\N	f	2026-05-12 12:06:57.16907
374	default	2026-05-12 09:29:39.988745	\N	product	searchProducts	0.00248	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:39.99123
573	default	2026-05-12 10:41:57.158315	\N	InternalSession	\N	0.035862	3	f	\N	\N	\N	\N	f	2026-05-12 10:41:57.194226
423	default	2026-05-12 10:02:08.411828	\N	InternalSession	\N	0.03484	3	f	\N	\N	\N	\N	f	2026-05-12 10:02:08.446719
426	default	2026-05-12 10:02:08.411692	\N	InternalSession	\N	0.074404	4	f	\N	\N	\N	\N	f	2026-05-12 10:02:08.486099
585	default	2026-05-12 10:42:01.082712	\N	productRanking	getTrendingProducts	0.366484	9	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.4492
427	default	2026-05-12 10:03:38.52209	\N	product	updateProduct	0.936074	9	f	DatabaseQueryException: { message: current transaction is aborted, commands ignored until end of transaction block, code: 25P02 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:34)\n#3      PostgresDatabaseConnection._mappedResultsQuery (package:serverpod/src/database/adapters/postgres/database_connection.dart:660:24)\n#4      PostgresDatabaseConnection.update (package:serverpod/src/database/adapters/postgres/database_connection.dart:266:19)\n#5      PostgresDatabaseConnection.updateRow (package:serverpod/src/database/adapters/postgres/database_connection.dart:282:25)\n#6      Database.updateRow (package:serverpod/src/database/database.dart:273:32)\n#7      ProductVariantRowRepository.updateRow (package:freshpickkat_server/src/generated/product_variant_row.dart:660:23)\n#8      PostgresProductCompatService._replaceProductVariants (package:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart:740:38)\n<asynchronous suspension>\n#9      PostgresProductCompatService.updateProduct.<anonymous closure> (package:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart:387:7)\n<asynchronous suspension>\n#10     PgConnectionImplementation.runTx.<anonymous closure> (package:postgres/src/v3/connection.dart:591:24)\n<asynchronous suspension>\n#11     Pool.withResource (package:pool/pool.dart:127:14)\n<asynchronous suspension>\n#12     PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:16)\n<asynchronous suspension>\n#13     Database.transaction (package:serverpod/src/database/database.dart:514:12)\n<asynchronous suspension>\n#14     ProductEndpoint.updateProduct (package:freshpickkat_server/src/endpoints/product_endpoint.dart:136:5)\n<asynchronous suspension>\n#15     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#16     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#17     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#18     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#19     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#20     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#21     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:03:39.458176
466	default	2026-05-12 10:17:36.010298	\N	InternalSession	\N	0.031642	3	f	\N	\N	\N	\N	f	2026-05-12 10:17:36.042001
500	default	2026-05-12 10:26:29.574082	\N	product	searchProductsWithOfferFilters	0.003831	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:29.577918
501	default	2026-05-12 10:26:30.669129	\N	product	searchProductsWithOfferFilters	0.053764	11	f	\N	\N	\N	\N	f	2026-05-12 10:26:30.722901
597	default	2026-05-12 10:45:10.601843	\N	orderRealtime	watchUserOrders	384.691268	1	f	\N	\N	\N	\N	f	2026-05-12 10:51:35.294157
522	default	2026-05-12 10:27:36.00971	\N	InternalSession	\N	0.009033	3	f	\N	\N	\N	\N	f	2026-05-12 10:27:36.018746
541	default	2026-05-12 10:30:12.500826	\N	productRanking	getTrendingProducts	0.472387	9	f	\N	\N	\N	\N	f	2026-05-12 10:30:12.973218
637	default	2026-05-12 11:31:40.244828	\N	productRanking	getFrequentlyReorderedProducts	0.379374	9	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.624206
646	default	2026-05-12 11:33:59.856925	\N	product	searchProducts	0.004995	0	f	\N	\N	\N	\N	f	2026-05-12 11:33:59.86194
647	default	2026-05-12 11:34:02.386407	\N	product	searchProducts	0.039694	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:02.426107
648	default	2026-05-12 11:34:13.274978	\N	product	searchProducts	0.000247	0	f	\N	\N	\N	\N	f	2026-05-12 11:34:13.275231
649	default	2026-05-12 11:34:14.093616	\N	product	searchProducts	0.000381	0	f	\N	\N	\N	\N	f	2026-05-12 11:34:14.094006
650	default	2026-05-12 11:34:14.731525	\N	product	searchProducts	0.032747	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:14.764277
651	default	2026-05-12 11:34:15.519823	\N	product	searchProducts	0.023526	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:15.543357
652	default	2026-05-12 11:34:17.794726	\N	product	searchProducts	0.021934	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:17.816665
653	default	2026-05-12 11:34:18.91018	\N	product	searchProducts	0.020196	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:18.930382
654	default	2026-05-12 11:34:37.504766	\N	product	searchProducts	0.01867	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:37.523442
655	default	2026-05-12 11:34:37.661907	\N	product	searchProducts	0.026087	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:37.688
656	default	2026-05-12 11:34:37.85134	\N	product	searchProducts	0.018622	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:37.869967
657	default	2026-05-12 11:34:45.326327	\N	product	searchProducts	0.000207	0	f	\N	\N	\N	\N	f	2026-05-12 11:34:45.326553
658	default	2026-05-12 11:34:46.145447	\N	product	searchProducts	0.027983	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:46.173454
659	default	2026-05-12 11:34:46.278316	\N	product	searchProducts	0.016064	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:46.294383
660	default	2026-05-12 11:34:49.422358	\N	product	searchProducts	0.017664	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:49.440027
661	default	2026-05-12 11:34:49.558314	\N	product	searchProducts	0.000212	0	f	\N	\N	\N	\N	f	2026-05-12 11:34:49.558532
662	default	2026-05-12 11:34:50.548529	\N	product	searchProducts	0.000206	0	f	\N	\N	\N	\N	f	2026-05-12 11:34:50.54874
663	default	2026-05-12 11:34:50.773924	\N	product	searchProducts	0.017748	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:50.791676
664	default	2026-05-12 11:34:51.982705	\N	product	searchProducts	0.021796	10	f	\N	\N	\N	\N	f	2026-05-12 11:34:52.004506
665	default	2026-05-12 11:35:04.29805	\N	product	searchProducts	0.018789	10	f	\N	\N	\N	\N	f	2026-05-12 11:35:04.316845
666	default	2026-05-12 11:35:04.474672	\N	product	searchProducts	0.000259	0	f	\N	\N	\N	\N	f	2026-05-12 11:35:04.474938
667	default	2026-05-12 11:35:06.735538	\N	product	searchProducts	0.000277	0	f	\N	\N	\N	\N	f	2026-05-12 11:35:06.73582
668	default	2026-05-12 11:35:07.248151	\N	product	searchProducts	0.014096	9	f	\N	\N	\N	\N	f	2026-05-12 11:35:07.262251
669	default	2026-05-12 11:35:09.106433	\N	product	searchProducts	0.000216	0	f	\N	\N	\N	\N	f	2026-05-12 11:35:09.106654
670	default	2026-05-12 11:35:16.580835	\N	product	searchProductsWithOfferFilters	0.022998	10	f	\N	\N	\N	\N	f	2026-05-12 11:35:16.603843
671	default	2026-05-12 11:35:21.473507	\N	product	searchProductsWithOfferFilters	0.021513	11	f	\N	\N	\N	\N	f	2026-05-12 11:35:21.495024
672	default	2026-05-12 11:35:29.376228	\N	product	searchProductsWithOfferFilters	0.021291	12	f	\N	\N	\N	\N	f	2026-05-12 11:35:29.397525
673	default	2026-05-12 11:35:32.027184	\N	product	searchProductsWithOfferFilters	0.021657	11	f	\N	\N	\N	\N	f	2026-05-12 11:35:32.048849
674	default	2026-05-12 11:36:57.157788	\N	InternalSession	\N	0.013834	3	f	\N	\N	\N	\N	f	2026-05-12 11:36:57.171626
675	default	2026-05-12 11:40:33.057996	\N	banner	getBanners	0.047914	5	f	\N	\N	\N	\N	f	2026-05-12 11:40:33.105923
375	default	2026-05-12 09:29:40.14599	\N	product	searchProducts	0.002062	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:40.148055
424	default	2026-05-12 10:02:08.406889	\N	InternalSession	\N	0.049441	3	f	\N	\N	\N	\N	f	2026-05-12 10:02:08.456335
578	default	2026-05-12 10:42:00.067	\N	banner	getBanners	0.097806	5	f	\N	\N	\N	\N	f	2026-05-12 10:42:00.164815
467	default	2026-05-12 10:17:36.006314	\N	InternalSession	\N	0.043181	3	f	\N	\N	\N	\N	f	2026-05-12 10:17:36.049499
469	default	2026-05-12 10:17:36.010148	\N	InternalSession	\N	0.063505	4	f	\N	\N	\N	\N	f	2026-05-12 10:17:36.073656
586	default	2026-05-12 10:42:01.085231	\N	productRanking	getMostViewedProducts	0.362805	9	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.448044
502	default	2026-05-12 10:26:37.232398	\N	product	searchProductsWithOfferFilters	0.000921	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:37.233322
523	default	2026-05-12 10:29:41.050617	\N	InternalSession	\N	0.03797	3	f	\N	\N	\N	\N	f	2026-05-12 10:29:41.088632
599	default	2026-05-12 10:45:10.323754	\N	productRanking	getMostSellingProducts	0.380421	9	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.704178
526	default	2026-05-12 10:29:41.053797	\N	InternalSession	\N	0.072375	5	f	\N	\N	\N	\N	f	2026-05-12 10:29:41.126175
527	default	2026-05-12 10:29:43.752043	\N	product	searchProductsWithOfferFilters	0.087729	11	f	\N	\N	\N	\N	f	2026-05-12 10:29:43.839786
615	default	2026-05-12 10:54:21.295884	\N	productRanking	getFrequentlyReorderedProducts	0.477202	9	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.773096
546	default	2026-05-12 10:32:12.056912	\N	InternalSession	\N	0.03161	3	f	\N	\N	\N	\N	f	2026-05-12 10:32:12.088567
557	default	2026-05-12 10:36:24.713437	\N	user	getUserByFirebaseUid	0.054822	4	f	\N	\N	\N	\N	f	2026-05-12 10:36:24.768266
566	default	2026-05-12 10:36:25.633949	\N	productRanking	getFrequentlyReorderedProducts	0.136112	9	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.770078
629	default	2026-05-12 11:31:39.14634	\N	banner	getBanners	0.206994	5	f	\N	\N	\N	\N	f	2026-05-12 11:31:39.353339
676	default	2026-05-12 11:40:33.066755	\N	user	getUserByFirebaseUid	0.041694	4	f	\N	\N	\N	\N	f	2026-05-12 11:40:33.108453
682	default	2026-05-12 11:40:34.008488	\N	productRanking	getMostSellingProducts	0.037886	9	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.046378
685	default	2026-05-12 11:40:34.080981	\N	freeDelivery	getDeliveryConfig	0.018361	1	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.099345
697	default	2026-05-12 11:41:48.704516	\N	banner	getBanners	0.068065	5	f	\N	\N	\N	\N	f	2026-05-12 11:41:48.772584
699	default	2026-05-12 11:41:48.706993	\N	banner	getBanners	0.078105	5	f	\N	\N	\N	\N	f	2026-05-12 11:41:48.785102
701	default	2026-05-12 11:41:49.679245	\N	product	getProductsByIds	0.049214	8	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.728464
702	default	2026-05-12 11:41:49.680492	\N	productRanking	getMostSellingProducts	0.052553	9	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.733056
703	default	2026-05-12 11:41:49.680059	\N	productRanking	getTrendingProducts	0.057913	9	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.737976
704	default	2026-05-12 11:41:49.681147	\N	productRanking	getFrequentlyReorderedProducts	0.055782	9	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.73694
705	default	2026-05-12 11:41:49.680849	\N	productRanking	getMostViewedProducts	0.068659	9	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.749512
706	default	2026-05-12 11:41:49.740913	\N	freeDelivery	getDeliveryConfig	0.016964	1	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.757881
707	default	2026-05-12 11:41:49.738982	\N	pricing	basketSuggestions	0.03751	23	f	\N	\N	\N	\N	f	2026-05-12 11:41:49.776498
709	default	2026-05-12 11:41:53.370757	\N	product	searchProductsWithOfferFilters	0.022757	12	f	\N	\N	\N	\N	f	2026-05-12 11:41:53.393523
710	default	2026-05-12 11:41:57.160871	\N	InternalSession	\N	0.010274	3	f	\N	\N	\N	\N	f	2026-05-12 11:41:57.171148
711	default	2026-05-12 11:41:57.160764	\N	InternalSession	\N	0.016671	3	f	\N	\N	\N	\N	f	2026-05-12 11:41:57.177437
712	default	2026-05-12 11:41:57.160361	\N	InternalSession	\N	0.030459	5	f	\N	\N	\N	\N	f	2026-05-12 11:41:57.190822
713	default	2026-05-12 11:42:02.502887	\N	product	searchProductsWithOfferFilters	0.017864	11	f	\N	\N	\N	\N	f	2026-05-12 11:42:02.520754
714	default	2026-05-12 11:42:09.545467	\N	product	searchProductsWithOfferFilters	0.020446	10	f	\N	\N	\N	\N	f	2026-05-12 11:42:09.565918
716	default	2026-05-12 11:48:14.856863	\N	product	getProducts	0.020126	8	f	\N	\N	\N	\N	f	2026-05-12 11:48:14.876992
717	default	2026-05-12 11:51:57.157723	\N	InternalSession	\N	0.014131	3	f	\N	\N	\N	\N	f	2026-05-12 11:51:57.171859
708	default	2026-05-12 11:41:49.945915	\N	orderRealtime	watchUserOrders	699.287724	1	f	\N	\N	\N	\N	f	2026-05-12 11:53:29.233651
718	default	2026-05-12 11:54:48.881857	\N	product	searchProductsWithOfferFilters	0.034743	10	f	\N	\N	\N	\N	f	2026-05-12 11:54:48.916605
719	default	2026-05-12 11:56:57.157735	\N	InternalSession	\N	0.010847	3	f	\N	\N	\N	\N	f	2026-05-12 11:56:57.168585
720	default	2026-05-12 12:01:57.160493	\N	InternalSession	\N	0.015599	3	f	\N	\N	\N	\N	f	2026-05-12 12:01:57.176095
721	default	2026-05-12 12:04:28.205937	\N	product	searchProducts	0.003774	0	f	\N	\N	\N	\N	f	2026-05-12 12:04:28.209719
722	default	2026-05-12 12:04:28.684863	\N	product	searchProducts	0.086192	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:28.77106
723	default	2026-05-12 12:04:28.800231	\N	product	searchProducts	0.023738	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:28.823973
724	default	2026-05-12 12:04:33.188744	\N	product	searchProductsWithOfferFilters	0.049854	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:33.238603
725	default	2026-05-12 12:04:46.277233	\N	product	searchProductsWithOfferFilters	0.049199	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:46.326437
726	default	2026-05-12 12:04:49.613255	\N	product	searchProductsWithOfferFilters	0.050489	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:49.663753
727	default	2026-05-12 12:04:51.957532	\N	product	searchProductsWithOfferFilters	0.059868	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:52.017413
728	default	2026-05-12 12:04:53.072889	\N	product	searchProductsWithOfferFilters	0.02228	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:53.095175
729	default	2026-05-12 12:04:54.778724	\N	product	searchProductsWithOfferFilters	0.016406	10	f	\N	\N	\N	\N	f	2026-05-12 12:04:54.795133
730	default	2026-05-12 12:05:04.829363	\N	product	searchProductsWithOfferFilters	0.015849	10	f	\N	\N	\N	\N	f	2026-05-12 12:05:04.845218
376	default	2026-05-12 09:29:40.312093	\N	product	searchProducts	0.001978	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:40.314074
753	default	2026-05-12 12:16:17.07047	\N	user	createOrUpdateUser	0.022657	8	f	\N	\N	\N	\N	f	2026-05-12 12:16:17.093131
425	default	2026-05-12 10:02:08.411486	\N	InternalSession	\N	0.058598	3	f	\N	\N	\N	\N	f	2026-05-12 10:02:08.470086
580	default	2026-05-12 10:42:00.070089	\N	banner	getBanners	0.099771	5	f	\N	\N	\N	\N	f	2026-05-12 10:42:00.169865
428	default	2026-05-12 10:04:11.201806	\N	user	getUserByFirebaseUid	0.115477	4	f	\N	\N	\N	\N	f	2026-05-12 10:04:11.317301
432	default	2026-05-12 10:04:11.206481	\N	product	getProducts	0.185383	9	f	\N	\N	\N	\N	f	2026-05-12 10:04:11.391873
584	default	2026-05-12 10:42:01.080847	\N	product	getProductsByIds	0.240651	8	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.321505
440	default	2026-05-12 10:04:12.341873	\N	pricing	basketSuggestions	0.425462	31	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.767349
443	default	2026-05-12 10:04:24.547278	\N	admin	getDashboardStats	0.009628	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:24.556916
445	default	2026-05-12 10:04:26.928761	\N	admin	completeFirebaseSetup	0.327412	3	f	\N	\N	\N	\N	f	2026-05-12 10:04:27.256181
446	default	2026-05-12 10:04:27.315701	\N	admin	firebaseLogin	0.004193	1	f	\N	\N	\N	\N	f	2026-05-12 10:04:27.319901
447	default	2026-05-12 10:04:30.107605	\N	product	getProductsPage	0.035567	10	f	\N	\N	\N	\N	f	2026-05-12 10:04:30.143179
450	default	2026-05-12 10:04:30.152825	\N	subCategory	getSubCategories	0.01459	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:30.167423
452	default	2026-05-12 10:04:33.102602	\N	bogo	getOfferForProduct	0.005324	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:33.10793
454	default	2026-05-12 10:04:33.587473	\N	categoryOffer	getCategoryOffersPage	0.020678	4	f	\N	\N	\N	\N	f	2026-05-12 10:04:33.608159
455	default	2026-05-12 10:04:33.648156	\N	bogo	getOffersPage	0.006194	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:33.654357
456	default	2026-05-12 10:04:41.694866	\N	product	updateProduct	0.059344	15	f	\N	\N	\N	\N	f	2026-05-12 10:04:41.754218
442	default	2026-05-12 10:04:24.470413	\N	orderRealtime	watchAdminOrders	34.11714	0	f	\N	\N	\N	\N	f	2026-05-12 10:04:58.587568
457	default	2026-05-12 10:04:58.595763	\N	product	searchProducts	0.004086	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:04:58.599856
468	default	2026-05-12 10:17:36.009893	\N	InternalSession	\N	0.046123	3	f	\N	\N	\N	\N	f	2026-05-12 10:17:36.056019
503	default	2026-05-12 10:26:39.945789	\N	product	searchProductsWithOfferFilters	0.001249	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:39.947044
524	default	2026-05-12 10:29:41.053906	\N	InternalSession	\N	0.041361	3	f	\N	\N	\N	\N	f	2026-05-12 10:29:41.09527
528	default	2026-05-12 10:29:45.057108	\N	product	searchProductsWithOfferFilters	0.007785	1	f	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:29:45.064901
547	default	2026-05-12 10:32:12.053269	\N	InternalSession	\N	0.042997	3	f	\N	\N	\N	\N	f	2026-05-12 10:32:12.09627
549	default	2026-05-12 10:32:12.056791	\N	InternalSession	\N	0.070564	5	f	\N	\N	\N	\N	f	2026-05-12 10:32:12.127358
550	default	2026-05-12 10:32:14.349869	\N	product	searchProductsWithOfferFilters	0.07324	12	f	\N	\N	\N	\N	f	2026-05-12 10:32:14.423123
551	default	2026-05-12 10:32:15.727831	\N	product	searchProductsWithOfferFilters	0.048771	11	f	\N	\N	\N	\N	f	2026-05-12 10:32:15.776612
552	default	2026-05-12 10:32:17.252512	\N	product	searchProductsWithOfferFilters	0.037097	10	f	\N	\N	\N	\N	f	2026-05-12 10:32:17.289624
553	default	2026-05-12 10:32:32.663523	\N	product	searchProductsWithOfferFilters	0.005866	2	f	\N	\N	\N	\N	f	2026-05-12 10:32:32.669393
554	default	2026-05-12 10:32:39.591684	\N	product	searchProductsWithOfferFilters	0.039663	10	f	\N	\N	\N	\N	f	2026-05-12 10:32:39.631355
555	default	2026-05-12 10:32:47.952465	\N	product	searchProductsWithOfferFilters	0.047856	10	f	\N	\N	\N	\N	f	2026-05-12 10:32:48.000336
556	default	2026-05-12 10:36:24.699553	\N	banner	getBanners	0.064873	5	f	\N	\N	\N	\N	f	2026-05-12 10:36:24.764434
560	default	2026-05-12 10:36:24.718112	\N	product	getProducts	0.07552	9	f	\N	\N	\N	\N	f	2026-05-12 10:36:24.793639
565	default	2026-05-12 10:36:25.633245	\N	productRanking	getMostViewedProducts	0.133626	9	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.766882
569	default	2026-05-12 10:36:30.070393	\N	product	searchProductsWithOfferFilters	0.041511	12	f	\N	\N	\N	\N	f	2026-05-12 10:36:30.111912
570	default	2026-05-12 10:36:32.57421	\N	product	searchProductsWithOfferFilters	0.032068	10	f	\N	\N	\N	\N	f	2026-05-12 10:36:32.606286
571	default	2026-05-12 10:37:12.056807	\N	InternalSession	\N	0.002582	1	f	\N	\N	\N	\N	f	2026-05-12 10:37:12.059392
377	default	2026-05-12 09:29:40.474663	\N	product	searchProducts	0.006056	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:29:40.480729
429	default	2026-05-12 10:04:11.212894	\N	banner	getBanners	0.139152	5	f	\N	\N	\N	\N	f	2026-05-12 10:04:11.352056
582	default	2026-05-12 10:42:01.140154	\N	freeDelivery	getDeliveryConfig	0.026204	1	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.166365
460	default	2026-05-12 10:05:03.903902	\N	product	searchProducts	0.002023	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:05:03.905929
470	default	2026-05-12 10:19:37.00267	\N	user	getUserByFirebaseUid	0.256317	4	f	\N	\N	\N	\N	f	2026-05-12 10:19:37.258995
477	default	2026-05-12 10:19:38.162399	\N	productRanking	getFrequentlyReorderedProducts	0.301798	9	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.464208
583	default	2026-05-12 10:42:01.3541	\N	orderRealtime	watchUserOrders	138.546221	1	f	\N	\N	\N	\N	f	2026-05-12 10:44:19.900351
492	default	2026-05-12 10:20:45.856522	\N	product	searchProductsWithOfferFilters	0.00715	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:20:45.86368
504	default	2026-05-12 10:26:43.409329	\N	product	searchProductsWithOfferFilters	0.000892	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:43.410225
603	default	2026-05-12 10:45:10.367068	\N	pricing	basketSuggestions	0.360953	31	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.728035
525	default	2026-05-12 10:29:41.053657	\N	InternalSession	\N	0.056113	3	f	\N	\N	\N	\N	f	2026-05-12 10:29:41.109772
529	default	2026-05-12 10:29:48.538276	\N	product	searchProductsWithOfferFilters	0.001119	1	f	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:29:48.539399
604	default	2026-05-12 10:46:29.991765	\N	product	searchProductsWithOfferFilters	0.027513	10	f	\N	\N	\N	\N	f	2026-05-12 10:46:30.019288
548	default	2026-05-12 10:32:12.056632	\N	InternalSession	\N	0.05384	3	f	\N	\N	\N	\N	f	2026-05-12 10:32:12.110475
558	default	2026-05-12 10:36:24.715997	\N	banner	getBanners	0.058709	5	f	\N	\N	\N	\N	f	2026-05-12 10:36:24.77471
605	default	2026-05-12 10:46:57.157939	\N	InternalSession	\N	0.008829	3	f	\N	\N	\N	\N	f	2026-05-12 10:46:57.166771
564	default	2026-05-12 10:36:25.631444	\N	productRanking	getTrendingProducts	0.128852	9	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.760304
606	default	2026-05-12 10:51:57.162693	\N	InternalSession	\N	0.024932	3	f	\N	\N	\N	\N	f	2026-05-12 10:51:57.187628
607	default	2026-05-12 10:54:19.994283	\N	user	getUserByFirebaseUid	0.231538	4	f	\N	\N	\N	\N	f	2026-05-12 10:54:20.225828
611	default	2026-05-12 10:54:20.041434	\N	product	getProducts	0.311925	9	f	\N	\N	\N	\N	f	2026-05-12 10:54:20.353377
616	default	2026-05-12 10:54:21.249138	\N	productRanking	getTrendingProducts	0.530377	9	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.779528
619	default	2026-05-12 10:54:21.352201	\N	pricing	basketSuggestions	0.493539	31	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.845757
620	default	2026-05-12 10:55:21.955119	\N	product	searchProductsWithOfferFilters	0.032574	10	f	\N	\N	\N	\N	f	2026-05-12 10:55:21.987703
677	default	2026-05-12 11:40:33.065626	\N	banner	getBanners	0.046388	5	f	\N	\N	\N	\N	f	2026-05-12 11:40:33.112018
681	default	2026-05-12 11:40:34.007867	\N	productRanking	getTrendingProducts	0.039244	9	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.047115
686	default	2026-05-12 11:40:34.078558	\N	pricing	basketSuggestions	0.057867	31	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.136432
688	default	2026-05-12 11:40:54.936411	\N	product	searchProductsWithOfferFilters	0.023738	11	f	\N	\N	\N	\N	f	2026-05-12 11:40:54.960155
689	default	2026-05-12 11:40:57.966424	\N	product	searchProductsWithOfferFilters	0.017126	12	f	\N	\N	\N	\N	f	2026-05-12 11:40:57.983554
687	default	2026-05-12 11:40:34.253529	\N	orderRealtime	watchUserOrders	69.076789	1	f	\N	\N	\N	\N	f	2026-05-12 11:41:43.330329
754	default	2026-05-12 12:16:17.10834	\N	user	createOrUpdateUser	0.026561	10	f	\N	\N	\N	\N	f	2026-05-12 12:16:17.134905
384	default	2026-05-12 09:39:13.221162	\N	banner	getBanners	0.134113	5	f	\N	\N	\N	\N	f	2026-05-12 09:39:13.35528
431	default	2026-05-12 10:04:11.209093	\N	banner	getBanners	0.144256	5	f	\N	\N	\N	\N	f	2026-05-12 10:04:11.353355
396	default	2026-05-12 09:39:20.952386	\N	product	searchProducts	0.002637	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:39:20.955026
568	default	2026-05-12 10:36:25.836129	\N	orderRealtime	watchUserOrders	200.023738	1	f	\N	\N	\N	\N	f	2026-05-12 10:39:45.859914
439	default	2026-05-12 10:04:12.290003	\N	productRanking	getMostSellingProducts	0.421177	9	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.711188
434	default	2026-05-12 10:04:12.56894	\N	orderRealtime	watchUserOrders	8.341739	1	f	\N	\N	\N	\N	f	2026-05-12 10:04:20.910717
588	default	2026-05-12 10:42:01.086082	\N	productRanking	getFrequentlyReorderedProducts	0.366634	9	f	\N	\N	\N	\N	f	2026-05-12 10:42:01.452724
449	default	2026-05-12 10:04:30.151562	\N	category	getCategories	0.013796	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:30.165366
608	default	2026-05-12 10:54:20.038829	\N	banner	getBanners	0.206583	5	f	\N	\N	\N	\N	f	2026-05-12 10:54:20.245638
458	default	2026-05-12 10:04:59.798011	\N	product	searchProducts	0.002003	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:04:59.800018
471	default	2026-05-12 10:19:37.005713	\N	banner	getBanners	0.272911	5	f	\N	\N	\N	\N	f	2026-05-12 10:19:37.278637
612	default	2026-05-12 10:54:21.365622	\N	freeDelivery	getDeliveryConfig	0.036608	1	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.402234
475	default	2026-05-12 10:19:38.210249	\N	freeDelivery	getDeliveryConfig	0.05932	1	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.269587
476	default	2026-05-12 10:19:38.155656	\N	product	getProductsByIds	0.301963	8	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.457626
614	default	2026-05-12 10:54:21.22615	\N	product	getProductsByIds	0.541009	8	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.767168
493	default	2026-05-12 10:20:48.315131	\N	product	searchProductsWithOfferFilters	0.001418	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:20:48.316553
505	default	2026-05-12 10:26:47.708317	\N	product	searchProductsWithOfferFilters	0.000804	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:47.709125
618	default	2026-05-12 10:54:21.276708	\N	productRanking	getMostViewedProducts	0.543623	9	f	\N	\N	\N	\N	f	2026-05-12 10:54:21.820349
530	default	2026-05-12 10:29:50.176523	\N	product	searchProductsWithOfferFilters	0.000963	1	f	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:29:50.17749
559	default	2026-05-12 10:36:24.716992	\N	banner	getBanners	0.056507	5	f	\N	\N	\N	\N	f	2026-05-12 10:36:24.773508
633	default	2026-05-12 11:31:40.262392	\N	freeDelivery	getDeliveryConfig	0.129736	1	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.392134
563	default	2026-05-12 10:36:25.632552	\N	productRanking	getMostSellingProducts	0.128747	9	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.761304
634	default	2026-05-12 11:31:40.240591	\N	product	getProductsByIds	0.373469	8	f	\N	\N	\N	\N	f	2026-05-12 11:31:40.614063
678	default	2026-05-12 11:40:33.073104	\N	banner	getBanners	0.047477	5	f	\N	\N	\N	\N	f	2026-05-12 11:40:33.120587
684	default	2026-05-12 11:40:34.009455	\N	productRanking	getFrequentlyReorderedProducts	0.038206	9	f	\N	\N	\N	\N	f	2026-05-12 11:40:34.047663
690	default	2026-05-12 11:40:59.092167	\N	product	searchProductsWithOfferFilters	0.018599	11	f	\N	\N	\N	\N	f	2026-05-12 11:40:59.11077
691	default	2026-05-12 11:41:09.345108	\N	product	searchProductsWithOfferFilters	0.020849	10	f	\N	\N	\N	\N	f	2026-05-12 11:41:09.365962
692	default	2026-05-12 11:41:12.916376	\N	product	searchProductsWithOfferFilters	0.01814	10	f	\N	\N	\N	\N	f	2026-05-12 11:41:12.93452
693	default	2026-05-12 11:41:13.842238	\N	product	searchProductsWithOfferFilters	0.020875	10	f	\N	\N	\N	\N	f	2026-05-12 11:41:13.863118
383	default	2026-05-12 09:39:13.216459	\N	banner	getBanners	0.13574	5	f	\N	\N	\N	\N	f	2026-05-12 09:39:13.352207
387	default	2026-05-12 09:39:14.308334	\N	freeDelivery	getDeliveryConfig	0.087239	1	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.395583
430	default	2026-05-12 10:04:11.212129	\N	banner	getBanners	0.142611	5	f	\N	\N	\N	\N	f	2026-05-12 10:04:11.354748
390	default	2026-05-12 09:39:14.295117	\N	productRanking	getTrendingProducts	0.25942	9	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.55454
590	default	2026-05-12 10:44:04.685292	\N	product	searchProductsWithOfferFilters	0.04641	10	f	\N	\N	\N	\N	f	2026-05-12 10:44:04.73171
395	default	2026-05-12 09:39:19.518352	\N	product	searchProducts	0.006142	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:39:19.524504
437	default	2026-05-12 10:04:12.291393	\N	productRanking	getFrequentlyReorderedProducts	0.415694	9	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.707094
451	default	2026-05-12 10:04:30.154503	\N	subCategory	getSubCategories	0.013768	2	f	\N	\N	\N	\N	f	2026-05-12 10:04:30.168274
591	default	2026-05-12 10:45:09.324483	\N	user	getUserByFirebaseUid	0.083905	4	f	\N	\N	\N	\N	f	2026-05-12 10:45:09.408399
459	default	2026-05-12 10:05:01.822763	\N	product	searchProducts	0.001959	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:05:01.824727
472	default	2026-05-12 10:19:36.973323	\N	banner	getBanners	0.309493	5	f	\N	\N	\N	\N	f	2026-05-12 10:19:37.282829
594	default	2026-05-12 10:45:09.333519	\N	banner	getBanners	0.107999	5	f	\N	\N	\N	\N	f	2026-05-12 10:45:09.441526
474	default	2026-05-12 10:19:37.00846	\N	product	getProducts	0.325126	9	f	\N	\N	\N	\N	f	2026-05-12 10:19:37.333598
481	default	2026-05-12 10:19:38.214473	\N	pricing	basketSuggestions	0.309284	31	f	\N	\N	\N	\N	f	2026-05-12 10:19:38.52377
595	default	2026-05-12 10:45:09.338849	\N	product	getProducts	0.126186	9	f	\N	\N	\N	\N	f	2026-05-12 10:45:09.465046
483	default	2026-05-12 10:19:47.50971	\N	product	searchProducts	0.063555	10	f	\N	\N	\N	\N	f	2026-05-12 10:19:47.573273
484	default	2026-05-12 10:19:49.832444	\N	product	searchProducts	0.031236	10	f	\N	\N	\N	\N	f	2026-05-12 10:19:49.863693
601	default	2026-05-12 10:45:10.325048	\N	productRanking	getFrequentlyReorderedProducts	0.376424	9	f	\N	\N	\N	\N	f	2026-05-12 10:45:10.701484
485	default	2026-05-12 10:19:53.212897	\N	product	searchProducts	0.030485	10	f	\N	\N	\N	\N	f	2026-05-12 10:19:53.243389
486	default	2026-05-12 10:19:58.333634	\N	productRanking	recordProductView	0.007549	0	f	\N	\N	\N	\N	f	2026-05-12 10:19:58.341199
487	default	2026-05-12 10:20:00.155709	\N	product	searchProducts	0.028	10	f	\N	\N	\N	\N	f	2026-05-12 10:20:00.183719
488	default	2026-05-12 10:20:02.229456	\N	product	searchProductsWithOfferFilters	0.032425	12	f	\N	\N	\N	\N	f	2026-05-12 10:20:02.261889
489	default	2026-05-12 10:20:29.595957	\N	product	searchProductsWithOfferFilters	0.010856	3	f	\N	\N	\N	\N	f	2026-05-12 10:20:29.606821
490	default	2026-05-12 10:20:33.054472	\N	product	searchProductsWithOfferFilters	0.040292	10	f	\N	\N	\N	\N	f	2026-05-12 10:20:33.094774
491	default	2026-05-12 10:20:39.096389	\N	product	searchProductsWithOfferFilters	0.038559	11	f	\N	\N	\N	\N	f	2026-05-12 10:20:39.134954
613	default	2026-05-12 10:54:21.571585	\N	orderRealtime	watchUserOrders	810.207171	1	f	\N	\N	\N	\N	f	2026-05-12 11:07:51.779859
506	default	2026-05-12 10:26:49.858459	\N	product	searchProductsWithOfferFilters	0.000811	1	f	Invalid argument (parameters): Contains superfluous variables: query: _Map len:1	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:136:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:26:49.859275
507	default	2026-05-12 10:26:50.780524	\N	product	searchProductsWithOfferFilters	0.024994	11	f	\N	\N	\N	\N	f	2026-05-12 10:26:50.805522
531	default	2026-05-12 10:29:51.199656	\N	product	searchProductsWithOfferFilters	0.001301	1	f	Invalid argument (parameters): Contains superfluous variables: limit, offset: _Map len:2	#0      InternalQueryDescription.bindParameters (package:postgres/src/v3/query_description.dart:222:9)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:144:35)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresOfferSearchService.getProductsByOffer (package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart:144:25)\n<asynchronous suspension>\n#8      Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#9      Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#10     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#11     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#12     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#13     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#14     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 10:29:51.200962
532	default	2026-05-12 10:30:11.474233	\N	user	getUserByFirebaseUid	0.067615	4	f	\N	\N	\N	\N	f	2026-05-12 10:30:11.541859
715	default	2026-05-12 11:46:57.157714	\N	InternalSession	\N	0.00655	3	f	\N	\N	\N	\N	f	2026-05-12 11:46:57.16427
533	default	2026-05-12 10:30:11.494027	\N	banner	getBanners	0.076685	5	f	\N	\N	\N	\N	f	2026-05-12 10:30:11.570722
536	default	2026-05-12 10:30:11.496353	\N	product	getProducts	0.094547	9	f	\N	\N	\N	\N	f	2026-05-12 10:30:11.590908
542	default	2026-05-12 10:30:12.503787	\N	productRanking	getFrequentlyReorderedProducts	0.472799	9	f	\N	\N	\N	\N	f	2026-05-12 10:30:12.976595
544	default	2026-05-12 10:30:13.844035	\N	orderRealtime	watchUserOrders	107.344312	1	f	\N	\N	\N	\N	f	2026-05-12 10:32:01.188393
561	default	2026-05-12 10:36:25.651236	\N	freeDelivery	getDeliveryConfig	0.021151	1	f	\N	\N	\N	\N	f	2026-05-12 10:36:25.6724
385	default	2026-05-12 09:39:13.222302	\N	banner	getBanners	0.148408	5	f	\N	\N	\N	\N	f	2026-05-12 09:39:13.370717
433	default	2026-05-12 10:04:12.336057	\N	freeDelivery	getDeliveryConfig	0.06328	1	f	\N	\N	\N	\N	f	2026-05-12 10:04:12.399344
386	default	2026-05-12 09:39:13.223144	\N	product	getProducts	0.174487	9	f	\N	\N	\N	\N	f	2026-05-12 09:39:13.397637
389	default	2026-05-12 09:39:14.293732	\N	product	getProductsByIds	0.253602	8	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.547338
392	default	2026-05-12 09:39:14.296414	\N	productRanking	getMostViewedProducts	0.259381	9	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.555799
391	default	2026-05-12 09:39:14.295903	\N	productRanking	getMostSellingProducts	0.257187	9	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.553107
393	default	2026-05-12 09:39:14.296923	\N	productRanking	getFrequentlyReorderedProducts	0.261416	9	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.558343
394	default	2026-05-12 09:39:14.310626	\N	pricing	basketSuggestions	0.260959	31	f	\N	\N	\N	\N	f	2026-05-12 09:39:14.571597
397	default	2026-05-12 09:39:22.683992	\N	product	searchProducts	0.002098	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:39:22.686095
398	default	2026-05-12 09:39:24.499405	\N	product	searchProducts	0.002228	1	f	DatabaseQueryException: { message: function similarity(text, text) does not exist, code: 42883, hint: No function matches the given name and argument types. You might need to add explicit type casts., position: 300 }	#0      _PgSessionBase._prepare (package:postgres/src/v3/connection.dart:199:35)\n#1      _PgSessionBase.execute (package:postgres/src/v3/connection.dart:183:30)\n#2      _PoolConnection.execute (package:postgres/src/pool/pool_impl.dart:309:24)\n#3      PoolImplementation.execute.<anonymous closure> (package:postgres/src/pool/pool_impl.dart:64:34)\n#4      PoolImplementation.withConnection (package:postgres/src/pool/pool_impl.dart:153:24)\n<asynchronous suspension>\n#5      PostgresDatabaseConnection._query (package:serverpod/src/database/adapters/postgres/database_connection.dart:562:20)\n<asynchronous suspension>\n#6      PostgresDatabaseConnection.query (package:serverpod/src/database/adapters/postgres/database_connection.dart:530:18)\n<asynchronous suspension>\n#7      PostgresCatalogService._countSearchProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:296:20)\n<asynchronous suspension>\n#8      PostgresCatalogService.searchActiveProducts (package:freshpickkat_server/src/services/postgres/postgres_catalog_service.dart:142:24)\n<asynchronous suspension>\n#9      ProductEndpoint.searchProducts (package:freshpickkat_server/src/endpoints/product_endpoint.dart:183:20)\n<asynchronous suspension>\n#10     Server._handleEndpointCall (package:serverpod/src/server/server.dart:509:22)\n<asynchronous suspension>\n#11     Server._endpoints (package:serverpod/src/server/server.dart:376:12)\n<asynchronous suspension>\n#12     Server._reportException.<anonymous closure> (package:serverpod/src/server/server.dart:207:16)\n<asynchronous suspension>\n#13     Server._headers.<anonymous closure> (package:serverpod/src/server/server.dart:351:22)\n<asynchronous suspension>\n#14     _RoutingMiddlewareBuilder.call.<anonymous closure> (package:relic_core/src/middleware/routing_middleware.dart:135:18)\n<asynchronous suspension>\n#15     _RelicServer._wrapHandlerWithMiddleware.<anonymous closure> (package:relic_core/src/relic_server.dart:156:24)\n<asynchronous suspension>\n#16     _RelicServer._handleRequest (package:relic_core/src/relic_server.dart:132:22)\n<asynchronous suspension>\n	\N	\N	f	2026-05-12 09:39:24.501638
388	default	2026-05-12 09:39:14.446368	\N	orderRealtime	watchUserOrders	22.185015	1	f	\N	\N	\N	\N	f	2026-05-12 09:39:36.631397
399	default	2026-05-12 09:40:06.380217	\N	category	getCategories	0.007606	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:06.387827
400	default	2026-05-12 09:40:06.381555	\N	subCategory	getSubCategories	0.005544	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:06.387109
401	default	2026-05-12 09:40:06.425407	\N	category	getCategories	0.006311	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:06.431722
402	default	2026-05-12 09:40:06.430732	\N	subCategory	getSubCategories	0.021185	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:06.451924
403	default	2026-05-12 09:40:06.508099	\N	product	getProductsPage	0.332614	11	f	\N	\N	\N	\N	f	2026-05-12 09:40:06.840718
404	default	2026-05-12 09:40:08.799195	\N	bogo	getOfferForProduct	0.008137	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:08.807339
405	default	2026-05-12 09:40:11.257126	\N	bogo	getOffersPage	0.009235	2	f	\N	\N	\N	\N	f	2026-05-12 09:40:11.266371
406	default	2026-05-12 09:40:11.258696	\N	comboOffer	getComboOffersPage	0.01329	3	f	\N	\N	\N	\N	f	2026-05-12 09:40:11.271991
407	default	2026-05-12 09:40:11.258155	\N	categoryOffer	getCategoryOffersPage	0.018855	4	f	\N	\N	\N	\N	f	2026-05-12 09:40:11.277017
408	default	2026-05-12 09:40:11.37717	\N	product	updateProduct	0.050984	4	f	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	\N	\N	f	2026-05-12 09:40:11.428166
409	default	2026-05-12 09:40:17.46945	\N	product	updateProduct	0.01055	4	f	DatabaseQueryException: { message: update or delete on table "product_variant" violates foreign key constraint "bogo_offer_fk_1" on table "bogo_offer", code: 23503, detail: Key (id)=(8def6c42-bcfb-492b-aa78-88fcce546c83) is still referenced from table "bogo_offer"., table: bogo_offer, constraint: bogo_offer_fk_1 }	package:postgres/src/v3/connection.dart 930:37                                                 _PgResultStreamSubscription.handleError\npackage:postgres/src/v3/connection.dart 530:21                                                 PgConnectionImplementation._handleMessage\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/zone.dart 633:7                                                                     _CustomZone.runUnaryGuarded\ndart:async/stream_impl.dart 381:11                                                             _BufferingStreamSubscription._sendData\ndart:async/stream_impl.dart 312:7                                                              _BufferingStreamSubscription._add\ndart:async/stream_controller.dart 798:19                                                       _SyncStreamControllerDispatch._sendData\ndart:async/stream_controller.dart 663:7                                                        _StreamController._add\ndart:async/stream_controller.dart 618:5                                                        _StreamController.add\ndart:async/stream.dart 823:20                                                                  Stream.asyncMap.<fn>.add\ndart:async/zone_root.dart 48:47                                                                _rootRunUnary\ndart:async/zone.dart 733:19                                                                    _CustomZone.runUnary\ndart:async/stream_impl.dart 215:3                                                              _BufferingStreamSubscription.resume\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 718:35                                                 _PreparedStatement.run\npackage:postgres/src/v3/connection.dart 185:31                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:20               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:18               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:18               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:12               PostgresDatabaseConnection.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:5   PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:7   PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n===== asynchronous gap ===========================\npackage:postgres/src/v3/connection.dart 199:35                                                 _PgSessionBase._prepare\npackage:postgres/src/v3/connection.dart 183:30                                                 _PgSessionBase.execute\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 562:34               PostgresDatabaseConnection._query\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 660:24               PostgresDatabaseConnection._mappedResultsQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 693:24               PostgresDatabaseConnection._deserializedMappedQuery\npackage:serverpod/src/database/adapters/postgres/database_connection.dart 469:18               PostgresDatabaseConnection.deleteWhere\npackage:serverpod/src/database/database.dart 398:32                                            Database.deleteWhere\npackage:freshpickkat_server/src/generated/product_variant_row.dart 741:23                      ProductVariantRowRepository.deleteWhere\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 641:32  PostgresProductCompatService._replaceProductVariants\npackage:freshpickkat_server/src/services/postgres/postgres_product_compat_service.dart 387:13  PostgresProductCompatService.updateProduct.<fn>\npackage:postgres/src/v3/connection.dart 591:24                                                 PgConnectionImplementation.runTx.<fn>\npackage:pool/pool.dart 127:14                                                                  Pool.withResource\npackage:postgres/src/pool/pool_impl.dart 153:16                                                PoolImplementation.withConnection\npackage:serverpod/src/database/database.dart 514:12                                            Database.transaction\npackage:freshpickkat_server/src/endpoints/product_endpoint.dart 136:5                          ProductEndpoint.updateProduct\npackage:serverpod/src/server/server.dart 509:22                                                Server._handleEndpointCall\npackage:serverpod/src/server/server.dart 376:12                                                Server._endpoints\npackage:serverpod/src/server/server.dart 207:16                                                Server._reportException.<fn>\npackage:serverpod/src/server/server.dart 351:22                                                Server._headers.<fn>\npackage:relic_core/src/middleware/routing_middleware.dart 135:18                               _RoutingMiddlewareBuilder.call.<fn>\npackage:relic_core/src/relic_server.dart 156:24                                                _RelicServer._wrapHandlerWithMiddleware.<fn>\npackage:relic_core/src/relic_server.dart 132:22                                                _RelicServer._handleRequest\n	\N	\N	f	2026-05-12 09:40:17.480012
410	default	2026-05-12 09:40:23.228549	\N	product	updateProduct	0.057344	15	f	\N	\N	\N	\N	f	2026-05-12 09:40:23.285903
731	default	2026-05-12 12:05:06.672247	\N	product	searchProductsWithOfferFilters	0.016911	10	f	\N	\N	\N	\N	f	2026-05-12 12:05:06.689162
755	default	2026-05-12 12:16:26.887201	\N	bogo	getActiveBogoOffersForProducts	0.002839	1	f	\N	\N	\N	\N	f	2026-05-12 12:16:26.890042
757	default	2026-05-12 12:16:26.883493	\N	product	getProductsByIds	0.018118	7	f	\N	\N	\N	\N	f	2026-05-12 12:16:26.901618
758	default	2026-05-12 12:16:26.915781	\N	pricing	calculateCartPricing	0.024606	18	f	\N	\N	\N	\N	f	2026-05-12 12:16:26.94039
759	default	2026-05-12 12:16:27.173352	\N	user	updateCart	0.007574	4	f	\N	\N	\N	\N	f	2026-05-12 12:16:27.180931
760	default	2026-05-12 12:16:34.269559	\N	checkout	createOrderAndPayment	0.074702	9	f	\N	\N	\N	\N	f	2026-05-12 12:16:34.344272
761	default	2026-05-12 12:16:57.157737	\N	InternalSession	\N	0.005862	3	f	\N	\N	\N	\N	f	2026-05-12 12:16:57.1636
762	default	2026-05-12 12:18:15.035997	\N	checkout	createOrderAndPayment	0.018103	9	f	\N	\N	\N	\N	f	2026-05-12 12:18:15.054103
763	default	2026-05-12 12:21:57.15777	\N	InternalSession	\N	0.012779	3	f	\N	\N	\N	\N	f	2026-05-12 12:21:57.170552
764	default	2026-05-12 12:26:57.157771	\N	InternalSession	\N	0.007415	3	f	\N	\N	\N	\N	f	2026-05-12 12:26:57.165188
765	default	2026-05-12 12:31:57.158437	\N	InternalSession	\N	0.012829	3	f	\N	\N	\N	\N	f	2026-05-12 12:31:57.171271
767	default	2026-05-12 12:37:10.209715	\N	InternalSession	\N	0.1007	3	f	\N	\N	\N	\N	f	2026-05-12 12:37:10.310419
770	default	2026-05-12 12:37:28.741308	\N	comboOffer	getActiveComboOffersForProducts	0.015907	1	f	\N	\N	\N	\N	f	2026-05-12 12:37:28.757219
782	default	2026-05-12 12:37:56.25575	\N	order	cancelOrder	0.051796	23	f	\N	\N	\N	\N	f	2026-05-12 12:37:56.30755
790	default	2026-05-12 12:38:23.2041	\N	user	updateCart	0.021731	4	f	\N	\N	\N	\N	f	2026-05-12 12:38:23.225838
792	default	2026-05-12 12:38:25.706755	\N	bogo	getActiveBogoOffersForProducts	0.013146	1	f	\N	\N	\N	\N	f	2026-05-12 12:38:25.719906
797	default	2026-05-12 12:38:28.409545	\N	checkout	createOrderAndPayment	5.185072	11	t	\N	\N	\N	\N	f	2026-05-12 12:38:33.594624
798	default	2026-05-12 12:38:33.663732	\N	orderTracking	seedUserLocation	0.030329	11	f	\N	\N	\N	\N	f	2026-05-12 12:38:33.694066
799	default	2026-05-12 12:38:44.384329	\N	payment	verifyPayment	0.079234	13	f	\N	\N	\N	\N	f	2026-05-12 12:38:44.463568
800	default	2026-05-12 12:38:44.526778	\N	order	getOrderById	0.022637	13	f	\N	\N	\N	\N	f	2026-05-12 12:38:44.54942
801	default	2026-05-12 12:38:44.45499	\N	InternalSession	\N	1.174246	9	t	\N	\N	\N	\N	f	2026-05-12 12:38:45.629239
804	default	2026-05-12 12:38:57.471937	\N	admin	getDashboardStats	0.292784	2	f	\N	\N	\N	\N	f	2026-05-12 12:38:57.764727
805	default	2026-05-12 12:38:57.47609	\N	admin	getAnalytics	0.327788	3	f	\N	\N	\N	\N	f	2026-05-12 12:38:57.803889
806	default	2026-05-12 12:39:00.563433	\N	admin	completeFirebaseSetup	0.269617	3	f	\N	\N	\N	\N	f	2026-05-12 12:39:00.833056
807	default	2026-05-12 12:39:00.850979	\N	admin	firebaseLogin	0.00364	1	f	\N	\N	\N	\N	f	2026-05-12 12:39:00.854624
808	default	2026-05-12 12:39:05.208607	\N	order	getOrdersPage	0.17965	7	f	\N	\N	\N	\N	f	2026-05-12 12:39:05.388274
803	default	2026-05-12 12:38:57.251837	\N	orderRealtime	watchAdminOrders	51.827791	1	f	\N	\N	\N	\N	f	2026-05-12 12:39:49.081554
811	default	2026-05-12 12:40:02.285799	\N	admin	getDashboardStats	0.01784	2	f	\N	\N	\N	\N	f	2026-05-12 12:40:02.303646
812	default	2026-05-12 12:40:02.311249	\N	admin	getAnalytics	0.048688	3	f	\N	\N	\N	\N	f	2026-05-12 12:40:02.359944
813	default	2026-05-12 12:40:05.413247	\N	admin	completeFirebaseSetup	0.554976	3	f	\N	\N	\N	\N	f	2026-05-12 12:40:05.968228
814	default	2026-05-12 12:40:06.013558	\N	admin	firebaseLogin	0.004534	1	f	\N	\N	\N	\N	f	2026-05-12 12:40:06.018098
816	default	2026-05-12 12:41:17.179361	\N	pricing	basketSuggestions	0.454878	36	f	\N	\N	\N	\N	f	2026-05-12 12:41:17.634248
809	default	2026-05-12 12:40:01.604431	\N	orderRealtime	watchAdminOrders	78.945723	0	f	\N	\N	\N	\N	f	2026-05-12 12:41:20.550166
822	default	2026-05-12 12:47:10.208826	\N	InternalSession	\N	0.010327	3	f	\N	\N	\N	\N	f	2026-05-12 12:47:10.219156
823	default	2026-05-12 12:52:10.208796	\N	InternalSession	\N	0.017428	3	f	\N	\N	\N	\N	f	2026-05-12 12:52:10.226226
824	default	2026-05-12 12:57:10.208763	\N	InternalSession	\N	0.02749	3	f	\N	\N	\N	\N	f	2026-05-12 12:57:10.236255
825	default	2026-05-12 13:02:10.20933	\N	InternalSession	\N	0.00859	3	f	\N	\N	\N	\N	f	2026-05-12 13:02:10.217923
733	default	2026-05-12 12:11:57.16057	\N	InternalSession	\N	0.00696	3	f	\N	\N	\N	\N	f	2026-05-12 12:11:57.167534
756	default	2026-05-12 12:16:26.888224	\N	comboOffer	getActiveComboOffersForProducts	0.002208	1	f	\N	\N	\N	\N	f	2026-05-12 12:16:26.890435
734	default	2026-05-12 12:12:34.723727	\N	pricing	calculateCartPricing	0.160199	18	f	\N	\N	\N	\N	f	2026-05-12 12:12:34.883938
735	default	2026-05-12 12:12:34.897741	\N	pricing	basketSuggestions	0.095613	16	f	\N	\N	\N	\N	f	2026-05-12 12:12:34.993365
766	default	2026-05-12 12:37:10.203253	\N	InternalSession	\N	0.079489	3	f	\N	\N	\N	\N	f	2026-05-12 12:37:10.282839
736	default	2026-05-12 12:12:34.891016	\N	coupon	getAvailableCoupons	0.115678	11	f	\N	\N	\N	\N	f	2026-05-12 12:12:35.006704
737	default	2026-05-12 12:12:35.040351	\N	comboOffer	getActiveComboOffers	0.006353	3	f	\N	\N	\N	\N	f	2026-05-12 12:12:35.046709
768	default	2026-05-12 12:37:10.209131	\N	InternalSession	\N	0.131421	3	f	\N	\N	\N	\N	f	2026-05-12 12:37:10.340556
739	default	2026-05-12 12:12:36.400731	\N	banner	getBanners	0.024262	5	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.424999
769	default	2026-05-12 12:37:10.209469	\N	InternalSession	\N	0.159735	5	f	\N	\N	\N	\N	f	2026-05-12 12:37:10.369207
738	default	2026-05-12 12:12:36.403324	\N	bogo	getActiveBogoOffersForProducts	0.0094	1	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.412727
740	default	2026-05-12 12:12:36.402618	\N	product	getProductsByIds	0.025994	7	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.42862
741	default	2026-05-12 12:12:36.404955	\N	comboOffer	getActiveComboOffersForProducts	0.027539	1	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.432498
771	default	2026-05-12 12:37:28.743513	\N	bogo	getActiveBogoOffersForProducts	0.009527	1	f	\N	\N	\N	\N	f	2026-05-12 12:37:28.753055
742	default	2026-05-12 12:12:36.478006	\N	pricing	calculateCartPricing	0.025998	18	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.504007
772	default	2026-05-12 12:37:28.733504	\N	product	getProductsByIds	0.073829	7	f	\N	\N	\N	\N	f	2026-05-12 12:37:28.807347
743	default	2026-05-12 12:12:36.571416	\N	category	getCategories	0.011311	2	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.582735
744	default	2026-05-12 12:12:36.572164	\N	subCategory	getSubCategories	0.009047	2	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.581223
745	default	2026-05-12 12:12:36.733398	\N	user	updateCart	0.033237	4	f	\N	\N	\N	\N	f	2026-05-12 12:12:36.766641
773	default	2026-05-12 12:37:28.836781	\N	pricing	calculateCartPricing	0.078078	18	f	\N	\N	\N	\N	f	2026-05-12 12:37:28.914866
746	default	2026-05-12 12:13:21.971505	\N	bogo	getActiveBogoOffersForProducts	0.00312	1	f	\N	\N	\N	\N	f	2026-05-12 12:13:21.974627
747	default	2026-05-12 12:13:21.972554	\N	comboOffer	getActiveComboOffersForProducts	0.008044	1	f	\N	\N	\N	\N	f	2026-05-12 12:13:21.980605
774	default	2026-05-12 12:37:29.106482	\N	user	updateCart	0.023188	4	f	\N	\N	\N	\N	f	2026-05-12 12:37:29.129679
748	default	2026-05-12 12:13:21.97355	\N	product	getProductsByIds	0.020542	7	f	\N	\N	\N	\N	f	2026-05-12 12:13:21.994094
749	default	2026-05-12 12:13:22.009562	\N	pricing	calculateCartPricing	0.029425	18	f	\N	\N	\N	\N	f	2026-05-12 12:13:22.03899
775	default	2026-05-12 12:37:29.675039	\N	checkout	createOrderAndPayment	0.568237	11	f	\N	\N	\N	\N	f	2026-05-12 12:37:30.243283
750	default	2026-05-12 12:13:22.150249	\N	banner	getBanners	0.010821	5	f	\N	\N	\N	\N	f	2026-05-12 12:13:22.161074
751	default	2026-05-12 12:13:22.269336	\N	user	updateCart	0.012642	4	f	\N	\N	\N	\N	f	2026-05-12 12:13:22.281986
776	default	2026-05-12 12:37:31.074532	\N	orderTracking	seedUserLocation	0.637779	11	f	\N	\N	\N	\N	f	2026-05-12 12:37:31.712319
777	default	2026-05-12 12:37:47.769296	\N	payment	verifyPayment	0.087633	13	f	\N	\N	\N	\N	f	2026-05-12 12:37:47.856939
778	default	2026-05-12 12:37:47.943751	\N	order	getOrderById	0.029691	13	f	\N	\N	\N	\N	f	2026-05-12 12:37:47.973449
779	default	2026-05-12 12:37:47.813148	\N	InternalSession	\N	1.29078	7	t	\N	\N	\N	\N	f	2026-05-12 12:37:49.103995
780	default	2026-05-12 12:37:51.954756	\N	order	getOrderById	0.028414	13	f	\N	\N	\N	\N	f	2026-05-12 12:37:51.983176
781	default	2026-05-12 12:37:52.011913	\N	refund	getRefundStatus	0.014729	4	f	\N	\N	\N	\N	f	2026-05-12 12:37:52.026651
783	default	2026-05-12 12:37:56.307404	\N	InternalSession	\N	0.002555	1	f	\N	\N	\N	\N	f	2026-05-12 12:37:56.309962
784	default	2026-05-12 12:37:56.328943	\N	order	getOrderById	0.026206	13	f	\N	\N	\N	\N	f	2026-05-12 12:37:56.355153
785	default	2026-05-12 12:37:56.373104	\N	refund	getRefundStatus	0.007885	4	f	\N	\N	\N	\N	f	2026-05-12 12:37:56.380993
786	default	2026-05-12 12:38:14.591826	\N	pricing	basketSuggestions	0.125176	36	f	\N	\N	\N	\N	f	2026-05-12 12:38:14.717019
787	default	2026-05-12 12:38:14.857416	\N	user	updateCart	0.027252	3	f	\N	\N	\N	\N	f	2026-05-12 12:38:14.884678
788	default	2026-05-12 12:38:22.982536	\N	pricing	calculateCartPricing	0.041874	18	f	\N	\N	\N	\N	f	2026-05-12 12:38:23.024415
789	default	2026-05-12 12:38:23.11074	\N	coupon	getAvailableCoupons	0.029484	11	f	\N	\N	\N	\N	f	2026-05-12 12:38:23.140241
791	default	2026-05-12 12:38:23.203036	\N	pricing	basketSuggestions	0.050202	8	f	\N	\N	\N	\N	f	2026-05-12 12:38:23.25325
793	default	2026-05-12 12:38:25.709508	\N	comboOffer	getActiveComboOffersForProducts	0.01318	1	f	\N	\N	\N	\N	f	2026-05-12 12:38:25.722692
794	default	2026-05-12 12:38:25.70606	\N	product	getProductsByIds	0.036787	7	f	\N	\N	\N	\N	f	2026-05-12 12:38:25.742854
795	default	2026-05-12 12:38:25.75623	\N	pricing	calculateCartPricing	0.040724	18	f	\N	\N	\N	\N	f	2026-05-12 12:38:25.796957
796	default	2026-05-12 12:38:26.010642	\N	user	updateCart	0.009789	4	f	\N	\N	\N	\N	f	2026-05-12 12:38:26.02044
802	default	2026-05-12 12:38:57.255853	\N	orderRealtime	watchDashboardUpdates	51.848467	1	f	\N	\N	\N	\N	f	2026-05-12 12:39:49.104334
815	default	2026-05-12 12:41:00.689457	\N	order	getOrdersPage	0.070611	7	f	\N	\N	\N	\N	f	2026-05-12 12:41:00.76008
818	default	2026-05-12 12:41:17.371442	\N	pricing	basketSuggestions	0.271969	31	f	\N	\N	\N	\N	f	2026-05-12 12:41:17.643416
817	default	2026-05-12 12:41:17.375517	\N	user	updateCart	0.259828	3	f	\N	\N	\N	\N	f	2026-05-12 12:41:17.63535
810	default	2026-05-12 12:40:01.613803	\N	orderRealtime	watchDashboardUpdates	78.937012	0	f	\N	\N	\N	\N	f	2026-05-12 12:41:20.550822
819	default	2026-05-12 12:41:27.918189	\N	user	getUserByFirebaseUid	0.016355	4	f	\N	\N	\N	\N	f	2026-05-12 12:41:27.934549
820	default	2026-05-12 12:41:29.553837	\N	order	getUserOrders	0.020454	9	f	\N	\N	\N	\N	f	2026-05-12 12:41:29.574296
821	default	2026-05-12 12:42:10.208975	\N	InternalSession	\N	0.027285	4	f	\N	\N	\N	\N	f	2026-05-12 12:42:10.236262
\.


--
-- Data for Name: sub_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_category (id, "categoryId", name, slug, "imageUrl", "displayOrder", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
d80729c8-922c-4c59-846d-c75b88b05758	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Apple & Pear	apple_pear	https://file.milkbasket.com/subcategories/Apple+%26+Pear_1727184764.png	0	active	\N	2026-05-12 05:22:27.162798	2026-05-12 05:22:27.162812
f8218f8b-b55a-44b6-b24a-909a2ffdf45d	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Banana, Papaya & Pineapple	banana_papaya_pineapple	https://file.milkbasket.com/subcategories/Banana+%26+Papaya+2_1727243942.png	0	active	\N	2026-05-12 05:23:52.635487	2026-05-12 05:23:52.63549
a49587a8-6cb8-4501-ba05-6c78e0d71a5c	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Berries, Guava & Sapota	berries_guava_sapota	https://file.milkbasket.com/subcategories/Berries%2C+Guava+%26+Sapota_1727184789.png	0	active	\N	2026-05-12 05:25:02.867486	2026-05-12 05:25:02.86749
1ed3786a-e5e8-47df-b55c-9d938c3b42a8	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Citrus & Pomegranate	citrus_pomegranate	https://file.milkbasket.com/subcategories/Citrus+%26+Pomegranate_1727184800.png	0	active	\N	2026-05-12 05:25:23.612382	2026-05-12 05:25:23.612385
e256adbd-eddf-4d95-bf26-75c711f103f5	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Coconut & Dates	coconut_dates	https://file.milkbasket.com/subcategories/Coconut+%26+Dates_1727184812.png	0	active	\N	2026-05-12 05:25:55.192265	2026-05-12 05:25:55.192269
2ac7c676-2d3f-4c58-98c1-75219953084f	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Dragon & Exotic Fruits	dragon_exotic_fruits	https://file.milkbasket.com/subcategories/International+Fruits_1727184827.png	0	active	\N	2026-05-12 05:26:20.893202	2026-05-12 05:26:20.893208
187cf555-03eb-425b-8687-87fed20b2310	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Kiwi & Avocado	kiwi_avocado	https://file.milkbasket.com/subcategories/Kiwi+%26+Avocado_1727184840.png	0	active	\N	2026-05-12 05:27:01.843286	2026-05-12 05:27:01.84329
d1d558ff-042e-4b80-9270-3872f54bb799	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Mango & Melons	mango_melons	https://file.milkbasket.com/subcategories/Mango+%26+Melons_1727184851.png	0	active	\N	2026-05-12 05:27:47.324782	2026-05-12 05:27:47.324785
4f1ca6d2-cb62-4db8-81cc-9710f07230b8	c5cbb6e8-fbb0-48c2-99a7-3643259dcaed	Stone Fruits	stone_fruits	https://file.milkbasket.com/subcategories/Stone+Fruits_1727184884.png	0	active	\N	2026-05-12 05:28:09.841408	2026-05-12 05:28:09.841411
ed71183a-1324-4336-9f82-ac9e95f575eb	0829417b-f54d-4baa-9732-d228d58ae666	Bhind, Gourds & Drumsticks	bhind_gourds_drumsticks	https://file.milkbasket.com/subcategories/Bhindi+%26+Gourds_1727186183.png	0	active	\N	2026-05-12 05:32:57.730994	2026-05-12 05:32:57.730997
8acd4d20-a95b-417f-a274-a06934c39267	0829417b-f54d-4baa-9732-d228d58ae666	Condiments & Leafy	condiments_leafy	https://file.milkbasket.com/subcategories/Condiments+%26+Leafy_1727186203.png	0	active	\N	2026-05-12 05:33:30.400441	2026-05-12 05:33:30.400445
4d362f94-2716-4ac4-a672-8b4e39aac5fe	0829417b-f54d-4baa-9732-d228d58ae666	Beans & Capsicum	beans_capsicum	https://file.milkbasket.com/subcategories/Beans+%26+Capsicum_1727186173.png	0	active	\N	2026-05-12 05:34:06.529676	2026-05-12 05:34:06.52968
bc0f5199-b695-4375-a684-39ee96ad8038	0829417b-f54d-4baa-9732-d228d58ae666	Root Vegetables & Raw Banana	root_vegetables_raw_banana	https://file.milkbasket.com/subcategories/Regular+vegetables_1727186286.png	0	active	\N	2026-05-12 05:34:56.046573	2026-05-12 05:34:56.046592
1e1306a2-1b26-44a4-a40f-d3994b77c846	0829417b-f54d-4baa-9732-d228d58ae666	Cauliflower & Brinjal	cauliflower_brinjal	https://file.milkbasket.com/subcategories/Cauliflower+%26+Brinjal_1727186192.png	0	active	\N	2026-05-12 05:35:23.225964	2026-05-12 05:35:23.225967
86e60c53-9134-4ff3-b5d4-4ebd9b9062e7	0829417b-f54d-4baa-9732-d228d58ae666	Salad & Sprouts	salad_sprouts	https://file.milkbasket.com/subcategories/Salad+%26+Sprouts_1727186295.png	0	active	\N	2026-05-12 05:36:46.595917	2026-05-12 05:37:10.536363
b20b4e9f-8de9-4b27-8cca-e43575f215fe	0829417b-f54d-4baa-9732-d228d58ae666	Onion, Potato & Tomato	onion_potato_tomato	https://file.milkbasket.com/subcategories/Onion%2C+Potato+%26+Tomato_1727186265.png	0	active	\N	2026-05-12 05:37:51.356074	2026-05-12 05:37:51.356078
\.


--
-- Data for Name: user_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_address (id, "userId", label, "recipientName", "phoneNumber", "streetLine1", "streetLine2", landmark, city, state, "postalCode", country, latitude, longitude, "isDefault", "createdAt", "updatedAt") FROM stdin;
c3aa772c-e211-49a0-8360-767e8b7141ce	d8035b52-e2b1-4f74-ad99-7223008bc246	shipping	\N	\N	Dashrath Bag	\N	\N	Indore	Madhya Pradesh	452015	India	22.749833128979862	75.83644174039364	t	2026-05-12 12:16:17.116078	2026-05-12 12:16:17.116078
\.


--
-- Data for Name: user_cart_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_cart_item (id, "userId", "productId", "variantId", quantity, "bogoFreeProductId", "comboId", "comboName", "comboDiscountType", "comboDiscountValue", "comboItemQuantity", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: serverpod_cloud_storage_direct_upload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_cloud_storage_direct_upload_id_seq', 1, false);


--
-- Name: serverpod_cloud_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_cloud_storage_id_seq', 1, false);


--
-- Name: serverpod_future_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_future_call_id_seq', 1, false);


--
-- Name: serverpod_health_connection_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_health_connection_info_id_seq', 174, true);


--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_health_metric_id_seq', 549, true);


--
-- Name: serverpod_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_log_id_seq', 1, false);


--
-- Name: serverpod_message_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_message_log_id_seq', 1, false);


--
-- Name: serverpod_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_method_id_seq', 1, false);


--
-- Name: serverpod_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_migrations_id_seq', 4, true);


--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_query_log_id_seq', 55, true);


--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_readwrite_test_id_seq', 1, false);


--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_runtime_settings_id_seq', 1, true);


--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_session_log_id_seq', 825, true);


--
-- Name: admin_audit_log admin_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_audit_log
    ADD CONSTRAINT admin_audit_log_pkey PRIMARY KEY (id);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id);


--
-- Name: banner_linked_product banner_linked_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner_linked_product
    ADD CONSTRAINT banner_linked_product_pkey PRIMARY KEY (id);


--
-- Name: banner banner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner
    ADD CONSTRAINT banner_pkey PRIMARY KEY (id);


--
-- Name: banner_placement banner_placement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner_placement
    ADD CONSTRAINT banner_placement_pkey PRIMARY KEY (id);


--
-- Name: bogo_offer bogo_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer
    ADD CONSTRAINT bogo_offer_pkey PRIMARY KEY (id);


--
-- Name: bogo_offer_reward bogo_offer_reward_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer_reward
    ADD CONSTRAINT bogo_offer_reward_pkey PRIMARY KEY (id);


--
-- Name: category_offer category_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer
    ADD CONSTRAINT category_offer_pkey PRIMARY KEY (id);


--
-- Name: category_offer_product_exclusion category_offer_product_exclusion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer_product_exclusion
    ADD CONSTRAINT category_offer_product_exclusion_pkey PRIMARY KEY (id);


--
-- Name: category_offer_product_scope category_offer_product_scope_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer_product_scope
    ADD CONSTRAINT category_offer_product_scope_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: combo_offer_item combo_offer_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_offer_item
    ADD CONSTRAINT combo_offer_item_pkey PRIMARY KEY (id);


--
-- Name: combo_offer combo_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_offer
    ADD CONSTRAINT combo_offer_pkey PRIMARY KEY (id);


--
-- Name: coupon coupon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon
    ADD CONSTRAINT coupon_pkey PRIMARY KEY (id);


--
-- Name: coupon_product_scope coupon_product_scope_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_product_scope
    ADD CONSTRAINT coupon_product_scope_pkey PRIMARY KEY (id);


--
-- Name: customer_order customer_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT customer_order_pkey PRIMARY KEY (id);


--
-- Name: delivery_config delivery_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_config
    ADD CONSTRAINT delivery_config_pkey PRIMARY KEY (id);


--
-- Name: delivery_rule delivery_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_rule
    ADD CONSTRAINT delivery_rule_pkey PRIMARY KEY (id);


--
-- Name: delivery_slab delivery_slab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_slab
    ADD CONSTRAINT delivery_slab_pkey PRIMARY KEY (id);


--
-- Name: free_delivery_rule free_delivery_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.free_delivery_rule
    ADD CONSTRAINT free_delivery_rule_pkey PRIMARY KEY (id);


--
-- Name: idempotency_record idempotency_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idempotency_record
    ADD CONSTRAINT idempotency_record_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_notification_outbox order_notification_outbox_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_notification_outbox
    ADD CONSTRAINT order_notification_outbox_pkey PRIMARY KEY (id);


--
-- Name: order_tracking order_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_tracking
    ADD CONSTRAINT order_tracking_pkey PRIMARY KEY (id);


--
-- Name: payment_transaction payment_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transaction
    ADD CONSTRAINT payment_transaction_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_search_document product_search_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_search_document
    ADD CONSTRAINT product_search_document_pkey PRIMARY KEY (id);


--
-- Name: product_search_rebuild_job product_search_rebuild_job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_search_rebuild_job
    ADD CONSTRAINT product_search_rebuild_job_pkey PRIMARY KEY (id);


--
-- Name: product_sub_category product_sub_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sub_category
    ADD CONSTRAINT product_sub_category_pkey PRIMARY KEY (id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: refund_record refund_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_record
    ADD CONSTRAINT refund_record_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_jwt_refresh_token serverpod_auth_core_jwt_refresh_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_jwt_refresh_token
    ADD CONSTRAINT serverpod_auth_core_jwt_refresh_token_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_profile_image serverpod_auth_core_profile_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile_image
    ADD CONSTRAINT serverpod_auth_core_profile_image_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_profile serverpod_auth_core_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile
    ADD CONSTRAINT serverpod_auth_core_profile_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_session serverpod_auth_core_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_session
    ADD CONSTRAINT serverpod_auth_core_session_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_user serverpod_auth_core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_user
    ADD CONSTRAINT serverpod_auth_core_user_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_anonymous_account serverpod_auth_idp_anonymous_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_anonymous_account
    ADD CONSTRAINT serverpod_auth_idp_anonymous_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_apple_account serverpod_auth_idp_apple_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_apple_account
    ADD CONSTRAINT serverpod_auth_idp_apple_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_email_account serverpod_auth_idp_email_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account
    ADD CONSTRAINT serverpod_auth_idp_email_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_email_account_request serverpod_auth_idp_email_account_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_request_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_facebook_account serverpod_auth_idp_facebook_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_facebook_account
    ADD CONSTRAINT serverpod_auth_idp_facebook_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_firebase_account serverpod_auth_idp_firebase_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_firebase_account
    ADD CONSTRAINT serverpod_auth_idp_firebase_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_github_account serverpod_auth_idp_github_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_github_account
    ADD CONSTRAINT serverpod_auth_idp_github_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_google_account serverpod_auth_idp_google_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_google_account
    ADD CONSTRAINT serverpod_auth_idp_google_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_microsoft_account serverpod_auth_idp_microsoft_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_microsoft_account
    ADD CONSTRAINT serverpod_auth_idp_microsoft_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_passkey_account serverpod_auth_idp_passkey_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_passkey_account
    ADD CONSTRAINT serverpod_auth_idp_passkey_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_passkey_challenge serverpod_auth_idp_passkey_challenge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_passkey_challenge
    ADD CONSTRAINT serverpod_auth_idp_passkey_challenge_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_rate_limited_request_attempt serverpod_auth_idp_rate_limited_request_attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_rate_limited_request_attempt
    ADD CONSTRAINT serverpod_auth_idp_rate_limited_request_attempt_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_secret_challenge serverpod_auth_idp_secret_challenge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_secret_challenge
    ADD CONSTRAINT serverpod_auth_idp_secret_challenge_pkey PRIMARY KEY (id);


--
-- Name: serverpod_cloud_storage_direct_upload serverpod_cloud_storage_direct_upload_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage_direct_upload
    ADD CONSTRAINT serverpod_cloud_storage_direct_upload_pkey PRIMARY KEY (id);


--
-- Name: serverpod_cloud_storage serverpod_cloud_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage
    ADD CONSTRAINT serverpod_cloud_storage_pkey PRIMARY KEY (id);


--
-- Name: serverpod_future_call serverpod_future_call_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_future_call
    ADD CONSTRAINT serverpod_future_call_pkey PRIMARY KEY (id);


--
-- Name: serverpod_health_connection_info serverpod_health_connection_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_connection_info
    ADD CONSTRAINT serverpod_health_connection_info_pkey PRIMARY KEY (id);


--
-- Name: serverpod_health_metric serverpod_health_metric_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_metric
    ADD CONSTRAINT serverpod_health_metric_pkey PRIMARY KEY (id);


--
-- Name: serverpod_log serverpod_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_log
    ADD CONSTRAINT serverpod_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_message_log serverpod_message_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_message_log
    ADD CONSTRAINT serverpod_message_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_method serverpod_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_method
    ADD CONSTRAINT serverpod_method_pkey PRIMARY KEY (id);


--
-- Name: serverpod_migrations serverpod_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_migrations
    ADD CONSTRAINT serverpod_migrations_pkey PRIMARY KEY (id);


--
-- Name: serverpod_query_log serverpod_query_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_query_log
    ADD CONSTRAINT serverpod_query_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_readwrite_test serverpod_readwrite_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_readwrite_test
    ADD CONSTRAINT serverpod_readwrite_test_pkey PRIMARY KEY (id);


--
-- Name: serverpod_runtime_settings serverpod_runtime_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_runtime_settings
    ADD CONSTRAINT serverpod_runtime_settings_pkey PRIMARY KEY (id);


--
-- Name: serverpod_session_log serverpod_session_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_session_log
    ADD CONSTRAINT serverpod_session_log_pkey PRIMARY KEY (id);


--
-- Name: sub_category sub_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_category
    ADD CONSTRAINT sub_category_pkey PRIMARY KEY (id);


--
-- Name: user_address user_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_address
    ADD CONSTRAINT user_address_pkey PRIMARY KEY (id);


--
-- Name: user_cart_item user_cart_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_cart_item
    ADD CONSTRAINT user_cart_item_pkey PRIMARY KEY (id);


--
-- Name: app_user_firebase_uid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX app_user_firebase_uid_idx ON public.app_user USING btree ("firebaseUid");


--
-- Name: banner_linked_product_banner_sort_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX banner_linked_product_banner_sort_idx ON public.banner_linked_product USING btree ("bannerId", "sortOrder", id);


--
-- Name: banner_linked_product_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX banner_linked_product_unique_idx ON public.banner_linked_product USING btree ("bannerId", "productId");


--
-- Name: banner_placement_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX banner_placement_unique_idx ON public.banner_placement USING btree ("bannerId", "placementKey");


--
-- Name: bogo_offer_reward_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX bogo_offer_reward_unique_idx ON public.bogo_offer_reward USING btree ("bogoOfferId", "rewardProductId", "rewardVariantId");


--
-- Name: category_offer_product_exclusion_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX category_offer_product_exclusion_unique_idx ON public.category_offer_product_exclusion USING btree ("categoryOfferId", "productId");


--
-- Name: category_offer_product_scope_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX category_offer_product_scope_unique_idx ON public.category_offer_product_scope USING btree ("categoryOfferId", "productId");


--
-- Name: category_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX category_slug_idx ON public.category USING btree (slug);


--
-- Name: combo_offer_item_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX combo_offer_item_unique_idx ON public.combo_offer_item USING btree ("comboOfferId", "productId", "productVariantId");


--
-- Name: coupon_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX coupon_code_idx ON public.coupon USING btree (code);


--
-- Name: coupon_product_scope_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX coupon_product_scope_unique_idx ON public.coupon_product_scope USING btree ("couponId", "productId");


--
-- Name: customer_order_order_number_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customer_order_order_number_idx ON public.customer_order USING btree ("orderNumber");


--
-- Name: customer_order_payment_ordered_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customer_order_payment_ordered_idx ON public.customer_order USING btree ("paymentStatus", "orderedAt", id);


--
-- Name: customer_order_status_ordered_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customer_order_status_ordered_idx ON public.customer_order USING btree ("orderStatus", "orderedAt", id);


--
-- Name: customer_order_user_ordered_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customer_order_user_ordered_idx ON public.customer_order USING btree ("userId", "orderedAt", id);


--
-- Name: customer_order_user_payment_ordered_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customer_order_user_payment_ordered_idx ON public.customer_order USING btree ("userId", "paymentStatus", "orderedAt", id);


--
-- Name: delivery_config_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX delivery_config_key_idx ON public.delivery_config USING btree ("configKey");


--
-- Name: delivery_slab_config_sort_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX delivery_slab_config_sort_idx ON public.delivery_slab USING btree ("configId", "sortOrder", id);


--
-- Name: idempotency_scope_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idempotency_scope_key_idx ON public.idempotency_record USING btree (scope, "idempotencyKey");


--
-- Name: order_address_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX order_address_order_idx ON public.order_address USING btree ("orderId");


--
-- Name: order_item_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX order_item_order_idx ON public.order_item USING btree ("orderId");


--
-- Name: order_item_product_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX order_item_product_idx ON public.order_item USING btree ("productId");


--
-- Name: order_item_product_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX order_item_product_order_idx ON public.order_item USING btree ("productId", "orderId");


--
-- Name: order_notification_outbox_dedupe_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX order_notification_outbox_dedupe_idx ON public.order_notification_outbox USING btree ("dedupeKey");


--
-- Name: order_notification_outbox_pending_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX order_notification_outbox_pending_idx ON public.order_notification_outbox USING btree ("processedAt", "createdAt", id);


--
-- Name: order_notification_outbox_user_pending_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX order_notification_outbox_user_pending_idx ON public.order_notification_outbox USING btree ("userId", "processedAt", "createdAt", id);


--
-- Name: order_tracking_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX order_tracking_order_idx ON public.order_tracking USING btree ("orderId");


--
-- Name: payment_transaction_gateway_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transaction_gateway_order_idx ON public.payment_transaction USING btree ("gatewayOrderId");


--
-- Name: payment_transaction_gateway_payment_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transaction_gateway_payment_idx ON public.payment_transaction USING btree ("gatewayPaymentId");


--
-- Name: payment_transaction_idempotency_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transaction_idempotency_idx ON public.payment_transaction USING btree ("idempotencyKey");


--
-- Name: payment_transaction_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transaction_order_idx ON public.payment_transaction USING btree ("orderId");


--
-- Name: product_most_purchase_count_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_most_purchase_count_idx ON public.product USING btree ("mostPurchaseCount", id);


--
-- Name: product_most_search_count_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_most_search_count_idx ON public.product USING btree ("mostSearchCount", id);


--
-- Name: product_reorder_count_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_reorder_count_idx ON public.product USING btree ("reorderCount", id);


--
-- Name: product_search_document_product_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_search_document_product_idx ON public.product_search_document USING btree ("productId");


--
-- Name: product_search_rebuild_job_status_scheduled_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_search_rebuild_job_status_scheduled_idx ON public.product_search_rebuild_job USING btree ("jobStatus", "scheduledAt", id);


--
-- Name: product_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_slug_idx ON public.product USING btree (slug);


--
-- Name: product_sub_category_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_sub_category_unique_idx ON public.product_sub_category USING btree ("productId", "subCategoryId");


--
-- Name: product_trending_score_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_trending_score_idx ON public.product USING btree ("trendingScore", id);


--
-- Name: product_variant_product_sort_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_variant_product_sort_idx ON public.product_variant USING btree ("productId", "sortOrder", id);


--
-- Name: product_variant_sku_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_variant_sku_idx ON public.product_variant USING btree (sku);


--
-- Name: refund_record_gateway_refund_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX refund_record_gateway_refund_idx ON public.refund_record USING btree ("gatewayRefundId");


--
-- Name: refund_record_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX refund_record_order_idx ON public.refund_record USING btree ("orderId");


--
-- Name: serverpod_auth_apple_account_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_apple_account_identifier ON public.serverpod_auth_idp_apple_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_core_jwt_refresh_token_last_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_auth_core_jwt_refresh_token_last_updated_at ON public.serverpod_auth_core_jwt_refresh_token USING btree ("lastUpdatedAt");


--
-- Name: serverpod_auth_facebook_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_facebook_account_user_identifier ON public.serverpod_auth_idp_facebook_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_firebase_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_firebase_account_user_identifier ON public.serverpod_auth_idp_firebase_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_github_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_github_account_user_identifier ON public.serverpod_auth_idp_github_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_google_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_google_account_user_identifier ON public.serverpod_auth_idp_google_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_idp_email_account_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_idp_email_account_email ON public.serverpod_auth_idp_email_account USING btree (email);


--
-- Name: serverpod_auth_idp_email_account_request_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_idp_email_account_request_email ON public.serverpod_auth_idp_email_account_request USING btree (email);


--
-- Name: serverpod_auth_idp_passkey_account_key_id_base64; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_idp_passkey_account_key_id_base64 ON public.serverpod_auth_idp_passkey_account USING btree ("keyIdBase64");


--
-- Name: serverpod_auth_idp_rate_limited_request_attempt_composite; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_auth_idp_rate_limited_request_attempt_composite ON public.serverpod_auth_idp_rate_limited_request_attempt USING btree (domain, source, nonce, "attemptedAt");


--
-- Name: serverpod_auth_microsoft_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_microsoft_account_user_identifier ON public.serverpod_auth_idp_microsoft_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_profile_user_profile_email_auth_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_profile_user_profile_email_auth_user_id ON public.serverpod_auth_core_profile USING btree ("authUserId");


--
-- Name: serverpod_cloud_storage_direct_upload_storage_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_cloud_storage_direct_upload_storage_path ON public.serverpod_cloud_storage_direct_upload USING btree ("storageId", path);


--
-- Name: serverpod_cloud_storage_expiration; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_cloud_storage_expiration ON public.serverpod_cloud_storage USING btree (expiration);


--
-- Name: serverpod_cloud_storage_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_cloud_storage_path_idx ON public.serverpod_cloud_storage USING btree ("storageId", path);


--
-- Name: serverpod_future_call_identifier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_future_call_identifier_idx ON public.serverpod_future_call USING btree (identifier);


--
-- Name: serverpod_future_call_serverId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_future_call_serverId_idx" ON public.serverpod_future_call USING btree ("serverId");


--
-- Name: serverpod_future_call_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_future_call_time_idx ON public.serverpod_future_call USING btree ("time");


--
-- Name: serverpod_health_connection_info_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_health_connection_info_timestamp_idx ON public.serverpod_health_connection_info USING btree ("timestamp", "serverId", granularity);


--
-- Name: serverpod_health_metric_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_health_metric_timestamp_idx ON public.serverpod_health_metric USING btree ("timestamp", "serverId", name, granularity);


--
-- Name: serverpod_log_sessionLogId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_log_sessionLogId_idx" ON public.serverpod_log USING btree ("sessionLogId");


--
-- Name: serverpod_method_endpoint_method_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_method_endpoint_method_idx ON public.serverpod_method USING btree (endpoint, method);


--
-- Name: serverpod_migrations_ids; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_migrations_ids ON public.serverpod_migrations USING btree (module);


--
-- Name: serverpod_query_log_sessionLogId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON public.serverpod_query_log USING btree ("sessionLogId");


--
-- Name: serverpod_session_log_isopen_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_isopen_idx ON public.serverpod_session_log USING btree ("isOpen");


--
-- Name: serverpod_session_log_serverid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_serverid_idx ON public.serverpod_session_log USING btree ("serverId");


--
-- Name: serverpod_session_log_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_time_idx ON public.serverpod_session_log USING btree ("time");


--
-- Name: serverpod_session_log_touched_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_touched_idx ON public.serverpod_session_log USING btree (touched);


--
-- Name: sub_category_category_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sub_category_category_slug_idx ON public.sub_category USING btree ("categoryId", slug);


--
-- Name: user_address_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_address_user_id_idx ON public.user_address USING btree ("userId");


--
-- Name: user_cart_item_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_cart_item_user_id_idx ON public.user_cart_item USING btree ("userId");


--
-- Name: admin_audit_log admin_audit_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_audit_log
    ADD CONSTRAINT admin_audit_log_fk_0 FOREIGN KEY ("actorUserId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: banner banner_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner
    ADD CONSTRAINT banner_fk_0 FOREIGN KEY ("linkedProductId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: banner banner_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner
    ADD CONSTRAINT banner_fk_1 FOREIGN KEY ("comboOfferId") REFERENCES public.combo_offer(id) ON DELETE RESTRICT;


--
-- Name: banner banner_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner
    ADD CONSTRAINT banner_fk_2 FOREIGN KEY ("couponId") REFERENCES public.coupon(id) ON DELETE RESTRICT;


--
-- Name: banner banner_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner
    ADD CONSTRAINT banner_fk_3 FOREIGN KEY ("linkedCategoryId") REFERENCES public.category(id) ON DELETE RESTRICT;


--
-- Name: banner banner_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner
    ADD CONSTRAINT banner_fk_4 FOREIGN KEY ("linkedSubCategoryId") REFERENCES public.sub_category(id) ON DELETE RESTRICT;


--
-- Name: banner_linked_product banner_linked_product_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner_linked_product
    ADD CONSTRAINT banner_linked_product_fk_0 FOREIGN KEY ("bannerId") REFERENCES public.banner(id) ON DELETE CASCADE;


--
-- Name: banner_linked_product banner_linked_product_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner_linked_product
    ADD CONSTRAINT banner_linked_product_fk_1 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: banner_placement banner_placement_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banner_placement
    ADD CONSTRAINT banner_placement_fk_0 FOREIGN KEY ("bannerId") REFERENCES public.banner(id) ON DELETE CASCADE;


--
-- Name: bogo_offer bogo_offer_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer
    ADD CONSTRAINT bogo_offer_fk_0 FOREIGN KEY ("triggerProductId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: bogo_offer bogo_offer_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer
    ADD CONSTRAINT bogo_offer_fk_1 FOREIGN KEY ("triggerVariantId") REFERENCES public.product_variant(id) ON DELETE RESTRICT;


--
-- Name: bogo_offer_reward bogo_offer_reward_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer_reward
    ADD CONSTRAINT bogo_offer_reward_fk_0 FOREIGN KEY ("bogoOfferId") REFERENCES public.bogo_offer(id) ON DELETE CASCADE;


--
-- Name: bogo_offer_reward bogo_offer_reward_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer_reward
    ADD CONSTRAINT bogo_offer_reward_fk_1 FOREIGN KEY ("rewardProductId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: bogo_offer_reward bogo_offer_reward_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bogo_offer_reward
    ADD CONSTRAINT bogo_offer_reward_fk_2 FOREIGN KEY ("rewardVariantId") REFERENCES public.product_variant(id) ON DELETE RESTRICT;


--
-- Name: category_offer category_offer_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer
    ADD CONSTRAINT category_offer_fk_0 FOREIGN KEY ("categoryId") REFERENCES public.category(id) ON DELETE RESTRICT;


--
-- Name: category_offer_product_exclusion category_offer_product_exclusion_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer_product_exclusion
    ADD CONSTRAINT category_offer_product_exclusion_fk_0 FOREIGN KEY ("categoryOfferId") REFERENCES public.category_offer(id) ON DELETE CASCADE;


--
-- Name: category_offer_product_exclusion category_offer_product_exclusion_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer_product_exclusion
    ADD CONSTRAINT category_offer_product_exclusion_fk_1 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: category_offer_product_scope category_offer_product_scope_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer_product_scope
    ADD CONSTRAINT category_offer_product_scope_fk_0 FOREIGN KEY ("categoryOfferId") REFERENCES public.category_offer(id) ON DELETE CASCADE;


--
-- Name: category_offer_product_scope category_offer_product_scope_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_offer_product_scope
    ADD CONSTRAINT category_offer_product_scope_fk_1 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: combo_offer_item combo_offer_item_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_offer_item
    ADD CONSTRAINT combo_offer_item_fk_0 FOREIGN KEY ("comboOfferId") REFERENCES public.combo_offer(id) ON DELETE CASCADE;


--
-- Name: combo_offer_item combo_offer_item_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_offer_item
    ADD CONSTRAINT combo_offer_item_fk_1 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: combo_offer_item combo_offer_item_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combo_offer_item
    ADD CONSTRAINT combo_offer_item_fk_2 FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON DELETE RESTRICT;


--
-- Name: coupon_product_scope coupon_product_scope_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_product_scope
    ADD CONSTRAINT coupon_product_scope_fk_0 FOREIGN KEY ("couponId") REFERENCES public.coupon(id) ON DELETE CASCADE;


--
-- Name: coupon_product_scope coupon_product_scope_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_product_scope
    ADD CONSTRAINT coupon_product_scope_fk_1 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: customer_order customer_order_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT customer_order_fk_0 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: customer_order customer_order_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT customer_order_fk_1 FOREIGN KEY ("couponId") REFERENCES public.coupon(id) ON DELETE RESTRICT;


--
-- Name: delivery_slab delivery_slab_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_slab
    ADD CONSTRAINT delivery_slab_fk_0 FOREIGN KEY ("configId") REFERENCES public.delivery_config(id) ON DELETE CASCADE;


--
-- Name: free_delivery_rule free_delivery_rule_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.free_delivery_rule
    ADD CONSTRAINT free_delivery_rule_fk_0 FOREIGN KEY ("couponId") REFERENCES public.coupon(id) ON DELETE RESTRICT;


--
-- Name: free_delivery_rule free_delivery_rule_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.free_delivery_rule
    ADD CONSTRAINT free_delivery_rule_fk_1 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: idempotency_record idempotency_record_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idempotency_record
    ADD CONSTRAINT idempotency_record_fk_0 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: idempotency_record idempotency_record_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idempotency_record
    ADD CONSTRAINT idempotency_record_fk_1 FOREIGN KEY ("orderId") REFERENCES public.customer_order(id) ON DELETE RESTRICT;


--
-- Name: idempotency_record idempotency_record_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idempotency_record
    ADD CONSTRAINT idempotency_record_fk_2 FOREIGN KEY ("paymentTransactionId") REFERENCES public.payment_transaction(id) ON DELETE RESTRICT;


--
-- Name: order_address order_address_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_fk_0 FOREIGN KEY ("orderId") REFERENCES public.customer_order(id) ON DELETE CASCADE;


--
-- Name: order_item order_item_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_fk_0 FOREIGN KEY ("orderId") REFERENCES public.customer_order(id) ON DELETE CASCADE;


--
-- Name: order_item order_item_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_fk_1 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- Name: order_item order_item_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_fk_2 FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON DELETE RESTRICT;


--
-- Name: order_item order_item_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_fk_3 FOREIGN KEY ("comboOfferId") REFERENCES public.combo_offer(id) ON DELETE RESTRICT;


--
-- Name: order_item order_item_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_fk_4 FOREIGN KEY ("bogoOfferId") REFERENCES public.bogo_offer(id) ON DELETE RESTRICT;


--
-- Name: order_tracking order_tracking_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_tracking
    ADD CONSTRAINT order_tracking_fk_0 FOREIGN KEY ("orderId") REFERENCES public.customer_order(id) ON DELETE CASCADE;


--
-- Name: payment_transaction payment_transaction_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transaction
    ADD CONSTRAINT payment_transaction_fk_0 FOREIGN KEY ("orderId") REFERENCES public.customer_order(id) ON DELETE RESTRICT;


--
-- Name: payment_transaction payment_transaction_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transaction
    ADD CONSTRAINT payment_transaction_fk_1 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: product product_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_fk_0 FOREIGN KEY ("categoryId") REFERENCES public.category(id) ON DELETE RESTRICT;


--
-- Name: product_search_document product_search_document_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_search_document
    ADD CONSTRAINT product_search_document_fk_0 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE CASCADE;


--
-- Name: product_search_rebuild_job product_search_rebuild_job_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_search_rebuild_job
    ADD CONSTRAINT product_search_rebuild_job_fk_0 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE CASCADE;


--
-- Name: product_sub_category product_sub_category_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sub_category
    ADD CONSTRAINT product_sub_category_fk_0 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE CASCADE;


--
-- Name: product_sub_category product_sub_category_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sub_category
    ADD CONSTRAINT product_sub_category_fk_1 FOREIGN KEY ("subCategoryId") REFERENCES public.sub_category(id) ON DELETE RESTRICT;


--
-- Name: product_variant product_variant_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_fk_0 FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE CASCADE;


--
-- Name: refund_record refund_record_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_record
    ADD CONSTRAINT refund_record_fk_0 FOREIGN KEY ("orderId") REFERENCES public.customer_order(id) ON DELETE RESTRICT;


--
-- Name: refund_record refund_record_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_record
    ADD CONSTRAINT refund_record_fk_1 FOREIGN KEY ("paymentTransactionId") REFERENCES public.payment_transaction(id) ON DELETE RESTRICT;


--
-- Name: refund_record refund_record_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_record
    ADD CONSTRAINT refund_record_fk_2 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: serverpod_auth_core_jwt_refresh_token serverpod_auth_core_jwt_refresh_token_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_jwt_refresh_token
    ADD CONSTRAINT serverpod_auth_core_jwt_refresh_token_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_core_profile serverpod_auth_core_profile_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile
    ADD CONSTRAINT serverpod_auth_core_profile_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_core_profile serverpod_auth_core_profile_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile
    ADD CONSTRAINT serverpod_auth_core_profile_fk_1 FOREIGN KEY ("imageId") REFERENCES public.serverpod_auth_core_profile_image(id);


--
-- Name: serverpod_auth_core_profile_image serverpod_auth_core_profile_image_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile_image
    ADD CONSTRAINT serverpod_auth_core_profile_image_fk_0 FOREIGN KEY ("userProfileId") REFERENCES public.serverpod_auth_core_profile(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_core_session serverpod_auth_core_session_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_session
    ADD CONSTRAINT serverpod_auth_core_session_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_anonymous_account serverpod_auth_idp_anonymous_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_anonymous_account
    ADD CONSTRAINT serverpod_auth_idp_anonymous_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_apple_account serverpod_auth_idp_apple_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_apple_account
    ADD CONSTRAINT serverpod_auth_idp_apple_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account serverpod_auth_idp_email_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account
    ADD CONSTRAINT serverpod_auth_idp_email_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_fk_0 FOREIGN KEY ("emailAccountId") REFERENCES public.serverpod_auth_idp_email_account(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_fk_1 FOREIGN KEY ("challengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_fk_2 FOREIGN KEY ("setPasswordChallengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_request serverpod_auth_idp_email_account_request_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_request_fk_0 FOREIGN KEY ("challengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_request serverpod_auth_idp_email_account_request_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_request_fk_1 FOREIGN KEY ("createAccountChallengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_facebook_account serverpod_auth_idp_facebook_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_facebook_account
    ADD CONSTRAINT serverpod_auth_idp_facebook_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_firebase_account serverpod_auth_idp_firebase_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_firebase_account
    ADD CONSTRAINT serverpod_auth_idp_firebase_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_github_account serverpod_auth_idp_github_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_github_account
    ADD CONSTRAINT serverpod_auth_idp_github_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_google_account serverpod_auth_idp_google_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_google_account
    ADD CONSTRAINT serverpod_auth_idp_google_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_microsoft_account serverpod_auth_idp_microsoft_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_microsoft_account
    ADD CONSTRAINT serverpod_auth_idp_microsoft_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_passkey_account serverpod_auth_idp_passkey_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_passkey_account
    ADD CONSTRAINT serverpod_auth_idp_passkey_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_log serverpod_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_log
    ADD CONSTRAINT serverpod_log_fk_0 FOREIGN KEY ("sessionLogId") REFERENCES public.serverpod_session_log(id) ON DELETE CASCADE;


--
-- Name: serverpod_message_log serverpod_message_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_message_log
    ADD CONSTRAINT serverpod_message_log_fk_0 FOREIGN KEY ("sessionLogId") REFERENCES public.serverpod_session_log(id) ON DELETE CASCADE;


--
-- Name: serverpod_query_log serverpod_query_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_query_log
    ADD CONSTRAINT serverpod_query_log_fk_0 FOREIGN KEY ("sessionLogId") REFERENCES public.serverpod_session_log(id) ON DELETE CASCADE;


--
-- Name: sub_category sub_category_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_category
    ADD CONSTRAINT sub_category_fk_0 FOREIGN KEY ("categoryId") REFERENCES public.category(id) ON DELETE RESTRICT;


--
-- Name: user_address user_address_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_address
    ADD CONSTRAINT user_address_fk_0 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE RESTRICT;


--
-- Name: user_cart_item user_cart_item_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_cart_item
    ADD CONSTRAINT user_cart_item_fk_0 FOREIGN KEY ("userId") REFERENCES public.app_user(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ZAhK7ahDBwBuFUA5aa9EAOaXGU6FcuzVuAlGDYvM6F5zQ8x6QSrOBoxtOEyB2fx

