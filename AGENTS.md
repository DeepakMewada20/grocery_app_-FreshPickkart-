## Goal
Payment infrastructure: Module 2 (Payment Links), Module 3 (Auto-Refund), Module 4 (Admin + Cron) — complete.

## Current Task: (completed) Full payment infrastructure — Modules 2/3/4

## Constraints & Preferences
- Product add/edit page's 4 separate paginated calls for offers must be eliminated via server hydration
- Offer data (BOGO, combo, category offer, free delivery) must be hydrated server-side into Product model — no extra client calls
- Admin product card must show badge chips for BOGO, COMBO, FREE DELIVERY, CATEGORY OFFER, and direct discount
- Home page must load all data (banners, products, 4 rankings, BOGO, combo, delivery offer, categories) in a single server round-trip
- Admin dashboard must merge stats + analytics into one endpoint
- Cart must merge pricing, suggestions, coupons, delivery config into one call
- Order detail must merge order + refund + complaints into one call
- Frontend changes allowed for hydrated composite endpoints (controllers update to use single call); no design/UI changes
- All server hydration must be internal — client apps call one endpoint per screen

## Done
### Basket Suggestion: Free Delivery Products
- **`BasketSuggestionService._scoreFreeDeliveryProducts()`**: New method — fetches products with `isFreeDelivery = true`, suggests those not in cart, calculates savings as current delivery fee; integrated into Phase 2 (filled basket) and empty mode
- **Phase 1 fetch**: `ProductEndpoint().getProducts(session, freeDelivery: true, limit: 6)` called after other data fetches at `basket_suggestion_service.dart:140`
- **Phase 2 scoring**: Free delivery suggestions scored alongside variant, BOGO, combo, coupon suggestions after line 186
- **Empty mode**: Free delivery products fetched in `Future.wait` (index 7), scored after delivery suggestion at line 356
- Uses existing `BasketSuggestionAction(type: 'product', label: 'FREE DELIVERY')` — no frontend changes needed
- Handler in `applyBasketSuggestion` already supports `action.type == 'product'` — adds product to cart

### Banner Resilience & Fallback
- **Server** (`postgres_home_service.dart`): Each query in `Future.wait` wrapped with `.catchError()` — single failure returns empty list/null instead of crashing the whole endpoint
- **Client banner controller**: Added `ensureHomeBannersLoaded()` — sequentially calls `loadHomeTopImageBannersIfEmpty()`, `loadHomeBannersIfEmpty()`, `loadHomeMiddleBannersIfEmpty()`; each has `isNotEmpty` guard
- **Home screen**: `_onRefresh()` calls `ensureHomeBannersLoaded()` after `fetchHomePageData()`; `InitialLoadingScreen.onRetry` loads both products AND banners
- **`initial_loading_screen.dart`**: `onRetry` type changed from `VoidCallback` to `Future<void> Function()`
- **`home_banner_with_horizontal_item.dart`**: `initState` calls `ensureHomeBannersLoaded()` when empty at widget creation

### Coupon Active-Only Filter
- **`postgres_coupon_service.dart`**: `getAvailableCoupons()` and `getBestCoupon()` now use `activeOnly: true` — only `status = 'active'` rows fetched from DB; admin endpoints unchanged

### Server-Side Hydration (12 new protocol models + 6 new endpoints)
- **Product model**: Added `comboOfferIds`, `hasCategoryOffer` to `product.spy.yaml` + generated
- **`PostgresCatalogService.hydrateProductsByIds()`**: Parallelized (10 queries → 2 batches); hydrates combo + category offer data
- **Home page**: `HomePageHydratedData` protocol, `PostgresHomeService` (12 parallel fetches), `HomeEndpoint.getHomePageHydrated()`
- **Admin dashboard**: `AdminDashboardHydrated` protocol, `getDashboardHydrated()` on `admin_endpoint.dart`
- **Category hierarchy**: `CategoryHierarchy` protocol, `getCategoryHierarchy()` on `category_endpoint.dart`
- **Free delivery**: `FreeDeliveryHydrated` protocol, `getFreeDeliveryHydrated()` on `free_delivery_endpoint.dart`
- **Cart**: `CartHydratedData` protocol (CartPricingResult + BasketSuggestionResult + DeliveryConfig + List<CouponDisplay>), `getCartHydratedData()` on `cart_endpoint.dart` — now fetches coupons with correct subtotal
- **Order detail**: `OrderDetailHydrated` protocol (Order + RefundRecord + activeProductComplaint + activeDeliveryComplaint), `getOrderDetailHydrated()` on `order_detail_endpoint.dart`
- **Product form reference**: `ProductFormReferenceData` protocol (bogoOffers + comboOffers + categoryOffers), `getProductFormReferenceData()` on `product_form_endpoint.dart`

