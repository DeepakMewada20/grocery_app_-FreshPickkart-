# FreshPickKat — Refer & Earn: Referral Code Onboarding Implementation Report

## 1. Executive Summary

The Refer & Earn system is **80% complete**. The referrer-side (code generation, sharing, reward engine, fraud detection, admin dashboard) is fully built. The missing piece is the **referee-side onboarding** — a post-registration flow where new users apply a referral code.

This report covers the final implementation to close this gap: deep link handling, eligibility checks, onboarding bottom sheet, and server-side tracking.

---

## 2. Current State Analysis

### ✅ Already Complete

| Component | Files |
|---|---|
| Referral code generation + DB | `postgres_referral_service.dart`, `app_user.referralCode` |
| Invite & Earn screen (referrer side) | `invite_earn_screen.dart` — code card, share, activity, terms |
| Share link generation | `shareLink = 'https://freshpickkart.com/invite?ref=$code'` |
| Share via system share sheet | `_share()` in invite_earn_screen |
| Reward engine (points, fraud, hold, reversal) | `postgres_referral_service.dart`, `postgres_fraud_score_service.dart` |
| Admin referral dashboard | `referral_dashboard_screen.dart`, `referral_settings_screen.dart` |
| Deep link listener service | `deep_link_service.dart` — already listens to incoming URIs |
| Route manager URI parsing | `route_manager.dart` — already parses product/category/offer paths |
| Server `applyReferral()` logic | `postgres_referral_service.dart:91` — validates code, checks self-referral, max pending, inserts referral row |
| Server `ReferralEndpoint` | Methods for code info, activity, settings, analytics, approve/reject |

### ❌ Missing (To Be Built)

| Component | Why Missing |
|---|---|
| Deep link parse for `/invite` | `route_manager.dart:fromUri()` returns `null` for `/invite` path |
| Deep link referral code storage | No code extraction from `?ref=CODE` query param |
| Referral onboarding eligibility endpoint | No check for new user / within 24h / already referred |
| Referral onboarding sheet UI | No bottom sheet after auth |
| Phone auth hook | No eligibility check after OTP verification |
| DB fields for onboarding tracking | `AppUserRow` missing: `referralCodeApplied`, `referralSource`, `referralAppliedAt`, `referralWindowExpiresAt`, `referralOnboardingDismissedAt` |
| Referral source tracking | No way to distinguish `DEEP_LINK` vs `MANUAL_ENTRY` |
| 24-hour window enforcement | No expiry logic |
| Skip/dismiss tracking | No dismiss timestamp |

---

## 3. Flow Diagrams

### 3.1 Referrer Flow (Already Complete)

```
Referrer opens Invite & Earn screen
    │
    ├── Copy Code (clipboard)
    └── Share via system sheet
            │
            └── https://freshpickkart.com/invite?ref=CODE123
```

### 3.2 Referee Flow (To Be Built)

```
Friend clicks invite link
    │
    ├── https://freshpickkart.com/invite?ref=CODE123
    │
    ├── If app installed
    │       └── DeepLinkService.handleUri() → extracts CODE123
    │           └── Stores in GetStorage('pending_referral_code')
    │
    ├── If app NOT installed
    │       └── Play Store → install → app opens
    │           └── PlayInstallReferrer restored → DeepLinkService
    │               └── Stores in GetStorage('pending_referral_code')
    │
    └── User sees Phone Auth screen
            │
            ├── Enter phone → OTP → Verify OTP
            │
            └── refreshAppUser() → user created on server
                    │
                    └── checkReferralOnboardingStatus(userId)
                            │
                            ├── NOT eligible → normal navigation (home/EditProfile)
                            │
                            └── ELIGIBLE → show bottom sheet
                                    │
                                    ├── Code auto-filled from deep link (or manual entry)
                                    │
                                    ├── APPLY
                                    │       ├── client.referral.applyReferralCode()
                                    │       ├── referral row created (SIGNED_UP)
                                    │       ├── AppUserRow updated (source, timestamp)
                                    │       └── Success animation → navigate
                                    │
                                    └── SKIP
                                            ├── AppUserRow.referralOnboardingDismissedAt = now
                                            └── Normal navigation
```

### 3.3 Eligibility Decision Tree

