# User App Responsive Audit

Scope: `freshpickkat_flutter` only. `freshpickkat_admin` was not inspected or modified.

## Phase 1 Findings

### Project-Wide Risk Summary

- UI surface audited: 24 screen files, 28 widget files, basket widgets, basket suggestion widgets, and order tracking UI.
- Fixed typography is widespread: 250+ local `fontSize:` declarations across screens/widgets/basket/tracking. The largest hotspots are `basket_screen.dart`, `order_confirmation_screen.dart`, `checkout_screen.dart`, `phone_auth_screen.dart`, `coupon_section.dart`, `product_detail_screen.dart`, and `more_screen.dart`.
- Fixed dimensions and spacing are widespread: 700+ occurrences of `SizedBox`, fixed `height`, fixed `width`, and `EdgeInsets` across user UI files. The largest hotspots are `checkout_screen.dart`, `modern_splash_screen.dart`, `order_confirmation_screen.dart`, `order_detail_screen.dart`, `phone_auth_screen.dart`, `basket_screen.dart`, `empty_basket_view.dart`, and `product_detail_screen.dart`.
- Responsive grid/orientation coverage is incomplete. Existing grids use fixed `crossAxisCount` and `childAspectRatio`, with no tablet or landscape strategy.
- No `OrientationBuilder` usage was found in user UI. A few `LayoutBuilder` usages exist, but they are local and not a full responsive system.
- `MediaQuery.of(context).size` is used directly for important layout dimensions, including product image height and screen-height placeholders. This creates landscape and split-screen issues.
- Product/card UI is centralized enough to fix many issues through shared components, but several screens pass hardcoded ratios/counts that must be replaced by adaptive delegates.

### High-Risk Overflow And Breakage Locations

- `lib/widgets/product_card.dart`: fixed text sizes, fixed button height, fixed dropdown height, fixed internal padding, fixed badge font, fixed quantity selector padding. Card content is placed in `Expanded` under a fixed grid aspect ratio, so long product names, large text scale, and low-height grid cells can overflow.
- `lib/widgets/item_selection_girdviwe.dart`: default `crossAxisCount: 3` and `childAspectRatio: 0.44` create very narrow product cards on small phones and awkward skinny cards on tablets/landscape. Mid-content split is based on configured column count, so it becomes wrong when columns need to adapt.
- `lib/widgets/shimmer_loading.dart`: shimmer grids mirror fixed product-grid ratios/counts, so loading state and loaded state can differ across devices.
- `lib/screens/home_screen.dart`: fixed header spacer `170`, banner heights `180`, loading height `400`, fixed shimmer columns, and direct screen-height use. Landscape phones are likely to show too little content and oversized vertical gaps.
- `lib/screens/category_item_screen.dart`: entire page is a `Row` with a fixed 90 px sidebar and a fixed 2-column product grid. In landscape/tablet it wastes space; on small phones the remaining grid can become cramped. Filter chip row has fixed height 50 and may clip text at high text scale.
- `lib/screens/cetegoris_screen_with_stick_heder.dart`: fixed 90 px category rail, fixed 9 px fade strip, fixed category item grid `3 / 0.74`, fixed all-items grid `2 / 0.471`, direct screen height used for a decorative strip, and nested non-scrollable grids inside a `ListView`. This is fragile in landscape and with dynamic category names.
- `lib/screens/view_all_products_screen.dart`: fixed 2-column grid with `childAspectRatio: 0.59`. No tablet or landscape adaptation.
- `lib/widgets/product_search_delegate.dart`: fixed 2-column search/result grids with `childAspectRatio: 0.58`, nested in `SingleChildScrollView`.
- `lib/screens/product_detail_screen.dart`: hero image height is `MediaQuery.width`, which is too tall in landscape and can dominate tablets. Price row uses horizontal scroll as a band-aid. Related products use fixed height `290` and fixed width `160`, causing cramped cards on small phones and undersized cards on tablets.
- `lib/basket/basket_screen.dart`: cart rows combine fixed 80 px images, product text, price row, and quantity selector in one horizontal row. Long product names/prices and high text scale can overflow. Bill rows use plain `Row` with two unconstrained `Text` widgets.
- `lib/screens/checkout_screen.dart`: address, item, combo, bill, payment, processing button, and UPI bottom sheet all use fixed padding/heights. Several bill/item rows use plain `Row` with unconstrained values. The place-order button can overflow when `_loadingStatus` is long.
- `lib/widgets/bogo_selection_bottomsheet.dart`: bottom sheet uses `Column(mainAxisSize: min)` with `Flexible` list. On landscape/small height devices the sheet can exceed usable height; buttons in product rows can squeeze text.
- `lib/basket/suggestions/combined_detail_bottomsheet.dart`: uses `IntrinsicHeight`, fixed product rows, fixed fonts, and fixed sheet sections. High risk on landscape and large text scale.
- `lib/screens/phone_auth_screen.dart`: bottom fixed action area plus scrollable content can still fight keyboard and landscape height. `Pinput` has fixed pin widths/heights that can exceed small-width devices with text scaling.
- `lib/screens/otp_verification_screen.dart`: non-scrollable `Column` with `Spacer`, fixed pin widths, and keyboard focus. This is a keyboard-overlap and landscape overflow risk.
- `lib/screens/location_picker_screen.dart`: `DraggableScrollableSheet` has fixed `initialChildSize`/`minChildSize` and fixed paddings. In landscape the map/form split can become impractical and keyboard can cover fields.
- `lib/widgets/address_form_widget.dart`: nested `SingleChildScrollView` and fixed field paddings. Useful for keyboard avoidance, but needs viewport-aware padding and button/row wrapping.
- `lib/widgets/network_banner_widget.dart`, `lib/widgets/home_banner_with_horizontal_item.dart`, `lib/widgets/offer_banner.dart`: generally use `BoxFit.cover`, but banner heights are supplied as fixed constants by screens. This can crop aggressively in landscape/tablet and appear too small on high-density wide devices.
- `lib/widgets/category_item_card.dart`: fixed image treatment and local font size; long category/subcategory names can overflow/clamp inconsistently.
- `lib/widgets/categories_selection_listview.dart`: fixed horizontal item width/height and list height; will undersize on tablets and can overflow if text scale is high.
- `lib/basket/empty_basket_view.dart`: fixed horizontal card sizes, fixed recommendation heights, and fixed grid counts. Empty state can look cramped on small landscape and sparse on tablet.
- `lib/screens/order_detail_screen.dart` and `lib/screens/order_confirmation_screen.dart`: receipt/order rows use many fixed dimensions and plain two-column rows. Long addresses, product names, and price strings can overflow.
- `lib/screens/more_screen.dart`, `appearance_screen.dart`, `edit_profile_screen.dart`, `orders_screen.dart`, `notification_screen.dart`, `coupons_screen.dart`, `offers_screen/*`, and `tracking/screens/order_tracking_map_screen.dart`: mostly scrollable, but use fixed cards, local text sizes, fixed icon/image dimensions, and unconstrained rows that should move to responsive spacing and text styles.