### Frontend Updates
- **Admin product list**: `_OfferChips` widget in `_ProductAdminCard` — shows BOGO, COMBO, FREE DELIVERY, CATEGORY OFFER, X% OFF / ₹X OFF badges
- **User app HomeDataService**: Single `fetchHomePageData()` replaces ~9 separate calls; 5 controllers have `populateFromHydrated()` methods
- **`DataInitializationService`**: Uses single `fetchHomePageData()` instead of 5 separate init calls
- **`OfferWidget`**: Static cache for hydrated delivery offer from home page data
- **Home screen `_onRefresh`**: Uses single `HomeDataService.fetchHomePageData()` call
- **Admin dashboard controller**: Updated to use `getDashboardHydrated()` single call
- **Admin broadcast controller**: Calls `listBroadcasts(status: null)` once, splits by status client-side (3 calls → 1)
- **Admin category controller**: Uses `getCategoryHierarchy()` instead of 2 separate calls
- **Admin free delivery controller**: Uses `getFreeDeliveryHydrated()` for initial load
- **User category controller**: Uses `getCategoryHierarchy()` instead of 2 separate calls
- **Order detail screen**: Uses `getOrderDetailHydrated()` single call instead of 3 separate service calls
- **Cart controller (`_runCartMetaRefresh`)**: Replaced 6 parallel calls with single `getCartHydratedData()` hydrated call — includes fallback to individual fetches on error
- **Admin product form dialog**: Replaced 3 paginated offer loads with single `getProductFormReferenceData()` call; removed dependency on 3 separate controllers

### Skipped (no frontend changes made)
- **Admin offers screen**: 8 controllers, lower impact; already parallel via `Future.wait`; composite endpoint would not significantly reduce latency
- **Admin offers screen controllers**: BOGO, combo, category offer, coupon, banner controllers still use paginated loads internally

## Test Status — 9/9 passing
- **`payment_link_flow_test.dart`** (4 tests): `getPaymentSessionStatus`, `disablePaymentLink`, `expireStaleSessions`, `completePaymentVerification` — all pass with seeded user + order (FK constraints satisfied)
- **`auto_refund_job_test.dart`** (5 tests): duplicate creates job, identical gatewayPaymentId dedup, createJob dedup, updateJobStatus, loadPendingJobs — all pass using `_seedCompletedOrder` helper
- Tests use `withServerpod` pattern (real DB, auto-rollback), seed via `AppUserRow` + `CustomerOrderRow` + `PaymentTransactionRow` protocol inserts
- `createJob()` signature uses `{required AutoRefundJobRow job}` — tests pass `AutoRefundJobRow` directly
- `expireStaleSessions` sets `paymentStatus = 'cancelled'` (not `'failed'`) — test expects `'cancelled'`
- Admin endpoint tests still blocked (require Firebase auth)

## Key Decisions
- Composite DTO approach for high-impact screens (home page, dashboard, order detail, cart)
- Parallelized `hydrateProductsByIds` reduces per-call latency for every screen using products
- Cart hydrated endpoint fetches pricing first (to get subtotal), then fetches suggestions + delivery config + coupons in parallel with correct subtotal
- Cart controller has fallback to individual fetches if hydrated call fails
- Broadcasts handled via existing endpoint with `null` status — no new protocol needed
- Admin product form dialog uses local lists instead of GetX controllers (simpler, no reactive overhead)

