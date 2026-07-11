# Vivo Device — App Restart on Resume Analysis

> **Date**: 2026-07-11  
> **Scope**: User app (`freshpickkat_flutter`) + Admin app (`freshpickkat_admin`)  
> **Device**: Vivo (Funtouch OS) — also affects Xiaomi/MIUI, Oppo/ColorOS, Realme/RealmeUI, Huawei/EMUI

---

## 1. Problem Statement

### Observed Behavior
When a user **leaves the freshpickkart app** to open another app (e.g., Settings → enable Location) and then **returns**, the app does **not** resume to the previous screen. Instead:

- The app **cold restarts** (shows splash screen → goes through full initialization)
- Previous navigation state is lost
- Server connection is lost during debug (`Lost connection to device`)
- User must re-navigate to where they were (e.g., Location Picker screen)

### Expected Behavior (as seen on older/normal phones)
- App resumes **exactly where the user left off** (e.g., Location Picker)
- No connection break during development
- No full re-initialization

---

## 2. Root Cause Analysis

### 2.1 Android Process Lifecycle

```
Normal flow:
  App → Background → System keeps process alive → Resume → Activity restored

Vivo flow:
  App → Background → System KILLS process → Resume → Cold restart (main() re-runs)
```

Android's standard behavior is to keep recently backgrounded processes alive for fast resumption. However, Chinese OEMs implement **aggressive battery optimization** that kills background processes immediately — even for apps the user just navigated away from.

### 2.2 Vivo-Specific Mechanisms

| Mechanism | What it does | Evidence in logs |
|-----------|-------------|------------------|
| **FAST** (Funtouch Auto Sleep Technology) | Kills background processes aggressively | `avc: denied { ioctl } for path="/proc/fas/render"` |
| **PhFlagUpdateRegistry** | Google Play Services cert validation fails → blocks Maps/Play Integrity | `SecurityException: GoogleCertificatesRslt: not allowed` |
| **StrictMode disk violations** | System detects disk reads/writes on main thread during Maps init | `StrictModeDiskReadViolation`, `StrictModeDiskWriteViolation` |
| **OOM priority** | Lowers app's OOM score so it's killed first under memory pressure | Process is SIGKILL'd, not just stopped |

### 2.3 Why Only Vivo?

- **Google Pixel / Stock Android**: Keeps process alive for hours in background
- **Samsung One UI**: Keeps process alive, only kills under memory pressure
- **Vivo Funtouch / Xiaomi MIUI / Oppo ColorOS**: Custom power-saving frameworks that ignore standard Android lifecycle contracts

### 2.4 Why `Lost connection to device` During Debug?

When Vivo kills the app process:
1. Flutter's *debug* mode uses a TCP connection (`flutter:52987` in logs)
2. The OS sends SIGKILL → Dart VM terminates abruptly
3. Flutter tool detects the socket closure → `Lost connection to device`
4. This is **development-only** — production APKs don't have a debug connection to lose

---

## 3. Impact Assessment

### Affects
| Aspect | Severity | Details |
|--------|----------|---------|
| **User Experience** | High | User must re-navigate, re-enter data, re-load screens |
| **Location Flow** | High | User enables location in Settings → app restarts → loses location picker state |
| **Payment Flow** | Medium | User checks UPI app → app restarts → order recovery needed |
| **Cart** | Medium | Cart items persist (server-side) but UI must reload |
| **Auth** | Low | Session token survives (stored in GetStorage) |
| **Development** | High | `Lost connection to device` on every suspend → must hot-reload again |

### Not Affected
- **Server-side data** — orders, cart, user data are never lost (stored in PostgreSQL)
- **Payment transactions** — gateway handles payment state; recovery cron handles edge cases
- **Auth tokens** — Firebase + JWT tokens survive process death

---

## 4. Possible Solutions

### 4.1 Solution A: GetStorage Route + Auth Persistence ✅ **RECOMMENDED**

**Approach**: Save current route + minimal auth state to disk (`GetStorage`) on app suspend. Restore on cold start.

