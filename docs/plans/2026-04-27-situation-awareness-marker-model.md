# Situation Awareness Marker Model Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Render map markers from event occurrence locations first, while keeping region markers as fallback/aggregation for unplaced news and research.

**Architecture:** Add a low-cost built-in location inference layer, preserve raw `CrisisEvent` values through the mobile map pipeline, and build marker models from events plus region summaries. Android moves from region-only MapLibre annotations to event markers plus region fallback markers; iOS keeps its event-marker map and gains the same fallback semantics.

**Tech Stack:** Kotlin, Jetpack Compose, MapLibre Android SDK, JUnit 4, Swift, SwiftUI MapKit, XCTest.

---

### Task 1: Android Location Inference Contract

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/domain/locations/LocationInference.kt`
- Test: `android/app/src/test/java/com/crisismap/app/domain/locations/LocationInferenceTest.kt`

**Step 1: Write the failing test**

```kotlin
package com.crisismap.app.domain.locations

import com.crisismap.app.data.model.Region
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class LocationInferenceTest {
    @Test
    fun prefersPhysicalLocationOverActorKeyword() {
        val result = inferEventLocation(
            title = "What's driving attacks against gov't and Russian forces in Mali?",
            summary = "Russian personnel remain exposed to attacks in Mali.",
            providedName = null,
            providedCountry = null
        )

        assertEquals("Mali", result?.location?.name)
        assertEquals("ML", result?.location?.country)
        assertEquals(Region.Africa, result?.region)
    }

    @Test
    fun returnsNullWhenNoReliableLocationExists() {
        val result = inferEventLocation(
            title = "NATO governments review support timelines",
            summary = "Security planning remains active.",
            providedName = null,
            providedCountry = null
        )

        assertNull(result)
    }
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd android
/usr/bin/env ANDROID_HOME=/Users/fanghuaian/Library/Android/sdk ANDROID_SDK_ROOT=/Users/fanghuaian/Library/Android/sdk ./gradlew :app:testDebugUnitTest --tests com.crisismap.app.domain.locations.LocationInferenceTest
```

Expected: FAIL because `inferEventLocation` does not exist.

**Step 3: Write minimal implementation**

Create a small built-in gazetteer. Start with strategic MVP entries only:

```kotlin
data class InferredEventLocation(
    val location: Location,
    val region: Region
)

fun inferEventLocation(
    title: String,
    summary: String,
    providedName: String?,
    providedCountry: String?
): InferredEventLocation? {
    val haystack = listOfNotNull(providedName, providedCountry, title, summary)
        .joinToString(" ")
        .lowercase()

    return strategicLocations.firstOrNull { candidate ->
        candidate.keywords.any { keyword -> keyword in haystack }
    }?.let { candidate ->
        InferredEventLocation(
            location = Location(
                lat = candidate.lat,
                lng = candidate.lng,
                name = candidate.name,
                country = candidate.countryCode
            ),
            region = candidate.region
        )
    }
}
```

**Step 4: Run test to verify it passes**

Run the same targeted Gradle command.

Expected: PASS.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/domain/locations/LocationInference.kt android/app/src/test/java/com/crisismap/app/domain/locations/LocationInferenceTest.kt
git commit -m "feat(android): infer strategic event locations"
```

### Task 2: Android Preserve Events In News Repository

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/data/sources/NewsRepository.kt`
- Test: `android/app/src/test/java/com/crisismap/app/data/sources/NewsRepositoryTest.kt`

**Step 1: Write the failing test**

Add a test that verifies successful loads expose enriched raw events, not only clusters:

```kotlin
@Test
fun returnsEventsWithInferredLocations() = runTest {
    val repository = NewsRepository(
        sources = listOf(
            StaticNewsSource(
                events = listOf(event("mali", "Mali defence minister killed"))
            )
        ),
        fallbackSource = StaticNewsSource(emptyList())
    )

    val result = repository.loadClusters()

    result as NewsLoadResult.Success
    assertEquals("Mali", result.events.first().location?.name)
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd android
/usr/bin/env ANDROID_HOME=/Users/fanghuaian/Library/Android/sdk ANDROID_SDK_ROOT=/Users/fanghuaian/Library/Android/sdk ./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.sources.NewsRepositoryTest
```

Expected: FAIL because `NewsLoadResult.Success` has no `events` field.

**Step 3: Write minimal implementation**

- Add `events: List<CrisisEvent>` to `NewsLoadResult.Success`.
- Before building clusters, map events through location inference:

```kotlin
private fun enrichEvent(event: CrisisEvent): CrisisEvent {
    val inferred = inferEventLocation(
        title = event.title,
        summary = event.summary,
        providedName = event.location?.name,
        providedCountry = event.location?.country
    )

    return if (event.location != null || inferred == null) {
        event
    } else {
        event.copy(location = inferred.location)
    }
}
```

- Return enriched events in `NewsLoadResult.Success`.
- Keep `buildNewsClusters(events)` working from enriched events.

**Step 4: Run test to verify it passes**

Run the targeted repository test.

Expected: PASS.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/data/sources/NewsRepository.kt android/app/src/test/java/com/crisismap/app/data/sources/NewsRepositoryTest.kt
git commit -m "feat(android): preserve located news events"
```

### Task 3: Android Event And Region Marker Models

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/ui/map/EventMapMarker.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/map/RegionMapMarker.kt`
- Test: `android/app/src/test/java/com/crisismap/app/ui/map/EventMapMarkerTest.kt`

**Step 1: Write the failing test**

```kotlin
@Test
fun buildsEventMarkersFromLocatedEvents() {
    val markers = buildEventMapMarkers(
        listOf(
            event(
                id = "mali",
                title = "Mali defence minister killed",
                location = Location(lat = 17.57, lng = -3.99, name = "Mali", country = "ML")
            )
        )
    )

    assertEquals(1, markers.size)
    assertEquals("mali", markers.first().eventId)
    assertEquals(17.57, markers.first().lat, 0.0001)
    assertEquals(-3.99, markers.first().lng, 0.0001)
}

@Test
fun excludesEventsWithoutLocationsFromEventMarkers() {
    assertEquals(emptyList<EventMapMarker>(), buildEventMapMarkers(listOf(event(location = null))))
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd android
/usr/bin/env ANDROID_HOME=/Users/fanghuaian/Library/Android/sdk ANDROID_SDK_ROOT=/Users/fanghuaian/Library/Android/sdk ./gradlew :app:testDebugUnitTest --tests com.crisismap.app.ui.map.EventMapMarkerTest
```

Expected: FAIL because `EventMapMarker` does not exist.

**Step 3: Write minimal implementation**

Create:

```kotlin
data class EventMapMarker(
    val eventId: String,
    val title: String,
    val snippet: String,
    val lat: Double,
    val lng: Double,
    val threatLevel: ThreatLevel
)

fun buildEventMapMarkers(events: List<CrisisEvent>): List<EventMapMarker> =
    events.mapNotNull { event ->
        val location = event.location ?: return@mapNotNull null
        EventMapMarker(
            eventId = event.id,
            title = event.title,
            snippet = location.name,
            lat = location.lat,
            lng = location.lng,
            threatLevel = event.level
        )
    }
```

Keep existing `buildRegionMapMarkers` for fallback summaries.

**Step 4: Run test to verify it passes**

Run the targeted marker test.

Expected: PASS.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/ui/map/EventMapMarker.kt android/app/src/main/java/com/crisismap/app/ui/map/RegionMapMarker.kt android/app/src/test/java/com/crisismap/app/ui/map/EventMapMarkerTest.kt
git commit -m "feat(android): model event map markers"
```

### Task 4: Android Map UI Uses Event Markers First

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/ui/map/MapViewModel.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/map/MapScreen.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/map/EventMarkerSheet.kt`
- Test: `android/app/src/test/java/com/crisismap/app/ui/map/MapViewModelTest.kt`

**Step 1: Write the failing test**

Test that `MapUiState` exposes both event markers and region fallback summaries:

```kotlin
@Test
fun mapStateIncludesLocatedEventsAndRegionSummaries() = runTest {
    val viewModel = MapViewModel(
        newsRepository = repositoryReturning(
            events = listOf(locatedEvent(id = "mali")),
            clusters = listOf(newsCluster(region = Region.Africa))
        ),
        researchRepository = researchRepositoryReturning(emptyList())
    )

    advanceUntilIdle()

    assertEquals(listOf("mali"), viewModel.uiState.eventMarkers.map { it.eventId })
    assertTrue(viewModel.uiState.summaries.any { it.region == Region.Africa })
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd android
/usr/bin/env ANDROID_HOME=/Users/fanghuaian/Library/Android/sdk ANDROID_SDK_ROOT=/Users/fanghuaian/Library/Android/sdk ./gradlew :app:testDebugUnitTest --tests com.crisismap.app.ui.map.MapViewModelTest
```

Expected: FAIL because `MapUiState.eventMarkers` does not exist.

**Step 3: Write minimal implementation**

- Add `events: List<CrisisEvent>` and `eventMarkers: List<EventMapMarker>` to `MapUiState`.
- Build event markers from `NewsLoadResult.Success.events`.
- In `MapScreen`, add event MapLibre markers first, and region markers second.
- Use the returned MapLibre marker IDs to map clicks back to either event or region selection.
- Event marker click opens `EventMarkerSheet`.
- Region marker click keeps opening `RegionMarkerSheet`.

**Step 4: Run test to verify it passes**

Run the targeted ViewModel test.

Expected: PASS.

**Step 5: Manual smoke**

Run:

```bash
cd android
/usr/bin/env ANDROID_HOME=/Users/fanghuaian/Library/Android/sdk ANDROID_SDK_ROOT=/Users/fanghuaian/Library/Android/sdk ./gradlew :app:testDebugUnitTest :app:assembleDebug
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb install -r app/build/outputs/apk/debug/app-debug.apk
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb shell am start -n com.crisismap.app/.MainActivity
```

Expected: event markers appear at specific locations; region markers remain for aggregate fallback.

**Step 6: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/ui/map/MapViewModel.kt android/app/src/main/java/com/crisismap/app/ui/map/MapScreen.kt android/app/src/main/java/com/crisismap/app/ui/map/EventMarkerSheet.kt android/app/src/test/java/com/crisismap/app/ui/map/MapViewModelTest.kt
git commit -m "feat(android): render event markers with region fallback"
```

### Task 5: iOS Contract Alignment

**Files:**
- Modify: `ios/CrisisMap/Models/CrisisEvent.swift`
- Create: `ios/CrisisMap/Services/LocationInference.swift`
- Test: `ios/CrisisMapTests/LocationInferenceTests.swift`
- Test: `ios/CrisisMapTests/NewsSourceAggregatorTests.swift`

**Step 1: Write the failing test**

```swift
func testPrefersPhysicalLocationOverActorKeyword() {
    let result = LocationInference.infer(
        title: "What's driving attacks against gov't and Russian forces in Mali?",
        summary: "Russian personnel remain exposed to attacks in Mali.",
        providedLocation: nil
    )

    XCTAssertEqual(result?.location.name, "Mali")
    XCTAssertEqual(result?.region, .africa)
}
```

**Step 2: Run test to verify it fails**

Run:

```bash
cd ios
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air'
```

Expected: FAIL because `LocationInference` does not exist.

**Step 3: Write minimal implementation**

Mirror Android's strategic gazetteer in Swift. Keep the same names, coordinates, country codes, and region mapping.

**Step 4: Run test to verify it passes**

Run the same Xcode test command.

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/Services/LocationInference.swift ios/CrisisMapTests/LocationInferenceTests.swift ios/CrisisMapTests/NewsSourceAggregatorTests.swift
git commit -m "feat(ios): infer strategic event locations"
```

### Task 6: iOS Region Fallback Markers

**Files:**
- Modify: `ios/CrisisMap/ViewModels/EventsViewModel.swift`
- Modify: `ios/CrisisMap/Views/Map/CrisisMapView.swift`
- Create: `ios/CrisisMap/Views/Map/RegionMarkerSheet.swift`
- Test: `ios/CrisisMapTests/EventsViewModelTests.swift`

**Step 1: Write the failing test**

Add a ViewModel test that verifies unlocated events remain visible through region fallback:

```swift
func testUnlocatedEventsAreAvailableAsRegionFallback() async {
    let viewModel = EventsViewModel(apiClient: StubClient(events: [unlocatedMideastEvent()]))
    await viewModel.refresh()

    XCTAssertTrue(viewModel.eventsWithLocation.isEmpty)
    XCTAssertEqual(viewModel.regionFallbacks.first?.region, .middleEast)
}
```

**Step 2: Run test to verify it fails**

Run the iOS test command.

Expected: FAIL because `regionFallbacks` does not exist.

**Step 3: Write minimal implementation**

- Add `regionFallbacks` computed state in `EventsViewModel`.
- Keep existing event annotations in `CrisisMapView`.
- Add region annotations for fallback regions.
- Region marker tap opens `RegionMarkerSheet`.

**Step 4: Run test to verify it passes**

Run the iOS test command.

Expected: PASS.

**Step 5: Commit**

```bash
git add ios/CrisisMap/ViewModels/EventsViewModel.swift ios/CrisisMap/Views/Map/CrisisMapView.swift ios/CrisisMap/Views/Map/RegionMarkerSheet.swift ios/CrisisMapTests/EventsViewModelTests.swift
git commit -m "feat(ios): show region fallback markers"
```

### Task 7: Related Research Support Layer

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/domain/regions/RegionMapping.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/map/EventMarkerSheet.kt`
- Modify: `ios/CrisisMap/Views/Map/EventDetailSheet.swift`
- Test: `android/app/src/test/java/com/crisismap/app/domain/regions/ResearchRelevanceTest.kt`
- Test: `ios/CrisisMapTests/ResearchRelevanceTests.swift`

**Step 1: Write failing tests**

Android:

```kotlin
@Test
fun relatedResearchUsesRegionAndActorTopics() {
    val result = relatedResearch(
        eventRegion = Region.Africa,
        entities = listOf("Russia", "Sahel"),
        articles = listOf(article(category = "africa", topics = listOf("Sahel")))
    )

    assertEquals(1, result.size)
}
```

iOS:

```swift
func testRelatedResearchUsesRegionAndActorTopics() {
    let result = RelatedResearch.match(
        eventRegion: .africa,
        entities: ["Russia", "Sahel"],
        articles: [article(category: "africa", topics: ["Sahel"])]
    )

    XCTAssertEqual(result.count, 1)
}
```

**Step 2: Run tests to verify they fail**

Run Android and iOS targeted tests.

Expected: FAIL because relevance helpers do not exist.

**Step 3: Write minimal implementation**

- Match research by region category first.
- Then match overlapping topics/entities.
- Limit event sheet support to 3 research items.
- Keep broad research in region sheet when event relevance is weak.

**Step 4: Run tests to verify they pass**

Run Android and iOS targeted tests.

Expected: PASS.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/domain/regions/RegionMapping.kt android/app/src/main/java/com/crisismap/app/ui/map/EventMarkerSheet.kt android/app/src/test/java/com/crisismap/app/domain/regions/ResearchRelevanceTest.kt ios/CrisisMap/Views/Map/EventDetailSheet.swift ios/CrisisMapTests/ResearchRelevanceTests.swift
git commit -m "feat: attach research support to map context"
```

### Task 8: Final Verification

**Files:**
- No source edits unless verification exposes a bug.

**Step 1: Android full verification**

Run:

```bash
cd android
/usr/bin/env ANDROID_HOME=/Users/fanghuaian/Library/Android/sdk ANDROID_SDK_ROOT=/Users/fanghuaian/Library/Android/sdk ./gradlew :app:testDebugUnitTest :app:assembleDebug
```

Expected: BUILD SUCCESSFUL.

**Step 2: Android emulator smoke**

Run:

```bash
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb install -r android/app/build/outputs/apk/debug/app-debug.apk
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb shell am start -n com.crisismap.app/.MainActivity
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb exec-out screencap -p > /tmp/crisismap-android-situation-awareness-markers.png
```

Expected: event markers are geographically placed; region fallback markers remain available.

**Step 3: iOS full verification**

Run:

```bash
cd ios
xcodebuild test -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'platform=iOS Simulator,name=iPhone Air'
xcodebuild -project CrisisMap.xcodeproj -scheme CrisisMap -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Expected: tests pass and simulator build succeeds.

**Step 4: iOS simulator smoke**

Install and launch the simulator app using the current repo's existing simulator workflow.

Expected: event markers and region fallback markers are visible; marker sheets separate location, actors, sources, and supporting research.

**Step 5: Final commit if verification fixes were needed**

```bash
git status --short
git add <only verification fix files>
git commit -m "fix: stabilize situation awareness markers"
```