## Next Steps
1. User to fill `RAZORPAY_WEBHOOK_SECRET` in `freshpickkat_server/.env` from Razorpay Dashboard
2. Run end-to-end testing on device/emulator — verify category screen tap-to-scroll works on first load and subsequent taps
3. Verify offer badges on user app product cards (BOGO, FREE DELIVERY, %/₹ OFF)
4. Verify offer chips on admin product cards (BOGO, COMBO, FREE DELIVERY, CATEGORY OFFER, %/₹ OFF)
5. Restart server to test free delivery product suggestions in basket
6. Run DB migration for `auto_refund_job_row` table (already in `definition.sql`)
7. Test auto-refund: create duplicate payment → verify job created → verify auto-refund processes → check admin health metrics
8. Test payment link flow: create order → get payment link → click link → pay → verify order completes
9. Verify expired payment link sessions are auto-cancelled by cron (sets `paymentStatus = 'cancelled'`)
10. Verify admin can retry/mark-reviewed auto-refund jobs from payment monitoring screen

## Recent Fixes
### Free delivery product suggestions (`basket_suggestion_service.dart`)
- `_scoreFreeDeliveryProducts()` fetches `isFreeDelivery = true` products via `ProductEndpoint.getProducts(freeDelivery: true, limit: 6)`
- Phase 2: scores free delivery products not in cart using current delivery fee as savings
- Empty mode: includes free delivery products in `Future.wait` (index 7)
- Uses `BasketSuggestionAction(type: 'product', label: 'FREE DELIVERY')` — existing handler adds product to cart
- Scoring: `conversionProbability: 32`, `userRelevance: 22`, `profitImpact: savings * 1.5`, `urgency: 18`

### Coupon active-only filter (`postgres_coupon_service.dart`)
- `getAvailableCoupons()` and `getBestCoupon()` now fetch only `status = 'active'` rows from DB (`activeOnly: true`)
- Fixes: user coupon screen no longer shows inactive coupons; basket screen only shows active ones; best-coupon auto-apply ignores inactive

### Paytm Payment Reconciliation — Retry & Recover Timed-Out UPI (`postgres_payment_service.dart`)
- **Client retry**: Increased `_handlePaymentError` retries 6 → 20 (18s → 60s) in `checkout_screen.dart:1286` to give Paytm more time
- **Webhook recovery path**: `razorpay_webhook_route.dart` already validates HMAC via `RAZORPAY_WEBHOOK_SECRET` and processes `payment.captured` events — Paytm timed-out payments recover via webhook when Paytm eventually confirms
- **Reconciliation cron fix**: `reconcileAllPendingPayments` at `postgres_payment_service.dart:792` now also queries `failed` payments with a non-null `gatewayPaymentId` that were updated within the last 2 hours; previously only `pending`/`verifying` were rechecked, so orders marked `failed` by the client were never revisited
- **Prerequisite**: User must fill `RAZORPAY_WEBHOOK_SECRET` value in `freshpickkat_server/.env` from Razorpay Dashboard

### Category Screen Scroll Sync (`cetegoris_screen_with_stick_heder.dart`)
- Simplified `_scrollToCategory`: removed complex `_estimateCategoryOffset` with nearest-built lookup
- **Overshoot + correct strategy**: (1) `Scrollable.ensureVisible` if widget built (fast path); (2) otherwise `animateTo` to `_categoryOffsets[index] + 500px` buffer to force ListView to build the target widget; (3) retry `Scrollable.ensureVisible` for precise alignment; (4) progressive 200px nudges if widget still not built (up to 3 retries)
- Added `_calibrateCategoryOffsets()`: after each category tap scroll, calibrates known offsets using actual render box positions for future accuracy
- Fixed landscape aspect ratio in `_computeCategoryOffsets` (0.86 vs 0.78)
- Empty subcategory sections use a fixed 50px estimate instead of a full grid cell height
- "All Items" separated into its own scroll-to-bottom path
- **`cacheExtent: 10000` on items ListView**: forces all category widgets to stay alive, so `Scrollable.ensureVisible` always has a valid context — no more two-phase overshoot retry, just a single smooth animation
- **`_onCategoryTap` no longer calls `_syncScrollState`**: header and sidebar are set by `setState` before the scroll, and `_syncScrollState` only runs on manual scroll — prevents inaccurate offsets from overwriting the header after a tap

