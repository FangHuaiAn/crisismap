# News Mention Index v1 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement a new iOS `News` tab that surfaces major events using configurable coarse-grained rule clustering and a decayed, precomputed Mention Index.

**Architecture:** Keep computation local on iOS. Ingest existing `CrisisEvent` feed, cluster via rule config, deduplicate mentions by `source + cluster`, compute decayed scores with configurable half-life, and precompute a snapshot for next local midnight.

**Tech Stack:** SwiftUI, SwiftData, Foundation (`Calendar`, `Date`), existing `APIClient` + `Events` domain models.

---

### Task 1: Add News Domain Models and Rule Schema

**Files:**
- Create: `ios/CrisisMap/Models/NewsClusterRule.swift`
- Create: `ios/CrisisMap/Models/ClusteredEvent.swift`
- Create: `ios/CrisisMap/Models/MentionSnapshot.swift`
- Modify: `ios/CrisisMap/Models/Region.swift`
- Resource: `ios/CrisisMap/Resources/ClusterRules/news-cluster-rules.v1.json`

**Step 1: Write the failing tests**

Create tests for:
- rule file decode
- deterministic rule ordering by priority
- region/topic assignment from rule

**Step 2: Run test to verify it fails**

Run: `xcodebuild -project ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone 16e' test`
Expected: FAIL because models/rule decoding do not exist.

**Step 3: Write minimal implementation**

Implement codable models and add `Region` mapping helpers for News filter tags.

**Step 4: Run tests to verify pass**

Run the same test command.
Expected: PASS for new model tests.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Models/NewsClusterRule.swift ios/CrisisMap/Models/ClusteredEvent.swift ios/CrisisMap/Models/MentionSnapshot.swift ios/CrisisMap/Models/Region.swift ios/CrisisMap/Resources/ClusterRules/news-cluster-rules.v1.json
git commit -m "feat(ios): add news cluster rule schema and models"
```

### Task 2: Implement Rule-based Coarse Clustering Engine

**Files:**
- Create: `ios/CrisisMap/Services/NewsClusteringEngine.swift`
- Test: `ios/CrisisMapTests/NewsClusteringEngineTests.swift`

**Step 1: Write the failing tests**

Add tests for:
- first-match-wins by priority
- fallback to `unclassified`
- coarse cluster mapping for multi-region event

**Step 2: Run tests to verify fail**

Run focused tests for clustering engine.
Expected: FAIL.

**Step 3: Implement minimal clustering engine**

Implement normalized text matching with `keywordsAny` and optional `keywordsAll`.

**Step 4: Run tests to verify pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsClusteringEngine.swift ios/CrisisMapTests/NewsClusteringEngineTests.swift
git commit -m "feat(ios): add deterministic rule-based news clustering engine"
```

### Task 3: Implement Mention Dedup Store (`source + cluster`)

**Files:**
- Create: `ios/CrisisMap/Models/CachedMention.swift`
- Modify: `ios/CrisisMap/App/CrisisMapApp.swift`
- Create: `ios/CrisisMap/Services/MentionStore.swift`
- Test: `ios/CrisisMapTests/MentionStoreTests.swift`

**Step 1: Write the failing tests**

Add tests for:
- first insert creates mention
- repeated same source/cluster does not increase mention count
- repeated same key updates `lastSeenAt`

**Step 2: Run tests to verify fail**

Expected: FAIL.

**Step 3: Implement minimal store**

Persist unique key via SwiftData model `CachedMention` with unique composite key string.

**Step 4: Run tests to verify pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Models/CachedMention.swift ios/CrisisMap/App/CrisisMapApp.swift ios/CrisisMap/Services/MentionStore.swift ios/CrisisMapTests/MentionStoreTests.swift
git commit -m "feat(ios): add mention dedup persistence for source-cluster keys"
```

### Task 4: Implement Mention Index Scoring with Half-life Parameter

**Files:**
- Create: `ios/CrisisMap/Services/MentionIndexCalculator.swift`
- Create: `ios/CrisisMap/Models/NewsScoringConfig.swift`
- Test: `ios/CrisisMapTests/MentionIndexCalculatorTests.swift`

**Step 1: Write the failing tests**

Add tests for:
- exact decay formula output (`halfLifeDays=180`)
- score decreases with older mention dates
- changing `halfLifeDays` changes score as expected

**Step 2: Run tests to verify fail**

Expected: FAIL.

**Step 3: Implement minimal calculator**

Implement:
- `weight = pow(2, -ageDays / halfLifeDays)`
- per-cluster score summation over deduped mentions

**Step 4: Run tests to verify pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/MentionIndexCalculator.swift ios/CrisisMap/Models/NewsScoringConfig.swift ios/CrisisMapTests/MentionIndexCalculatorTests.swift
git commit -m "feat(ios): add decayed mention index calculator with configurable half-life"
```

### Task 5: Implement Precompute Scheduler for Next Local Midnight

**Files:**
- Create: `ios/CrisisMap/Services/NewsPrecomputeScheduler.swift`
- Create: `ios/CrisisMap/Models/CachedMentionSnapshot.swift`
- Modify: `ios/CrisisMap/App/CrisisMapApp.swift`
- Test: `ios/CrisisMapTests/NewsPrecomputeSchedulerTests.swift`

**Step 1: Write the failing tests**

Add tests for:
- next run date resolves to local next midnight
- snapshot metadata (`asOf`, `halfLifeDays`) persisted
- stale snapshot detection

**Step 2: Run tests to verify fail**

Expected: FAIL.

**Step 3: Implement scheduler and snapshot storage**

On app open:
- compute current score (non-blocking)
- compute snapshot for next local midnight in background

**Step 4: Run tests to verify pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/NewsPrecomputeScheduler.swift ios/CrisisMap/Models/CachedMentionSnapshot.swift ios/CrisisMap/App/CrisisMapApp.swift ios/CrisisMapTests/NewsPrecomputeSchedulerTests.swift
git commit -m "feat(ios): add local-midnight mention index precompute scheduler"
```

### Task 6: Add News ViewModel and UI Tab

**Files:**
- Create: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- Create: `ios/CrisisMap/Views/News/NewsView.swift`
- Create: `ios/CrisisMap/Views/News/ClusterRow.swift`
- Create: `ios/CrisisMap/Views/News/ClusterDetailView.swift`
- Modify: `ios/CrisisMap/App/ContentView.swift`
- Modify: `ios/CrisisMap/Resources/Localizable.xcstrings`

**Step 1: Write the failing UI/viewmodel tests**

Add tests for:
- top clusters sorted by score desc
- region/topic filters narrow cluster list
- cluster detail shows source coverage and recent items

**Step 2: Run tests to verify fail**

Expected: FAIL.

**Step 3: Implement minimal UI**

- Add `News` tab entry in `TabView`
- Render `Top Clusters`, filter controls, detail navigation
- keep existing tabs unchanged

**Step 4: Run tests to verify pass**

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/ViewModels/NewsViewModel.swift ios/CrisisMap/Views/News ios/CrisisMap/App/ContentView.swift ios/CrisisMap/Resources/Localizable.xcstrings
git commit -m "feat(ios): add news tab with mention-index major event ranking"
```

### Task 7: Regression Verification and Smoke

**Files:**
- Modify: as needed for test fixes only

**Step 1: Run full test suite**

Run project test command.
Expected: all tests pass.

**Step 2: Run iOS smoke build**

Build and launch app on simulator; verify tabs load and `News` tab renders.

**Step 3: Final commit (if any test-only adjustments)**

```bash
git add <changed-files>
git commit -m "test(ios): stabilize news mention index v1 coverage"
```
