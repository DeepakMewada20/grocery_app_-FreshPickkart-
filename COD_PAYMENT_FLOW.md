# COD Payment Flow — Cash & Online (UPI QR)

## Table of Contents
1. [Overview](#overview)
2. [Cash COD Flow](#cash-cod-flow)
3. [Online UPI QR Flow — Payment Session](#online-upi-qr-flow--payment-session)
4. [Session Lifecycle — State Machine](#session-lifecycle--state-machine)
5. [Admin UI Lifecycle — Polling & Display](#admin-ui-lifecycle--polling--display)
6. [Security Measures](#security-measures)
7. [Database Schema](#database-schema)
8. [File Reference](#file-reference)

---

## Overview

COD (Cash on Delivery) supports two collection modes:

| Mode | Description | When Used |
|------|-------------|-----------|
| `cash` | Admin collects physical cash at delivery | Customer pays cash |
| `upi_qr` | Customer scans Razorpay UPI QR with GPay/PhonePe/Paytm | Customer pays digitally at doorstep |

Both modes share the same delivery lifecycle but diverge at payment collection.

| Aspect | Cash | UPI QR |
|--------|------|--------|
| Payment gateway | None | Razorpay Dynamic QR API |
| Mark paid | Immediately on admin confirm | Only on webhook confirmation |
| Collection proof | Physical cash | Razorpay payment record |
| Failure risk | Counterfeit cash | Expired QR, network issue |
| Steps | 1 (confirm → paid) | 5+ (create → show → scan → webhook → paid) |

---

## Cash COD Flow

### Order Lifecycle (checkout to delivery)

```
[User]                          [Server]                     [Admin]
  │                               │                            │
  ├── Place COD order ──────────► │                            │
  │                               ├── paymentMode='cod'        │
  │                               ├── paymentStatus='pending'  │
  │                               ├── orderStatus='confirmed'  │
  │                               │                            │
  │                               │    ┌── confirmed ──────────┤
  │                               │    ├── packed ─────────────┤
  │                               │    ├── out_for_delivery ───┤
  │                               │    │                       │
  │                               │    │  [Shows: "Collect COD │
  │                               │    │   Payment" card]      │
  │                               │    │  [Cash] [UPI QR]      │
  │                               │    │                       │
  │                               │    ├── Click "Cash" ──────►│
  │                               │◄───┤   Confirmation dialog │
  │                               │    │                       │
  │                               ├── collectCodPayment()      │
  │                               ├── Validates:               │
  │                               │   • paymentMode='cod'      │
  │                               │   • paymentStatus!='paid'  │
  │                               │   • paymentCollectedAt=null│
  │                               │   • orderStatus not        │
  │                               │     delivered/cancelled    │
  │                               ├── paymentStatus='paid'     │
  │                               ├── paymentCollectionMode=   │
  │                               │   'cash'                   │
  │                               ├── paymentCollectedAt=now   │
  │                               ├── paymentCollectedBy=admin │
  │                               │                            │
  │                               │    [Delivery buttons now   │
  │                               │     appear: Photo/OTP]     │
  │                               │    ├── Photo or OTP ───────►│
  │                               │    ├── delivered ──────────►│
```

### Key Points
- Payment is marked **paid immediately** on admin confirmation
- No external payment gateway involved
- Single-step: confirm → paid
- `paymentCollectionMode` = `'cash'`

---

## Online UPI QR Flow — Payment Session

### Session = Temporary Payment Object

When admin clicks "UPI QR", a **PaymentSession** is created. This is NOT the order — it is a temporary object that represents "a UPI QR code was generated, we are waiting for payment".

```
Order #FPK-12345
  │
  ├── paymentMode = 'cod'
  ├── paymentStatus = 'pending'
  │
  └── PaymentSession (1 order can have many sessions over time)
        ├── id = uuid
        ├── status = 'ACTIVE' (or PAID/EXPIRED/CANCELLED/FAILED)
        ├── razorpayQrId = 'qr_xxx'
        ├── qrImageUrl = 'https://rzp.io/...'
        ├── expiresAt = now + 5 min
        ├── amount = order.finalAmount (frozen at creation)
        └── createdByAdminId = admin Firebase UID
```

### Full Sequence (step by step with code)

#### STEP 1 — Admin taps "UPI QR" button
**File:** `order_detail_screen.dart:909-928`

Button click → calls `_startQrPaymentSession(context, order)`

#### STEP 2 — `_startQrPaymentSession()` (admin UI)
**File:** `order_detail_screen.dart:1298-1329`

```
setState(isLoading = true)
→ _orderController.createQrPaymentSession(order.orderId)
   (calls endpoint)
→ If session returned:
    _qrSession = session
    _showQrSection = true
    _startPolling(context)
    check if already PAID
→ If null: show error snackbar
→ On error: show error snackbar
→ finally: setState(isLoading = false)
```

#### STEP 3 — Server: `createQrPaymentSession()` (endpoint)
**File:** `payment_session_endpoint.dart:17-28`

```
ensureAdminSeller(firebaseUid, idToken)
→ _paymentSessions.createQrPaymentSession(session, orderId, adminFirebaseUid)
```

#### STEP 4 — Server: `createQrPaymentSession()` (service)
**File:** `postgres_payment_session_service.dart:29-143`

This is the CORE method. It runs inside a DB transaction:

```
┌─ Transaction BEGIN ─────────────────────────────────────────────────┐
│                                                                      │
│  1. Find order by orderNumber                                       │
│     → If null: return FAILED session, error="Order not found"       │
│                                                                      │
│  2. FOR UPDATE lock on order row                                    │
│     → SELECT "id" FROM customer_order WHERE id = @id FOR UPDATE     │
│     → Blocks concurrent admin from creating another session         │
│                                                                      │
│  3. Re-read order under lock                                        │
│     → Validate:                                                     │
│       • paymentMode must be 'cod'                                   │
│       • paymentStatus must NOT be 'paid'                            │
│       • If already paid → return FAILED session                     │
│                                                                      │
│  4. Check for existing ACTIVE session                               │
│     → If found → return existing session (don't create duplicate)   │
│     → Prevents multiple QR codes for same order                     │
│                                                                      │
│  5. Insert PaymentSessionRow                                        │
│     → status = 'ACTIVE'                                             │
│     → amount = order.finalAmount (frozen!)                          │
│     → expiresAt = now + 5 minutes                                   │
│     → customerId, createdByAdminId set                              │
│                                                                      │
│  6. Call Razorpay API: POST /v1/payments/qr_codes                   │
│     → body: {                                                       │
│         type: "upi_qr",                                             │
│         usage: "single_use",                                        │
│         fixed_amount: true,                                         │
│         payment_amount: amountInPaise,                              │
│         description: "COD payment - Order FPK-XXX",                 │
│         close_by: now+5min_epoch,                                   │
│         notes: { order_id, session_id }                             │
│       }                                                             │
│     → If API fails (non-200):                                       │
│         • Delete the session row (rollback insert)                  │
│         • Return FAILED session with error                          │
│     → If API succeeds:                                              │
│         • Extract razorpayQrId, qrImageUrl from response            │
│         • Update session row with these values                      │
│                                                                      │
│  7. Return PaymentSessionData to admin                              │
│     → success: true                                                 │
│     → sessionId: uuid                                               │
│     → qrImageUrl: Razorpay CDN URL                                  │
│     → status: "ACTIVE"                                              │
│     → expiresInSeconds: remaining seconds                           │
│                                                                      │
└─ Transaction END ───────────────────────────────────────────────────┘
```

#### STEP 5 — Admin UI shows QR section
**File:** `order_detail_screen.dart:1407-1537`

```
┌────────────────────────────────────────────┐
│  Online Payment (UPI QR)                   │
│  Amount: ₹250.00                            │
│                                            │
│  Status: ● ACTIVE                          │
│  Expires in: 04:32                         │
│                                            │
│  ┌────────────────────────────────────┐    │
│  │         [QR Code Image]           │    │
│  │    (loaded from qrImageUrl)       │    │
│  └────────────────────────────────────┘    │
│                                            │
│  [Refresh]                                 │
│                                            │
│  Customer scans with GPay / PhonePe /      │
│  Paytm / BHIM                              │
└────────────────────────────────────────────┘
```

| State | What admin sees |
|-------|----------------|
| `ACTIVE` | QR image, green dot, countdown timer, Refresh button |
| `PAID` | Green checkmark "Payment Received", QR hidden |
| `EXPIRED` | Orange "QR Expired", Regenerate QR button |
| `CANCELLED` | Orange "Session CANCELLED", Regenerate QR button |
| `FAILED` | Orange "Session FAILED", Regenerate QR button |
| Loading | Spinner "Generating QR..." |

#### STEP 6 — Polling starts
**File:** `order_detail_screen.dart:1331-1366`

```
_startPolling(context):

Timer.periodic(Duration(seconds: 3), (_) async {
  if (!mounted) { _pollTimer?.cancel(); return; }

  session = await _orderController.getQrPaymentSession(orderId)
  if (session == null || !mounted) return;

  setState(() => _qrSession = session);

  if (session.status == 'PAID') {
    _pollTimer?.cancel();
    _handleQrPaid(context, _order, session);
    // → delivery buttons appear
  }
  else if (session.status == 'EXPIRED' ||
           session.status == 'CANCELLED' ||
           session.status == 'FAILED') {
    _pollTimer?.cancel();
    // Grace check: wait 3 seconds for late webhook
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && _qrSession?.status != 'PAID') {
        setState(() { /* show expired UI */ });
      }
    });
  }
  // else ACTIVE → keep polling
});
```

**Polling stops when:**
| Condition | Trigger |
|-----------|---------|
| Session status = `PAID` | Immediate stop, _handleQrPaid() |
| Session status = `EXPIRED` | Stop, 3s grace, then show expired |
| Session status = `CANCELLED` | Stop, 3s grace, then show cancelled |
| Session status = `FAILED` | Stop, 3s grace, then show failed |
| Screen unmounts (dispose) | `_pollTimer?.cancel()` in dispose() |
| Admin navigates away | Widget disposed → mounted=false → timer auto-stops on next tick |

#### STEP 7 — Customer scans QR and pays
Customer opens GPay/PhonePe/Paytm → scans QR → sees pre-filled amount → confirms payment → Razorpay receives payment

#### STEP 8 — Razorpay sends webhook
**File:** `razorpay_webhook_route.dart:53-78`

```
POST /razorpay-webhook
Headers:
  x-razorpay-signature: <HMAC-SHA256>

Body:
{
  "entity": "event",
  "account_id": "acc_xxx",
  "event": "qr_code.paid",
  "contains": ["qr_code", "payment"],
  "payload": {
    "qr_code": {
      "entity": {
        "id": "qr_AbC123XyZ",
        "type": "upi_qr",
        "status": "paid"
      }
    },
    "payment": {
      "entity": {
        "id": "pay_PaymentId123",
        "amount": 25000,          ← paise (₹250.00)
        "currency": "INR",
        "status": "captured"
      }
    }
  },
  "created_at": 1234567890
}
```

**Webhook processing order (critical):**

```
Line 22: HMAC verification → reject if invalid
   ↓
Line 53: Check event == "qr_code.paid" → YES → process HERE
   ↓   (BEFORE line 54-101: before paymentId extraction,
   ↓    before order lookup, before COD skip guard!)
   ↓
Extract: qrId = payload.payload.qr_code.entity.id
         paymentId = payload.payload.payment.entity.id
         amount = payload.payload.payment.entity.amount
   ↓
Call: _paymentSessions.handleQrWebhookPayment(
        session,
        razorpayQrId: qrId,
        gatewayPaymentId: paymentId,
        paidAmount: amount / 100
      )
   ↓
Return 200 OK
```

**Why this runs before line 54:**
- Line 54-101 extracts paymentId, orderNumber, order, amount, currency
- Line 94-101: "if order.paymentMode == 'cod' → skip (return 200)"
- If `qr_code.paid` reached line 94, it would be SKIPPED because the order is COD
- Solution: `qr_code.paid` handler at line 53 → processes BEFORE line 54 → never reaches COD skip

#### STEP 9 — Server: `handleQrWebhookPayment()` (service)
**File:** `postgres_payment_session_service.dart:343-435`

```
┌─ Transaction BEGIN ─────────────────────────────────────────────────┐
│                                                                      │
│  1. Find PaymentSessionRow by razorpayQrId (UNIQUE index)           │
│     → If null: log warning, return error "Session not found"        │
│                                                                      │
│  2. Validate session status == 'ACTIVE'                              │
│     → If PAID/EXPIRED/CANCELLED: return error "Session not active"  │
│                                                                      │
│  3. Validate amount                                                 │
│     → if |session.amount - paidAmount| > 1.0:                       │
│       return error "Amount mismatch"                                │
│     → Prevents: customer paying ₹100 for ₹500 order                 │
│                                                                      │
│  4. FOR UPDATE lock on order row                                    │
│     → SELECT ... FROM customer_order WHERE id = @id FOR UPDATE      │
│                                                                      │
│  5. Validate order.paymentStatus != 'paid'                           │
│     → If already paid: return error "Already paid"                  │
│     → Edge case: admin collected cash while QR was active           │
│                                                                      │
│  6. UPDATE PaymentSessionRow                                        │
│     → status = 'PAID'                                               │
│     → paidAt = now                                                  │
│     → gatewayPaymentId = paymentId from webhook                     │
│                                                                      │
│  7. UPDATE CustomerOrderRow                                         │
│     → paymentStatus = 'paid'                                        │
│     → paymentCollectedAt = now                                      │
│     → paymentCollectedBy = session.createdByAdminId                 │
│     → paymentCollectionMode = 'upi_qr'                              │
│                                                                      │
│  8. Log: "COD online payment completed for order X via QR session Y"│
│     → Return success                                                │
│                                                                      │
└─ Transaction END ───────────────────────────────────────────────────┘
```

#### STEP 10 — Admin UI detects PAID on next poll
Next 3-second poll → `_qrSession.status == 'PAID'` → `_handleQrPaid()`:

```
_handleQrPaid(context, order, session):
  setState(
    _showQrSection = false
    _qrSession = null
    _order = order.copyWith(
      paymentStatus = 'paid'
      paymentCollectedAt = session.paidAt
      paymentCollectedBy = 'You'
      paymentCollectionMode = 'upi_qr'
    )
  )
  → Shows snackbar "Payment received via UPI QR!"
  → Screen rebuilds → lifecycle actions show delivery buttons
  → Admin can now do Photo/OTP delivery
```

#### STEP 11 — Delivery verification
Same as cash COD — admin completes delivery with Photo or OTP verification.

---

## Session Lifecycle — State Machine

### State Diagram

```
                    ┌────────────────────────┐
                    │       CREATED           │
                    │  (row inserted in DB)   │
                    └───────────┬────────────┘
                                │
                    Razorpay API call
                   ┌───────────┴───────────┐
                   │                       │
                   ▼                       ▼
          ┌────────────────┐     ┌──────────────────┐
          │    ACTIVE       │     │     FAILED        │
          │ QR ready, poll  │     │ Razorpay API err  │
          │ started         │     │ (session DELETED) │
          └──┬────┬────┬───┘     └──────────────────┘
             │    │    │
    ┌────────┘    │    └──────────┐
    ▼             ▼               ▼
┌────────┐ ┌──────────┐ ┌──────────────┐
│  PAID  │ │ EXPIRED  │ │  CANCELLED   │
│Webhook │ │ 5min up  │ │ Cash/Admin   │
│recvd   │ │ no pay   │ │ fallback     │
└────────┘ └──────────┘ └──────────────┘

ALL 4 are TERMINAL states:
  • PAID → never change (payment recorded)
  • EXPIRED → new session must be created
  • CANCELLED → new session must be created
  • FAILED → new session must be created
```

### State Descriptions

| State | Meaning | DB Fields Set | When does it happen? |
|-------|---------|--------------|----------------------|
| **CREATED** | Session row inserted, waiting for Razorpay API | `id`, `orderId`, `customerId`, `createdByAdminId`, `amount`, `status='CREATED'`, `expiresAt`, `createdAt`, `updatedAt` | Inside DB transaction, before Razorpay API call |
| **ACTIVE** | Razorpay QR created, ready to scan | Above + `razorpayQrId`, `qrImageUrl`, `status='ACTIVE'` | After Razorpay API returns 200 |
| **PAID** | Payment confirmed via webhook | Above + `status='PAID'`, `paidAt`, `gatewayPaymentId` | Webhook `qr_code.paid` received |
| **EXPIRED** | 5 minutes passed, no payment | Above + `status='EXPIRED'`, `expiredAt` | Admin clicks "Regenerate QR" → `expireCurrentSession()` |
| **CANCELLED** | Admin cancelled session | Above + `status='CANCELLED'`, `cancelledAt` | Admin collects cash while QR active (TODO) |
| **FAILED** | Razorpay API error | Above + `status='FAILED'` | Razorpay API returns non-200 (session also DELETED from DB) |

### Transition Conditions

| From | To | Condition | Who triggers |
|------|----|-----------|-------------|
| CREATED | ACTIVE | Razorpay API returns 200 with QR data | Server (in transaction) |
| CREATED | FAILED | Razorpay API returns non-200/throws | Server (session deleted, return error) |
| ACTIVE | PAID | Webhook received, amount matches, session active | Razorpay webhook |
| ACTIVE | EXPIRED | Admin requests regenerate | Admin via Regenerate button |
| ACTIVE | CANCELLED | Admin collects cash (TODO: not yet implemented) | Admin via Cash button |

### Why CREATED state exists

Between "session row inserted" and "Razorpay QR created", there is a brief moment (~200-500ms) where the session is in CREATED state. This is a transient state — you should never see it in the admin UI because:

1. Row inserted → immediate Razorpay API call
2. API success → row updated to ACTIVE (within same transaction)
3. API failure → row deleted (within same transaction)

The admin UI only sees ACTIVE or FAILED.

### Why FAILED sessions are DELETED (not kept)

When Razorpay API fails:
- The session row is **deleted** from DB (transaction rollback equivalent)
- Admin sees error message "Failed to create UPI QR"
- Can try again → fresh session created

This prevents DB pollution from failed attempts. If the session were kept with FAILED status, admin would need to manually clean up.

### Why EXPIRED sessions are NOT deleted

Unlike FAILED, EXPIRED sessions are **kept** in DB because:
- The Razorpay QR may still be active (Razorpay side may not have closed it yet)
- Need to track history: "this session was generated but expired"
- Admin needs to see "Expired" status to know QR was generated earlier
- Allows audit trail: who created, when it expired

### Regenerate Flow (EXPIRED → new ACTIVE)

```
Admin clicks "Regenerate QR"

_expireCurrentSession(orderId):
  1. Find ACTIVE session for this order
  2. If found:
     a. Call Razorpay CLOSE /v1/payments/qr_codes/{qrId}/close
        (non-fatal if fails)
     b. UPDATE session: status='EXPIRED', expiredAt=now
  
  → (no DB transaction — simple sequential updates)

_createQrPaymentSession(orderId, adminFirebaseUid):
  → Same as STEP 4 above
  → New session row, new Razorpay QR
  → New 5-minute expiry
```

After regenerate:
- **Old session**: EXPIRED (kept for audit)
- **New session**: ACTIVE (brand new QR code)
- Admin sees fresh QR + fresh 5-minute countdown

### Cash Fallback (TODO — Not Yet Implemented)

Current behavior if admin clicks "Cash" while a QR session is ACTIVE:
- `collectCodPayment('cash')` marks order as paid immediately
- QR session remains ACTIVE in DB
- **Problem**: Webhook can still fire later, but `handleQrWebhookPayment` will detect `order.paymentStatus == 'paid'` and reject with "Already paid"
- **But**: The session remains ACTIVE forever — no way to expire it

**Recommended fix**: In `collectCodPayment` (cash path), check for active session and expire it:
```
if (collectionMode == 'cash') {
  // Expire any active QR session
  await expireCurrentSession(session, orderId: orderId);
}
```

---

## Admin UI Lifecycle — Polling & Display

### Timeline from admin perspective

```
Admin taps "UPI QR"
    │
    ├── setState(loading)
    ├── API: createQrPaymentSession
    │
    ▼
Server processes (FOR UPDATE lock, Razorpay API call)
    │
    ├── SUCCESS: returns session with status='ACTIVE'
    │   │
    │   ├── setState(_qrSession=session, _showQrSection=true)
    │   ├── setState(loading=false)
    │   ├── _startPolling(context)
    │   │   └── Timer.periodic(3s)
    │   │
    │   ├── [UI shows QR image + countdown]
    │   │
    │   ├── Poll #1 (3s) → status='ACTIVE' → continue
    │   ├── Poll #2 (6s) → status='ACTIVE' → continue
    │   ├── Poll #3 (9s) → status='ACTIVE' → continue
    │   ├── ... (customer scans and pays) ...
    │   │
    │   ├── Razorpay sends webhook
    │   │
    │   ├── Poll #N → status='PAID'
    │   │   ├── _pollTimer.cancel()
    │   │   ├── _handleQrPaid()
    │   │   │   ├── setState(_showQrSection=false, order updated)
    │   │   │   └── snackbar "Payment received!"
    │   │   └── [Delivery buttons appear]
    │   │
    │   └── (OR Poll #N → status='EXPIRED')
    │       ├── _pollTimer.cancel()
    │       ├── wait 3 seconds (grace period)
    │       ├── if status still != 'PAID':
    │       │   setState(show expired UI)
    │       └── [Regenerate QR button appears]
    │
    └── ERROR: throws exception
        ├── setState(loading=false)
        └── snackbar "Failed to start QR payment: <error>"
```

### What polling does NOT do

| Not done | Reason |
|----------|--------|
| Polling does NOT write to DB | Read-only endpoint `getQrPaymentSession` |
| Polling does NOT update order | Order updated ONLY by webhook |
| Polling does NOT expire sessions | Only manual regenerate triggers expiry |
| Polling does NOT create duplicate sessions | Only `createQrPaymentSession` does that |
| Polling does NOT poll after PAID | Timer cancelled immediately |

### Polling lifecycle

```
Timer starts:  After createQrPaymentSession returns success
Timer runs:    Every 3 seconds
Timer stops:   • Session PAID → immediate stop
               • Session EXPIRED → stop, 3s grace
               • Session CANCELLED → stop, 3s grace
               • Session FAILED → stop, 3s grace
               • Widget dispose → stop (in dispose())
               • mounted=false → auto stop on next tick
```

### Grace period after expiry

```
Poll detects EXPIRED
  │
  ├── _pollTimer.cancel()           ← Stop polling
  ├── Future.delayed(3 seconds)     ← Wait for late webhook
  │     │
  │     ├── After 3s: check _qrSession?.status
  │     │   │
  │     │   ├── If PAID → ignore (will be caught by _handleQrPaid)
  │     │   │
  │     │   └── If still EXPIRED/CANCELLED/FAILED → setState()
  │     │       → Show expired UI with Regenerate button
```

Purpose of 3-second grace: Razorpay webhook may arrive at the exact same moment as poll detects expiry. The grace period gives the webhook 3 extra seconds to process before declaring the session expired.

---

## Security Measures

### 1. Immutable Payment Records
- **Double-collection guard**: `collectCodPayment` checks `paymentStatus != 'paid'` AND `paymentCollectedAt == null` — rejects if already paid
- **Protected fields**: Once `paymentStatus = 'paid'`, these fields are never written again: `paymentStatus`, `paymentCollectionMode`, `paymentCollectedAt`, `paymentCollectedBy`, `codFailureReason`
- **Session integrity**: Once a PaymentSession reaches PAID/EXPIRED/CANCELLED, its status is never changed back to ACTIVE

### 2. Webhook Security
- **HMAC validation**: Every webhook request verified via `x-razorpay-signature` header against `RAZORPAY_WEBHOOK_SECRET` — rejects forged requests
- **Early return**: `qr_code.paid` handler runs BEFORE the existing COD skip guard (line 94-101), ensuring QR payments are never accidentally filtered
- **Amount validation**: Webhook validates paid amount against session amount (tolerance ₹1) — prevents over/under payment fraud
- **Session lookup by qrId**: Webhook finds session by unique `razorpayQrId` index — cannot be confused with other sessions

### 3. Database-Level Locks
- **FOR UPDATE**: Order row is locked during `createQrPaymentSession` AND `handleQrWebhookPayment` — prevents race conditions
  - Two admins cannot create sessions simultaneously
  - Webhook cannot process while session is being created
  - Cash collection and webhook cannot happen at same time
- **Transaction atomicity**: Session creation + Razorpay API call + order update are all in a DB transaction — partial failures roll back completely
- **Unique constraint**: `razorpayQrId` has a UNIQUE index — prevents duplicate processing

### 4. Amount Freezing
- Session amount is frozen at creation time (`order.finalAmount`)
- If admin modifies order amount after session creation, they must regenerate QR (old QR shows wrong amount)
- **Regenerate flow**: Expire old session → create new session with updated amount → new QR

### 5. Single-Use QR
- Razorpay QR is created with `usage: "single_use"` — can only be paid once
- `fixed_amount: true` — customer cannot modify the amount during payment
- QR auto-closes after 5 minutes via `close_by` timestamp

### 6. Admin Authentication
- **Every endpoint**: Requires `ensureAdminSeller` — Firebase UID + ID token verified on every call
- **Audit trail**: All payment collections logged to `admin_audit_log` with action `collect_cod_payment`
- **Session tracking**: `createdByAdminId` on PaymentSessionRow records which admin initiated the QR

### 7. Client-Side Safety
- **Polling only reads**: Admin UI polls `getQrPaymentSession` (read-only) — never writes state from client
- **Server is single source of truth**: All status transitions happen server-side or via webhook
- **Dispose safety**: Poll timer cancelled on screen close, component unmount, or PAID/EXPIRED detection

---

## Database Schema

### payment_session table

```sql
CREATE TABLE "payment_session" (
    "id"                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId"               uuid NOT NULL REFERENCES customer_order(id) ON DELETE RESTRICT,
    "customerId"            uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    "createdByAdminId"      text NOT NULL,
    "paymentMethod"         text NOT NULL DEFAULT 'cod_online',
    "collectionMode"        text NOT NULL DEFAULT 'upi_qr',
    "amount"                double precision NOT NULL,
    "currency"              text NOT NULL DEFAULT 'INR',
    "status"                text NOT NULL,         -- CREATED, ACTIVE, PAID, EXPIRED, CANCELLED, FAILED
    "razorpayQrId"          text,                  -- Razorpay QR code ID (unique)
    "qrImageUrl"            text,                  -- Razorpay CDN URL for QR image
    "gatewayPaymentId"      text,                  -- Razorpay payment ID (set on webhook)
    "gatewaySignature"      text,
    "gatewayTransactionReference" text,
    "notes"                 text,                  -- JSON: { order_id, session_id }
    "createdAt"             timestamp DEFAULT CURRENT_TIMESTAMP,
    "expiresAt"             timestamp NOT NULL,    -- 5 min from creation
    "paidAt"                timestamp,
    "expiredAt"             timestamp,
    "cancelledAt"           timestamp,
    "updatedAt"             timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX payment_session_order_idx ON payment_session(orderId);
CREATE UNIQUE INDEX payment_session_razorpay_qr_idx ON payment_session(razorpayQrId);
CREATE INDEX payment_session_status_idx ON payment_session(orderId, status);
```

### Customer Order — COD-related fields

| Column | Used For |
|--------|----------|
| `paymentMode` | `'cod'` for both cash and UPI QR |
| `paymentStatus` | `'pending'` → `'paid'` (immediate for cash, on webhook for QR) |
| `paymentCollectedAt` | Timestamp of when payment was collected |
| `paymentCollectedBy` | Admin Firebase UID who collected |
| `paymentCollectionMode` | `'cash'` or `'upi_qr'` |
| `codFailureReason` | Set when delivery fails after payment |
| `gatewayPaymentId` | Razorpay payment ID (set by webhook for QR) |

### Table Relationships

```
┌──────────────────┐       ┌──────────────────────┐
│   customer_order  │       │   payment_session     │
├──────────────────┤       ├──────────────────────┤
│ id (PK)          │◄──────│ orderId (FK)          │
│ userId (FK)      │       │ customerId (FK)       │
│ paymentMode      │       │ status                │
│ paymentStatus    │       │ razorpayQrId (UNIQUE) │
│ paymentCollectedAt      │ expiresAt             │
│ paymentCollectedBy      │ paidAt                │
│ paymentCollectionMode   │ expiredAt             │
└──────────────────┘       └──────────────────────┘
                                  │
                                  │ (1 order : N sessions)
                                  │
                           One order can have
                           multiple sessions over time:
                           ┌─────────────────┐
                           │ Session #1      │ → EXPIRED
                           │ Session #2      │ → EXPIRED
                           │ Session #3      │ → PAID (final)
                           └─────────────────┘
```

---

## File Reference

| File | Role |
|------|------|
| `freshpickkat_server/lib/src/protocol/db_rows/payment_session_row.spy.yaml` | DB table protocol |
| `freshpickkat_server/lib/src/protocol/data_flow/payment_session_data.spy.yaml` | API DTO protocol |
| `freshpickkat_server/lib/src/services/payments/payment_gateway_service.dart` | Razorpay QR API calls (createUpiQr, fetchQrCode, closeQrCode) |
| `freshpickkat_server/lib/src/services/payments/postgres_payment_session_service.dart` | Session lifecycle: create, get, expire, regenerate, webhook handler |
| `freshpickkat_server/lib/src/endpoints/payment_session_endpoint.dart` | Admin endpoints (create/get/regenerate) |
| `freshpickkat_server/lib/src/web/routes/razorpay_webhook_route.dart` | `qr_code.paid` webhook handler (before line 54) |
| `freshpickkat_server/lib/src/endpoints/order_endpoint.dart` | `collectCodPayment` — rejects `upi_qr`, only handles cash now |
| `freshpickkat_server/lib/src/services/postgres/postgres_order_service.dart` | `collectCodPayment` — validates order state, updates payment fields |
| `freshpickkat_admin/lib/controller/admin_order_controller.dart` | 3 new PaymentSession API methods |
| `freshpickkat_admin/lib/screens/order_detail_screen.dart` | Split Cash/UPI QR buttons, QR section widget, polling, regenerate |
| `freshpickkat_client/lib/src/protocol/client.dart` | `EndpointPaymentSession` class with 3 methods |
| `freshpickkat_server/migrations/20260707100953983/` | DB migration for payment_session table |

---
