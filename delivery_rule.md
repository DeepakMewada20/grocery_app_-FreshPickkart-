# Delivery Rule System — Documentation

## Table of Contents
1. [Overview](#1-overview)
2. [Architecture](#2-architecture)
3. [Delivery Config & Slabs](#3-delivery-config--slabs)
4. [Special Delivery Rules](#4-special-delivery-rules)
5. [Target User Types](#5-target-user-types)
6. [Evaluation Flow](#6-evaluation-flow)
7. [Sort Order System](#7-sort-order-system)
8. [Date Range & Expiry](#8-date-range--expiry)
9. [Product-Level Free Delivery Override](#9-product-level-free-delivery-override)
10. [Admin CRUD Operations](#10-admin-crud-operations)
11. [Security & Auth](#11-security--auth)
12. [Validation Rules](#12-validation-rules)
13. [Dependency Checking](#13-dependency-checking)
14. [Cascade Deactivation](#14-cascade-deactivation)
15. [Audit Logging](#15-audit-logging)
16. [API Endpoints](#16-api-endpoints)
17. [Database Schema](#17-database-schema)
18. [Complete Pricing Flow](#18-complete-pricing-flow)
19. [Common Issues & Fixes](#19-common-issues--fixes)

---

## 1. Overview

Delivery Rule System FreshPickKart mein delivery fee calculate karne ke liye hai. Iske 3 layers hain:

| Layer | Purpose |
|-------|---------|
| **Special Delivery Rules** (`delivery_rule` table) | Time-bound ya user-targeted fee overrides (e.g., "1st order free delivery", "5th order ₹20") |
| **Delivery Slabs** (`delivery_slab` table) | Cart total ke hisaab se automatic fee slabs (e.g., ₹0-199 → ₹40, ₹200-299 → ₹20) |
| **Base Delivery Fee** (`delivery_config` table) | Default fee jab koi rule/slab match na kare |
| **Product Free Delivery** (`product.isFreeDelivery`) | Product-level override, sabse upar precedence |

### Evaluation Hierarchy (top to bottom):
```
1. Special Delivery Rule (user-targeted) → match mila to yahin stop
2. Delivery Slab (cart total based) → match mila to yahin stop
3. Base Delivery Fee → default fallback
4. [Override] Product Free Delivery → upar ke teeno ko override karta hai
```

---

## 2. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Client (App/Web)                         │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  PricingEngine                                        │   │
│  │  → DeliveryChargeCalculator.calculate()               │   │
│  └──────────────────┬───────────────────────────────────┘   │
└─────────────────────┼───────────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────────┐
│              ▼                                              │
│  DeliveryChargeCalculator                                   │
│  ┌─────────────────────────────────────┐                    │
│  │  1. DeliveryEngine.calculate()      │ ← Rules + Slabs    │
│  │  2. _hasPromotionalFreeDelivery()   │ ← Product override │
│  │  3. Merge/Prioritize results        │                    │
│  └──────────────────┬──────────────────┘                    │
│                     ▼                                       │
│  DeliveryEngine                                             │
│  ┌─────────────────────────────────────┐                    │
│  │  calculate()                        │                    │
│  │  ├─ getActiveDeliveryRules()        │                    │
│  │  ├─ matchesUserAsync()             │                    │
│  │  ├─ sort by sortOrder ASC          │                    │
│  │  ├─ _matchSlab()                   │                    │
│  │  └─ _buildResult()                 │                    │
│  └──────────────────┬──────────────────┘                    │
│                     ▼                                       │
│  PostgresDeliveryService                                    │
│  ┌─────────────────────────────────────┐                    │
│  │  getAllDeliveryRules()              │                    │
│  │  upsertDeliveryRule()               │                    │
│  │  deleteDeliveryRule()               │                    │
│  │  swapSortOrder()                    │                    │
│  │  getDeliveryConfig()               │                    │
│  └──────────────────┬──────────────────┘                    │
│                     ▼                                       │
│  PostgreSQL (delivery_rule, delivery_config, delivery_slab) │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Delivery Config & Slabs

### DeliveryConfig (`delivery_config` table)

Base delivery settings jo pura system control karta hai:

```yaml
class: DeliveryConfig
fields:
  configId: String?
  baseDeliveryFee: double        # Default fee (e.g., ₹40)
  slabs: List<DeliverySlab>      # Slab definitions
  isActive: bool
  updatedAt: DateTime
```

### DeliverySlab (`delivery_slab` table)

Cart total ke hisaab se automatic fee calculation:

```yaml
class: DeliverySlab
fields:
  minOrderAmount: double
  maxOrderAmount: double
  fee: double
```

**Default Slabs** (jab DB empty ho):
| Min Amount | Max Amount | Fee |
|------------|-----------|-----|
| ₹0 | ₹199 | ₹40 |
| ₹200 | ₹299 | ₹20 |
| ₹300 | ₹999999 | ₹0 (Free) |

### Slab Matching Logic (`_matchSlab` in `delivery_engine.dart`)

```dart
static DeliverySlab? _matchSlab(double cartTotal, List<DeliverySlab> slabs) {
  for (final slab in slabs) {
    if (cartTotal >= slab.minOrderAmount && cartTotal <= slab.maxOrderAmount) {
      return slab;
    }
  }
  return null;
}
```

- Linearly iterate karta hai
- Pehla matching slab select hota hai
- `maxOrderAmount = 999999` ka matlab "above this" (unlimited)

---

## 4. Special Delivery Rules

### DB Table: `delivery_rule`

```yaml
class: DeliveryRuleRow
table: delivery_rule
fields:
  id: UuidValue?                    # Auto-generated UUID
  name: String                      # Rule name (e.g., "New User Offer")
  description: String?              # Optional description
  deliveryFee: double               # Applied fee (0 = free)
  sortOrder: int                    # Lower number = evaluated first
  targetUserType: String?           # 'all', 'new_user', 'specific_order'
  targetOrderCount: int?            # Required for 'specific_order'
  startsAt: DateTime?               # Campaign start (nullable = no start limit)
  endsAt: DateTime?                 # Campaign end (nullable = no end limit)
  status: String                    # 'active' ya 'inactive'
  deactivatedAt: DateTime?          # When soft-deleted
  createdAt: DateTime
  updatedAt: DateTime
```

### API DTO: `DeliveryRule`

```yaml
class: DeliveryRule
fields:
  ruleId: String?
  name: String
  description: String?
  deliveryFee: double
  sortOrder: int
  targetUserType: String?
  targetOrderCount: int?
  isActive: bool
  startDate: DateTime?
  endDate: DateTime?
  createdAt: DateTime
```

### Key Changes from Old Design:
| Old Field | New Field | Change |
|-----------|-----------|--------|
| `ruleType` | removed | All rules are equal — no `special_event`/`user_rule` distinction |
| `priority` | `sortOrder` | Renamed for clarity; lower = evaluated first (same as before) |
| `startsAt`/`endsAt` (NOT NULL) | `startsAt`/`endsAt` (nullable) | Optional expiry — null means no limit |

### Key Points:
- `ruleType` removed: All rules evaluate dates if set, skip if null
- `sortOrder` auto-assigned on insert (max existing + 1)
- No renumbering on delete — sortOrder values remain stable
- Admin can move rules up/down (swaps sortOrder with neighbor)
- `freeDeliveryReason` stores Rule ID first (`ruleId`), falls back to Rule Name for old orders

---

## 5. Target User Types

### `all` (default)

- **Sabhi users ke liye applicable**
- Agar `targetUserType` null/empty hai to bhi `all` treat hota hai
- Koi condition nahi — har user ke liye match karega
- Example: "Free delivery for everyone during Diwali"

```dart
if (target == null || target.isEmpty || target == 'all') {
  return true; // Sabke liye match
}
```

### `new_user`

- **Sirf un users ke liye jinhone kabhi order deliver nahi karwaya**
- Check: `completedOrdersCount <= 0`
- Completed orders = `orderStatus == 'delivered'` wale orders
- Example: "Free delivery on your 1st order!"

```dart
if (target == 'new_user') {
  return _isNewUser(session, userId ?? '');
}

static Future<bool> _isNewUser(Session session, String userId) async {
  final count = await _getCompletedOrdersCount(session, userId);
  return count <= 0;
}
```

### `specific_order`

- **Specific order number ke liye** (e.g., 5th order)
- `targetOrderCount` field specify karta hai ki kaunsa order hai
- Match tab hota hai jab: `completedOrdersCount == (targetOrderCount - 1)`
  - targetOrderCount=5 → 4 orders complete hain → 5th order pe apply
- Example: "Free delivery on your 5th order!"

```dart
if (target == 'specific_order') {
  if (rule.targetOrderCount == null || rule.targetOrderCount! <= 0) {
    return false;
  }
  final count = await _getCompletedOrdersCount(session, userId);
  return count == (rule.targetOrderCount! - 1);
}
```

### Validation (server-side):

```dart
final targetType = rule.targetUserType?.trim().toLowerCase();
if (targetType != null && targetType.isNotEmpty &&
    targetType != 'all' && targetType != 'new_user' && targetType != 'specific_order') {
  throw InvalidParametersException('Invalid delivery target user type');
}
if (targetType == 'specific_order' &&
    (rule.targetOrderCount == null || rule.targetOrderCount! <= 0)) {
  throw InvalidParametersException(
    'Target order count is required and must be greater than 0 for specific_order rules',
  );
}
```

---

## 6. Evaluation Flow

```
DeliveryEngine.calculate()
│
├─ Step 1: Fetch config + active rules
│   ├─ getDeliveryConfig() → DeliveryConfig (baseFee, slabs)
│   └─ getActiveDeliveryRules() → List<DeliveryRule>
│
├─ Step 2: Filter matching rules (user targeting + date check)
│   for each rule:
│   ├─ matchesUserAsync(session, rule, userId)
│   │   ├─ targetUserType = null/'all' → true
│   │   ├─ targetUserType = 'new_user' → _isNewUser()
│   │   └─ targetUserType = 'specific_order' → count == (n-1)
│   │
│   ├─ Date check (if dates are set):
│   │   ├─ startsAt != null && now.isBefore(startsAt) → skip
│   │   └─ endsAt != null && now.isAfter(endsAt) → skip
│   │
│   └─ matchingRules.add(rule) if both pass
│
├─ Step 3: Sort by sortOrder ASC
│   matchingRules.sort((a, b) => a.sortOrder.compareTo(b.sortOrder))
│   [IMPORTANT: Lower number = evaluated first]
│
├─ Step 4: Apply first matching rule
│   if matchingRules.isNotEmpty:
│   └─ return selectedRule.deliveryFee (STOP)
│
├─ Step 5: Fall back to slab matching
│   slab = _matchSlab(cartTotal, config.slabs)
│   └─ return slab.fee if found (STOP)
│
└─ Step 6: Fall back to base fee
    └─ return config.baseDeliveryFee
```

### Example Scenarios:

| Scenario | cartTotal | Active Rules | Slabs | Result |
|----------|-----------|-------------|-------|--------|
| New user, 1st order | ₹150 | new_user rule (fee=0, sortOrder=1) | ₹0-199→₹40 | **₹0** (rule wins) |
| Returning user, ₹150 | ₹150 | new_user rule (fee=0, sortOrder=1) | ₹0-199→₹40 | **₹40** (rule doesn't match, slab applies) |
| 5th order offer | ₹250 | specific_order=5 (fee=0, sortOrder=2) | ₹200-299→₹20 | **₹0** (rule wins if 4 previous orders) |
| Existing user, no rules | ₹500 | — | ₹300+→₹0 | **₹0** (slab: free) |

---

## 7. Sort Order System

- **Lower number = higher priority** (ASC sorting)
- Pehla matching rule hi apply hota hai — ek se zyada rules kabhi stack nahi hote
- Sort order 1 sabse pehle evaluate hota hai, phir 2, 3, etc.

### Auto-Assignment on Create:
```dart
final maxRow = await DeliveryRuleRow.db.findFirst(
  session: session,
  orderBy: (r) => (r.sortOrder, QueryOrder.descending),
);
final nextSortOrder = (maxRow?.sortOrder ?? 0) + 1;
```

### Move Up/Down (Swap):
```dart
static Future<bool> swapSortOrder(Session session, String id1, String id2) async {
  // Read both rows
  // Swap their sortOrder values
  // Save both rows
}
```

### Important:
- sortOrder values are **not renumbered** on delete
- Insert always gets `max + 1`
- Move up/down performs a clean swap between adjacent rules
- After delete, there may be gaps (e.g., 1, 5, 10) — this is intentional

### Use Cases:
| sortOrder | Rule | Effect |
|-----------|------|--------|
| 1 | New user free delivery | Sabse pehle check |
| 2 | 5th order ₹20 | Second check |
| 10 | Monsoon offer ₹10 | Last check |

---

## 8. Date Range & Expiry

- **All rules** can have optional expiry dates (`startsAt`/`endsAt` nullable)
- No distinction between `special_event` and `user_rule` (removed)
- If dates are set, they are enforced during evaluation
- If dates are null, no date restriction applies (permanent rule)

### Evaluation:
```dart
final now = DateTime.now();
if (row.startsAt != null && now.isBefore(row.startsAt!)) continue; // skip
if (row.endsAt != null && now.isAfter(row.endsAt!)) continue; // skip
```

### Behavior:
| startsAt | endsAt | Behavior |
|----------|--------|----------|
| null | null | Always active (permanent) |
| 1 July 2026 | null | Active from 1 July onwards |
| null | 31 July 2026 | Active until 31 July |
| 1 July 2026 | 31 July 2026 | Active only during July |

### Admin UI:
- Toggle "Set Expiry Dates" switch
- When on: both start and end date pickers shown
- When off: both dates set to null
- On edit: if either date is non-null, switch is ON

---

## 9. Product-Level Free Delivery Override

`DeliveryChargeCalculator` ek additional layer hai jo `DeliveryEngine` ke result ko override karta hai.

### Flow:
```
DeliveryChargeCalculator.calculate()
│
├─ Step 1: normalPricing = DeliveryEngine.calculate()
│   (ye special rules → slabs → base fee evaluate karta hai)
│
├─ Step 2: Check cart items for isFreeDelivery = true
│   _hasPromotionalFreeDelivery(session, cartItems)
│   → ProductRow.db.find(where: id IN productIds AND status = 'active')
│   → return products.any((p) => p.isFreeDelivery)
│
├─ Step 3: Override decision
│   if (!hasPromotionalFreeDelivery || normalPricing.deliveryFee <= 0):
│     return normalPricing  // No override needed
│   else:
│     // Find the free delivery product in the list
│     freeProduct = products.firstWhere((p) => p.isFreeDelivery)
│     return DeliveryPricingResult(
│       deliveryFee: 0,
│       deliverySource: 'product_free_delivery',
│       freeDeliveryProductId: freeProduct.id,
│       freeDeliveryProductName: freeProduct.name,
│       ...
│     )  // Force free
```

### Important:
- Product free delivery **sirf tab override karta hai** jab normal pricing fee > 0 ho
- Agar special rule ya slab already free de raha hai, to override nahi hota
- `deliverySource: 'product_free_delivery'` set hota hai override case mein
- Free product ID and name are returned in the pricing result

### Use Case:
- User ke cart me ek product hai jiska `isFreeDelivery = true` hai
- Normal delivery fee slab se ₹40 aa raha hai
- Override → delivery fee = ₹0 ho jayega

---

## 10. Admin CRUD Operations

### Get Active Rules (Admin Screen)
```
GET getFreeDeliveryHydrated(uid, idToken)
→ FreeDeliveryHydrated(deliveryConfig, deliveryRules, totalCount)
```
- Sirf `status = 'active'` wale rules return karta hai
- Sorted by `sortOrder ASC`

### Get Inactive Rules
```
GET getInactiveDeliveryRules()
→ List<DeliveryRule>
```
- Sirf `status = 'inactive'` wale rules

### Create/Update Rule
```
POST upsertDeliveryRule(rule, uid, idToken, notificationDraft?)
→ bool
```
- Agar `rule.ruleId` null → insert (auto sortOrder = max + 1)
- Agar `rule.ruleId` exists → update
- Audit log write hota hai

### Delete Rule (Soft Delete)
```
POST deleteDeliveryRule(ruleId, uid, idToken)
→ String (empty = success, non-empty = error message)
```
- Dependency check: `DependencyChecker.checkDeliveryRule()`
- Agar dependencies hain → error message return
- Agar nahi → `status='inactive'`, `deactivatedAt=now`
- **Hard delete nahi hota** — sirf soft deactivate

### Move Rule Up/Down
```
POST moveDeliveryRuleUp(ruleId, uid, idToken)
→ bool

POST moveDeliveryRuleDown(ruleId, uid, idToken)
→ bool
```
- Adjacent rule ke saath sortOrder swap karta hai
- Up = sortOrder decrease (more priority)
- Down = sortOrder increase (less priority)

### Toggle Active/Inactive
```
POST setDeliveryRuleActive(ruleId, isActive, uid, idToken)
→ bool
```
- Deactivate karte waqt cascade deactivation check hota hai (admin UI me)
- Activate karte waqt direct set hota hai

---

## 11. Security & Auth

### Admin Guard (`PostgresAdminGuardService.ensureAdminSeller()`)

Har admin endpoint pe ye guard call hota hai:

1. **Firebase Token Verification**
   - `firebaseUid` empty nahi hona chahiye
   - `idToken` Firebase se verify hota hai
   - Token ka UID `firebaseUid` se match hona chahiye
   - `emailVerified` true hona chahiye

2. **In-Memory Cache (5-minute)**
   - Baar baar DB hit na ho isliye cache use hota hai
   - Key: `firebaseUid`, TTL: 5 minutes

3. **Role Check**
   - DB se `AppUserRow` find hota hai (`firebaseUid` + `status='active'`)
   - Role check: `admin`, `seller`, `admin_seller`, `admin-seller`, `admin seller`, `ADMIN_SELLER`
   - Koi bhi in roles me se allow hai

### Endpoint Security Summary:
| Endpoint | Auth Required | Guard Used |
|----------|--------------|------------|
| `getDeliveryConfig()` | ❌ No | — |
| `getUserDeliveryOffer()` | ❌ No | — |
| `calculateDeliveryPricing()` | ❌ No | — |
| `getInactiveDeliveryRules()` | ❌ No | — |
| `getAllDeliveryRules()` | ✅ Yes | `ensureAdminSeller` |
| `getDeliveryRulesPage()` | ✅ Yes | `ensureAdminSeller` |
| `getFreeDeliveryHydrated()` | ✅ Yes | `ensureAdminSeller` |
| `upsertDeliveryRule()` | ✅ Yes | `ensureAdminSeller` |
| `deleteDeliveryRule()` | ✅ Yes | `ensureAdminSeller` |
| `moveDeliveryRuleUp()` | ✅ Yes | `ensureAdminSeller` |
| `moveDeliveryRuleDown()` | ✅ Yes | `ensureAdminSeller` |
| `setDeliveryRuleActive()` | ✅ Yes | `ensureAdminSeller` |
| `upsertDeliveryConfig()` | ✅ Yes | `ensureAdminSeller` |

---

## 12. Validation Rules

### Delivery Rule Validation (`validateDeliveryRule`):

```dart
static void validateDeliveryRule(DeliveryRule rule) {
  // Name required
  if (rule.name.trim().isEmpty)
    → throw 'Rule name is required'

  // Fee non-negative
  if (rule.deliveryFee < 0)
    → throw 'Delivery fee cannot be negative'

  // sortOrder non-negative
  if (rule.sortOrder < 0)
    → throw 'Sort order cannot be negative'

  // Date range validation (if both set)
  if (startDate != null && endDate != null && endDate.isBefore(startDate))
    → throw 'End date must be after start date'

  // Target user type validation
  if (targetType != null && targetType != 'all' &&
      targetType != 'new_user' && targetType != 'specific_order')
    → throw 'Invalid delivery target user type'

  // specific_order requires targetOrderCount
  if (targetType == 'specific_order' &&
      (targetOrderCount == null || targetOrderCount <= 0))
    → throw 'Target order count is required and must be > 0'
}
```

### Slab Overlap Validation (`_validateSlabsNoOverlap`):

```dart
// Ensures no two slabs have overlapping ranges
// e.g., slab1: 0-199, slab2: 150-300 → REJECT (overlap at 150-199)
```

### Delivery Config Validation (`validateDeliveryConfig`):

```dart
static void validateDeliveryConfig(DeliveryConfig config) {
  // Base fee non-negative
  if (config.baseDeliveryFee < 0)
    → throw 'Base delivery fee cannot be negative'

  // Slab validation
  for (each slab):
    if (minOrderAmount < 0 || maxOrderAmount < minOrderAmount || fee < 0)
      → throw 'Invalid delivery slab configuration'
}
```

---

## 13. Dependency Checking

`DependencyChecker.checkDeliveryRule()` do tarah ke dependencies check karta hai:

### 1. Orders (ID-first, name fallback)
```dart
// First try: match by rule ID
final idCount = await CustomerOrderRow.db.count(
  where: freeDeliveryApplied = true AND freeDeliveryReason = rule.id
);
// Second try: match by rule name (old orders pre-dating ID-based snapshot)
final nameCount = await CustomerOrderRow.db.count(
  where: freeDeliveryApplied = true AND freeDeliveryReason = rule.name
);
// Subtract double-counted (ID match is also in name match for old orders)
return idCount + max(0, nameCount - idCount);
```
- ID-first matching: newer orders store Rule ID in `freeDeliveryReason`
- Name fallback: old orders (pre-refactor) store rule name text
- Double-count subtraction: ID matches would also match by name if name was used as fallback in old orders

### 2. Banners
```dart
final bannerCount = await BannerRow.db.count(
  where: offerId = rule.id AND status = 'active'
);
```

### Behavior on Delete:
- Agar dependencies milti hain → error message return hota hai
- Admin UI me "Delivery Rule In Use" dialog dikhta hai
- User "Proceed" kare to rule deactivate hota hai (delete nahi)
- Agar dependencies nahi hain → rule soft-delete ho jata hai

---

## 14. Cascade Deactivation

Jab admin kisi rule ko deactivate karta hai (`toggleDeliveryRule(id, false)`):

### Analysis Phase:
```dart
_analyzeDeliveryRule():
  → Sirf rule khud ko deactivate karta hai
  → Koi downstream cascade nahi (banners, products affected nahi hote)
```

### Execution Phase:
```dart
case 'delivery_rule':
  DeliveryRuleRow.db.updateRow(
    status: 'inactive',
    deactivatedAt: now,
    updatedAt: now,
  );
```

### Contrast with Other Entities:
| Entity | Cascade Effect |
|--------|---------------|
| Product | Banners, BOGO, Combo, Category Offers, Coupons affected |
| Coupon | Orders, Banners, Free Delivery Rules affected |
| **Delivery Rule** | **Sirf khud — koi cascade nahi** |

---

## 15. Audit Logging

Har admin action pe audit log write hota hai:

| Action | entityType | entityId |
|--------|-----------|----------|
| Create/Update Rule | `delivery_rule` | `rule.ruleId` or `rule.name` |
| Delete Rule | `delivery_rule` | `ruleId` |
| Move Rule Up/Down | `delivery_rule` | `ruleId` |
| Toggle Active/Inactive | N/A (directly via cascade or setDeliveryRuleActive) | N/A |

---

## 16. API Endpoints

### Public Endpoints (No Auth):
| Method | Endpoint | Returns | Description |
|--------|----------|---------|-------------|
| `GET` | `freeDelivery.getDeliveryConfig` | `DeliveryConfig` | Base delivery config + slabs |
| `GET` | `freeDelivery.getUserDeliveryOffer(userId)` | `DeliveryPricingResult` | User-specific delivery offer (home page) |
| `GET` | `freeDelivery.calculateDeliveryPricing(cartTotal, userId, cartItems)` | `DeliveryPricingResult` | Ad-hoc pricing calculation |
| `GET` | `freeDelivery.getInactiveDeliveryRules` | `List<DeliveryRule>` | Inactive rules list |

### Admin Endpoints (Auth Required):
| Method | Endpoint | Returns | Description |
|--------|----------|---------|-------------|
| `GET` | `freeDelivery.getAllDeliveryRules(uid, idToken)` | `List<DeliveryRule>` | All active rules (sorted by sortOrder) |
| `GET` | `freeDelivery.getDeliveryRulesPage(uid, idToken, limit, pageToken)` | `DeliveryRulePage` | Paginated rules |
| `GET` | `freeDelivery.getFreeDeliveryHydrated(uid, idToken)` | `FreeDeliveryHydrated` | Config + Rules in one call |
| `POST` | `freeDelivery.upsertDeliveryRule(rule, uid, idToken, notificationDraft?)` | `bool` | Create/update rule |
| `POST` | `freeDelivery.deleteDeliveryRule(ruleId, uid, idToken)` | `String` | Soft-delete rule |
| `POST` | `freeDelivery.moveDeliveryRuleUp(ruleId, uid, idToken)` | `bool` | Move rule up (increase priority) |
| `POST` | `freeDelivery.moveDeliveryRuleDown(ruleId, uid, idToken)` | `bool` | Move rule down (decrease priority) |
| `POST` | `freeDelivery.setDeliveryRuleActive(ruleId, isActive, uid, idToken)` | `bool` | Toggle active/inactive |
| `POST` | `freeDelivery.upsertDeliveryConfig(config, uid, idToken)` | `bool` | Update base config |
| `POST` | `freeDelivery.setProductFreeDelivery(productId, isFreeDelivery, uid, idToken)` | `OfferMutationResult` | Toggle product free delivery |

---

## 17. Database Schema

### Table: `delivery_config`
```sql
CREATE TABLE "delivery_config" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "configKey" text NOT NULL UNIQUE,
    "baseDeliveryFee" double precision NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### Table: `delivery_slab`
```sql
CREATE TABLE "delivery_slab" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "configId" uuid NOT NULL REFERENCES delivery_config(id) ON DELETE CASCADE,
    "minOrderAmount" double precision NOT NULL,
    "maxOrderAmount" double precision NOT NULL,
    "fee" double precision NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX delivery_slab_config_sort_idx ON delivery_slab(configId, sortOrder, id);
```

### Table: `delivery_rule`
```sql
CREATE TABLE "delivery_rule" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "description" text,
    "deliveryFee" double precision NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "targetUserType" text,
    "targetOrderCount" bigint,
    "startsAt" timestamp,
    "endsAt" timestamp,
    "status" text NOT NULL DEFAULT 'active',
    "deactivatedAt" timestamp,
    "createdAt" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### Migration (20260707080601754) — ruleType → sortOrder:
```sql
ALTER TABLE "delivery_rule" RENAME COLUMN "priority" TO "sortOrder";
ALTER TABLE "delivery_rule" DROP COLUMN "ruleType";
ALTER TABLE "delivery_rule" ALTER COLUMN "startsAt" DROP NOT NULL;
ALTER TABLE "delivery_rule" ALTER COLUMN "endsAt" DROP NOT NULL;
```

### Migration (20260707084420676) — freeDeliveryThreshold removed:
```sql
ALTER TABLE "delivery_config" DROP COLUMN "freeDeliveryThreshold";
```

---

## 18. Complete Pricing Flow

Pura flow jab koi order place karta hai:

```
1. Checkout Screen
   ↓
2. PricingEngine.calculatePricing()
   ↓
3. Item-level discounts (item discount, BOGO, Combo, Category Offer)
   ↓
4. Coupon discount
   ↓
5. SMGM (Shop More, Get More) reward
   ↓
6. Delivery Fee Calculation:
   ├─ DeliveryChargeCalculator.calculate(
   │     cartTotal: effectiveSubtotal,
   │     userId: userId,
   │     cartItems: items,
   │   )
   │   │
   │   ├─ DeliveryEngine.calculate()
   │   │   ├─ getActiveDeliveryRules()       → [Rule A, Rule B]
   │   │   ├─ filter by targetUserType        → [Rule A, Rule B]
   │   │   ├─ filter by date (if set)         → [Rule A, Rule B]
   │   │   ├─ sort by sortOrder ASC           → [Rule A (1), Rule B (5)]
   │   │   ├─ Rule A matches?                 → Yes → fee = rule.deliveryFee
   │   │   │                                    appliedRuleId = rule.id
   │   │   └─ No rule matches?                → _matchSlab(cartTotal)
   │   │                                         → No slab? → baseDeliveryFee
   │   │
   │   └─ _hasPromotionalFreeDelivery()
   │       └─ Any product with isFreeDelivery? → Override fee to ₹0
   │          deliverySource: 'product_free_delivery'
   │          freeDeliveryProductId: product.id
   │          freeDeliveryProductName: product.name
   │
   └─ result: DeliveryPricingResult
        { deliveryFee, isFree, deliverySource, appliedRuleId,
          freeDeliveryProductId, freeDeliveryProductName, ... }
   ↓
7. FreshPoints redemption
   ↓
8. Order creation (createPendingOrder / createCoDPendingOrder)
   ├─ deliveryFee: pricing.deliveryFee
   ├─ freeDeliveryApplied: pricing.isFree
   ├─ freeDeliveryReason: appliedRuleId ?? appliedRuleName ?? freeDeliveryProductName
   └─ deliverySnapshot: JSON with full delivery pricing details
        includes deliverySource, appliedRuleId, product fields
```

### Delivery Snapshot Format:
```json
{
  "deliveryFee": 0.0,
  "isFree": true,
  "deliverySource": "rule" | "slab" | "product_free_delivery",
  "appliedRuleId": "uuid-of-rule",
  "appliedRuleName": "New User Offer",
  "freeDeliveryProductId": null,
  "freeDeliveryProductName": null,
  "baseDeliveryFee": 40.0,
  "baseTotal": 250.0
}
```

---

## 19. Common Issues & Fixes

### Issue 1: Rule Delete Nahi Hota / Wapas Aa Jata Hai
- **Root Cause**: `getAllDeliveryRules()` pehle `status` filter nahi karta tha, soft-delete ke baad bhi inactive rules dikh rahe the
- **Fix**: Ab `WHERE status = 'active'` filter lag gaya hai

### Issue 2: Rule Delete Karne Par Koi Message Nahi Dikhta
- **Root Cause**: UI delete result check nahi kar raha tha, controller silently fail kar raha tha
- **Fix**: Ab snackbar show hota hai success/failure ke saath

### Issue 3: Sort Order Confusion
- **Previous Problem**: `priority` field tha jiska label "higher is evaluated first" tha, lekin code ASC sort karta tha (lower = first)
- **Fix**: Field renamed to `sortOrder`, labels consistent with ASC sort (lower = evaluated first)

### Issue 4: Rule Name Change se Dependency Check Fail
- **Root Cause**: `checkDeliveryRule` `freeDeliveryReason` (rule name text) se match karta tha — naam badle to purane orders detect nahi hote
- **Fix**: Ab Rule ID se match hota hai (fallback to name for old orders)
- **Status**: Partially mitigated — newer orders store Rule ID in snapshot

### Issue 5: Multiple Matching Rules
- **Design Decision**: Sirf pehla (lowest sortOrder) matching rule apply hota hai
- Users ke liye multiple rules stack nahi hote

### Issue 6: No Hard Delete
- **Design**: `deleteDeliveryRule` sirf soft-delete karta hai (status='inactive')
- Data DB me hamesha rehta hai — recovery possible hai
- Hard delete ke liye alag method nahi hai

### Issue 7: No Overlap Validation Before Refactor
- **Root Cause**: Slab overlap validation missing — conflicting slabs could exist silently
- **Fix**: `_validateSlabsNoOverlap` added to `upsertDeliveryConfig`

### Issue 8: Expiry Dates Not Optional Before Refactor
- **Root Cause**: `startsAt`/`endsAt` were NOT NULL with default values, forcing all rules to have dates
- **Fix**: Made nullable — null means no date restriction

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `freshpickkat_server/lib/src/protocol/db_rows/delivery_rule_row.spy.yaml` | DB schema |
| `freshpickkat_server/lib/src/protocol/data_flow/delivery_rule.spy.yaml` | API DTO |
| `freshpickkat_server/lib/src/protocol/data_flow/delivery_pricing_result.spy.yaml` | Pricing result DTO |
| `freshpickkat_server/lib/src/services/delivery/delivery_engine.dart` | Core engine |
| `freshpickkat_server/lib/src/services/delivery/delivery_charge_calculator.dart` | Pricing calculator |
| `freshpickkat_server/lib/src/services/postgres/postgres_delivery_service.dart` | DB operations |
| `freshpickkat_server/lib/src/services/business/validation_service.dart` | Validation |
| `freshpickkat_server/lib/src/services/admin/dependency_checker.dart` | Dependency checks |
| `freshpickkat_server/lib/src/services/admin/cascade_deactivation_service.dart` | Cascade handling |
| `freshpickkat_server/lib/src/endpoints/free_delivery_endpoint.dart` | API endpoints |
| `freshpickkat_server/lib/src/migrations/20260707080601754/migration.sql` | Schema migration |
| `freshpickkat_admin/lib/controller/admin_offer_controller/admin_free_delivery_controller.dart` | Admin controller |
| `freshpickkat_admin/lib/screens/free_delivery_screen.dart` | Admin UI screen |
