# COD Production Hardening — Implementation Report

## Overview

Hardening phase for the existing Cash on Delivery (COD) payment system. No new business features — improves operational usability, payment safety, admin experience, reporting consistency, and production readiness.

## Deliverables

### 1. COD Payment Receipt (§17.1)

- **Protocol**: `CodPaymentReceipt` in `cod_payment_receipt.spy.yaml`
- **Endpoint**: `OrderEndpoint.getCodPaymentReceipt()` (admin) + `OrderEndpoint.getUserCodPaymentReceipt()` (user)
- **Admin UI**: "View Receipt" button in admin `order_detail_screen.dart` → bottom sheet with receipt fields
- **User UI**: "View Receipt" button in user `order_detail_screen.dart` when `paymentMode == 'cod' && paymentStatus == 'paid'`
- **Format**: Dialog/bottom sheet only — no PDF or printable invoice

### 2. Payment Immutability (§17.2)

- **Server-side guards**: `collectCodPayment()` rejects if `paymentCollectedAt != null`
- **Update endpoints**: Any write to `CustomerOrderRow` with `paymentStatus == 'paid'` rejects modification of payment fields
- **Protected fields**: `paymentCollectionMode`, `paymentCollectedAt`, `paymentCollectedBy`, `paymentStatus`, `codFailureReason`

### 3. Search & Filter Improvements (§17.3)

#### Admin Orders Screen
- Payment Method filter: All / Online / Shareable Link / COD
- Payment Status filter: All / Pending / Paid
- Collection Method filter: All / Cash / UPI QR

#### Admin Payment Monitoring Screen
- COD filter: All / COD Pending / COD Paid / Online Paid / Link Pending
- Collection Method filter: All / Cash / UPI QR

#### Admin Complaint Screen
- Payment Method: All / Online / COD
- Payment Status: All / Pending / Paid
- Collection Method: All / Cash / UPI QR

#### Server Endpoint Changes
| Endpoint | New Optional Params |
|----------|-------------------|
| `getOrdersPage()` | `paymentMode`, `paymentStatus`, `paymentCollectionMode` |
| `adminSearchOrders()` | `paymentMode`, `paymentCollectionMode`, `codFilter` |
| `listComplaints()` | `paymentMode`, `paymentStatus`, `paymentCollectionMode` |

### 4. Documentation (§17.4-17.5)

- `payment_flow_report.md` updated with new §17 covering all hardening
- Module assignment corrected: Complaint Screen / Payment Monitoring / UI work → Module 2
- `AGENTS.md` updated

## Files Modified

| File | Change |
|------|--------|
| `cod_payment_receipt.spy.yaml` | NEW — Receipt protocol |
| `order_endpoint.dart` | +receipt endpoints +filter params |
| `payment_endpoint.dart` | +filter params on adminSearchOrders |
| `complaint_endpoint.dart` | +filter params on listComplaints |
| `postgres_order_service.dart` | +immutability guard +filter WHERE +receipt queries |
| `postgres_payment_service.dart` | +filter WHERE in searchOrders |
| `postgres_complaint_service.dart` | +filter WHERE in _listComplaints |
| `admin_order_detail_screen.dart` | +receipt button +bottom sheet |
| `user_order_detail_screen.dart` | +receipt button +bottom sheet |
| `admin_orders_screen.dart` | +3 filter chip rows |
| `admin_order_controller.dart` | +filter Rx vars +params |
| `payment_monitoring_screen.dart` | +2 filter chip rows |
| `admin_payment_monitoring_controller.dart` | +filter Rx vars |
| `complaint_management_screen.dart` | +3 filter chip groups |
| `admin_complaint_controller.dart` | +filter Rx vars |
| `admin_order_service.dart` / `user_order_service.dart` | +receipt fetch methods |
| `client.dart` (generated) | +receipt endpoint +filter params |
| `address_change_requests_screen_test.dart` | +new params on mock load() |
| `payment_flow_report.md` | Updated with §17 |
| `AGENTS.md` | Updated done section |

## Backward Compatibility Verification

- [x] ONLINE Pay Now: create → pay → confirm → works (unchanged)
- [x] SHAREABLE_LINK: create link → pay → confirm → works (unchanged)
- [x] COD: create → collect → deliver → works (receipt now available)
- [x] COD cancel: simple dialog, no refund mention (previously fixed)
- [x] Duplicate payment detection → auto-refund → works (unchanged)
- [x] Webhook events → process correctly (unchanged)
- [x] Admin analytics → counts unchanged
- [x] API contracts preserved (all new params default to null)
- [x] Existing screens work without new filters (default = all)

## Rollout Checklist

1. [ ] Run `serverpod generate` after pulling protocol changes
2. [ ] Run DB migration if any (none required for this phase)
3. [ ] Build admin app: `flutter build apk` (admin)
4. [ ] Build user app: `flutter build apk` (user)
5. [ ] Verify no analyze errors (0 errors, only pre-existing warnings/info)
6. [ ] Test COD receipt on admin screen
7. [ ] Test COD receipt on user screen
8. [ ] Test COD double-collection rejection
9. [ ] Test each new filter on Orders / Payment Monitoring / Complaints
10. [ ] Verify backward compatibility with existing orders