### Hardcoded Dimensions

Representative high-impact examples:

- Fixed sidebars/rails: `category_item_screen.dart` width 90, `cetegoris_screen_with_stick_heder.dart` width 90.
- Fixed product card grids: `home_screen.dart`, `item_selection_girdviwe.dart`, `category_item_screen.dart`, `view_all_products_screen.dart`, `product_search_delegate.dart`, `offers_screen.dart`.
- Fixed banner heights: 120, 130, 140, 150, 180 across home, category, cart, checkout, product detail.
- Fixed image boxes: product/card/cart/checkout/bogo rows use 40, 50, 52, 54, 64, 80 px image boxes.
- Fixed action heights: product card add button 32, checkout button 54, cart proceed button 56, auth buttons 56, dropdown 24, filter section 50.
- Fixed vertical gaps: many 12/16/20/24/32/40/50 gaps are repeated locally and not tied to screen class.

### Fixed Typography

Representative hotspots:

- Product card: title 12, quantity 10, price 14, real price 10, add button 12, selector 12.
- Product detail: title 24, price 20, banners 16, related header 18, subscribe action 18.
- Basket/checkout/order rows: 10-20 px local styles, no shared receipt row behavior.
- Auth: titles 32, pin text 22/24, button 16, several local body styles.
- Navigation: bottom labels are fixed at 11 and icon sizes at 23/26.

Risk: text scale and translations can clip in fixed-height chips, buttons, cards, pin fields, and bill rows.

### Image Rendering

- Positive: most network product/banner images already specify `BoxFit.cover` or `BoxFit.contain`, and `SafeNetworkImage` exists.
- Problems: image dimensions are often fixed by the parent. Product detail uses a square image based on screen width, banner heights are fixed, cart/product rows use fixed square boxes, and related-product cards are fixed width/height.
- Missing consistency: direct `Image.network` appears in several places instead of `SafeNetworkImage`, causing inconsistent placeholders/errors.

### Grid/List Issues

- Product grids use hardcoded columns and ratios: 2/0.44, 2/0.59, 3/0.458, 3/0.44, etc.
- Category grids use hardcoded 3/0.74 and category section uses 4/0.75.
- Shimmer grids do not derive layout from loaded grids.
- Nested `GridView.builder(shrinkWrap: true, NeverScrollableScrollPhysics())` inside `ListView` is used in categories and product search. This is acceptable for sectioned content but expensive for large lists and can produce big layout passes.

