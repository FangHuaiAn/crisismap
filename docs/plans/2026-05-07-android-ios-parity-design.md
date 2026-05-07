# Android iOS Parity Architecture Design

Status: Direction approved
Date: 2026-05-07

## Purpose

Bring the Android app into parity with the iOS News and Research improvements without turning this stage into a broad Android redesign.

The goal is source trust and language parity:

- Android users should see the same monitored source posture as iOS.
- News and Research should have a basic English / Traditional Chinese UI foundation.
- The source transparency statement should be available from both News and Research.
- Source labels should distinguish direct publisher reporting from derived or aggregated signals.

## Existing Android State

The Android app is a Kotlin + Jetpack Compose application under `android/`.

Current relevant surfaces:

- `android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt`
- `android/app/src/main/java/com/crisismap/app/ui/research/ResearchScreen.kt`
- `android/app/src/main/java/com/crisismap/app/ui/shell/CrisisMapApp.kt`
- `android/app/src/main/java/com/crisismap/app/data/sources/RssNewsSource.kt`
- `android/app/src/main/java/com/crisismap/app/data/sources/GdeltNewsSource.kt`
- `android/app/src/main/java/com/crisismap/app/data/sources/ResearchRepository.kt`

Current gaps versus iOS:

- UI strings are hardcoded in English.
- Android has no `strings.xml` / `values-zh-rTW` localization layer.
- RSS coverage is narrower than iOS. Android currently ships BBC and Al Jazeera RSS, plus GDELT.
- There is no source transparency sheet.
- News cluster rows do not expose source kind or attribution summaries.

## Recommended Architecture

Use a parity foundation rather than a full feature rewrite.

This stage should add Android equivalents for the iOS source coverage, source transparency, and localized UI/source labels. It should not rebuild the entire iOS News detail experience yet, and it should not wire Android private X/Grok fetching before the Android private-source architecture exists.

## Localization Architecture

Create Android resource localization as the first layer:

- `android/app/src/main/res/values/strings.xml`
- `android/app/src/main/res/values-zh-rTW/strings.xml`

Use `stringResource(...)` in Compose for:

- Shell tab labels.
- News title, loading/error/retry labels, source count text, source type labels, attribution labels.
- Research title, loading/error/retry labels, section labels.
- Source transparency title, sections, explanatory copy, and limits.

Proper nouns such as `Reuters`, `GDELT`, `RAND`, and `USNI` should remain plain source names, not translated strings.

Android should not add remote article translation in this architecture stage. iOS currently has a translation-ready display/cache model, but the visible shipped behavior for this stage is localized UI/source metadata and transparency copy.

## News Source Coverage Architecture

Expand `RssNewsSource.defaultFeeds` to match the iOS feed set:

- Reuters
- AP News
- BBC News
- NHK World
- Al Jazeera
- DW
- The Guardian
- NPR World
- France 24
- UN News

Keep `GdeltNewsSource` as the global news index / aggregation signal.

Extend `RssFeed` so source metadata can align with iOS:

- `id`
- `name`
- `domain`
- `url`
- optional fallback URLs
- `kind`, defaulting to `NewsSourceKind.Publisher`

Reuters and AP News should be `NewsSourceKind.Wire`. Most RSS publishers remain `Publisher`. GDELT remains `Aggregator` and `Derived`.

The Android repository should continue using fault isolation: a failed feed returns no events for that feed and does not block other sources.

## Source Metadata Presentation

Keep raw metadata in the data/domain layer and localized wording in the UI layer.

`buildNewsClusters(...)` should expose enough metadata for a row summary without formatting user-facing text in the domain layer. Recommended additions to `NewsClusterSummary`:

- ordered source kinds present in the cluster
- direct attribution count
- derived attribution count

The UI should render:

- Mixed attribution clusters as count summaries, such as `2 direct · 1 derived`.
- Single-attribution clusters as source type summaries, such as `wire · publisher`.

Traditional Chinese labels should mirror the iOS wording:

- Direct: `直接來源`
- Derived: `轉載彙整`
- Wire: `通訊社`
- Publisher: `發行媒體`
- Aggregator: `聚合器`
- Social: `社群`

## Source Transparency Architecture

Create a shared static content model and one reusable Compose sheet:

- `android/app/src/main/java/com/crisismap/app/ui/shared/SourceTransparencyContent.kt`
- `android/app/src/main/java/com/crisismap/app/ui/shared/SourceTransparencySheet.kt`

The content model should match iOS:

- News source names include the full RSS set, GDELT, and X/Grok.
- Research source names include Brookings, CATO, CFR, CSIS, Chatham House, Foreign Affairs, Heritage, IISS, INSS, Mitchell, RAND, and USNI.
- Limit statements include coverage, availability, and original-source verification.

The sheet should be available from News and Research through a small info icon in the page header. It should be readable as a lightweight trust statement, not a full methodology page.

## Research Architecture

Keep `ResearchRepository` and `ThinkTankApi` unchanged for this stage.

Research parity is UI and transparency parity:

- Localize visible Research screen labels.
- Add the same transparency entry point as News.
- Use the shared source transparency content for the currently included think tank / policy sources.

## Android Dependencies

Add the smallest UI dependency needed for icon buttons:

- `androidx.compose.material:material-icons-extended`

The Compose BOM should continue managing Compose versions.

## Testing Strategy

Use JVM unit tests for data and pure Kotlin presentation logic:

- RSS default feed coverage includes the iOS-matching source names.
- Reuters and AP News are marked as wire sources.
- GDELT remains an aggregator/derived signal.
- `SourceTransparencyContent` includes required news sources, research sources, and limitations.
- News cluster metadata counts direct/derived attribution and source kinds.

Use Gradle resource/build validation for Compose and localized resources:

- `./gradlew :app:testDebugUnitTest`
- `./gradlew :app:assembleDebug`

Manual simulator/emulator validation should confirm:

- News page opens.
- Research page opens.
- The info icon opens the transparency sheet from both pages.
- Traditional Chinese device locale shows Chinese UI and transparency copy.

## Non-Goals

- Do not add Android X/Grok fetching in this stage.
- Do not add remote article translation in this stage.
- Do not rebuild the full iOS News cluster detail interaction in this stage.
- Do not expose raw feed URLs in the user-facing transparency sheet.
- Do not make transparency a new primary tab.

## Success Criteria

- Android and iOS communicate the same source coverage and limitations.
- Android has a resource-based localization foundation for English and Traditional Chinese.
- News source coverage is expanded to match iOS public RSS coverage.
- News rows can show localized source attribution/type summaries.
- News and Research both expose the same lightweight transparency statement.
- Unit tests and debug build pass before emulator deployment.
