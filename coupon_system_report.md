# Coupon System — Complete Architecture Report

## 1. Database Schema

### Table: `coupon`

| Column | Type | Description |
|--------|------|-------------|
| `id` | `uuid PK` | Auto-generated primary key |
| `code` | `text UNIQUE` | Coupon code (uppercase, unique) |
| `description` | `text?` | Human-readable description |
| `couponType` | `text` | `FLAT_DISCOUNT` or `PERCENTAGE_DISCOUNT` |
| `couponCategory` | `text` | `General`, `Loyalty`, `Product Based`, `Seasonal` |
| `discountValue` | `double?` | Flat amount or percentage value |
| `minOrderAmount` | `double` | Minimum cart subtotal required (default 0) |
| `maxDiscountAmount` | `double?` | Max discount cap (required for percentage type) |
| `maxUsageTotal` | `bigint?` | Global usage limit across all users |
| `maxUsagePerUser` | `bigint?` | Per-user usage limit |
| `loyaltyRequiredOrders` | `bigint?` | Completed orders needed (Loyalty category) |
| `usedCount` | `bigint` | Current usage count (default 0) |
| `startsAt` | `timestamp?` | Offer start date |
| `endsAt` | `timestamp?` | Offer end date |
| `status` | `text` | `active` or `inactive` (default `active`) |
| `deactivatedAt` | `timestamp?` | When deactivated |
| `assignedUserId` | `uuid?` | User-specific coupon (referral reward) |
| `assignedPhone` | `text?` | Phone-specific coupon (referral reward) |
| `productIds` | `text?` | Comma-separated product IDs for Product Based |
| `createdAt` | `timestamp` | Creation time |
| `updatedAt` | `timestamp` | Last update time |

---

## 2. Admin Coupon CRUD — Fields & Behavior

### Create / Edit Form (`catalog_coupons_tab.dart`)

| Field | Required | Behavior |
|-------|----------|----------|
| **Code** | Yes | Auto-uppercased, validated unique. Disabled in edit mode. |
| **Description** | Yes | Shown to users in coupon list. |
| **Coupon Category** | Yes | `General` — no restrictions. `Loyalty` — requires `completedOrders >= loyaltyRequiredOrders`. `Product Based` — requires `productIds` list. `Seasonal` — no additional restrictions. |
| **Discount Type** | Yes | `FLAT_DISCOUNT` — fixed ₹ off. `PERCENTAGE_DISCOUNT` — % off (max 100%). |
| **Discount Value** | Yes | Amount or percentage. |
| **Min Order Amount** | Yes (default 0) | Cart subtotal must be >= this. |
| **Max Discount** | Conditional | Required when type = `PERCENTAGE_DISCOUNT`. Cap on max discount. |
| **Max Uses Per User** | No | How many times a single user can use it. |
| **Active** | Yes | Toggle. Controls `status` field. |
| **Valid From / Valid Until** | No | Date range. `endsAt` must be after `startsAt`. |
| **Product IDs** | Conditional | Required when category = `Product Based`. Comma-separated product IDs that must be in cart. |
| **Notification** | No (create only) | Optional push notification on coupon creation (title, body, image URL). |

### Admin Actions

| Action | Method | Behavior |
|--------|--------|----------|
| **Create** | `uploadCoupon()` | Inserts row, optionally creates notification + audit log |
| **Update** | `updateCoupon()` | Updates row + audit log |
| **Toggle Active** | `setCouponActive()` | Toggles status `active`/`inactive` with cascade deactivation dialog |
| **Delete** | `deleteCoupon()` | Soft delete — checks dependencies (banners, free delivery rules, orders), sets status `inactive` |
| **Hard Delete** | `hardDeleteCoupon()` | Permanent row deletion |

---

## 3. User-Facing Coupon Flow

### 3.1 How Coupons Reach the User

```
Cart Page Load
  ↓
CartController._runCartMetaRefresh() OR applyCartHydratedData()
  ↓
getCartHydratedData() or fetchAvailableCoupons()
  ↓
getAvailableCoupons() → evaluates all active coupons against cart
  ↓
Returns List<CouponDisplay> with isApplicable, reason, discountAmount
  ↓
CouponSection UI renders applicable + non-applicable lists
```

### 3.2 Auto-Apply Behavior

The app **automatically applies** the best eligible coupon. Users never manually apply.

```
Pricing Engine runs
  ↓
if autoApplyCoupons == true
  ↓
getBestCoupon() → evaluates all active coupons → picks highest discount
  ↓
Coupon discount subtracted from subtotal
  ↓
Result: couponDiscount, appliedCoupon (with isAutoApplied: true)
```

### 3.3 Manual Apply (Alternative Path)

```
User taps "Apply" on a coupon in CouponSection
  ↓
CartController.applyCoupon(code)
  ↓
CouponEndpoint.applyCoupon(code, subtotal, items, userId)
  ↓
_evaluateCoupon() runs full validation checklist
  ↓
Returns CouponValidationResult with isValid, discountAmount
  ↓
If valid → pricing re-run with this coupon → order total updated
```

