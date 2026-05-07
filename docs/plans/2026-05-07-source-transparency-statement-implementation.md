# Source Transparency Statement Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a lightweight source transparency sheet to News and Research so general users can see monitored news and research sources.

**Architecture:** Keep the source lists in a small shared model, render them through one reusable SwiftUI sheet, and present that sheet from News and Research toolbar info buttons. Static explanatory copy lives in `Localizable.xcstrings`; source names remain plain proper nouns.

**Tech Stack:** Swift 6, SwiftUI, XCTest, XcodeGen, `Localizable.xcstrings`.

---

### Task 1: Source Transparency Content Model

**Files:**
- Create: `ios/CrisisMap/Models/SourceTransparencyContent.swift`
- Test: `ios/CrisisMapTests/SourceTransparencyContentTests.swift`

**Step 1: Write the failing test**

Add tests that verify:

- News sources include Reuters, AP News, GDELT, and X/Grok.
- Research sources include Brookings, CSIS, RAND, and USNI.
- Limit statements include at least one user-facing coverage limitation.

**Step 2: Verify RED**

Run:

```bash
xcodegen generate
xcodebuild build-for-testing -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' -derivedDataPath /private/tmp/crisismap-source-transparency-test CODE_SIGNING_ALLOWED=NO
```

Expected: FAIL because `SourceTransparencyContent` does not exist.

**Step 3: Implement minimal model**

Create `SourceTransparencyContent` with static arrays:

- `newsSources`
- `researchSources`
- `limitations`

Do not fetch remote data in the view.

### Task 2: Reusable Sheet View

**Files:**
- Create: `ios/CrisisMap/Views/Shared/SourceTransparencySheet.swift`
- Modify: `ios/CrisisMap/Resources/Localizable.xcstrings`

**Step 1: Implement sheet**

Create a `NavigationStack` sheet with:

- title: `sourceTransparency.title`
- intro paragraph
- News section
- Research section
- How information is organized section
- Limits section

Use compact text and list rows. Avoid technical pipeline terms.

**Step 2: Add localized copy**

Add English and Traditional Chinese strings for the title, section headers, and short explanatory paragraphs.

### Task 3: Entry Points

**Files:**
- Modify: `ios/CrisisMap/Views/News/NewsView.swift`
- Modify: `ios/CrisisMap/Views/Research/ResearchView.swift`

**Step 1: Add state and sheet**

Add:

```swift
@State private var isShowingSourceTransparency = false
```

Present:

```swift
.sheet(isPresented: $isShowingSourceTransparency) {
    SourceTransparencySheet()
}
```

**Step 2: Add toolbar info button**

Add an `info.circle` button in News and Research toolbar. Use an accessibility label localized as `sourceTransparency.button`.

### Task 4: Verification and Simulator Deployment

**Files:**
- All touched files.

**Step 1: Regenerate project**

Run:

```bash
xcodegen generate
```

**Step 2: Run tests**

Run:

```bash
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air' -derivedDataPath /private/tmp/crisismap-source-transparency-test CODE_SIGNING_ALLOWED=NO
```

Expected: 0 failures.

**Step 3: Deploy to simulator**

Run build + launch on the iPhone Air simulator using the existing `CrisisMap` scheme and bundle id `net.strataperture.StratAperture`.
