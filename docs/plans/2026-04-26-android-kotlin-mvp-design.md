# Android Kotlin MVP Design

Date: 2026-04-26

## Decision

Build the Android version as a native Kotlin app that mirrors the iOS MVP:

- Map
- News
- Research

The Android app should not introduce new product behavior. It should follow the iOS information flow and data contracts exactly, then render the same map-first News/Research experience with platform-native UI.

## Goals

- Use Kotlin for the Android implementation.
- Keep feature scope aligned with the current iOS MVP.
- Keep JSON/data structures compatible with iOS models.
- Avoid server-side dependencies for the MVP.
- Avoid private API keys.
- Avoid dynamic Feed, Dashboard, Markets, Actors, and notification work.

## Recommended Stack

- Kotlin
- Jetpack Compose
- Kotlin Coroutines and Flow
- kotlinx.serialization for JSON
- Room for structured cache, or DataStore/files for lightweight raw payload cache
- OkHttp/Ktor client for HTTP
- MapLibre Android for map rendering without Google Maps billing dependency
- JUnit for model and domain tests

Do not use Kotlin Multiplatform for the first Android pass. The iOS app already has working Swift domain logic. The safest MVP route is a native Kotlin mirror with explicit contract tests.

## Architecture

Create a new `android/` project:

```text
android/
  app/
    src/main/java/com/crisismap/app/
      data/
        cache/
        model/
        sources/
      domain/
        clustering/
        regions/
        scoring/
      ui/
        map/
        news/
        research/
        shell/
```

The Android app should use a unidirectional flow:

```text
Public sources + static JSON
→ data models
→ cache
→ domain mapping/clustering/scoring
→ screen state
→ Compose UI
```

## Feature Parity With iOS

### Tabs

Android should expose only:

- Map
- News
- Research

It should not expose:

- Feed
- Dashboard
- Markets
- Actors

### News

Android should implement the same MVP source policy:

- RSS public feeds
- GDELT public API
- X/Grok disabled by default unless credentials exist

The first version may prioritize static fixture and Research flow before live RSS/GDELT, but the final MVP should match iOS behavior.

### Research

Android should consume the same static JSON endpoints:

- `https://thinktankbriefdata.strataperture.net/topics.json`
- `https://thinktankbriefdata.strataperture.net/2026/weeks.json`
- `https://thinktankbriefdata.strataperture.net/2026/{week}.json`

Research should use local cache and show cached data when live fetches fail.

### Map

Android should render region-level markers only:

- Middle East
- Europe
- East Asia
- Africa
- Americas

Do not add country/city markers until the News/Research-to-region flow is working end to end.

## Data Contract Requirements

Android model names can use Kotlin style, but serialized field names and enum raw values must match iOS.

### Enum Raw Values

`Region`:

- `all`
- `middle-east`
- `europe`
- `east-asia`
- `africa`
- `americas`

`EventCategory`:

- `conflict`
- `statement`
- `military`
- `diplomatic`
- `economic`
- `terrorism`
- `disaster`
- `prediction`
- `earthquake`

`ThreatLevel`:

- `critical`
- `high`
- `medium`
- `low`
- `info`

`SourceTier`:

- `public`
- `private`

`NewsSourceKind`:

- `wire`
- `publisher`
- `aggregator`
- `social`

`NewsSourceAttribution`:

- `direct`
- `derived`

### Kotlin Serialization Pattern

Use `@SerialName` whenever JSON differs from Kotlin property names.

Example:

```kotlin
@Serializable
data class ThinkTankArticle(
    val id: String,
    @SerialName("think_tank") val thinkTank: String,
    val title: String,
    val url: String,
    val date: String,
    val summary: String = "",
    val category: String = "general",
    val status: String = "unknown",
    val topics: List<String> = emptyList()
)
```

`ThinkTankWeekly` must serialize `start_date`, `end_date`, and `generated_at` to Kotlin `startDate`, `endDate`, and `generatedAt`.

`NewsClusterRule` should use snake_case JSON keys only if the runtime JSON does. If the iOS runtime uses camelCase, Android must match camelCase.

## Cross-Platform Contract Strategy

Add Android tests that decode representative JSON fixtures matching iOS behavior.

Fixtures should cover:

- Think tank weekly JSON with missing optional `summary`, `category`, `status`, and `topics`
- `Region` raw values with hyphenated names
- `CrisisEvent` with nullable `location`, `url`, `actor`, `entities`, and `newsSource`
- `NewsSourceDescriptor`
- `NewsClusterRule`
- `NewsScoringConfig`

The Android implementation should not treat fields as required when iOS provides defaults.

## Deferred

- Server-side aggregator
- Kotlin Multiplatform
- Google Maps billing dependency
- Dashboard
- Dynamic Feed
- Markets
- Actors
- Push notifications
- Private API credentials
- Country/city marker expansion

## Success Criteria

- Android project builds from `android/`.
- Bottom navigation shows Map, News, and Research only.
- Kotlin models decode the same JSON shape as iOS.
- Research static JSON loads and caches.
- News list can display clusters from public-source data or fixtures.
- Map renders five region markers.
- Android emulator can launch the app.
