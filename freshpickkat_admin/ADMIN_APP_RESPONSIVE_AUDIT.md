# Admin App Responsive Audit

Date: 2026-05-07

## Scope

Focused on `freshpickkat_admin` only. The pass covered admin shell/navigation, dashboard, orders, products, product dialogs, product picker, catalog/offers tabs, standalone coupons, standalone BOGO offers/editor/picker, category/banner/free-delivery forms, live delivery tracking, settings, login, splash, customers, audit logs, network/error utility screens, and shared admin/product/catalog widgets.

## Main Issues Found

- Multiple screens used fixed padding such as `EdgeInsets.all(16/20)` and fixed bottom offsets, which caused cramped small-phone layouts and awkward tablet spacing.
- Several forms used fixed-width dialogs (`520`, `640`) and fixed-height dialog content (`520`), breaking landscape and small-height devices.
- Product/order/banner cards used fixed image sizes with long unbounded text next to action menus, creating Row overflow risks.
- Grid/list layouts were mostly portrait-phone biased: product lists were always single-column and offer dashboard grids were hardcoded to two columns.
- Bottom sheets did not consistently use max-width/max-height constraints, making tablet layouts too wide and landscape sheets too short or clipped.
- Map preview overlays used fixed `16` insets and an unbounded bottom status card, risking map control/status overlap in landscape.
- Login/setup forms used a full-width column with fixed spacing and no max-width, causing poor tablet presentation and keyboard pressure on small screens.
- Shared widgets such as state/error views, product form cards, image previews, picker buttons, catalog stat cards, and appearance tiles had fixed font/icon/padding values.
- Dynamic API content risks existed for long product names, coupon descriptions, category names, order IDs, addresses, and banner placement labels.

## Responsive Strategy Implemented

- Added a centralized admin responsive foundation:
  - `lib/utils/admin_responsive.dart`
  - `lib/utils/admin_text_styles.dart`
- Configured `flutter_screenutil` in admin app startup with a consistent design size and text-scale clamping.
- Added `auto_size_text` for high-risk dynamic labels such as order IDs and product card titles.
- Standardized page padding, card padding, bottom safe inset, dialog constraints, bottom-sheet constraints, max content width, max form width, adaptive grid counts, and map overlay sizing.
- Navigation now uses bottom `NavigationBar` on compact screens and `NavigationRail` on tablet/landscape widths.
- Product lists now adapt between compact list and multi-column grid depending on width.
- Dialogs/bottom sheets now use constrained widths/heights and scrollable content.
- Images are clipped and rendered with stable dimensions and `BoxFit.cover` where product/card inspection matters.
- Rows with dynamic text now use `Expanded`, `Flexible`, `Wrap`, max lines, ellipsis, or adaptive column layouts.

## High-Impact Fix Areas

- Orders: responsive filter bar, list padding, order cards, status chips, customer/phone row, details bottom sheet, order item image rows, amount rows.
- Products: responsive product list/grid cards, search/category controls, add/edit form max-width, keyboard-safe scrolling, adaptive field rows, action bar safe area.
- Live delivery: responsive page constraints, status chips, info rows, map button, empty/hint cards.
- Live map preview: constrained top controls and bottom status card, scrollable bottom overlay, adaptive metric tiles.
- Offers/catalog: adaptive dashboard stat grids, constrained FAB positions, responsive catalog stat cards and badges, safer offer product chips.
- Coupons: responsive stats, search/create controls, constrained form bottom sheet, adaptive coupon form rows and actions.
- Categories: adaptive stats, list padding, constrained add/edit bottom sheets, safer category/subcategory text.
- Banners: responsive filters, list cards, image previews, status chips, constrained banner sheet, adaptive date rows, safer linked product/coupon pickers.
- Free delivery: responsive list padding, constrained dialogs, adaptive delivery slab fields and date buttons.
- Standalone coupons: max-width content, filtered list without shrink gaps, responsive cards/actions, constrained create/edit/delete dialogs, server-store wording, keyboard-safe form scrolling.
- Standalone BOGO: responsive search/list/stat cards, safe FAB inset, constrained delete dialog, adaptive BOGO editor and free-product picker, responsive selected-product summary, product tiles, variant editor, BOGO selector, and subcategory chips.
- Login/settings/customers/audit logs: max-width content, keyboard-safe forms, scrollable empty states, responsive text/icon sizing.
- Splash/network utility screens: scroll-safe centered splash content, responsive icon/text sizing, constrained network example list.
- Shared widgets: state/error views, appearance section, product image/picker/input/card widgets, catalog badges/cards.

## Orientation And Tablet Notes

- Landscape bottom sheets use taller allowed height and are constrained to avoid clipped forms.
- Tablet content is centered with max widths to avoid giant stretched cards.
- Product grids increase columns on wider screens.
- Map overlay controls and status card remain accessible after rotation.
- Forms use scrollable bodies and bottom safe-area action bars where needed.

## Verification

- `flutter analyze --no-fatal-infos` passed with no errors. Remaining output is existing info-level lint debt such as `avoid_print`, deprecated API hints, and style suggestions.
- `flutter test` passed.
- `flutter build apk --debug` passed and produced `build/app/outputs/flutter-apk/app-debug.apk`.

## Remaining Non-Blocking Lints

- Existing `print` calls in offer controllers.
- Existing deprecated `onPopInvoked` and `withOpacity` usage in banner flow.
- Existing style suggestions in category widgets and one async-context warning in product form cleanup path.

These are not responsive blockers and were left untouched to keep the UI pass focused.
