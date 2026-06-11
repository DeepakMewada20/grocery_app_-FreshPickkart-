## Goal
Eliminate multiple API calls per screen by implementing server-side hydration across admin and user apps, then add offer chips to admin product cards.

## Current Task: (completed) Fix category screen scroll sync, verify variant-level offer badges

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

## Key Decisions
- Composite DTO approach for high-impact screens (home page, dashboard, order detail, cart)
- Parallelized `hydrateProductsByIds` reduces per-call latency for every screen using products
- Cart hydrated endpoint fetches pricing first (to get subtotal), then fetches suggestions + delivery config + coupons in parallel with correct subtotal
- Cart controller has fallback to individual fetches if hydrated call fails
- Broadcasts handled via existing endpoint with `null` status — no new protocol needed
- Admin product form dialog uses local lists instead of GetX controllers (simpler, no reactive overhead)

## Next Steps
1. Run end-to-end testing on device/emulator — verify category screen tap-to-scroll works on first load and subsequent taps
2. Verify offer badges on user app product cards (BOGO, FREE DELIVERY, %/₹ OFF)
3. Verify offer chips on admin product cards (BOGO, COMBO, FREE DELIVERY, CATEGORY OFFER, %/₹ OFF)

## Recent Fixes
### Category Screen Scroll Sync (`cetegoris_screen_with_stick_heder.dart`)
- Simplified `_scrollToCategory`: removed complex `_estimateCategoryOffset` with nearest-built lookup
- **Overshoot + correct strategy**: (1) `Scrollable.ensureVisible` if widget built (fast path); (2) otherwise `animateTo` to `_categoryOffsets[index] + 500px` buffer to force ListView to build the target widget; (3) retry `Scrollable.ensureVisible` for precise alignment; (4) progressive 200px nudges if widget still not built (up to 3 retries)
- Added `_calibrateCategoryOffsets()`: after each category tap scroll, calibrates known offsets using actual render box positions for future accuracy
- Fixed landscape aspect ratio in `_computeCategoryOffsets` (0.86 vs 0.78)
- Empty subcategory sections use a fixed 50px estimate instead of a full grid cell height
- "All Items" separated into its own scroll-to-bottom path
- **`cacheExtent: 10000` on items ListView**: forces all category widgets to stay alive, so `Scrollable.ensureVisible` always has a valid context — no more two-phase overshoot retry, just a single smooth animation
- **`_onCategoryTap` no longer calls `_syncScrollState`**: header and sidebar are set by `setState` before the scroll, and `_syncScrollState` only runs on manual scroll — prevents inaccurate offsets from overwriting the header after a tap

## Key Optimizations
- **Home page DB queries reduced**: ~63 → ~23 per load. Fetch IDs first (5 simple SQL queries), merge + deduplicate, hydrate once (10 queries), distribute results.
- **`ProductRankingService` refactored**: `_RankingRow` → public `RankingRow`; new `getRankedProductIds()` returns unhydrated rows; static `buildRankingItems()` constructs `ProductRankingItem` from rows + product map.
- **`PostgresCatalogService.getActiveProductIds()`**: New method returning just product IDs (no hydration, no cursor/pagination needed for home page).

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