```
getReferralOnboardingStatus(userId)
    │
    ├── User found?
    │       └── No → NOT ELIGIBLE
    │
    ├── createdAt within 24h?
    │       └── No → NOT ELIGIBLE (existing user)
    │
    ├── referralCodeApplied != null?
    │       └── Yes → NOT ELIGIBLE (already linked)
    │
    ├── Any ReferralRow with inviteeUserId = userId?
    │       └── Yes → NOT ELIGIBLE (already referred)
    │
    ├── windowExpiresAt passed?
    │       └── Yes → NOT ELIGIBLE (window expired)
    │
    ├── Dismissed AND dismiss expiry passed?
    │       └── Yes → NOT ELIGIBLE
    │
    └── All checks pass → ELIGIBLE
```

---

## 4. Data Model Changes

### 4.1 `app_user_row.spy.yaml` — 5 New Fields

```yaml
referralCodeApplied: String?          # The referral code that was applied
referralSource: String?               # 'DEEP_LINK' | 'MANUAL_ENTRY'
referralAppliedAt: DateTime?          # When the code was applied
referralWindowExpiresAt: DateTime?    # createdAt + 24 hours
referralOnboardingDismissedAt: DateTime?  # When user tapped Skip
```

### 4.2 `app_user.spy.yaml` — Same 5 Fields (for Admin)

```yaml
referralCodeApplied: String?
referralSource: String?
referralAppliedAt: DateTime?
referralWindowExpiresAt: DateTime?
referralOnboardingDismissedAt: DateTime?
```

### 4.3 NEW: `referral_onboarding_status.spy.yaml`

```yaml
class: ReferralOnboardingStatus
fields:
  isEligible: bool
  pendingReferralCode: String?
  windowExpiresAt: DateTime?
```

---

## 5. Server-Side Changes

### 5.1 `postgres_user_service.dart` (Line ~106)

In `createOrUpdateUser()`, inside `isNewUser` block, after referral code generation:

```dart
if (isNewUser) {
  final referral = PostgresReferralService();
  await referral.getOrCreateReferralCodeForUser(session, persistedId);
  // NEW: set 24-hour referral window
  await AppUserRow.db.updateById(
    session,
    persistedId,
    columnValues: (t) => [
      t.referralWindowExpiresAt(now.add(const Duration(hours: 24))),
    ],
    transaction: transaction,
  );
}
```

### 5.2 `postgres_referral_service.dart` — New Methods

```dart
Future<ReferralOnboardingStatus> getReferralOnboardingStatus(
  Session session, UuidValue userId,
) async {
  final user = await AppUserRow.db.findById(session, userId);
  if (user == null) {
    return ReferralOnboardingStatus(isEligible: false);
  }

  // Check user was created within 24h
  if (user.createdAt == null ||
      DateTime.now().toUtc().difference(user.createdAt!).inHours > 24) {
    return ReferralOnboardingStatus(isEligible: false);
  }

  // Check 24-hour window
  final windowExpiresAt = user.referralWindowExpiresAt;
  if (windowExpiresAt != null &&
      DateTime.now().toUtc().isAfter(windowExpiresAt)) {
    return ReferralOnboardingStatus(isEligible: false);
  }

  // Already applied a referral
  if (user.referralCodeApplied != null) {
    return ReferralOnboardingStatus(isEligible: false);
  }

  // Already has a referral row as invitee
  final existing = await ReferralRow.db.findFirstRow(
    session,
    where: (t) => t.inviteeUserId.equals(userId),
  );
  if (existing != null) {
    return ReferralOnboardingStatus(isEligible: false);
  }

  // Dismissed and re-show window expired
  if (user.referralOnboardingDismissedAt != null) {
    final dismissExpiry =
        user.referralOnboardingDismissedAt!.add(const Duration(hours: 24));
    if (DateTime.now().toUtc().isAfter(dismissExpiry)) {
      return ReferralOnboardingStatus(isEligible: false);
    }
  }

  return ReferralOnboardingStatus(
    isEligible: true,
    windowExpiresAt: windowExpiresAt,
  );
}

Future<void> dismissReferralOnboarding(
  Session session, UuidValue userId,
) async {
  await AppUserRow.db.updateById(
    session,
    userId,
    columnValues: (t) => [t.referralOnboardingDismissedAt(DateTime.now().toUtc())],
  );
}
```