| Step | What | Where |
|------|------|-------|
| A1 | Create `RoutePersistenceService` — saves route, args, timestamp to GetStorage | `services/route_persistence_service.dart` (new file) |
| A2 | Listen to `AppLifecycleState.pause` → save current route | `main.dart` lifecycle observer |
| A3 | Persist `isLoggedIn` + `userId` on auth change | `auth_controller.dart` |
| A4 | On splash screen init → check saved route → restore if valid | `splash_screen.dart` |
| A5 | Expire saved state after 5 minutes | `RoutePersistenceService` |

**Pros**:
- Survives full process death (disk-backed)
- No Android-specific flags that OEMs ignore
- Uses existing `GetStorage` — zero new dependencies
- Controllers re-hydrate from server (always fresh data)
- Works on ALL aggressive OEMs, not just Vivo
- ~150 lines of code, 4 files

**Cons**:
- Brief splash flash on resume (vs. instant on normal phones)
- Saved route expired after 5 min (acceptable — prevents stale data)
- Controllers re-fetch data on restore (network required)

### 4.2 Solution B: Flutter `StateRestoration` API

**Approach**: Use `RestorationMixin`, `RestorableRouteFuture`, `restorationId` on every screen.

**Pros**:
- Official Flutter API
- Fine-grained state restoration (scroll position, form fields, etc.)

**Cons**:
- ❌ **Does NOT survive process death** on most Android versions — only activity re-creation
- Poor integration with GetX routing (`GetPage` has no `RestorableRouteFuture` support)
- Requires modifying every screen in the app (50+ screens)
- Complex, error-prone, high maintenance burden

### 4.3 Solution C: Android Foreground Service

**Approach**: Run a persistent foreground service with `android:foregroundServiceType="dataSync"` to prevent process death.

**Pros**:
- Prevents process death entirely

**Cons**:
- ❌ Vivo's FAST may still kill foreground services
- Mandatory persistent notification ("freshpickkart is running") — annoys users
- Battery drain
- App Store guidelines may reject
- Overkill for a shopping app

### 4.4 Solution D: Android `android:persistableMode` + `onSaveInstanceState`

**Approach**: Use `persistableMode="persistAcrossReboots"` in `AndroidManifest.xml` + override `onSaveInstanceState`/`onRestoreInstanceState` on Flutter's `MainActivity`.

**Pros**:
- Android native mechanism
- Survives process death and even device reboots

**Cons**:
- ❌ Flutter engine does NOT use Android's `SavedState` for restoration
- Flutter Activity always starts from scratch; Dart VM state is not serialized
- Requires modifying Flutter engine source code — not practical
- No reliable way to serialize Flutter widget tree to Android's `Bundle`

### 4.5 Solution E: Don't Fix — Rely on Server Recovery

**Approach**: Accept the restart; let the app's existing recovery mechanisms (order recovery, cart persistence) handle it.

**Pros**:
- Zero development effort
- All critical data already survives (cart, orders, auth)

**Cons**:
- ❌ Poor UX — user feels the app is broken
- ❌ Location flow specifically breaks (dialog → Settings → return → restart → location not enabled)
- ❌ Payment flow confusion (user checks UPI → app restarts → "payment failed")
- ❌ Negative Play Store reviews from Vivo users

---

## 5. Recommendation

### Why Solution A (GetStorage Persistence) is the Most Stable

| Criteria | Solution A (GetStorage) | Solution B (Restoration API) | Solution C (Foreground Service) |
|----------|------------------------|------------------------------|--------------------------------|
| Survives process death | ✅ Yes (disk) | ❌ No (RAM) | ✅ No death occurs |
| No new dependencies | ✅ GetStorage already in use | ✅ Built-in | ❌ Android-specific |
| Works on all OEMs | ✅ Yes | ❌ Pixel/Stock only | ❌ Vivo ignores |
| Implementation complexity | **Low** (~150 lines) | **Very High** (every screen) | Medium |
| Battery impact | None | None | **Negative** |
| User-visible | Brief splash flash | Seamless | **Persistent notification** |
| Maintenance | Low | High | Medium |