### 3.4 Coupon Screens

| Screen | File | Purpose |
|--------|------|---------|
| **CouponSection** (cart page) | `coupon_section.dart` | Shows applicable offers, best auto-applied badge, locked offers |
| **Coupons Screen** (full page) | `coupons_screen.dart` | All active coupons with "Copy Code" button |
| **Basket Suggestions** | Various | Coupon suggestions scored alongside BOGO/combo/delivery suggestions |

---

## 4. Coupon Evaluation Checklist

Complete validation in `_evaluateCouponWithContext()` (`postgres_coupon_service.dart:501-588`):

| # | Check | Condition | Result |
|---|-------|-----------|--------|
| 1 | Code empty | `code.isEmpty` | Not applicable |
| 2 | Active status | `!coupon.isActive` | Not applicable |
| 3 | Start date | `now.isBefore(startDate)` | "Coupon is not active yet" |
| 4 | Expiry | `now.isAfter(expiryDate)` | "Coupon has expired" |
| 5 | Min order amount | `subtotal < minOrderAmount` | "Add ₹X more to use this coupon" |
| 6 | Login required | FIRST_ORDER/LOYALTY type & no userId | Login required |
| 7 | First order check | FIRST_ORDER & `completedOrdersCount > 0` | Not applicable |
| 8 | Loyalty check | LOYALTY & `completedOrdersCount < requiredOrders` | "Need X more orders" |
| 9 | Per-user usage limit | Already used coupon before (`userCouponUsageCount > 0`) | "Already used" |
| 10 | Product-based eligibility | PRODUCT_BASED & no matching products in cart | Not applicable |
| 11 | **Ownership check** | `assignedUserId` doesn't match OR `assignedPhone` doesn't match | "Coupon not assigned to you" |

---

## 5. Security & Hardening

### 5.1 Coupon Ownership (Hardening Phase E)

Every coupon can have `assignedUserId` and `assignedPhone` fields:

```
_evaluateCoupon() at postgres_coupon_service.dart:461-478
  ↓
if coupon.assignedUserId is set → must match current user's ID
if coupon.assignedPhone is set → must match current user's phone
  ↓
Mismatch → returns "Coupon not assigned to you" / "Coupon not assigned to your phone"
```

- Set during referral reward processing (`postgres_referral_service.dart:166-195`)
- Validated during every coupon evaluation
- Prevents sharing of user-specific coupons

### 5.2 Active-Only Filter

- `getAvailableCoupons()` and `getBestCoupon()` always use `activeOnly: true`
- Only fetches `status = 'active'` rows from DB
- `_evaluateCouponWithContext()` also checks `coupon.isActive`
- Admin endpoints (CRUD) bypass the active filter (show all)

### 5.3 Validation on Save

Server-side validation in `validation_service.dart:90-164`:

```
validateCoupon(Coupon)
  ├── Code required
  ├── Description required
  ├── minOrderAmount >= 0
  ├── endDate after startDate
  ├── maxDiscount/maxDiscountAmount >= 0
  ├── usageLimit >= 0
  ├── loyaltyRequiredOrders >= 0
  ├── Category must be: General, Loyalty, Product Based, Seasonal
  ├── Discount type must be: FLAT_DISCOUNT or PERCENTAGE_DISCOUNT
  ├── discountValue >= 0
  ├── Percentage cannot exceed 100
  ├── Max discount required for percentage type
  └── Product Based requires at least one productId
```

### 5.4 Usage Limit Enforcement

| Limit | Enforced At | Mechanism |
|-------|-------------|-----------|
| Total usage (`maxUsageTotal`) | Order payment | `usedCount` incremented on successful payment |
| Per-user usage (`maxUsagePerUser`) | Coupon evaluation | `_countUserCouponUsage()` checks past orders with this coupon |
| Decrement on cancel | Order cancellation | `_decrementCouponUsage()` on order cancellation |

---

## 6. Pricing Engine Integration

### 6.1 Order of Operations

```
1. Product discounts (variant realPrice vs salePrice)
2. Combo discounts
3. BOGO discounts
4. Category offers
5. COUPON DISCOUNT  ← here
6. Shop More, Get More reward
7. Free delivery check
8. FreshPoints deduction
9. Final total
```

### 6.2 Coupon Placement in Pipeline

```
effectiveSubtotal = subtotal - comboDiscount - bogoDiscount - categoryDiscount

if appliedCouponCode provided (manual):
  → couponService.applyCoupon(code, effectiveSubtotal, items, userId)
  → result.couponDiscount = validated discount

if autoApplyCoupons == true (auto):
  → couponService.getBestCoupon(effectiveSubtotal, items, userId)
  → result.couponDiscount = best coupon's discount
  → result.appliedCoupon.isAutoApplied = true

effectiveSubtotal -= result.couponDiscount
```

### 6.3 Discount Calculation

