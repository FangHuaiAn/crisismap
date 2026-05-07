# StratAperture Release Package Readiness

Generated: 2026-04-30

## Android

- App name: `StratAperture`
- Package id: `net.strataperture.StratAperture`
- Version: `1.0.2`
- Version code: `2`
- AAB: `android/StratAperture-android-1.0.2-v2-release-signed.aab`
- APK: `android/StratAperture-android-1.0.2-v2-release-signed.apk`
- Alternate named AAB: `android/net.strataperture.StratAperture-1.0.2-v2.aab`
- Current upload alias: `android/net.strataperture.StratAperture.aab`
- Verification: `:app:testDebugUnitTest :app:assembleRelease :app:bundleRelease` passed, including `:app:validateSigningRelease` and `:app:signReleaseBundle`. APK metadata reports package `net.strataperture.StratAperture`, label `StratAperture`, version `1.0.2`, version code `2`. `apksigner verify` passed for the APK, and `jarsigner -verify` reports `jar verified` for the AAB.
- Signing status: signed with the upload keystore at `android/key/upload-keystore.jks`. Local signing files are ignored by Git via `.gitignore`.

## iOS

- App name: `StratAperture`
- Bundle id: `net.strataperture.StratAperture`
- Version: `1.0.2`
- Build number: `2`
- App Store Connect export: `ios/StratAperture-ios-1.0.2-build2-20260430-013527-app-store.ipa`
- Signed archive: `ios/StratAperture-1.0.2-build2-20260430-013527.xcarchive`
- Verification: Release archive and App Store Connect export succeeded. IPA contains `CFBundleShortVersionString = 1.0.2`, `CFBundleVersion = 2`, `CFBundleIcons -> CFBundlePrimaryIcon -> CFBundleIconName = AppIcon`, and `Assets.car` contains a 1024x1024 `AppIcon`.
- Signing status: exported with Apple Distribution certificate `85BAA877716EA26C9282047A6BC9A3F2949FFCE5` and profile `iOS Team Store Provisioning Profile: net.strataperture.StratAperture`. Local `codesign --verify` reports `CSSMERR_TP_NOT_TRUSTED`; validate the IPA upload in App Store Connect before external distribution.

## Required For Store Submission

- Android: Play Console app record, store listing, privacy/data safety content.
- iOS: Apple Developer Team ID, App Store Connect app record, provisioning profile or automatic signing, `MARKETING_VERSION`, `CURRENT_PROJECT_VERSION`, and export options for App Store distribution.
