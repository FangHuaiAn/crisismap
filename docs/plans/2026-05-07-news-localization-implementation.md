# News Localization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Localize the iOS `News` tab UI and source metadata for English/Traditional Chinese, then add a small localized display fallback model for future translated news titles and summaries.

**Architecture:** Keep `CrisisEvent.title` and `CrisisEvent.summary` as original source text. Move News UI and source metadata labels through `Localizable.xcstrings`, and add a presentation-only localized content model that can prefer translated display text while falling back to original event text.

**Tech Stack:** Swift 6, SwiftUI, XCTest, Xcode project, `Localizable.xcstrings`.

---

### Task 1: Localize News Source Presentation

**Files:**
- Modify: `ios/CrisisMap/Views/News/NewsSourcePresentation.swift`
- Modify: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- Modify: `ios/CrisisMap/Resources/Localizable.xcstrings`
- Test: `ios/CrisisMapTests/NewsSourcePresentationTests.swift`
- Test: `ios/CrisisMapTests/NewsViewModelTests.swift`

**Step 1: Write failing tests**

Update `NewsSourcePresentationTests` so direct/derived and kind labels expect `String(localized:)` values instead of hard-coded English.

Update `NewsViewModelTests.testClusterSummariesExposeAttributionAndKindMix` so summaries expect localized format helpers, not embedded English literals.

**Step 2: Run tests to verify failure**

Run:

```bash
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' -only-testing:CrisisMapTests/NewsSourcePresentationTests -only-testing:CrisisMapTests/NewsViewModelTests
```

Expected: FAIL until production code reads localized labels.

**Step 3: Implement minimal source label localization**

Add localization keys for:

- `news.source.attribution.direct`
- `news.source.attribution.derived`
- `news.source.kind.wire`
- `news.source.kind.publisher`
- `news.source.kind.aggregator`
- `news.source.kind.social`
- `news.source.summary.direct`
- `news.source.summary.derived`

Change `NewsSourcePresentation` and `NewsClusterSummary` to compose labels from these keys.

**Step 4: Run tests to verify pass**

Run the same targeted test command.

### Task 2: Localize News Views

**Files:**
- Modify: `ios/CrisisMap/Views/News/NewsView.swift`
- Modify: `ios/CrisisMap/Views/News/ClusterRow.swift`
- Modify: `ios/CrisisMap/Views/News/ClusterDetailView.swift`
- Modify: `ios/CrisisMap/App/ContentView.swift`
- Modify: `ios/CrisisMap/Resources/Localizable.xcstrings`

**Step 1: Replace hard-coded UI strings**

Use explicit keys:

- `news.title`
- `news.search`
- `news.error.unavailable`
- `news.empty.title`
- `news.empty.description`
- `news.offline.cached`
- `news.topic.all`
- `news.sources.count`
- `news.signal.section`
- `news.signal.mentionIndex`
- `news.signal.distinctSources`
- `news.signal.attributionMix`
- `news.signal.sourceTypes`
- `news.events.recent`

**Step 2: Add English and Traditional Chinese values**

Add both `en` and `zh-Hant-TW` values to `Localizable.xcstrings`.

**Step 3: Build**

Run:

```bash
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' -derivedDataPath /private/tmp/crisismap-news-localization-build CODE_SIGNING_ALLOWED=NO build
```

Expected: BUILD SUCCEEDED.

### Task 3: Add Localized Event Display Fallback Model

**Files:**
- Create: `ios/CrisisMap/Models/NewsLocalizedContent.swift`
- Test: `ios/CrisisMapTests/NewsLocalizedContentTests.swift`
- Modify: `ios/CrisisMap.xcodeproj/project.pbxproj` if the project file does not auto-include the new files.

**Step 1: Write failing tests**

Test that `NewsLocalizedEventDisplay`:

- falls back to original `event.title` and `event.summary` when localized content is missing
- uses translated title/summary when present
- uses original summary when translated summary is empty
- changes cache identity when title, summary, or locale changes

**Step 2: Run tests to verify failure**

Run:

```bash
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' -only-testing:CrisisMapTests/NewsLocalizedContentTests
```

Expected: FAIL until the new model exists.

**Step 3: Implement minimal model**

Add:

- `NewsLocalizedContent`
- `NewsLocalizedEventDisplay`
- stable `cacheKey(event:localeIdentifier:)`

Use the existing FNV-style hash from `NewsSourceHeuristics.hashString` if accessible, or keep a small local deterministic hash helper if needed.

**Step 4: Run tests to verify pass**

Run the same targeted test command.

### Task 4: Final Verification

**Files:**
- All changed files.

**Step 1: Run focused tests**

```bash
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' -only-testing:CrisisMapTests/NewsSourcePresentationTests -only-testing:CrisisMapTests/NewsViewModelTests -only-testing:CrisisMapTests/NewsLocalizedContentTests
```

**Step 2: Run iOS build**

```bash
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' -derivedDataPath /private/tmp/crisismap-news-localization-build CODE_SIGNING_ALLOWED=NO build
```

**Step 3: Check diff hygiene**

```bash
git diff --check
git status -sb
```

Expected: no whitespace errors; only intended files changed plus already-untracked `data/`, `release-artifacts/`, and Xcode user data.