**Decision**: Implement **Solution A** — `RoutePersistenceService` with GetStorage-based route + auth persistence.

### Implementation Priority

1. **Phase 1** (User app — 4 files, ~150 lines):
   - Create `RoutePersistenceService`
   - Add lifecycle observer to `main.dart`
   - Persist auth state in `AuthController`
   - Add restore logic to splash screen

2. **Phase 2** (Admin app — 3 files, ~80 lines):
   - Same pattern, simplified (no deep links, fewer controllers)
   - Admin `AuthController` + `AuthWrapper` restore

3. **Phase 3** (Optional — Smart restore):
   - Expiry time based on screen type (payment screens expire faster)
   - Deep link pending queue restore
   - Tab index restore for `MainScreen`

---

## 6. Technical Details

### 6.1 GetStorage Keys to Use

| Key | Type | Purpose | Expiry |
|-----|------|---------|--------|
| `saved_route_name` | `String` | Last route name (`/checkout`, `/cart`, etc.) | 5 min |
| `saved_route_args` | `String` (JSON-encoded) | Route arguments | 5 min |
| `saved_route_timestamp` | `String` (ISO 8601) | When route was saved | — |
| `saved_auth_user_id` | `String` | User's UID for auth restore | 24 hr |
| `saved_auth_phone` | `String` | User's phone number | 24 hr |
| `saved_auth_token` | `String` | Auth token / session ID | 24 hr |
| `saved_tab_index` | `int` | Current tab on MainScreen | 5 min |

### 6.2 Route Whitelist

Only persist routes that make sense to restore:

| Route | Restore? | Reason |
|-------|----------|--------|
| `/splash` | ❌ No | Always skip splash on restore |
| `/login`, `/phone-auth` | ❌ No | Auth state persisted separately |
| `/home`, `/cart`, `/checkout` | ✅ Yes | Core shopping flow |
| `/offers`, `/coupons` | ✅ Yes | Info screens, safe to restore |
| `/order-detail/:id` | ✅ Yes | User was viewing their order |
| `/product/:slug` | ✅ Yes | User was browsing a product |
| `/address-picker` | ✅ Yes | Cancelling this is frustrating |
| `/location-picker` | ✅ Yes | **High priority** — location flow |
| `/complaint/:id` | ✅ Yes | Active complaint flow |

### 6.3 Expiry Logic

```
onAppSuspend:
  saveRoute()
  saveAuth()

onAppResume / ColdStart:
  if saved_route exists AND saved_route_timestamp is within 5 min:
    restoreRoute()
    restoreAuth()
    navigate()
  else:
    clearSavedRoute()
    normalStart()
```

### 6.4 Edge Cases Handled

| Case | Handling |
|------|----------|
| Auth token expired during absence | AuthController validates token on init → redirect to login |
| Cart changed on another device | CartController re-fetches from server on init |
| Deep link vs. manual navigation | Deep link service already has its own persistence (`pending_referral_code`) |
| Order paid while away | OrderRecoveryService already runs on init |
| Saved route is a deleted product | Product screen will show 404 → user navigates away |
| Admin vs. user app | Separate persistence (different GetStorage box or prefix) |

---

## 7. Conclusion

**The problem is Vivo's Funtouch OS aggressively killing background processes** — standard Android lifecycle solutions do not work. The most reliable fix is client-side route + auth persistence using GetStorage (already in use), so on cold restart the app can restore the user's previous screen and skip unnecessary re-login.

This approach:
- Costs **~150 lines of new code**
- Adds **zero new dependencies**
- Has **no battery/performance impact**
- Works on **all aggressive OEMs**
- Survives **full process death** (including kernel SIGKILL)

---

## References

- Android Activity Lifecycle: https://developer.android.com/guide/components/activities/process-lifecycle
- Flutter App Lifecycle: https://docs.flutter.dev/ui/widgets/binding
- get_storage package: https://pub.dev/packages/get_storage
- Vivo FAST (Funtouch Auto Sleep): Kernel-level process killer (proprietary)
- Related git history: `AGENTS.md` — "Stale `_pendingOrderInfo` After Failed Payment" fix
