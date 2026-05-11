--
-- PostgreSQL database dump
--

\restrict T4whFWoiIw8R4jOmO87urNxBKgi1cgtvFt45Uv6vcKaVu85wcS0NNoDHgpnah02

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
\.


--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_user (id, "firebaseUid", "phoneNumber", name, email, role, "fcmToken", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: banner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banner (id, title, "imageUrl", "actionType", "offerId", "externalUrl", "linkedProductId", "comboOfferId", "couponId", "linkedCategoryId", "linkedSubCategoryId", priority, "isBaseImage", "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: banner_linked_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banner_linked_product (id, "bannerId", "productId", "sortOrder", "createdAt") FROM stdin;
\.


--
-- Data for Name: banner_placement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banner_placement (id, "bannerId", "placementKey", "createdAt") FROM stdin;
\.


--
-- Data for Name: bogo_offer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bogo_offer (id, "triggerProductId", "triggerVariantId", "minTriggerQuantity", "triggerBaseQuantity", "triggerBaseUnit", title, "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: bogo_offer_reward; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bogo_offer_reward (id, "bogoOfferId", "rewardProductId", "rewardVariantId", "freeQuantity", "createdAt") FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, name, slug, "imageUrl", "displayOrder", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: category_offer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_offer (id, "categoryId", name, description, "discountType", "discountValue", "maxDiscountAmount", "minOrderAmount", priority, "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
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
\.


--
-- Data for Name: combo_offer_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.combo_offer_item (id, "comboOfferId", "productId", "productVariantId", quantity, "sortOrder", "createdAt") FROM stdin;
\.


--
-- Data for Name: coupon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon (id, code, description, "couponType", "couponCategory", "discountValue", "minOrderAmount", "maxDiscountAmount", "maxUsageTotal", "maxUsagePerUser", "loyaltyRequiredOrders", "usedCount", "startsAt", "endsAt", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
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
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, "orderId", "recipientName", "phoneNumber", "streetLine1", "streetLine2", landmark, city, state, "postalCode", country, latitude, longitude, "createdAt") FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, "orderId", "productId", "productVariantId", "comboOfferId", "bogoOfferId", "productNameSnapshot", "productImageUrlSnapshot", "variantLabelSnapshot", quantity, "unitPrice", "totalPrice", "isFreeItem", "createdAt") FROM stdin;
\.


--
-- Data for Name: order_notification_outbox; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_notification_outbox (id, "dedupeKey", "eventType", "orderId", "userId", status, "payloadJson", "attemptCount", "lastError", "processedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: order_tracking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_tracking (id, "orderId", "trackingEnabled", "userLatitude", "userLongitude", "userAddress", "userLocationType", "riderLatitude", "riderLongitude", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: payment_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_transaction (id, "orderId", "userId", "idempotencyKey", "gatewayName", "gatewayOrderId", "gatewayPaymentId", amount, "currencyCode", "paymentStatus", "gatewayStatus", "failureReason", "paidAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, "categoryId", name, slug, "shortDescription", description, "primaryImageUrl", "countryOfOrigin", "baseUnit", "baseQuantity", "quantityDescription", stock, "stockUnit", "discountType", "mostSearchCount", "mostPurchaseCount", "last7DaysSold", "last7DaysViews", "reorderCount", "trendingScore", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: product_search_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_search_document (id, "productId", "searchText", "builtAt", "sourceCreatedAt", "sourceUpdatedAt") FROM stdin;
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
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, "productId", label, sku, "quantityValue", "quantityUnit", "quantityDescription", "salePrice", "listPrice", "isAvailable", "isDefault", "sortOrder", "createdAt", "updatedAt") FROM stdin;
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
1	default	2026-05-11 13:08:00	0	0	0	1
34	default	2026-05-11 13:13:00	0	0	0	1
35	default	2026-05-11 13:17:00	0	0	0	1
36	default	2026-05-11 14:34:00	0	0	0	1
37	default	2026-05-11 15:29:00	0	0	0	1
38	default	2026-05-11 15:57:00	0	0	0	1
39	default	2026-05-11 16:02:00	0	0	0	1
40	default	2026-05-11 16:03:00	0	0	0	1
41	default	2026-05-11 17:25:00	0	0	0	1
\.


--
-- Data for Name: serverpod_health_metric; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_health_metric (id, name, "serverId", "timestamp", "isHealthy", value, granularity) FROM stdin;
1	serverpod_database	default	2026-05-11 13:08:00	t	0.001214	1
2	serverpod_cpu	default	2026-05-11 13:08:00	t	0	1
3	serverpod_memory	default	2026-05-11 13:08:00	t	0.04660960307022272	1
34	serverpod_database	default	2026-05-11 13:13:00	t	0.00233	1
35	serverpod_cpu	default	2026-05-11 13:13:00	t	0	1
36	serverpod_memory	default	2026-05-11 13:13:00	t	0.046514736637847394	1
37	serverpod_database	default	2026-05-11 13:17:00	t	0.004747	1
38	serverpod_cpu	default	2026-05-11 13:17:00	t	0	1
39	serverpod_memory	default	2026-05-11 13:17:00	t	0.3237131478043725	1
40	serverpod_database	default	2026-05-11 14:34:00	t	0.008039	1
41	serverpod_cpu	default	2026-05-11 14:34:00	t	0	1
42	serverpod_memory	default	2026-05-11 14:34:00	t	0.26624597456273913	1
43	serverpod_database	default	2026-05-11 15:29:00	t	0.002908	1
44	serverpod_cpu	default	2026-05-11 15:29:00	t	0	1
45	serverpod_memory	default	2026-05-11 15:29:00	t	0.23296645108385478	1
46	serverpod_database	default	2026-05-11 15:57:00	t	0.000612	1
47	serverpod_cpu	default	2026-05-11 15:57:00	t	0	1
48	serverpod_memory	default	2026-05-11 15:57:00	t	0.038651686362274125	1
49	serverpod_database	default	2026-05-11 16:02:00	t	0.000681	1
50	serverpod_cpu	default	2026-05-11 16:02:00	t	0	1
51	serverpod_memory	default	2026-05-11 16:02:00	t	0.038733616639608115	1
52	serverpod_database	default	2026-05-11 16:03:00	t	0.000705	1
53	serverpod_cpu	default	2026-05-11 16:03:00	t	0	1
54	serverpod_memory	default	2026-05-11 16:03:00	t	0.03877026965841542	1
55	serverpod_database	default	2026-05-11 17:25:00	t	0.000804	1
56	serverpod_cpu	default	2026-05-11 17:25:00	t	0	1
57	serverpod_memory	default	2026-05-11 17:25:00	t	0.0471745912649388	1
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
1	freshpickkat	20260509120035765	2026-05-11 13:04:41.690048
2	serverpod	20260129180959368	2026-05-11 13:04:41.690048
3	serverpod_auth_idp	20260213194423028	2026-05-11 13:04:41.690048
4	serverpod_auth_core	20260129181112269	2026-05-11 13:04:41.690048
\.


--
-- Data for Name: serverpod_query_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_query_log (id, "serverId", "sessionLogId", "messageId", query, duration, "numRows", error, "stackTrace", slow, "order") FROM stdin;
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
1	default	2026-05-11 13:07:57.182739	\N	InternalSession	\N	0.014199	3	f	\N	\N	\N	\N	f	2026-05-11 13:07:57.196939
34	default	2026-05-11 13:12:04.404513	\N	InternalSession	\N	0.016109	3	f	\N	\N	\N	\N	f	2026-05-11 13:12:04.420622
35	default	2026-05-11 13:16:01.001467	\N	InternalSession	\N	0.031549	3	f	\N	\N	\N	\N	f	2026-05-11 13:16:01.033079
36	default	2026-05-11 14:33:43.085698	\N	InternalSession	\N	0.034472	3	f	\N	\N	\N	\N	f	2026-05-11 14:33:43.120232
38	default	2026-05-11 15:28:52.289459	\N	InternalSession	\N	0.031263	3	f	\N	\N	\N	\N	f	2026-05-11 15:28:52.320763
37	default	2026-05-11 15:28:52.286089	\N	InternalSession	\N	0.041779	3	f	\N	\N	\N	\N	f	2026-05-11 15:28:52.327871
39	default	2026-05-11 15:28:52.289199	\N	InternalSession	\N	0.042579	3	f	\N	\N	\N	\N	f	2026-05-11 15:28:52.331785
40	default	2026-05-11 15:28:52.289343	\N	InternalSession	\N	0.060039	4	f	\N	\N	\N	\N	f	2026-05-11 15:28:52.349384
43	default	2026-05-11 15:56:36.282436	\N	InternalSession	\N	0.007734	3	f	\N	\N	\N	\N	f	2026-05-11 15:56:36.29017
41	default	2026-05-11 15:56:36.282386	\N	InternalSession	\N	0.005992	3	f	\N	\N	\N	\N	f	2026-05-11 15:56:36.288378
44	default	2026-05-11 15:56:36.282455	\N	InternalSession	\N	0.009585	4	f	\N	\N	\N	\N	f	2026-05-11 15:56:36.292041
42	default	2026-05-11 15:56:36.282474	\N	InternalSession	\N	0.007294	3	f	\N	\N	\N	\N	f	2026-05-11 15:56:36.289768
45	default	2026-05-11 16:01:36.276513	\N	InternalSession	\N	0.00114	1	f	\N	\N	\N	\N	f	2026-05-11 16:01:36.277654
46	default	2026-05-11 16:02:30.188965	\N	InternalSession	\N	0.003202	3	f	\N	\N	\N	\N	f	2026-05-11 16:02:30.192167
47	default	2026-05-11 16:02:30.188872	\N	InternalSession	\N	0.004884	3	f	\N	\N	\N	\N	f	2026-05-11 16:02:30.193756
48	default	2026-05-11 16:02:30.188928	\N	InternalSession	\N	0.008957	3	f	\N	\N	\N	\N	f	2026-05-11 16:02:30.197885
49	default	2026-05-11 16:02:30.188942	\N	InternalSession	\N	0.009927	4	f	\N	\N	\N	\N	f	2026-05-11 16:02:30.19887
53	default	2026-05-11 17:25:49.171317	\N	InternalSession	\N	0.007533	4	f	\N	\N	\N	\N	f	2026-05-11 17:25:49.178851
50	default	2026-05-11 17:25:49.171277	\N	InternalSession	\N	0.005104	3	f	\N	\N	\N	\N	f	2026-05-11 17:25:49.176381
51	default	2026-05-11 17:25:49.171326	\N	InternalSession	\N	0.005575	3	f	\N	\N	\N	\N	f	2026-05-11 17:25:49.176901
52	default	2026-05-11 17:25:49.171307	\N	InternalSession	\N	0.006388	3	f	\N	\N	\N	\N	f	2026-05-11 17:25:49.177696
\.


--
-- Data for Name: sub_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_category (id, "categoryId", name, slug, "imageUrl", "displayOrder", status, "deactivatedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: user_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_address (id, "userId", label, "recipientName", "phoneNumber", "streetLine1", "streetLine2", landmark, city, state, "postalCode", country, latitude, longitude, "isDefault", "createdAt", "updatedAt") FROM stdin;
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

SELECT pg_catalog.setval('public.serverpod_health_connection_info_id_seq', 41, true);


--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_health_metric_id_seq', 57, true);


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

SELECT pg_catalog.setval('public.serverpod_migrations_id_seq', 33, true);


--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_query_log_id_seq', 1, false);


--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_readwrite_test_id_seq', 1, false);


--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_runtime_settings_id_seq', 33, true);


--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_session_log_id_seq', 53, true);


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

\unrestrict T4whFWoiIw8R4jOmO87urNxBKgi1cgtvFt45Uv6vcKaVu85wcS0NNoDHgpnah02