### 5.3 Update `applyReferral()` to Track Source

```dart
Future<void> applyReferral(
  Session session,
  UuidValue inviteeUserId,
  String inviteePhone,
  String referralCode, {
  String? source,  // 'DEEP_LINK' | 'MANUAL_ENTRY'
}) async {
  // ... existing validation ...

  final now = DateTime.now().toUtc();
  await ReferralRow.db.insertRow(session, /* ... existing ... */);

  // NEW: Update AppUserRow with referral tracking
  await AppUserRow.db.updateById(
    session,
    inviteeUserId,
    columnValues: (t) => [
      t.referralCodeApplied(normalized),
      t.referralSource(source),
      t.referralAppliedAt(now),
    ],
  );

  // ... existing audit log ...
}
```

### 5.4 `referral_endpoint.dart` — New Endpoint Methods

```dart
Future<protocol.ReferralOnboardingStatus> getReferralOnboardingStatus(
  Session session, String userId,
) async {
  final parsedId = await _resolveUserId(session, userId);
  return _referral.getReferralOnboardingStatus(session, parsedId);
}

Future<void> applyReferralOnboarding(
  Session session, String userId,
  String referralCode, String source, String phone,
) async {
  final parsedId = await _resolveUserId(session, userId);
  await _referral.applyReferral(
    session, parsedId, phone, referralCode,
    source: source,
  );
}

Future<void> dismissReferralOnboarding(
  Session session, String userId,
) async {
  final parsedId = await _resolveUserId(session, userId);
  await _referral.dismissReferralOnboarding(session, parsedId);
}
```

---

## 6. Flutter Changes

### 6.1 `route_manager.dart` — Deep Link Invite Support

```dart
enum DeepLinkType { product, category, offer, invite }

// In fromUri():
'invite' => DeepLinkTarget(
  type: DeepLinkType.invite,
  value: uri.queryParameters['ref'] ?? '',
  uri: uri,
),
```

### 6.2 `deep_link_service.dart` — Store Referral Code

```dart
static const _pendingReferralCodeKey = 'pending_referral_code';

Future<void> handleUri(Uri uri) async {
  final target = RouteManager.fromUri(uri);
  if (target == null) { /* ... */ return; }

  if (target.type == DeepLinkType.invite && target.value.isNotEmpty) {
    await _storage.write(_pendingReferralCodeKey, target.value);
    return; // No navigation — sheet will handle it
  }
  await openTarget(target);
}

String? getPendingReferralCode() =>
    _storage.read<String?>(_pendingReferralCodeKey);

void clearPendingReferralCode() =>
    _storage.remove(_pendingReferralCodeKey);
```

### 6.3 NEW: `referral_onboarding_sheet.dart`

Bottom sheet widget with 4 states:

| State | UI |
|---|---|
| **Input** | TextField (auto-filled if deep link), Apply + Skip buttons |
| **Applying** | Spinner on Apply, buttons disabled |
| **Success** | Green check, auto-dismiss after 1.5s, returns `true` |
| **Error** | Error text below field, buttons re-enabled |

