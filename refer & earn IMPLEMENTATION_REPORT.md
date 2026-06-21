# Refer & Earn — Implementation Report

> **Date:** June 21, 2026  
> **Modules Covered:** Payment Infrastructure + Referral & Earn Growth System + Server Optimizations + Hardening Phases A–I

---

## Table of Contents

1. [Authentication & Authorization](#1-authentication--authorization)
2. [Security Architecture](#2-security-architecture)
3. [Module 1: Payment Infrastructure](#3-module-1-payment-infrastructure)
4. [Module 2: Referral Growth System](#4-module-2-referral-growth-system)
5. [Server-Side Optimizations](#5-server-side-optimizations)
6. [Test Coverage](#6-test-coverage)
7. [Database Schema Changes](#7-database-schema-changes)
8. [Hardening Phases A–I](#8-hardening-phases-a-i-fraud-prevention--security)

---

## 1. Authentication & Authorization

### 1.1 Firebase Authentication Flow

**Client Side** (`freshpickkat_flutter/lib/controller/auth_controller.dart`)

| Step | Description |
|------|-------------|
| Firebase `signInWithPhoneNumber` | SMS OTP sent to user's phone |
| OTP verification | `credential` obtained from SMS |
| Firebase `signInWithCredential` | User logged in, ID token minted |
| `currentUser?.uid` | Firebase UID used as user identifier |
| `auth.appUserRx` | Reactive AppUser state (GetX) |
| `registerFcmToken()` | FCM token registered per device |

**Server Side** (`freshpickkat_server`)

All endpoints receive `Session` from Serverpod. The auth pattern:

```dart
// Serverpod session management
Future<void> someEndpoint(Session session, String userId) async {
  // session.auth is populated by Firebase ID token verification
  // User must be authenticated to call this endpoint
}
```

### 1.2 Admin Authentication

Admin endpoints use a guard pattern (`_adminGuard.ensureAdminSeller`):

```dart
class _AdminGuard {
  Future<AppUserRow> ensureAdminSeller(
    Session session, {
    required String firebaseUid,
    required String idToken,
  }) async {
    // 1. Verify Firebase ID token is valid (not expired)
    // 2. Look up user by firebaseUid
    // 3. Check user.role is 'admin' or 'seller'
    // 4. Return user or throw
  }
}
```

Every admin endpoint requires both `firebaseUid` and `idToken` parameters:

```dart
// referral_endpoint.dart — admin methods
@Endpoint()
Future<ReferralAdminStats> getReferralAnalytics(
  Session session, {
  required String firebaseUid,
  required String idToken,
}) async {
  await _adminGuard.ensureAdminSeller(session,
    firebaseUid: firebaseUid, idToken: idToken);
  return _referral.getReferralAnalytics(session);
}
```

### 1.3 User Auth Guards

User-specific endpoints validate ownership via `_ensureOrderOwner`:

```dart
Future<void> _ensureOrderOwner(Session session, {
  required String orderId,
  required String firebaseUid,
  String? idToken,
}) async {
  // 1. Verify Firebase ID token
  final user = await _userGuard.ensureUser(session,
    firebaseUid: firebaseUid, idToken: idToken);
  // 2. Look up order
  final order = await CustomerOrderRow.db.findFirstRow(session,
    where: (t) => t.orderNumber.equals(orderId.trim()));
  // 3. Verify ownership
  if (order == null || order.userId != user.id) {
    throw Exception('Order does not belong to user.');
  }
}
```

### 1.4 Unauthenticated Endpoints

These endpoints do NOT require Firebase auth (token-based instead):

| Endpoint | Auth Mechanism |
|----------|---------------|
| `payment_link.getPaymentPageData` | Secure 32-byte alphanumeric token |
| `payment_link.confirmPayment` | Same token as credential |
| `razorpay_webhook_route` | HMAC-SHA256 webhook signature |

### 1.5 Role-Based Access

| Role | Access |
|------|--------|
| `customer` | Own orders, own profile, own referrals |
| `admin` | All admin endpoints, referrals, settings, payments |
| `seller` | Admin-level access (same guard) |

---

## 2. Security Architecture

### 2.1 Razorpay Webhook HMAC Validation

**File:** `freshpickkat_server/lib/src/web/routes/razorpay_webhook_route.dart:22-48`

```dart
// 1. Load secret from environment
final secret = EnvService.get('RAZORPAY_WEBHOOK_SECRET');

// 2. Extract signature header
final signature = request.headers['x-razorpay-signature'];

// 3. Compute HMAC-SHA256 over RAW request body bytes
final bodyBytes = await readBodyBytes(request);
final hmac = Hmac(sha256, utf8.encode(secret));
final digest = hmac.convert(bodyBytes);
final expectedSignature = digest.toString();

// 4. Compare (constant-time comparison)
if (expectedSignature != signature) {
  return Response.unauthorized(body: Body.fromString('Invalid signature'));
}
```

**Why raw bytes?** Prevents serialization differences between Razorpay's signing (their JSON bytes) and our re-serialization.

### 2.2 Client-Side Payment Signature Verification

**File:** `freshpickkat_server/lib/src/services/payments/payment_gateway_service.dart:27-37`

```dart
String generateSignature(String razorpayOrderId, String razorpayPaymentId, String secret) {
  final hmac = Hmac(sha256, utf8.encode(secret));
  final digest = hmac.convert(utf8.encode('$razorpayOrderId|$razorpayPaymentId'));
  return digest.toString();
}
```

Standard Razorpay signature format: `HMAC_SHA256(order_id + "|" + payment_id, key_secret)`.

**Configurable enforcement** (`postgres_payment_service.dart:168`):
```dart
final enforceHmac = EnvService.get('ENFORCE_PAYMENT_HMAC') == 'true';
```

### 2.3 API Key Management

**File:** `freshpickkat_server/lib/src/services/payments/payment_gateway_service.dart:11-25`

| Variable | Source | Fallback |
|----------|--------|----------|
| `RAZORPAY_KEY_ID` | `.env` file | `RAZORPAY_KEY` |
| `RAZORPAY_KEY_SECRET` | `.env` file | `RAZORPAY_SECRET` |
| `RAZORPAY_WEBHOOK_SECRET` | `.env` file | — |

Keys are loaded at runtime from `.env` via `EnvService`. Never hardcoded. Never exposed to clients (except key ID needed by Razorpay Checkout SDK).

### 2.4 Database Row-Level Locking

To prevent race conditions during payment processing:

| Location | Query | Purpose |
|----------|-------|---------|
| `verifyPayment:210-223` | `SELECT ... FOR UPDATE` | Lock order + transaction rows |
| `completePaymentVerification:526-539` | `SELECT ... FOR UPDATE` | Lock order + transaction rows |
| `getOrCreatePaymentLink:629` | `SELECT ... FOR UPDATE` | Prevent double link creation |

### 2.5 Cron Advisory Locks

**File:** `freshpickkat_server/lib/src/services/background/payment_reconciliation_cron_job.dart:461-500`

```dart
Future<bool> _tryAdvisoryLock(Session session, int lockKey) async {
  final result = await session.db.unsafeQuery(
    'SELECT pg_try_advisory_lock(@lockKey::bigint) AS locked', ...);
  return result.first.toColumnMap()['locked'] == true;
}
```

Each cron job has a unique lock key. Ensures only one server instance runs each cron at a time. If lock acquisition fails, the cycle is skipped.

| Cron Job | Lock Key |
|----------|----------|
| Payment Reconciliation | 4200301 |
| Auto-Cancel Payments | 4200302 |
| Payment Link Expiry | 4200303 |
| Auto-Refund Processing | 4200304 |
| Session Expiry | 4200305 |
| Orphan Detection | 4200306 |
| Payment Link Reconciliation | 4200307 |

### 2.6 Payment Link Token Security

**File:** `freshpickkat_server/lib/src/services/postgres/postgres_payment_link_service.dart:15-23`

```dart
String generateSecureToken() {
  final bytes = List<int>.generate(32, (_) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return chars.codeUnitAt(_secureRandom.nextInt(chars.length));
  });
  return String.fromCharCodes(bytes);  // 32 bytes → 32-char alphanumeric
}
```

- Uses `Random.secure()` (cryptographically secure random from `dart:math`)
- **32 bytes** = 256 bits of entropy
- Token IS the authentication for public payment page endpoints
- Status machine: `ACTIVE` → `DISABLED` / `EXPIRED`
- `isUsed` flag prevents replay attacks

### 2.7 Webhook Security Checks

| Check | Location | Description |
|-------|----------|-------------|
| HMAC signature | `razorpay_webhook_route.dart:43-48` | SHA-256 HMAC over raw body |
| Amount validation | `razorpay_webhook_route.dart:69-92` | Expected vs actual, ±1 paise tolerance |
| Currency validation | `razorpay_webhook_route.dart:75-80` | Must be `INR` |
| Duplicate payment ID | `razorpay_webhook_route.dart:132-184` | Different ID → auto-refund job |
| Payment link ID mismatch | `razorpay_webhook_route.dart:600-621` | Token→linkId must match stored record |
| Closed order detection | `razorpay_webhook_route.dart:193-224` | Already cancelled → auto-refund |

### 2.8 Referral Fraud Protection

| Mechanism | Location | Description |
|-----------|----------|-------------|
| Self-referral blocked | `postgres_referral_service.dart:73,101,266` | At validation, apply, AND reward time |
| Monthly cap | `postgres_referral_service.dart:252-264` | Default 20/month per referrer |
| Min qualifying amount | `postgres_referral_service.dart:240` | Configurable minimum order value |
| Status gating | `postgres_referral_service.dart:241-242` | Only triggers on configured status (default `DELIVERED`) |
| Idempotency check | `postgres_referral_service.dart:244-250` | Already-rewarded invitee skipped |
| Duplicate code prevention | `app_user.referralCode` UNIQUE index | DB-level unique constraint |
| Unique invitee index | `referral.inviteeUserId` UNIQUE index | One referral per invitee |

### 2.9 Audit Log Events

**File:** `freshpickkat_server/lib/src/services/postgres/postgres_audit_log_service.dart`

| Event | Source |
|-------|--------|
| `DUPLICATE_PAYMENT_DETECTED` | Payment verification + webhook |
| `AUTO_REFUND_PROCESSING` | Cron job processing |
| `AUTO_REFUND_COMPLETED` | Refund succeeded |
| `AUTO_REFUND_FAILED` | Final failure |
| `AUTO_REFUND_RETRY` | Transient failure |
| `PAYMENT_SESSION_EXPIRED` | Session expiry cron |
| `ORPHAN_PAYMENT_DETECTED` | Orphan detection cron |
| `REFERRAL_CODE_APPLIED` | Referral code used |
| `REFERRAL_REWARD_PROCESSED` | Reward issued |
| `UPDATE_REFERRAL_SETTINGS` | Settings updated |
| `REFERRAL_REWARD_REJECTED` | Admin rejected reward |

---

## 3. Module 1: Payment Infrastructure

### 3.1 Razorpay Payment Flow

```
[Flutter Client]          [Server]              [Razorpay API]
     |                       |                       |
     |--- createOrder ------->|                       |
     |                       |--- POST /v1/orders --->|
     |                       |<-- razorpayOrderId ----|
     |<-- razorpayOrderId ---|                       |
     |                       |                       |
     |-- Razorpay Checkout  (client-side overlay)    |
     |-- User enters UPI --->|                       |
     |-- Payment complete ---|                       |
     |                       |                       |
     |--- verifyPayment ---->|                       |
     |   (razorpay_payment_id + signature)           |
     |                       |-- HMAC verification   |
     |                       |-- FOR UPDATE lock     |
     |                       |-- Update order: paid  |
     |                       |-- Deduct stock        |
     |                       |-- Delete cart         |
     |                       |-- Enqueue outbox      |
     |<-- success -----------|                       |
     |                       |                       |
     |                    [Webhook]                  |
     |                       |<-- payment.captured --|
     |                       |-- HMAC verification   |
     |                       |-- completePayment...  |
     |                       |-- Duplicate detection |
```

### 3.2 Key Files

| File | Lines | Purpose |
|------|-------|---------|
| `postgres_payment_service.dart` | 1877 | Core payment verification, reconciliation |
| `postgres_payment_link_service.dart` | 955 | Payment link management |
| `payment_gateway_service.dart` | 90 | Razorpay API client |
| `razorpay_webhook_route.dart` | 875 | Webhook event processing |
| `payment_reconciliation_cron_job.dart` | 501 | All cron jobs |
| `postgres_auto_refund_service.dart` | 176 | Auto-refund job management |
| `postgres_refund_service.dart` | 534 | Refund processing |

### 3.3 Payment States

```
Order States:
  placed → confirmed (on payment) → packed → out_for_delivery → delivered
    ↓ cancelled / payment_expired (on failure/expiry)

Payment States:
  pending → verifying → paid
    ↓ failed / cancelled

Refund States:
  none → processing → completed
    ↓ failed
```

### 3.4 Payment Links

**Two modes:**

| Mode | Description | URL |
|------|-------------|-----|
| `ENABLE_WEB_CHECKOUT=true` | Self-hosted payment page | `$baseUrl/pay/$token` |
| `ENABLE_WEB_CHECKOUT=false` | Razorpay hosted page | `rzp.io/...` |

**Lifecycle:**
1. Order created with `paymentStatus: 'pending'`
2. `initializePaymentSession()` generates UUID session
3. `getOrCreatePaymentLink()` creates Razorpay payment link with 20-min expiry
4. User clicks link → pays → webhook confirms → order completes
5. On expiry → cron marks order as `payment_expired`

### 3.5 Auto-Refund System

**Trigger conditions:**
- Different `gatewayPaymentId` arrives for an already-paid order
- Payment arrives for a cancelled/expired order
- Same `paymentId` → webhook retry (no action)

**Job states:** `PENDING` → `PROCESSING` → `COMPLETED` / `MANUAL_REVIEW`

**Suspicious amount check:** If payment > 1.5× order amount → `MANUAL_REVIEW`

**Retry schedule:**

| Attempt | Wait | Next Status |
|---------|------|-------------|
| 1 | Immediate | `PENDING` |
| 2 | 5 min | `PENDING` |
| 3 | 15 min | `PENDING` |
| 4 | 60 min | `PENDING` |
| 5 | 6 hours | `PENDING` |
| 6+ | Never | `MANUAL_REVIEW` |

**Crash recovery:** Jobs stuck in `PROCESSING` for >5 min are auto-recovered to `PENDING` on startup.

### 3.6 Cron Jobs Summary

| Job | Interval | Scope | Action |
|-----|----------|-------|--------|
| Payment Reconciliation | 2 min | Pending/verifying/failed < 24h | Check Razorpay status, recover |
| Payment Link Reconciliation | 5 min | Active links > 2 min old | Check Razorpay link status |
| Auto-Cancel | 1 min | Pending > 10 min | Cancel unpaid orders |
| Payment Link Expiry | 1 min | Expired links < 2 days | Mark orders cancelled |
| Auto-Refund Processing | 60 sec | PENDING jobs | Process refunds |
| Session Expiry | 1 min | Stale sessions | Mark expired |
| Orphan Detection | 5 min | Paid txn + unpaid order | Log for audit |

### 3.7 Webhook Event Routing

```
                         POST /razorpay-webhook
                                |
                         HMAC-SHA256 validation
                                |
                          JSON body parse
                                |
                    ┌───────────┼───────────┐
                    │           │           │
              payment.captured  │    payment_link.paid
                    │           │           │
              ┌─────┴─────┐     │     ┌─────┴─────┐
              │           │     │     │           │
         Already     Closed  Other  Link ID   Duplicate
         paid?       order?         mismatch?  payment?
              │           │     │     │           │
         Create     Create     │  Reject    Create
         auto-      auto-      │           auto-
         refund     refund     │           refund
              │           │     │           │
              └───────────┘     └───────────┘
                     │                │
              completePaymentVerification()
                     │
               ┌─────┴─────┐
               │           │
          Order update  Push notif
          Stock deduct  Real-time msg
          Cart delete
```

---

## 4. Module 2: Referral Growth System

### 4.1 Architecture Overview

```
[User Signup]
     │
     ├──→ referral code auto-generated (getOrCreateReferralCodeForUser)
     │
[User enters referral code]
     │
     ├──→ validateReferralCode() — 3 checks
     │     • Code exists on app_user
     │     • Not self-referral
     │     • Not already referred
     │
     ├──→ applyReferral() → ReferralRow(status: 'SIGNED_UP')
     │
[User places order → status changes]
     │
     └──→ checkOrderForReward() — 11 guard checks
           │
           ├──→ _processReward() — Transactional
                 ├── Create invitee coupon (CouponRow)
                 ├── Credit referrer FreshPoints
                 ├── Update referral → 'REWARDED'
                 └── Write audit log
           │
           └──→ Push notification (FCM topic user-{firebaseUid})
                 type: 'referral_reward'
```

### 4.2 Referral Code System

**Format:** `FPK` + 4 chars = 7 chars total  
**Char set:** `ABCDEFGHJKLMNPQRSTUVWXYZ23456789` (excludes I/O/0/1)  
**Uniqueness:** DB unique index + retry loop (10 attempts)

**Storage:** `app_user.referralCode` column with UNIQUE index.

**Generation on signup:** `postgres_user_service.dart:106-108` — runs inside the user creation transaction, only for `isNewUser == true`.

### 4.3 Code Validation (`validateReferralCode`)

```dart
1. Code matches an existing user's referralCode → else null
2. Code doesn't belong to current user → else null (self-referral)
3. Current user has no existing referral → else null (already referred)
```

### 4.4 Reward Engine (`checkOrderForReward`)

**11 sequential guard checks:**

| # | Check | On fail |
|---|-------|---------|
| 1 | Order exists | return |
| 2 | Order has userId | return |
| 3 | Order has finalAmount | return |
| 4 | Referral record exists for invitee | return |
| 5 | Not already REWARDED/REJECTED/EXPIRED | return |
| 6 | Referral program is enabled | return |
| 7 | Order amount ≥ minQualifyingAmount | return |
| 8 | Order status ≥ rewardTriggerStatus | return |
| 9 | Invitee not already rewarded (idempotency) | return |
| 10 | Monthly cap not exceeded | return |
| 11 | Not self-referral | status → REJECTED |

**Status comparison order:** `placed < confirmed < packed < out_for_delivery < delivered < cancelled < returned`

### 4.5 Reward Processing (`_processReward`)

**Inside DB transaction:**

```
1. Invitee Coupon (if enabled)
   → CouponRow(
       code: 'WELCOME{referralCodeUsed}',
       type: 'FLAT_DISCOUNT',
       value: settings.inviteeCouponAmount,
       maxUsageTotal: 1,
       expires: 30 days
     )

2. Referrer FreshPoints (if enabled)
   → AppUserRow.currentFreshPoints += points
   → AppUserRow.totalEarned += points
   → FreshPointsTransactionRow(
       type: 'REFERRAL_REWARD',
       referenceType: 'referral'
     )

3. Referral status update
   → ReferralRow.status = 'REWARDED'
   → qualifyingOrderId, amount, points, timestamp saved

4. Audit log
   → REFERRAL_REWARD_PROCESSED with full metadata
```

**After transaction (best-effort):**
```
5. Push notification
   → topic: 'user-{referrer.firebaseUid}'
   → title: 'Referral Reward Earned!'
   → body: 'You earned N FreshPoints...'
   → data: { type: 'referral_reward', points: N }
```

### 4.6 Referral Settings (Configurable)

| Setting | Default | Description |
|---------|---------|-------------|
| `isEnabled` | `true` | Master toggle |
| `inviteeCouponEnabled` | `true` | Give coupon to invitee |
| `inviteeCouponAmount` | `50.0` | Coupon discount value |
| `inviteeCouponCodeTemplate` | `'WELCOME{CODE}'` | Template with `{CODE}` placeholder |
| `referrerPointsEnabled` | `true` | Give points to referrer |
| `referrerRewardPoints` | `50` | Points per qualified referral |
| `minimumQualifyingAmount` | `0.0` | Min order amount for reward |
| `rewardTriggerStatus` | `'DELIVERED'` | Order status triggering reward |
| `maxRewardedPerMonth` | `20` | Per-referrer monthly cap |
| `enableFraudProtection` | `true` | Policy flag |
| `enableReferralExpiry` | `false` | Expiry toggle |
| `referralExpiryDays` | `90` | Days until expiry |
| `shareMessageTemplate` | `'Join...{CODE}...₹50 OFF'` | Share text |

### 4.7 Referral Statuses

| Status | Meaning | Terminal? |
|--------|---------|-----------|
| `LINK_SHARED` | Code shared (not used in practice — auto-advances) | No |
| `SIGNED_UP` | Invitee signed up with code | No |
| `QUALIFIED` | Order qualifies (manual approval mode) | No |
| `REWARDED` | Reward issued | Yes |
| `REJECTED` | Admin rejected / self-referral | Yes |
| `EXPIRED` | Expired (future use) | Yes |

### 4.8 API Endpoints

**User endpoints (no admin guard):**

| Method | Parameters | Returns |
|--------|------------|---------|
| `getMyReferralCodeInfo` | `userId` | `ReferralCodeInfo` (code, stats, share link) |
| `getMyReferralActivity` | `userId` | `List<ReferralActivity>` (timeline) |
| `validateReferralCode` | `code, currentUserId` | `Map?` (referrer info or null) |
| `applyReferralCode` | `inviteeUserId, inviteePhone, referralCode` | `void` |

**Admin endpoints (require `firebaseUid` + `idToken`):**

| Method | Parameters | Returns |
|--------|------------|---------|
| `updateSettings` | `settings` | `ReferralSettings` |
| `getReferralAnalytics` | — | `ReferralAdminStats` (funnel, top referrers) |
| `listReferrals` | `limit, pageToken, statusFilter` | `Map` (paginated JSON) |
| `approveReward` | `referralId` | `void` |
| `rejectReward` | `referralId, reason` | `void` |

**Public endpoint:**

| Method | Returns |
|--------|---------|
| `getSettings` | `ReferralSettings` (read-only, no auth) |

### 4.9 Push Notifications

**FCM Topic Pattern:** `user-{firebaseUid}` — each user subscribes on login.

**Notification payload:**
```json
{
  "type": "referral_reward",
  "points": "50"
}
```

**Client routing** (`notification_controller.dart:385-390`):
- `type == 'referral_reward'` → navigates to `InviteEarnScreen`

**Best-effort delivery:** Notification failure does not abort the reward transaction (try/catch wrapping).

### 4.10 Integration Hooks

**Order status change hooks** (6 locations in `order_endpoint.dart`):

| Hook | Trigger |
|------|---------|
| `updateOrderStatus` | Admin-driven status update |
| `confirmOrder` | Order confirmed |
| `cancelOrder` (with refund) | Order cancelled |
| `cancelOrder` (simple) | Order cancelled |
| `generateDeliveryOtp` | Delivery OTP generated |
| `verifyDeliveryOtp` | Order delivered |

Each hook follows: `enqueueOrderStatusChanged → checkOrderForReward → broadcastOrderEvent`

**Signup hook** (`postgres_user_service.dart:106-108`):
```dart
if (isNewUser) {
  final referral = PostgresReferralService();
  await referral.getOrCreateReferralCodeForUser(session, persistedId);
}
```

---

## 5. Server-Side Optimizations

### 5.1 Server-Side Hydration Pattern

**Problem:** Client apps made multiple paginated API calls per screen.  
**Solution:** Composite DTO endpoints that fetch all needed data in one server round-trip.

**Protocol models created (12 new):**

| Protocol | Contents |
|----------|----------|
| `HomePageHydratedData` | Banners, products, 4 rankings, BOGO, combo, delivery offer, categories |
| `AdminDashboardHydrated` | Stats + analytics merged |
| `CategoryHierarchy` | Categories with subcategories |
| `FreeDeliveryHydrated` | Free delivery product list |
| `CartHydratedData` | Pricing + suggestions + delivery config + coupons |
| `OrderDetailHydrated` | Order + refund + complaints |
| `ProductFormReferenceData` | BOGO + combo + category offers |

### 5.2 Home Page Optimization

**Before:** ~63 DB queries per load (separate fetches for each section)  
**After:** ~23 queries (fetch IDs → deduplicate → hydrate once → distribute)

**Pattern** (`postgres_home_service.dart`):
```
1. Fetch product IDs from 5 sources (BOGO, combo, ranking×4, category, featured)
2. Merge + deduplicate IDs
3. Hydrate all at once via hydrateProductsByIds()
4. Distribute hydrated products back to each source
```

**Resilience:** Each query wrapped with `.catchError()` → single failure returns empty list instead of crashing the entire endpoint.

### 5.3 Featured Variant Resolver

`FeaturedVariantResolver` selects the best variant per product using priority rules:

```
Priority: BOGO > Free Delivery > Combo > Discount > Default
```

Replaces the old `onlyDefaultVariant: true` approach. Each product now displays its most valuable variant with correct badges and pricing.

### 5.4 Cart Optimization

**Before:** 6 parallel API calls per cart refresh.  
**After:** 1 hydrated call (`getCartHydratedData`).

**Flow:**
1. Server fetches pricing first (to get subtotal)
2. Then fetches suggestions + delivery config + coupons in parallel with correct subtotal
3. Returns `CartHydratedData` protocol

**Fallback:** Client falls back to individual fetches if hydrated call fails.

### 5.5 Coupon Active-Only Filter

**Before:** All coupons returned (including inactive/expired).  
**After:** `getAvailableCoupons()` and `getBestCoupon()` filter with `activeOnly: true`.

Admin endpoints remain unchanged (need to see all coupons).

---

## 6. Test Coverage

### 6.1 Test Summary

 | Suite | Type | Count | Status |
|-------|------|-------|--------|
| Referral Code Generation | Unit | 4 | ✅ All pass |
| Referral System | Integration | 26 | ✅ All pass |
| Hardening — Fraud Rules | Unit | 3 | ✅ All pass |
| Hardening — Full Flow | Integration | 14 | ✅ All pass |
| Payment Link Flow | Integration | 4 | ✅ All pass |
| Auto-Refund Jobs | Integration | 5 | ✅ All pass |
| **Total** | | **56** | **✅ 56/56** |

### 6.2 Referral Unit Tests (`test/unit/referral_code_test.dart`)

| Test | Assertion |
|------|-----------|
| Format is FPK + 4 chars | Length 7, starts with 'FPK', suffix alphanumeric |
| Diverse codes | 100 calls → >90 unique codes |
| No ambiguous chars | 500 codes → no I/O/0/1 in suffix |
| Prefix always FPK | 50 codes → all start with 'FPK' |

### 6.3 Referral Integration Tests (`test/integration/referral_test.dart`)

**Code Generation + Storage (2 tests):**
1. Creates code on new user
2. Returns existing code on repeated call

**Validation (3 tests):**
1. Valid code returns referrer info
2. Invalid code returns null
3. Self-referral returns null

**Apply Referral (3 tests):**
1. Creates referral with status `SIGNED_UP`
2. Throws for invalid code
3. Throws for already referred user

**Referral Info + Activity (3 tests):**
1. Returns correct stats (zero case)
2. Counts rewarded referrals
3. Returns activity list

**Reward Engine — Happy Path (1 test):**
- Delivered order → status `REWARDED`, points issued, coupon created

**Reward Engine — Edge Cases (5 tests):**
1. Below min amount → no change
2. Before trigger status → no change
3. Already rewarded → no change
4. Monthly cap → second referral blocked
5. Self-referral → status `REJECTED` with fraud notes

**Settings CRUD (4 tests):**
1. `getSettings` returns null when empty
2. `getOrCreateSettings` creates defaults
3. `updateSettings` persists changes
4. `updateSettings` works without admin user

**Admin Analytics (1 test):**
- Counts by status + points + coupons + top referrers

**Admin List (2 tests):**
1. Pagination (page of 3, then remaining 2)
2. Status filter (`'REJECTED'` only)

**Admin Approve/Reject (2 tests):**
1. `rejectReward` sets status + fraud notes
2. `approveReward` processes reward for `QUALIFIED` referral

### 6.4 Test Infrastructure

- Serverpod's `withServerpod` pattern (real PostgreSQL, auto-rollback)
- Test database: `freshpickkat_test` on `localhost:9090`
- Migrations auto-applied before tests
- Each test runs in its own DB transaction (rolled back after)
- Seed helpers: `_seedUser()`, `_seedReferralRow()`, `_seedSettingsRow()`

---

## 7. Database Schema Changes

### 7.1 New Tables

**`referral` table:**
```sql
CREATE TABLE referral (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
  invitee_user_id UUID,
  invitee_phone TEXT NOT NULL,
  referral_code_used TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'LINK_SHARED',
  qualifying_order_id UUID,
  qualifying_order_amount DOUBLE PRECISION DEFAULT 0.0,
  reward_points_issued BIGINT DEFAULT 0,
  invitee_coupon_issued BOOLEAN DEFAULT false,
  reward_issued_at TIMESTAMPTZ,
  fraud_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX referral_invitee_idx ON referral(invitee_user_id);
CREATE INDEX referral_referrer_idx ON referral(referrer_user_id);
CREATE INDEX referral_code_status_idx ON referral(referral_code_used, status);
```

**`referral_settings` table:**
```sql
CREATE TABLE referral_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  is_enabled BOOLEAN DEFAULT true,
  invitee_coupon_enabled BOOLEAN DEFAULT true,
  invitee_coupon_amount DOUBLE PRECISION DEFAULT 50.0,
  invitee_coupon_code_template TEXT DEFAULT 'WELCOME{CODE}',
  referrer_points_enabled BOOLEAN DEFAULT true,
  referrer_reward_points BIGINT DEFAULT 50,
  minimum_qualifying_amount DOUBLE PRECISION DEFAULT 0.0,
  reward_trigger_status TEXT DEFAULT 'DELIVERED',
  max_rewarded_per_month BIGINT DEFAULT 20,
  enable_fraud_protection BOOLEAN DEFAULT true,
  enable_referral_expiry BOOLEAN DEFAULT false,
  referral_expiry_days BIGINT DEFAULT 90,
  share_message_template TEXT DEFAULT 'Join FreshPickKat using my referral code {CODE}. Get ₹50 OFF on your first order!',
  last_updated_by UUID,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

**`auto_refund_job` table:**
```sql
CREATE TABLE auto_refund_job (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES customer_order(id),
  order_number TEXT NOT NULL,
  customer_id UUID NOT NULL REFERENCES app_user(id),
  gateway_payment_id TEXT NOT NULL,
  payment_transaction_id UUID NOT NULL REFERENCES payment_transaction(id),
  amount DOUBLE PRECISION NOT NULL,
  job_status TEXT NOT NULL DEFAULT 'PENDING',
  attempts INT DEFAULT 0,
  last_error TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX auto_refund_job_gateway_id_idx ON auto_refund_job(gateway_payment_id);
```

### 7.2 Modified Tables

**`app_user` — added columns:**
```sql
ALTER TABLE app_user ADD COLUMN referral_code TEXT;
CREATE UNIQUE INDEX app_user_referral_code_idx ON app_user(referral_code);
ALTER TABLE app_user ADD COLUMN termsAcceptedAt TIMESTAMP;
```

**`referral` — added columns (Phase A hardening):**
```sql
ALTER TABLE referral ADD COLUMN fraudScore BIGINT DEFAULT 0;
ALTER TABLE referral ADD COLUMN fraudBreakdown TEXT;
ALTER TABLE referral ADD COLUMN holdExpiresAt TIMESTAMP;
ALTER TABLE referral ADD COLUMN scheduledReleaseAt TIMESTAMP;
ALTER TABLE referral ADD COLUMN attempts BIGINT DEFAULT 0;
ALTER TABLE referral ADD COLUMN lastError TEXT;
ALTER TABLE referral ADD COLUMN dailyShareCount BIGINT DEFAULT 0;
ALTER TABLE referral ADD COLUMN monthlyShareCount BIGINT DEFAULT 0;
ALTER TABLE referral ADD COLUMN lastShareDate TIMESTAMP;
```

**`referral_settings` — added columns (Phase A hardening):**
```sql
-- Fraud scoring settings
ALTER TABLE referral_settings ADD COLUMN enableFraudScoring BOOLEAN DEFAULT true;
ALTER TABLE referral_settings ADD COLUMN autoApproveThreshold BIGINT DEFAULT 40;
ALTER TABLE referral_settings ADD COLUMN manualReviewThreshold BIGINT DEFAULT 69;
ALTER TABLE referral_settings ADD COLUMN autoRejectThreshold BIGINT DEFAULT 90;
ALTER TABLE referral_settings ADD COLUMN enableRewardHold BOOLEAN DEFAULT true;
ALTER TABLE referral_settings ADD COLUMN holdDurationHours BIGINT DEFAULT 72;
ALTER TABLE referral_settings ADD COLUMN enableAutoReject BOOLEAN DEFAULT true;
-- Qualification settings
ALTER TABLE referral_settings ADD COLUMN minimumActualPaymentForQualification DOUBLE PRECISION DEFAULT 0;
ALTER TABLE referral_settings ADD COLUMN maxRewardedPerDay BIGINT DEFAULT 3;
ALTER TABLE referral_settings ADD COLUMN maxPendingReferrals BIGINT DEFAULT 50;
-- Velocity/fraud settings
ALTER TABLE referral_settings ADD COLUMN maxSharesPerDay BIGINT DEFAULT 100;
ALTER TABLE referral_settings ADD COLUMN maxSharesPerMonth BIGINT DEFAULT 1000;
ALTER TABLE referral_settings ADD COLUMN referralVelocityScore BIGINT DEFAULT 30;
ALTER TABLE referral_settings ADD COLUMN velocityTimeWindowHours BIGINT DEFAULT 24;
ALTER TABLE referral_settings ADD COLUMN velocityThreshold BIGINT DEFAULT 3;
ALTER TABLE referral_settings ADD COLUMN newAccountScore BIGINT DEFAULT 20;
ALTER TABLE referral_settings ADD COLUMN newAccountHours BIGINT DEFAULT 48;
-- Reversal & terms
ALTER TABLE referral_settings ADD COLUMN autoReversalWindowDays BIGINT DEFAULT 30;
ALTER TABLE referral_settings ADD COLUMN termsText TEXT;
```

**`coupon` — added columns:**
```sql
ALTER TABLE coupon ADD COLUMN assignedUserId UUID;
ALTER TABLE coupon ADD COLUMN assignedPhone TEXT;
```

### 7.3 Indexes Summary

| Table | Index | Type | Columns |
|-------|-------|------|---------|
| `app_user` | `app_user_referral_code_idx` | UNIQUE | `referral_code` |
| `referral` | `referral_invitee_idx` | UNIQUE | `invitee_user_id` |
| `referral` | `referral_referrer_idx` | B-tree | `referrer_user_id` |
| `referral` | `referral_code_status_idx` | B-tree | `referral_code_used, status` |
| `auto_refund_job` | `auto_refund_job_gateway_id_idx` | UNIQUE | `gateway_payment_id` |

---

## File Index

### Server

| File | Lines | Module |
|------|-------|--------|
| `lib/src/services/postgres/postgres_payment_service.dart` | 1877 | Payment |
| `lib/src/services/postgres/postgres_payment_link_service.dart` | 955 | Payment |
| `lib/src/services/postgres/postgres_refund_service.dart` | 534 | Payment |
| `lib/src/services/postgres/postgres_auto_refund_service.dart` | 176 | Payment |
| `lib/src/services/postgres/postgres_referral_service.dart` | 720 | Referral |
| `lib/src/services/postgres/postgres_audit_log_service.dart` | — | Shared |
| `lib/src/services/postgres/postgres_coupon_service.dart` | — | Coupon |
| `lib/src/services/postgres/postgres_home_service.dart` | — | Optimization |
| `lib/src/services/postgres/postgres_catalog_service.dart` | — | Optimization |
| `lib/src/services/payments/payment_gateway_service.dart` | 90 | Payment |
| `lib/src/services/firebase/firebase_notification_service.dart` | 525 | Notification |
| `lib/src/services/notifications/notification_service.dart` | 127 | Notification |
| `lib/src/services/background/payment_reconciliation_cron_job.dart` | 501 | Payment |
| `lib/src/services/background/order_outbox_service.dart` | — | Notification |
| `lib/src/services/postgres/postgres_user_service.dart` | — | Referral hook |
| `lib/src/endpoints/payment_endpoint.dart` | 349 | Payment |
| `lib/src/endpoints/payment_link_endpoint.dart` | 355 | Payment |
| `lib/src/endpoints/referral_endpoint.dart` | 137 | Referral |
| `lib/src/endpoints/user_endpoint.dart` | — | Referral hook |
| `lib/src/endpoints/order_endpoint.dart` | — | Referral hooks |
| `lib/src/web/routes/razorpay_webhook_route.dart` | 875 | Payment |
| `lib/src/protocol/db_rows/referral_row.spy.yaml` | 26 | Referral |
| `lib/src/protocol/db_rows/referral_settings_row.spy.yaml` | 20 | Referral |
| `lib/src/protocol/db_rows/auto_refund_job.spy.yaml` | — | Payment |
| `lib/src/protocol/db_rows/user_fcm_token_row.spy.yaml` | — | Notification |
| `lib/src/protocol/data_flow/referral.spy.yaml` | — | Referral |
| `lib/src/protocol/data_flow/referral_settings.spy.yaml` | — | Referral |
| `lib/src/protocol/data_flow/referral_code_info.spy.yaml` | — | Referral |
| `lib/src/protocol/data_flow/referral_activity.spy.yaml` | — | Referral |
| `lib/src/protocol/data_flow/referral_admin_stats.spy.yaml` | — | Referral |
| `lib/src/protocol/data_flow/top_referrer_entry.spy.yaml` | — | Referral |
| `lib/src/protocol/data_flow/payment_link_data.spy.yaml` | — | Payment |
| `lib/src/protocol/home_page_hydrated_data.spy.yaml` | — | Optimization |
| `lib/src/protocol/product_form_reference_data.spy.yaml` | — | Optimization |
| `test/unit/referral_code_test.dart` | 39 | Tests |
| `test/integration/referral_test.dart` | 776 | Tests |
| `test/integration/payment_link_flow_test.dart` | 231 | Tests |
| `test/integration/auto_refund_job_test.dart` | 251 | Tests |
| `lib/src/services/fraud/fraud_rule.dart` | — | Hardening (Phase B) |
| `lib/src/services/fraud/rules/hard_reject_rules.dart` | — | Hardening (Phase B) |
| `lib/src/services/fraud/rules/soft_score_rules.dart` | — | Hardening (Phase B) |
| `lib/src/services/fraud/postgres_fraud_score_service.dart` | — | Hardening (Phases B–C) |
| `lib/src/protocol/data_flow/referral_fraud_result.spy.yaml` | — | Hardening (Phase A) |
| `lib/src/protocol/data_flow/referral_fraud_rule_result.spy.yaml` | — | Hardening (Phase A) |
| `test/unit/fraud_rules_test.dart` | — | Hardening (Phase I) |
| `test/integration/hardening_test.dart` | — | Hardening (Phase I) |

### Flutter (User App)

| File | Purpose |
|------|---------|
| `lib/screens/checkout_screen.dart` | Checkout flow, retry, decision matrix |
| `lib/screens/order_detail_screen.dart` | Order detail with hydrated data |
| `lib/screens/invite_earn_screen.dart` | Referral code display + share + stats |
| `lib/notifications/controllers/notification_controller.dart` | Push notification routing |
| `lib/services/home_data_service.dart` | Single-call home page service |
| `lib/services/data_initialization_service.dart` | Uses single home page call |
| `lib/basket/cart_controller.dart` | Hydrated cart with fallback |
| `lib/controller/auth_controller.dart` | Firebase auth + app user state |
| `lib/controller/banner_controller.dart` | Banner resilience |

### Flutter (Admin App)

| File | Purpose |
|------|---------|
| `lib/screens/referral_dashboard_screen.dart` | Analytics + referral list + approve/reject |
| `lib/screens/referral_settings_screen.dart` | 12-field settings form |
| `lib/controller/admin_referral_controller.dart` | Referral state management |
| `lib/screens/payment_monitoring_screen.dart` | Auto-refund panel + health metrics |
| `lib/screens/dashboard_screen.dart` | Referral mini-card + drawer entry |

---

## 8. Hardening Phases A–I (Fraud Prevention & Security)

### 8.1 Phase A — Schema & Protocol

**New columns on `referral_row`:**
| Column | Type | Purpose |
|--------|------|---------|
| `fraudScore` | `int` (default 0) | Total fraud score from evaluation |
| `fraudBreakdown` | `text` (nullable) | JSON of per-rule fraud results |
| `holdExpiresAt` | `DateTime` (nullable) | When reward hold expires (72h default) |
| `scheduledReleaseAt` | `DateTime` (nullable) | When held reward auto-releases |
| `attempts` | `int` (default 0) | Retry count for held rewards |
| `lastError` | `text` (nullable) | Last error message |
| `dailyShareCount` | `int` (default 0) | Shares today |
| `monthlyShareCount` | `int` (default 0) | Shares this month |
| `lastShareDate` | `DateTime` (nullable) | Last share timestamp |

**New columns on `referral_settings`:**
| Category | Fields |
|----------|--------|
| Fraud Scoring | `enableFraudScoring`, `autoApproveThreshold` (40), `manualReviewThreshold` (69), `autoRejectThreshold` (90) |
| Hold/Reject | `enableRewardHold` (true), `holdDurationHours` (72), `enableAutoReject` (true) |
| Qualification | `minimumActualPaymentForQualification` (0), `maxRewardedPerDay` (3), `maxPendingReferrals` (50) |
| Velocity/New Acct | `referralVelocityScore` (30), `velocityTimeWindowHours` (24), `velocityThreshold` (3), `newAccountScore` (20), `newAccountHours` (48) |
| Share Limits | `maxSharesPerDay` (100), `maxSharesPerMonth` (1000) |
| Reversal | `autoReversalWindowDays` (30) |
| Terms | `termsText` (nullable) |

**New protocols:** `ReferralFraudRuleResult` (per-rule detail), `ReferralFraudResult` (aggregate outcome)

**Migration:** `20260621092616556`

### 8.2 Phase B — Fraud Scoring Engine

#### 8.2.1 Architecture
```
checkOrderForReward
    │
    └──→ PostgresFraudScoreService.evaluateReferral()
          │
          ├── Phase 1: Hard Reject Rules (score 999, immediate reject)
          │   ├── SameUidRule: referrer == invitee
          │   ├── SamePhoneRule: referrer phone == invitee phone
          │   └── AlreadyRewardedRule: invitee already REWARDED
          │
          └── Phase 2: Soft Score Rules (only if no hard reject)
              ├── SameAddressRule: shared address → escalating 20/40/70
              ├── SamePaymentContactRule: shared UPI/payment → +30
              ├── SamePayerNameRule: same name on payments → +20
              ├── ReferralVelocityRule: >N referrals in window → configurable
              └── NewAccountRule: account <N hours old → configurable
```

#### 8.2.2 Hybrid Outcome Routing

| Score Range | Outcome | Action |
|-------------|---------|--------|
| 0–39 | `AUTO_APPROVE` | Reward processed immediately |
| 40–69 | `MANUAL_REVIEW` | Status → `PENDING_REVIEW`, admin must approve |
| 70–89 | `AUTO_HOLD` | Status → `REWARD_HELD`, 72h hold (`holdExpiresAt`) |
| ≥90 | `AUTO_REJECT` | Status → `REJECTED`, score + breakdown stored |
| 999 (hard reject) | `AUTO_REJECT` | Status → `REJECTED`, rule name in fraud notes |

Overrides (settings): `enableAutoReject`, `enableRewardHold` can disable auto-reject/hold.

#### 8.2.3 Rule Implementation

**Interface** (`fraud_rule.dart`):
```dart
abstract class FraudRule {
  String get name;
  Future<FraudRuleResult> evaluate(Session session, ReferralRow referral);
}
class FraudRuleResult {
  final String ruleName;
  final int score;
  final bool hardReject;
  final String reason;
  final Map<String, dynamic>? details;
}
```

**Hard Reject Rules** (`hard_reject_rules.dart`):
| Rule | Condition | Score | Reason |
|------|-----------|-------|--------|
| `SameUidRule` | `referrerUserId == inviteeUserId` | 999 | `'Self-referral'` |
| `SamePhoneRule` | `app_user.phoneNumber` matches between referrer/invitee | 999 | `'Same phone number'` |
| `AlreadyRewardedRule` | Existing REWARDED referral for same invitee | 999 | `'Already rewarded'` |

**Soft Score Rules** (`soft_score_rules.dart`):
| Rule | Logic | Max Score |
|------|-------|-----------|
| `SameAddressRule` | Count shared addresses → 1→20, 2→40, 3+→70 | 70 |
| `SamePaymentContactRule` | Shared UPI/payment contact between users | 30 |
| `SamePayerNameRule` | Same `payerName` in payment transactions | 20 |
| `ReferralVelocityRule` | Referrals in window > threshold → score applied | Configurable |
| `NewAccountRule` | Account age < threshold hours → score applied | Configurable |

#### 8.2.4 Explainability

Every fraud decision stores a per-rule breakdown:
```json
{
  "totalScore": 50,
  "outcome": "MANUAL_REVIEW",
  "hardReject": false,
  "ruleResults": [
    {"ruleName": "SameUidRule", "score": 0, "passed": true, "reason": "Different user IDs"},
    {"ruleName": "SameAddressRule", "score": 20, "passed": false, "reason": "1 shared address found"}
  ]
}
```
Storage: `referral_row.fraudBreakdown` (JSON text), `referral_row.fraudScore` (int).

### 8.3 Phase C — Hybrid Reward Flow

**Updated `checkOrderForReward` flow:**
```
checkOrderForReward → 11 guard checks → Fraud Scoring
    │
    ├── AUTO_APPROVE → _processReward() → status REWARDED
    ├── MANUAL_REVIEW → status PENDING_REVIEW (admin approval needed)
    ├── AUTO_HOLD → status REWARD_HELD, holdExpiresAt = now + 72h
    ├── AUTO_REJECT → status REJECTED, fraud score + breakdown stored
    └── Hard Reject → status REJECTED, fraud notes = rule name
```

**Release held rewards** (`releaseHeldRewards()`): Queries `REWARD_HELD` where `holdExpiresAt ≤ now`, processes each via `_processReward()`. Runs every 5 min via cron timer (`_holdReleaseLock=4200308`).

**Approve reward** (`approveReward`): Handles `PENDING_REVIEW` → `REWARDED` path (admin approves manually flagged referrals).

**Status descriptions:** `getMyReferralActivity` displays human-readable descriptions for `PENDING_REVIEW`, `REWARD_HELD`, `REVERSED`.

### 8.4 Phase D — Qualification Hardening

| Check | Setting | Behavior |
|-------|---------|----------|
| Minimum actual payment | `minimumActualPaymentForQualification` | `order.finalAmount < threshold` → no reward |
| Daily cap | `maxRewardedPerDay` | Counts REWARDED referrals since midnight UTC; at/above limit → skip |
| Max pending | `maxPendingReferrals` | `applyReferral` rejects if referrer has ≥ limit in SIGNED_UP/PENDING_REVIEW/REWARD_HELD |

### 8.5 Phase E — Coupon Protection

**Ownership fields** on `coupon_row`: `assignedUserId` (UUID) and `assignedPhone` (text).

**Set during reward:** `_processReward` assigns coupon to invitee via:
```dart
CouponRow(
  assignedUserId: referral.inviteeUserId,
  assignedPhone: referral.inviteePhone,
)
```

**Validation** in `_evaluateCoupon`:
```dart
if (coupon.assignedUserId != null && coupon.assignedUserId != user.id) {
  return CouponValidationResult(isValid: false, errorMessage: 'Coupon not assigned to this user');
}
if (coupon.assignedPhone != null && coupon.assignedPhone != userPhone) {
  return CouponValidationResult(isValid: false, errorMessage: 'Coupon not assigned to this phone');
}
```

### 8.6 Phase F — Reward Reversal

**`reverseReward()`:**
1. Validates referral status is `REWARDED`
2. Deducts `rewardPointsIssued` from referrer's `currentFreshPoints` and `totalEarned`
3. Creates `FreshPointsTransactionRow` with `transactionType: 'REWARD_REVERSAL'`
4. Sets `ReferralRow.status = 'REVERSED'`, resets `rewardPointsIssued = 0`, stores reason in `fraudNotes`

**`autoReverseExpiredRewards()`:** Cron method — queries `REWARDED` referrals where `rewardIssuedAt` is beyond `autoReversalWindowDays` (configurable, default 30), calls `reverseReward` for each. Runs every 5 min via cron timer (`_autoReversalLock=4200309`).

**Admin endpoints:** `reverseReward(referralId, reason)`, `autoReverseExpiredRewards()`.

### 8.7 Phase G — Admin Fraud Dashboard (Server-Side)

| Endpoint | Returns |
|----------|---------|
| `getFraudAnalytics()` | Total referrals, fraud-scored count, avg score, rejection rate, system health tags |
| `getFraudBreakdown(referralId)` | `fraudScore` + parsed `fraudBreakdown` (List of rule results) |
| `reverseReward(referralId, reason, actorFirebaseUid)` | Manual override reversal |

No admin UI changes — endpoints are queryable via existing admin tools.

### 8.8 Phase H — Terms & Conditions

**Schema:** `app_user_row.termsAcceptedAt` — nullable `DateTime`, added via migration `20260621101601760`.

**Service methods:**
```dart
Future<void> acceptTerms(Session session, int userId) async {
  // Sets termsAcceptedAt = DateTime.now().toUtc()
}
Future<bool> hasAcceptedTerms(Session session, int userId) async {
  // Returns termsAcceptedAt != null
}
```

**Client UI** (`invite_earn_screen.dart`): Terms & Conditions text with checkbox. On accept, calls `referralService.acceptTerms(userId)`.

### 8.9 Phase I — Hardening Tests

**Unit tests** (`test/unit/fraud_rules_test.dart` — 3 tests):
| Test | Assertion |
|------|-----------|
| `FraudRuleResult toJson` | toJson produces correct map |
| `FraudRuleResult fromJson` | fromJson restores correctly |
| `FraudRuleResult passed` | passed result serializes correctly |

**Integration tests** (`test/integration/hardening_test.dart` — 14 tests):

| Category | Tests |
|----------|-------|
| Fraud Scoring (4) | Low score → AUTO_APPROVE; SameUid → hard reject; SamePhone → scores; AlreadyRewarded → hard reject |
| Qualification (3) | Minimum payment blocks; daily cap blocks; max pending blocks |
| Coupon Protection (3) | assignedUserId blocks; assignedPhone blocks; own coupon works |
| Reward Reversal (2) | Manual reverse deducts points; auto-reverse beyond window |
| Fraud Breakdown (1) | getFraudBreakdown returns stored score + breakdown |
| Terms (1) | acceptTerms stores timestamp |

### 8.10 Phase J — Production Validation Tests

**3 production validation tests** added to `test/integration/hardening_test.dart`:

| Test | Scenario | Assertion |
|------|----------|-----------|
| **Concurrency** | Two sequential calls to `checkOrderForReward` | FOR UPDATE + inner re-check prevent duplicate reward |
| **Idempotency** | Three sequential `checkOrderForReward` calls | Only 1 reward, 1 ledger, 1 coupon produced |
| **Negative Balance** | User with 20 points, reversal of 50 | Balance → 0, `outstandingRecoveryPoints=30`, `isRecoveryPending=true` |

**2 chaos retry tests** (also in `hardening_test.dart`):

| Test | Scenario | Mechanism |
|------|----------|-----------|
| **Chaos A** | FreshPoints credited + ledger entry exists, but referral still SIGNED_UP | Idempotency guard skips duplicate points credit, completes status update |
| **Chaos B** | Coupon exists, but referral still SIGNED_UP | Coupon insert is idempotent; FreshPoints credited once; status updated |

**Idempotency guard added** inside `_processReward`: before crediting FreshPoints, checks for existing `FreshPointsTransactionRow` with `REFERRAL_REWARD` type for this referral. Prevents duplicate points on retry after crash mid-reward.

### 8.11 Fraud Prevention Summary

| Feature | Implementation |
|---------|---------------|
| Identity abuse | SameUidRule, SamePhoneRule (hard reject) |
| Reward farming | AlreadyRewardedRule, daily cap, max pending |
| Address fraud | SameAddressRule (escalating 20/40/70) |
| Payment fraud | SamePaymentContactRule (+30), SamePayerNameRule (+20) |
| Velocity abuse | ReferralVelocityRule (config window × threshold) |
| Sybil attacks | NewAccountRule (age threshold) |
| Coupon theft | assignedUserId + assignedPhone validation |
| Reward clawback | reverseReward + autoReverseExpiredRewards |
| Explainability | Per-rule fraudBreakdown JSON on every decision |

---

## Key Security Decisions

| Decision | Rationale |
|----------|-----------|
| HMAC over raw bytes (not JSON) | Prevents serialization mismatch |
| DB `FOR UPDATE` locks | Prevents race conditions on payment |
| PostgreSQL advisory locks | Cross-instance cron coordination |
| `Random.secure()` for tokens | Cryptographically secure randomness |
| Payment link as auth token | No Firebase dependency for shared payment links |
| Referral code retry loop (10×) | Collision unlikely but handled gracefully |
| Reward notification best-effort | Don't let notification failure abort reward |
| `ENFORCE_PAYMENT_HMAC` toggle | Flexible enforcement in dev/test |
| Audit log for all critical actions | Traceability for support/forensics |
| Order ownership verification | Prevent unauthorized payment access |

---

## Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `RAZORPAY_KEY_ID` | Yes | Razorpay API key |
| `RAZORPAY_KEY_SECRET` | Yes | Razorpay API secret |
| `RAZORPAY_WEBHOOK_SECRET` | Yes | Webhook HMAC secret |
| `ENFORCE_PAYMENT_HMAC` | No | Toggle signature enforcement (default off) |
| `ENABLE_WEB_CHECKOUT` | No | Self-hosted vs Razorpay payment page |
