# FreshPickKat Deep Linking

## Folder Structure

- `freshpickkat_flutter/lib/routes/route_manager.dart`: canonical URL builders, parsers, and GetX route paths.
- `freshpickkat_flutter/lib/services/deep_link_service.dart`: cold/background/foreground app-link listener and Play Install Referrer fallback.
- `freshpickkat_flutter/lib/services/share_service.dart`: product share text and Android/iOS native share sheet.
- `freshpickkat_flutter/lib/screens/deep_link_loading_screen.dart`: loading resolver for `/product/:productId`, `/category/:categoryId`, and `/offer/:offerCode`.
- `freshpickkat_flutter/lib/screens/deep_link_not_found_screen.dart`: product/category/link not-found UI.
- `freshpickkat_server/web/deeplink-fallback.html`: website fallback page for users without the app installed.

## Dependencies

```yaml
app_links: 6.4.1
share_plus: 10.1.4
play_install_referrer: ^0.5.0
```

`app_links` handles Android App Links and foreground/background streams. `share_plus` opens the native share sheet. `play_install_referrer` reads Google Play's referrer after first install for best-effort deferred routing.

## URL Structure

- `https://freshpickkat.com/product/{productId}`
- `https://freshpickkat.com/category/{categoryId}`
- `https://freshpickkat.com/offer/{offerCode}`

The app also accepts `https://www.freshpickkat.com/...`.

## AndroidManifest.xml

`MainActivity` uses `android:launchMode="singleTop"` and `android:autoVerify="true"` HTTPS-only App Link filters for `/product/`, `/category/`, and `/offer/` on both hosts.

## assetlinks.json

Host this exact shape at `https://freshpickkat.com/.well-known/assetlinks.json` and, if using `www`, also at `https://www.freshpickkat.com/.well-known/assetlinks.json`.

Replace the fingerprint with the SHA-256 from Google Play Console > App integrity > App signing key certificate.

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.freshpickkart.customer",
      "sha256_cert_fingerprints": [
        "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
      ]
    }
  }
]
```

Serve it with `Content-Type: application/json`, no redirect, and HTTP 200.

## Website Fallback

Configure the web server/CDN to serve `freshpickkat_server/web/deeplink-fallback.html` for:

- `/product/*`
- `/category/*`
- `/offer/*`

When the app is not installed, Android opens the HTTPS URL in the browser. The fallback page attempts an Android intent and then redirects to Google Play with:

```text
referrer=deep_link%3Dhttps%253A%252F%252Ffreshpickkat.com%252Fproduct%252F123%26utm_source%3Ddeeplink
```

On first launch, `DeepLinkService` reads this referrer and opens the original link when Google Play provides it.

## Deferred Deep Linking

Firebase Dynamic Links is no longer a good production choice because it was deprecated and shut down on August 25, 2025. This implementation uses Android App Links plus Google Play Install Referrer as the best first-party Android fallback.

Limitations:

- Deferred routing only works when the install comes through Google Play and Play returns the referrer.
- iOS has no equivalent install referrer path in this implementation.
- For campaign-grade deferred links, use a maintained provider such as Branch, AppsFlyer, Adjust, or a custom attribution backend.

## Testing Checklist

1. Run `flutter pub get` in `freshpickkat_flutter`.
2. Install a release or debug build on Android.
3. Verify app links:

```bash
adb shell pm get-app-links --user 0 com.freshpickkart.customer
```

4. Open a product link:

```bash
adb shell am start -a android.intent.action.VIEW -d "https://freshpickkat.com/product/123" com.freshpickkart.customer
```

5. Confirm the app shows a loading state, fetches the product, and opens `ProductDetailScreen`.
6. Test a missing/inactive product and confirm `Product not found` appears.
7. Put the app in background and run the same `adb shell am start` command; confirm one navigation only.
8. Keep the app foregrounded and open another product link; confirm no duplicate navigation for the same link.
9. Tap the product share button and confirm WhatsApp, Telegram, SMS, email, and native Android share targets can receive the text.
10. Upload `assetlinks.json`, then verify on Android 12+ that the host state is approved.
11. Serve `/product/*` through the fallback page and confirm a no-app device lands on Google Play with an encoded `referrer`.