### Module 2 — Payment Links
- **`PostgresPaymentLinkService`**: `initializePaymentSession()`, `getOrCreatePaymentLink()`, `getPaymentSessionStatus()`, `disablePaymentLink()` — generates Razorpay payment links with expiry
- **`PostgresPaymentService.verifyPayment()`** and `completePaymentVerification()`: Disable payment link on successful payment to prevent reuse
- **`PostgresOrderService.cancelPendingOrder()`**: Disable payment link on cancellation
- **`PaymentLinkEndpoint`**: `getPaymentSessionStatus()`, `getOrCreatePaymentLink()` — returns `PaymentLinkData`
- **`CheckoutEndpoint`**: `initializePaymentSession()` called after order creation
- **Flutter**: `PaymentSessionSheet` widget (countdown timer, copy link, retry), `payment_link_service.dart` updated, `checkout_screen.dart` — retry via `PaymentSessionSheet`, auto-navigate on payment success
- **`PaymentLinkData` protocol**: `shortUrl`, `expiresAt`, `status`, `paymentSessionId`

### Module 3 — Auto-Refund (Duplicate Detection)
- **`auto_refund_job_row` table**: `definition.sql` + `auto_refund_job.spy.yaml` protocol — unique constraint on `gatewayPaymentId`, FK to `customer_order`/`app_user`/`payment_transaction`
- **`PostgresAutoRefundService`**: `createJob()` with dedup (INSERT ON CONFLICT DO NOTHING), suspicious amount validation (>1.5x → `MANUAL_REVIEW`), capture validation via Razorpay API
- **Duplicate detection at 3 hooks**: `verifyPayment()`, `completePaymentVerification()`, razorpay webhook (`payment.captured` + `payment_link.paid`)
- **`AdminEndpoint.getAutoRefundJobStatus()`**: Returns JSON list of auto-refund jobs for a given order
- **Refund source `'auto_refund'`** already supported (free-text `String` in `refund_record.source`)

### Module 4 — Admin + Cron
- **Cron job rewrite** (`payment_reconciliation_cron_job.dart`): Separate timer for payment link expiry recovery (every 30s), auto-refund processing (60s), session expiry (60s), orphan detection (5min) — all non-blocking isolated timers
- **`PostgresAutoRefundService.loadPendingJobs()`**: Loads `PENDING` + `FAILED` (past retry window) jobs; `updateJobStatus()` writes audit log
- **`PostgresPaymentService.expireStaleSessions()`**: Sets `paymentStatus = 'cancelled'`, `orderStatus = 'payment_expired'`, `linkStatus = 'EXPIRED'` for expired payment link sessions
- **`PostgresPaymentService.detectOrphanPayments()`**: Finds `paid` orders with no `paymentTransactionId` or `razorpayPaymentId` (webhook recovery gap)
- **`AdminEndpoint`**: `retryAutoRefund()`, `markAutoRefundReviewed()`, `getPaymentHealthMetrics()` — JSON-based responses
- **`AdminPaymentMonitoringController`**: 3 new methods (`getAutoRefundJobStatus()`, `retryAutoRefund()`, `markAutoRefundReviewed()`, `getPaymentHealthMetrics()`)
- **Admin `payment_monitoring_screen.dart`**: Health metrics banner (pending/expired/duplicate/auto-refund counts), `_AutoRefundPanel` + `_AutoRefundJobCard` widgets with retry/mark-reviewed actions
- **Audit log events**: `DUPLICATE_PAYMENT_DETECTED`, `AUTO_REFUND_PROCESSING`, `AUTO_REFUND_COMPLETED`, `AUTO_REFUND_FAILED`, `AUTO_REFUND_RETRY`, `PAYMENT_SESSION_EXPIRED`, `ORPHAN_PAYMENT_DETECTED`

### Stale `_pendingOrderInfo` After Failed Payment (`checkout_screen.dart`)
- **Problem**: When UPI payment fails/cancelled, `_handlePaymentError` marks order as `failed` on server via `_markPaymentFailedBestEffort`, but `_pendingOrderInfo` still shows `paymentStatus: 'pending'` on client. Next Pay Now click → decision matrix sees 'pending' → tries `pendingOrderAction: 'continue'` → server's `findActivePendingOrder` doesn't find the now-failed order → returns "No active pending order found".
- **Fix**: In `_handlePaymentError` at line 1668, after `_markPaymentFailedBestEffort`, clear `_pendingOrderInfo` via `setState` if matches current order.
- **File**: `freshpickkat_flutter/lib/screens/checkout_screen.dart:1668`