**Layout:**
```
┌─────────────────────────────────────┐
│  🎉 Welcome to FreshPickKat!        │
│                                     │
│  Have a referral code?              │
│  ┌─────────────────────────────┐    │
│  │  (auto-filled from deep link) │   │
│  └─────────────────────────────┘    │
│                                     │
│  [          Apply Code         ]    │
│  ┌─────────────────────────────┐    │
│  │           Skip              │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### 6.4 `phone_auth_screen.dart` — Hook After OTP

In `_verifyOTP()`, after `refreshAppUser()` and before navigation:

```dart
if (result['success']) {
  // NEW: Check referral eligibility
  final userId = _authController.currentUser?.uid;
  if (userId != null) {
    try {
      final status = await _authController.client.referral
          .getReferralOnboardingStatus(userId);
      if (status.isEligible) {
        final pendingCode = DeepLinkService.instance.getPendingReferralCode();
        final applied = await ReferralOnboardingSheet.show(
          context,
          pendingCode: pendingCode,
          windowExpiresAt: status.windowExpiresAt,
        );
        if (applied) {
          DeepLinkService.instance.clearPendingReferralCode();
        }
      }
    } catch (_) { /* continue normal flow */ }
  }

  // Existing hasName/hasAddress navigation logic...
}
```

---

## 7. File Change Summary

| # | Layer | File | Action |
|---|---|---|---|
| 1 | Server DB | `app_user_row.spy.yaml` | +5 fields |
| 2 | Server Protocol | `app_user.spy.yaml` | +5 fields |
| 3 | Server Protocol | `referral_onboarding_status.spy.yaml` | **NEW** |
| 4 | Generated | (generated) | `serverpod generate` + migration |
| 5 | Server Service | `postgres_user_service.dart` | Set `referralWindowExpiresAt` on new user |
| 6 | Server Service | `postgres_referral_service.dart` | +2 methods, update `applyReferral()` |
| 7 | Server Endpoint | `referral_endpoint.dart` | +3 endpoint methods |
| 8 | Flutter Route | `route_manager.dart` | Add `invite` deep link type |
| 9 | Flutter Service | `deep_link_service.dart` | Store/retrieve/clear referral code |
| 10 | Flutter UI | `referral_onboarding_sheet.dart` | **NEW** bottom sheet |
| 11 | Flutter Screen | `phone_auth_screen.dart` | Hook sheet after OTP |

---

## 8. Implementation Order (11 Steps)

| Step | File | Est. Time |
|---|---|---|
| 1 | `app_user_row.spy.yaml` — add 5 fields | 5 min |
| 2 | `app_user.spy.yaml` — add same 5 fields | 3 min |
| 3 | `referral_onboarding_status.spy.yaml` — NEW | 5 min |
| 4 | `serverpod generate` + `serverpod create-migration` | 5 min |
| 5 | `postgres_user_service.dart` — set window on new user | 5 min |
| 6 | `postgres_referral_service.dart` — 2 new + 1 update | 20 min |
| 7 | `referral_endpoint.dart` — 3 new methods | 10 min |
| 8 | `route_manager.dart` — invite deep link | 5 min |
| 9 | `deep_link_service.dart` — store/clear code | 10 min |
| 10 | `referral_onboarding_sheet.dart` — NEW widget | 30 min |
| 11 | `phone_auth_screen.dart` — hook sheet | 10 min |
| | **Total** | **~108 min** |

---

## 9. Security Rules

| Rule | Implementation |
|---|---|
| One-time only | `referralCodeApplied` null check in eligibility + DB field set once |
| Immutable after success | Fields set once; no update endpoints |
| Not editable / removable | No API to modify these fields |
| Self-referral blocked | Existing `applyReferral()`: `referrer.id != inviteeUserId` |
| 24-hour window | `referralWindowExpiresAt` set at user creation, checked in eligibility |
| Existing users never see flow | Eligibility checks `createdAt` within 24h |
| Dismiss tracking | `referralOnboardingDismissedAt` prevents re-show after window expiry |

---

## 10. Admin Visibility

Available via existing `AppUser` protocol (now includes 5 new fields):
- **Referral code applied** — which code was used
- **Source** — DEEP_LINK or MANUAL_ENTRY
- **Applied at** — timestamp
- **Window expires at** — deadline
- **Dismissed at** — if user skipped

Integrates with `ReferralDashboardScreen` and `AdminReferralController`.

---

## 11. Test Plan

| # | Test | Type | Validates |
|---|---|---|---|
| 1 | New user within 24h is eligible | Integration | `isEligible: true` |
| 2 | Existing user (>24h) is ineligible | Integration | `isEligible: false` |
| 3 | Already referred user is ineligible | Integration | `isEligible: false` |
| 4 | Referral code applied with source tracking | Integration | `referralSource` = DEEP_LINK or MANUAL_ENTRY |
| 5 | Dismiss onboarding, re-show within 24h | Integration | Still eligible after dismiss |
| 6 | Dismiss onboarding, window expired | Integration | Ineligible after 24h from dismiss |
| 7 | Apply onboarding creates ReferralRow | Integration | SIGNED_UP status |
| 8 | All existing referral tests unaffected | Regression | 47 tests still pass |