### Orientation And Tablet Issues

- Portrait assumptions: fixed bottom nav, fixed header spacer, fixed side rails, fixed square product detail image, fixed bottom sheets, fixed auth vertical spacing.
- Landscape risks: auth/OTP forms, product detail, checkout, location picker, bottom sheets, and product grids can overflow vertically.
- Tablet risks: 2-column grids make oversized cards; banners and related-product cards do not apply max widths; content is not centered/constrained in checkout, basket, profile, orders, and detail screens.

### Keyboard Overlap Issues

- `phone_auth_screen.dart`: scrollable content plus fixed bottom button can be covered by keyboard unless bottom padding follows `viewInsets`.
- `otp_verification_screen.dart`: non-scrollable column with `Spacer` is high risk under keyboard and landscape.
- `location_picker_screen.dart`: draggable form sheet does not pad for keyboard viewInsets.
- `edit_profile_screen.dart` and `address_form_widget.dart`: scrollable, but needs consistent bottom inset padding.

### Unsafe MediaQuery Usage

- Direct `MediaQuery.size.width/height` is used for layout-critical sizing in home, categories, product detail, coupons, offers, combo cards, basket loading animation, and splash. These should be replaced with centralized breakpoint/orientation helpers or `LayoutBuilder` constraints.

## Phase 2 Responsive Strategy

### Sizing

- Add `flutter_screenutil` with design size `390 x 844`, `minTextAdapt: true`, and split-screen support.
- Use `.w`, `.h`, `.r`, and `.sp` only through local responsive helpers for app spacing, radii, icon sizes, and typography.
- Clamp important component sizes to avoid giant tablet scaling.
- Use max-content widths for form/checkout/order/detail content on tablets.

### Typography

- Use a central `AppTextStyles` system backed by `.sp`.
- Keep text scale accessible but clamp extreme scaling with a global text scaler cap for dense commerce cards and controls.
- Use `AutoSizeText` only where text lives inside fixed-height controls/cards, such as product card names, badges, buttons, bottom-nav labels, bill-row values, and compact chips.

### Spacing

- Add `AppSpacing` tokens (`xs`, `sm`, `md`, `lg`, `xl`) and EdgeInsets helpers.
- Replace repeated local 12/16/20/24 spacings in high-traffic components first, then continue screen-by-screen.

### Grids/Cards

- Add adaptive grid helpers:
  - Product grid: phone portrait 2 columns, phone landscape 3-4 depending width, tablet portrait 3-4, tablet landscape 4-5.
  - Category grid: phone portrait 3, landscape/tablet 4-6.
  - Card aspect ratio should derive from available width and orientation, not fixed constants.
- Product cards should keep image as `AspectRatio(1)` and let the remaining content scale with bounded text/button sizes.

### Images

- Standardize on `SafeNetworkImage` for product/category images.
- Use `AspectRatio` for all product/category cards.
- Use adaptive banner heights based on width and orientation with min/max clamps.
- Use `BoxFit.cover` for promotional banners and `BoxFit.contain` only where product inspection matters.

### Landscape/Tablet

- Use `OrientationBuilder`/responsive helpers only where structure changes: product detail, grids, auth forms, checkout/cart max-width content, and bottom sheets.
- Constrain dense form/checkout content to a readable max width on tablets while keeping grids wider.
- Bottom sheets get max-height constraints and scrollable content so action buttons remain accessible.

### Foundation Files

- `lib/utils/responsive.dart`: breakpoints, spacing, radii, adaptive grid delegates, banner sizing, max content width, text-scaler helpers.
- `lib/utils/app_text_styles.dart`: shared text styles for headings, section titles, product cards, body, caption, buttons, and receipt rows.
- `main.dart`: wrap app with `ScreenUtilInit` and a global clamped `MediaQuery.textScaler`.

## Progress Tracking

Completed before code changes:

- User app boundary identified as `freshpickkat_flutter`.
- Admin app ignored.
- UI files inventoried.
- Responsive risk scan completed for screens, widgets, basket, suggestions, dialogs/sheets, forms, grids, images, and typography.
- Architecture strategy defined above.

Pending:

- Add dependencies and global responsive foundation.
- Refactor adaptive grids and product card.
- Fix home/category/product detail/cart/checkout/auth/location high-risk flows.
- Run `flutter pub get`, format, analyze.
- Perform final responsive QA report.

## Implementation Progress

Completed in this pass:

