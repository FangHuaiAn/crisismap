# News Source UI Surface Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Expose the new multidimensional news source metadata in low-risk UI surfaces without changing ranking, layout structure, or interaction patterns.

**Architecture:** Keep all changes inside existing News presentation views by adding lightweight formatting helpers and tiny metadata chips. Test the new behavior through deterministic formatting and view-model level helpers instead of introducing snapshot or inspection frameworks.

**Tech Stack:** Swift 6, SwiftUI, XCTest, existing `NewsClusterSummary`, `CrisisEvent`, and `NewsSourceDescriptor`.

---

### Task 1: Add Cluster-Level Source Summary Helpers

**Files:**
- Modify: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- Test: `ios/CrisisMapTests/NewsViewModelTests.swift`

**Step 1: Write the failing test**

Add a test that builds a cluster with mixed `direct/derived` and `wire/publisher/social` events, then asserts the cluster exposes short summary strings suitable for `ClusterRow`.

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsViewModelTests
```

Expected: FAIL because cluster-level UI summaries do not exist.

**Step 3: Write minimal implementation**

- Add computed properties to `NewsClusterSummary` for:
  - attribution summary
  - source-kind summary
- Keep output short and deterministic.

**Step 4: Run test to verify it passes**

Run the same command.
Expected: PASS.

### Task 2: Add Event-Level Source Metadata Helpers

**Files:**
- Create: `ios/CrisisMap/Views/News/NewsSourcePresentation.swift`
- Test: `ios/CrisisMapTests/NewsSourcePresentationTests.swift`

**Step 1: Write the failing test**

Add tests for:

- `direct` / `derived` badge text
- `wire` / `publisher` / `social` / `aggregator` badge text
- outlet/domain subtitle preference logic

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsSourcePresentationTests
```

Expected: FAIL because presentation helpers do not exist.

**Step 3: Write minimal implementation**

- Add a tiny formatting helper namespace for event-level source metadata presentation.

**Step 4: Run test to verify it passes**

Run the same command.
Expected: PASS.

### Task 3: Surface Metadata in Existing News Views

**Files:**
- Modify: `ios/CrisisMap/Views/News/ClusterRow.swift`
- Modify: `ios/CrisisMap/Views/News/ClusterDetailView.swift`
- Test: `ios/CrisisMapTests/NewsViewModelTests.swift`
- Test: `ios/CrisisMapTests/NewsSourcePresentationTests.swift`

**Step 1: Write the failing test**

Add a view-model level test that verifies the cluster-level helper output used by `ClusterRow` and the event-level helper output used by `ClusterDetailView`.

**Step 2: Run test to verify it fails**

Run:

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsViewModelTests -only-testing:CrisisMapTests/NewsSourcePresentationTests
```

Expected: FAIL until the views read the new helpers.

**Step 3: Write minimal implementation**

- `ClusterRow`: add one short metadata line
- `ClusterDetailView`: add attribution row and per-event metadata chips plus outlet/domain subtitle

**Step 4: Run test to verify it passes**

Run the same command.
Expected: PASS.

### Task 4: Verify News and Full App Tests

**Files:**
- Verify only

**Step 1: Run targeted News suite**

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' CODE_SIGNING_ALLOWED=NO test -only-testing:CrisisMapTests/NewsSourcePresentationTests -only-testing:CrisisMapTests/NewsViewModelTests -only-testing:CrisisMapTests/NewsSourceAggregatorTests -only-testing:CrisisMapTests/MentionIndexCalculatorTests
```

Expected: PASS.

**Step 2: Run full iOS test suite**

```bash
xcodebuild -project /Users/fanghuaian/Documents/Projects/crisismap/ios/CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' CODE_SIGNING_ALLOWED=NO test
```

Expected: PASS.