```
_calculateDiscountAmount() (postgres_coupon_service.dart:714)
  ├── FLAT_DISCOUNT: amount = min(discountValue, maxDiscountAmount) OR discountValue
  └── PERCENTAGE_DISCOUNT: amount = min(subtotal * discountValue/100, maxDiscountAmount)
```

---

## 7. Coupon Snapshot & Order History

When an order is placed, the coupon details are **immutably captured**:

```json
// Snapshot stored in customer_order.couponSnapshot
{
  "couponId": "uuid",
  "couponCode": "WELCOME10",
  "discountType": "FLAT_DISCOUNT",
  "discountValue": 100,
  "appliedDiscount": 100
}
```

- Built by `SnapshotBuilder.buildCouponSnapshot()` (`snapshot_builder.dart:180-189`)
- Stored during `createPendingOrder()` and cart-to-pending conversion
- Preserved even if coupon is later deleted
- Referenced by FK `couponId` for live resolution

---

## 8. Coupon Usage Lifecycle

```
Admin creates coupon → CouponRow inserted (usedCount=0)

User adds to cart → getAvailableCoupons() evaluates → shows applicable

Order placed → couponSnapshot stored, couponId FK set

Payment successful → usedCount +1 (postgres_payment_service.dart:1561-1572)

Order cancelled → usedCount -1 (postgres_order_service.dart:1895-1919)
                   (decrementCouponUsage)

Admin deactivates → cascade_deactivation_service analyzes impact:
                     → deactivates linked banners
                     → deactivates linked free delivery rules

Product deactivated → coupons referencing that product via productIds
                      auto-deactivated
```

---

## 9. Referral Coupon Integration

### 9.1 Welcome Coupon (for Invitee)

```
Referral applied → new user signs up
  ↓
postgres_referral_service.dart:166-195
  ↓
Creates CouponRow with:
  ├── code: WELCOME{referralCode} (e.g., WELCOMEABC123)
  ├── type: FLAT_DISCOUNT
  ├── discountValue: from referral_settings.inviteeCouponDiscountValue
  ├── maxUsageTotal: 1
  ├── maxUsagePerUser: 1
  ├── assignedUserId: invitee's ID
  ├── assignedPhone: invitee's phone
  └── endDate: now + inviteeCouponValidityDays
```

### 9.2 Reward Qualification Check

```
checkOrderForReward() (postgres_referral_service.dart:454-462)
  ↓
if settings.inviteeCouponEnabled:
  → Looks up the welcome coupon by code template
  → Checks order.couponId matches welcome coupon's id
  → If no match → reward not qualified
```

---

## 10. Cascade Deactivation & Dependencies

### What happens when a coupon is deactivated:

```
setCouponActive(code, false)
  ↓
cascade_deactivation_service._analyzeCouponDeactivation()
  ├── Finds banners linked to this coupon → deactivates them
  └── Finds free delivery rules linked to this coupon → deactivates them
```

### What happens when a product is deactivated:

```
Product deactivated
  ↓
cascade_deactivation_service.deactivateCouponsForProducts()
  ↓
Finds all active coupons where productIds CSV contains the product
  ↓
Sets their status to inactive
```

### Dependency Checker (`dependency_checker.dart`):

```
checkCoupon(code):
  ├── Counts banners referencing this coupon
  ├── Counts free delivery rules referencing this coupon
  └── Counts orders referencing this coupon

checkProduct(productId):
  └── Counts coupons with productIds containing this product
```

---

## 11. Basket Suggestion Integration

Coupons are scored as basket suggestions alongside other offer types:

```
_scoreCoupon() (basket_suggestion_service.dart:920-976)
  ├── Fetches best coupon via getBestCoupon()
  ├── Creates BasketSuggestion with type: 'coupon'
  ├── Scored based on savings amount, relevance, urgency
  └── User can apply via suggestion action handler
```

---

## 12. Protocol Models Summary

| DTO | Fields | Purpose |
|-----|--------|---------|
| `CouponRow` | All DB columns | Database ORM |
| `Coupon` | id, code, description, type, discountValue, minOrderAmount, maxDiscount, maxDiscountAmount, productIds, loyaltyRequiredOrders, startDate, endDate, expiryDate, usageLimit, maxUsagePerUser, usedCount, isActive, couponCategory, assignedUserId, assignedPhone | Admin CRUD API |
| `CouponDisplay` | id, code, description, type, couponCategory, minOrderAmount, maxDiscount, maxDiscountAmount, discountValue, isDeliveryDiscount, isApplicable, status, reason, discountAmount, isBest | User-facing evaluation result |
| `CouponValidationResult` | isValid, couponCode, couponId, couponType, errorMessage, discountAmount, isDeliveryDiscount | Apply coupon response |
| `AppliedCouponInfo` | couponId, couponCode, discountAmount, isAutoApplied | Embedded in pricing result |
| `BestCouponResult` | bestCouponCode, discountAmount | Auto-apply best coupon response |