### Switch to Ask Someone Else After Failed UPI Payment (`checkout_screen.dart` + server)
- **Problem**: After UPI cancel, user switches to "Ask Someone Else To Pay" → decision matrix doesn't check `_isShareablePayment` → `_placeOrderCore` (UPI flow) runs instead of `_placeOrderWithShareableLink` (link flow). Server's `createShareablePaymentLink` also lacks `pendingOrderAction` → returns "Failed to create payment link".
- **Fix**: (1) `_handlePendingOrderOnPlaceOrder` — all 4 paths (`failed`, `pending`+same+time, `pending`+active link, `pending`+no link) now check `_isShareablePayment` and route to `_placeOrderWithShareableLink(pendingOrderAction: 'cancel')`. (2) Server `createShareablePaymentLink` accepts `pendingOrderAction: 'cancel'` — cancels existing pending order before creating new one. (3) `_placeOrderWithShareableLink` passes `pendingOrderAction` param to endpoint.
- **Files**: `checkout_screen.dart:226-272`, `payment_link_endpoint.dart:22-162`, `payment_link_service.dart:18-34`, `client.dart:2994-3012`, `endpoints.dart:6369-6417`

### Timezone Fix — All DateTime Display (`_formatDate` in 5 screens)
- **Root cause**: Server stores `orderedAt` etc. as UTC (`DateTime.now().toUtc()`), but PostgreSQL `TIMESTAMP` column loses the UTC flag. Client receives DateTime not marked as UTC, so `dt.toLocal()` is a no-op — UTC time displayed as-is (e.g. 8:26 AM UTC instead of 1:56 PM IST).
- **Fix**: In all `_formatDate` methods, `DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, ...)` forces raw values to be treated as UTC, then `.toLocal()` correctly converts to IST.
- **Files**: `order_detail_screen.dart:1362`, `orders_screen.dart:240`, `order_confirmation_screen.dart:872`, `complaint_detail_screen.dart:530`, `my_complaints_screen.dart:144`

## Key Optimizations
- **Home page DB queries reduced**: ~63 → ~23 per load. Fetch IDs first (5 simple SQL queries), merge + deduplicate, hydrate once (10 queries), distribute results.
- **`ProductRankingService` refactored**: `_RankingRow` → public `RankingRow`; new `getRankedProductIds()` returns unhydrated rows; static `buildRankingItems()` constructs `ProductRankingItem` from rows + product map.
- **`PostgresCatalogService.getActiveProductIds()`**: New method returning just product IDs (no hydration, no cursor/pagination needed for home page).
- **`FeaturedVariantResolver`**: New service that selects the best variant per product using priority rules (BOGO > Free Delivery > Combo > Discount > Default). Replaces `onlyDefaultVariant: true` on the homepage — now each product displays its most valuable variant with correct badges and pricing.

