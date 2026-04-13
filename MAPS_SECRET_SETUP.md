# Google Maps Secret Setup

Use the local-only files below. Do not commit them to GitHub.

## Customer App

- Android: `freshpickkat_flutter/android/local.properties`
- iOS: `freshpickkat_flutter/ios/Flutter/Secrets.xcconfig`

## Admin App

- Android: `freshpickkat_admin/android/local.properties`
- iOS: `freshpickkat_admin/ios/Flutter/Secrets.xcconfig`

## Required key

```properties
MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
```

## Notes

- Android reads the key from `local.properties` and passes it into the manifest placeholder.
- iOS reads the key from `Secrets.xcconfig` and initializes Google Maps in `AppDelegate`.
- The example files in each app show the exact format.
- The secret files are ignored by git.