- Added `flutter_screenutil` and `auto_size_text`.
- Wrapped `GetMaterialApp` in `ScreenUtilInit`.
- Added a global text-scaler cap via `MediaQuery.copyWith(textScaler: ...)` to prevent commerce cards/buttons from exploding on extreme text scale while still allowing moderate accessibility scaling.
- Added `lib/utils/responsive.dart` with breakpoints, page spacing, max content widths, adaptive banner heights, adaptive product/category grid delegates, sheet constraints, and tablet content constraints.
- Added `lib/utils/app_text_styles.dart` with shared section/product/body/button/receipt styles.
- Converted primary product grids to adaptive delegates:
  - Home "Other Products"
  - Category item product grid
  - Sticky category subcategory grids
  - View-all products
  - Search results and suggestions
  - Offers product grid
  - Category grid section
  - Empty basket category chips
  - Initial loading product skeleton
  - Product grid shimmer/category shimmer
- Refactored `ProductCard` with scaled dimensions, `AutoSizeText`, flexible price rows, scaled add/quantity controls, and safer offer badge sizing.
- Refactored home header/search/banners for landscape-aware header height, scaled search bar, adaptive banner heights, and adaptive horizontal product strip sizing.
- Refactored product detail image height so landscape no longer uses a full-width square image, constrained tablet content width, scaled related product cards, and made bottom action text flexible.
- Refactored basket rows, BOGO gift rows, bill rows, and proceed button with flexible/auto-sized text and responsive image/control sizes.
- Refactored checkout page with max readable width on tablets, adaptive checkout banner, flexible address/item/combo/bill rows, scroll-safe UPI sheet, and processing button text overflow protection.
- Refactored phone auth and OTP screens for keyboard-aware bottom padding, scrollable small-landscape behavior, and adaptive Pinput cell widths.
- Refactored location picker bottom sheet sizing for landscape and keyboard insets.
- Refactored BOGO selection bottom sheet with max sheet constraints and bounded selectable product list.
- Refactored offers/combo screens and bottom navigation label/icon sizing.

Validation completed:

- `flutter pub get` succeeded.
- `dart format` succeeded on all modified Dart files.
- `flutter analyze --no-fatal-infos` succeeded with no errors/warnings. Remaining output is existing info-level lint debt such as `avoid_print`, `withOpacity`, and one async-context info.
- `flutter test` ran, but no tests were discovered in the user app.
- `flutter build apk --debug` succeeded and produced `build/app/outputs/flutter-apk/app-debug.apk`.

Follow-up pass completed:

- Refactored the remaining order/history/account screens:
  - `order_detail_screen.dart`
  - `order_confirmation_screen.dart`
  - `orders_screen.dart`
  - `notification_screen.dart`
  - `more_screen.dart`
  - `coupons_screen.dart`
  - `edit_profile_screen.dart`
  - `appearance_screen.dart`
  - `wallet_screen.dart`
  - `transactions_screen.dart`
  - `search_screen.dart`
- Refactored remaining reusable widgets/components:
  - `address_form_widget.dart`
  - `coupon_section.dart`
  - `payment_status_widget.dart`
  - `combo_offer_card.dart`
  - `combo_product_preview_card.dart`
  - basket suggestion cards, chips, progress bars, thumbnails, skeletons, and combined-detail bottom sheet
  - `login_bottom_sheet.dart`
  - `network_banner_widget.dart`
  - `offer_banner.dart`
  - `offer_widget.dart`
  - `category_header_widget.dart`
  - `product_offer_badge.dart`
  - `discound_badge.dart`
  - `safe_network_image.dart`
- Added scroll/keyboard/tablet protections to profile and account forms.
- Added adaptive max-width constraints to order, coupon, profile, notification, wallet, transaction, tracking, and bottom-sheet content.
- Converted high-risk fixed rows to `Wrap`, `Expanded`, `Flexible`, or width-aware `LayoutBuilder` branches.
- Added `AutoSizeText` to compact badges, long order IDs, coupon codes, dynamic status chips, bill rows, bottom-sheet CTAs, and product/combo names.
- Standardized more image handling through `SafeNetworkImage` and added loading placeholder behavior.
- Updated order tracking map bottom card so it stays centered, safe-area aware, and metric tiles stack on very narrow widths.
- Improved splash orientation behavior with smaller landscape logo spacing and scaled skyline artwork.

Final validation:

- `dart format freshpickkat_flutter/lib` succeeded.
- `flutter analyze --no-fatal-infos` succeeded. Remaining output is info-level existing lint debt (`avoid_print`, `withOpacity`, `curly_braces_in_flow_control_structures`, and one async-context info).
- `flutter test` ran, but no tests were found in the user app.
- `flutter build apk --debug` succeeded and produced `build/app/outputs/flutter-apk/app-debug.apk`.

Residual notes:

- Decorative splash artwork still uses fixed window-grid column counts by design; the surrounding layout is now orientation-scaled.
- Some direct `Image.network` calls intentionally remain in full-screen/banner contexts where they already specify `BoxFit` and error handling.
- Existing info-level analyzer lints are not responsive-layout failures and were left out of scope.