## Relevant Files
- `freshpickkat_server/lib/src/protocol/product.spy.yaml`: added `comboOfferIds`, `hasCategoryOffer`
- `freshpickkat_server/lib/src/services/postgres/postgres_catalog_service.dart`: hydrateProductsByIds parallelized; combo/category hydration; `getActiveProductIds()` added
- `freshpickkat_admin/lib/screens/product_dialogs/products_list_content.dart`: `_OfferChips` widget in `_ProductAdminCard`
- `freshpickkat_server/lib/src/protocol/home_page_hydrated_data.spy.yaml`: composite home page DTO
- `freshpickkat_server/lib/src/services/postgres/postgres_home_service.dart`: aggregates 12 home page data sources
- `freshpickkat_server/lib/src/endpoints/home_endpoint.dart`: `getHomePageHydrated()`
- `freshpickkat_server/lib/src/endpoints/admin_endpoint.dart`: `getDashboardHydrated()`
- `freshpickkat_server/lib/src/endpoints/category_endpoint.dart`: `getCategoryHierarchy()`
- `freshpickkat_server/lib/src/endpoints/free_delivery_endpoint.dart`: `getFreeDeliveryHydrated()`
- `freshpickkat_server/lib/src/endpoints/cart_endpoint.dart`: `getCartHydratedData()` — now includes coupons with correct subtotal
- `freshpickkat_server/lib/src/endpoints/order_detail_endpoint.dart`: `getOrderDetailHydrated()`
- `freshpickkat_server/lib/src/endpoints/product_form_endpoint.dart`: `getProductFormReferenceData()` — new endpoint
- `freshpickkat_server/lib/src/protocol/product_form_reference_data.spy.yaml`: new protocol for product form
- `freshpickkat_flutter/lib/screens/order_detail_screen.dart`: uses hydrated endpoint
- `freshpickkat_flutter/lib/controller/category_provider_controller.dart`: uses `getCategoryHierarchy`
- `freshpickkat_flutter/lib/basket/cart_controller.dart`: `_runCartMetaRefresh` uses `getCartHydratedData()` with fallback
- `freshpickkat_flutter/lib/controller/*.dart`: 5 controllers with `populateFromHydrated()`
- `freshpickkat_flutter/lib/services/home_data_service.dart`: single-call home data service
- `freshpickkat_flutter/lib/services/data_initialization_service.dart`: uses `HomeDataService`
- `freshpickkat_admin/lib/controller/admin_broadcast_controller.dart`: single call with null status
- `freshpickkat_admin/lib/controller/admin_category_controller.dart`: uses `getCategoryHierarchy`
- `freshpickkat_admin/lib/controller/admin_offer_controller/admin_free_delivery_controller.dart`: uses `getFreeDeliveryHydrated`
- `freshpickkat_admin/lib/screens/product_dialogs/product_form_dialog.dart`: uses `getProductFormReferenceData()` — removed 3 controller dependencies
- `freshpickkat_server/lib/src/services/postgres/postgres_coupon_service.dart`: `getAvailableCoupons()` and `getBestCoupon()` now use `activeOnly: true`
- `freshpickkat_server/lib/src/services/basket_suggestions/basket_suggestion_service.dart`: free delivery product suggestions (`_scoreFreeDeliveryProducts`)
- `freshpickkat_server/lib/src/services/postgres/postgres_home_service.dart`: resilient `Future.wait` with `.catchError()` per query
- `freshpickkat_flutter/lib/controller/banner_controller.dart`: `ensureHomeBannersLoaded()`, `populateFromHydrated()` fixes
- `freshpickkat_flutter/lib/screens/home_screen.dart`: `_onRefresh` + retry load banners
- `freshpickkat_flutter/lib/widgets/home_banner_with_horizontal_item.dart`: `initState` fallback
- `freshpickkat_flutter/lib/widgets/initial_loading_screen.dart`: `onRetry` type change
- `freshpickkat_flutter/lib/screens/checkout_screen.dart`: client-side UPI retry loop (line 1286), `_tryResolvePendingUpiPayment` (line 1173)
- `freshpickkat_server/lib/src/web/routes/razorpay_webhook_route.dart`: webhook endpoint – validates HMAC, processes `payment.captured`/`payment.failed`; works once secret is set
- `freshpickkat_server/lib/src/services/payment_reconciliation_cron_job.dart`: multi-timer cron (30s link expiry, 60s auto-refund, 60s session expiry, 5min orphan detection)
- `freshpickkat_server/lib/src/protocol/auto_refund_job.spy.yaml`: auto-refund job protocol
- `freshpickkat_server/lib/src/protocol/payment_link_data.spy.yaml`: payment link data protocol
- `freshpickkat_server/lib/src/services/postgres/postgres_payment_link_service.dart`: payment link creation/management
- `freshpickkat_server/lib/src/services/postgres/postgres_auto_refund_service.dart`: auto-refund job creation/processing
- `freshpickkat_server/lib/src/endpoints/payment_link_endpoint.dart`: `getPaymentSessionStatus()`, `getOrCreatePaymentLink()`
- `freshpickkat_server/lib/src/endpoints/admin_endpoint.dart`: `getAutoRefundJobStatus()`, `retryAutoRefund()`, `markAutoRefundReviewed()`, `getPaymentHealthMetrics()`
- `freshpickkat_admin/lib/controller/admin_payment_monitoring_controller.dart`: auto-refund + health metrics methods
- `freshpickkat_admin/lib/screens/payment_monitoring_screen.dart`: `_AutoRefundPanel`, `_AutoRefundJobCard`, health metrics banner
- `freshpickkat_flutter/lib/widgets/payment_session_sheet.dart`: payment link countdown/retry sheet
- `freshpickkat_flutter/lib/services/payment_link_service.dart`: payment link HTTP calls
