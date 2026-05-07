# StratAperture Release Package Readiness

Generated: 2026-05-07

## Android

- App name: `StratAperture`
- Package id: `net.strataperture.StratAperture`
- Version: `1.0.3`
- Version code: `3`
- AAB: `android/StratAperture-android-1.0.3-v3-release-signed.aab`
- APK: `android/StratAperture-android-1.0.3-v3-release-signed.apk`
- Alternate named AAB: `android/net.strataperture.StratAperture-1.0.3-v3.aab`
- Current upload alias: `android/net.strataperture.StratAperture.aab`
- Verification: `:app:testDebugUnitTest :app:assembleRelease :app:bundleRelease` passed, including `:app:validateSigningRelease` and `:app:signReleaseBundle`. APK metadata reports package `net.strataperture.StratAperture`, label `StratAperture`, version `1.0.3`, version code `3`. `apksigner verify` passed for the APK, and `jarsigner -verify` reports `jar verified` for the AAB.
- Signing status: signed with the upload keystore at `android/key/upload-keystore.jks`. Local signing files are ignored by Git via `.gitignore`.

## iOS

- App name: `StratAperture`
- Bundle id: `net.strataperture.StratAperture`
- Version: `1.0.3`
- Build number: `3`
- App Store Connect export: `ios/StratAperture-ios-1.0.3-build3-20260507-201020-app-store.ipa`
- Signed archive: `ios/StratAperture-1.0.3-build3-20260507-201020.xcarchive`
- Verification: Release archive and App Store Connect export succeeded. IPA contains `CFBundleShortVersionString = 1.0.3`, `CFBundleVersion = 3`, and bundle id `net.strataperture.StratAperture`. `codesign --verify --deep --strict` passed for the exported IPA app bundle.
- Signing status: exported with Apple Distribution certificate `85BAA877716EA26C9282047A6BC9A3F2949FFCE5` and profile `iOS Team Store Provisioning Profile: net.strataperture.StratAperture`.

## Required For Store Submission

- Android: Play Console app record, store listing, privacy/data safety content.
- iOS: Apple Developer Team ID, App Store Connect app record, provisioning profile or automatic signing, `MARKETING_VERSION`, `CURRENT_PROJECT_VERSION`, and export options for App Store distribution.
