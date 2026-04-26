# Android Kotlin MVP Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a native Kotlin Android app that mirrors the iOS Map/News/Research MVP and preserves the same serialized data contracts.

**Architecture:** Create a new `android/` Gradle project using Kotlin, Jetpack Compose, kotlinx.serialization, coroutines, and MapLibre. Build contract tests first, then implement data models, static Research loading, public News sources, region summaries, and three-tab Compose UI.

**Tech Stack:** Kotlin, Android Gradle Plugin, Jetpack Compose, kotlinx.serialization, OkHttp or Ktor, Room/DataStore or file cache, MapLibre Android, JUnit.

---

### Task 1: Scaffold Android Project

**Files:**
- Create: `android/settings.gradle.kts`
- Create: `android/build.gradle.kts`
- Create: `android/gradle.properties`
- Create: `android/app/build.gradle.kts`
- Create: `android/app/src/main/AndroidManifest.xml`
- Create: `android/app/src/main/java/com/crisismap/app/MainActivity.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/shell/CrisisMapApp.kt`

**Step 1: Create Gradle project files**

Create `android/settings.gradle.kts`:

```kotlin
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "CrisisMapAndroid"
include(":app")
```

Create `android/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.0.21" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.0.21" apply false
    id("org.jetbrains.kotlin.plugin.serialization") version "2.0.21" apply false
}
```

Create `android/gradle.properties`:

```properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.nonTransitiveRClass=true
```

Create `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
    id("org.jetbrains.kotlin.plugin.serialization")
}

android {
    namespace = "com.crisismap.app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.crisismap.app"
        minSdk = 26
        targetSdk = 35
        versionCode = 1
        versionName = "0.1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        compose = true
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.12.01")
    implementation(composeBom)
    androidTestImplementation(composeBom)

    implementation("androidx.activity:activity-compose:1.9.3")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.8.7")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.7")
    implementation("androidx.navigation:navigation-compose:2.8.5")

    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.3")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")

    implementation("org.maplibre.gl:android-sdk:11.5.0")

    testImplementation("junit:junit:4.13.2")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.9.0")
}
```

**Step 2: Create minimal app shell**

Create `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:theme="@style/AppTheme"
        android:label="CrisisMap">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

Create `android/app/src/main/res/values/styles.xml`:

```xml
<resources>
    <style name="AppTheme" parent="android:style/Theme.Material.NoActionBar" />
</resources>
```

Create `android/app/src/main/java/com/crisismap/app/MainActivity.kt`:

```kotlin
package com.crisismap.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.crisismap.app.ui.shell.CrisisMapApp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CrisisMapApp()
        }
    }
}
```

Create `android/app/src/main/java/com/crisismap/app/ui/shell/CrisisMapApp.kt`:

```kotlin
package com.crisismap.app.ui.shell

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable

@Composable
fun CrisisMapApp() {
    MaterialTheme {
        Text("CrisisMap")
    }
}
```

**Step 3: Build**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: debug APK builds.

**Step 4: Commit**

```bash
git add android
git commit -m "feat(android): scaffold kotlin app"
```

---

### Task 2: Add Contract Models With Failing Tests First

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/data/model/Contracts.kt`
- Create: `android/app/src/test/java/com/crisismap/app/data/model/ContractsTest.kt`

**Step 1: Write failing tests**

Create `ContractsTest.kt`:

```kotlin
package com.crisismap.app.data.model

import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ContractsTest {
    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
    }

    @Test
    fun decodesThinkTankArticleWithIosDefaults() {
        val article = json.decodeFromString<ThinkTankArticle>(
            """
            {
              "id": "a1",
              "think_tank": "RAND",
              "title": "Report",
              "url": "https://example.com",
              "date": "2026-04-01"
            }
            """.trimIndent()
        )

        assertEquals("RAND", article.thinkTank)
        assertEquals("", article.summary)
        assertEquals("general", article.category)
        assertEquals("unknown", article.status)
        assertEquals(emptyList<String>(), article.topics)
    }

    @Test
    fun decodesHyphenatedRegionRawValues() {
        assertEquals(Region.MiddleEast, json.decodeFromString<Region>("\"middle-east\""))
        assertEquals(Region.EastAsia, json.decodeFromString<Region>("\"east-asia\""))
    }

    @Test
    fun decodesCrisisEventNullableFields() {
        val event = json.decodeFromString<CrisisEvent>(
            """
            {
              "id": "e1",
              "title": "Title",
              "summary": "Summary",
              "category": "conflict",
              "level": "high",
              "location": null,
              "timestamp": "2026-04-01T00:00:00Z",
              "source": "Reuters",
              "sourceTier": "public"
            }
            """.trimIndent()
        )

        assertNull(event.location)
        assertNull(event.url)
        assertNull(event.actor)
        assertNull(event.entities)
        assertNull(event.newsSource)
    }
}
```

**Step 2: Run tests and verify RED**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.model.ContractsTest
```

Expected: fails because contract models do not exist.

**Step 3: Add models**

Create `Contracts.kt`:

```kotlin
package com.crisismap.app.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
enum class Region {
    @SerialName("all") All,
    @SerialName("middle-east") MiddleEast,
    @SerialName("europe") Europe,
    @SerialName("east-asia") EastAsia,
    @SerialName("africa") Africa,
    @SerialName("americas") Americas
}

@Serializable
enum class EventCategory {
    @SerialName("conflict") Conflict,
    @SerialName("statement") Statement,
    @SerialName("military") Military,
    @SerialName("diplomatic") Diplomatic,
    @SerialName("economic") Economic,
    @SerialName("terrorism") Terrorism,
    @SerialName("disaster") Disaster,
    @SerialName("prediction") Prediction,
    @SerialName("earthquake") Earthquake
}

@Serializable
enum class ThreatLevel {
    @SerialName("critical") Critical,
    @SerialName("high") High,
    @SerialName("medium") Medium,
    @SerialName("low") Low,
    @SerialName("info") Info
}

@Serializable
enum class SourceTier {
    @SerialName("public") Public,
    @SerialName("private") Private
}

@Serializable
enum class NewsSourceKind {
    @SerialName("wire") Wire,
    @SerialName("publisher") Publisher,
    @SerialName("aggregator") Aggregator,
    @SerialName("social") Social
}

@Serializable
enum class NewsSourceAttribution {
    @SerialName("direct") Direct,
    @SerialName("derived") Derived
}

@Serializable
data class Location(
    val lat: Double,
    val lng: Double,
    val name: String,
    val country: String? = null
)

@Serializable
data class NewsSourceDescriptor(
    val displayName: String,
    val kind: NewsSourceKind,
    val identity: String,
    val group: String,
    val attribution: NewsSourceAttribution,
    val originalOutlet: String? = null,
    val originCountry: String? = null,
    val languageCode: String? = null,
    val domain: String? = null,
    val authorHandle: String? = null
)

@Serializable
data class CrisisEvent(
    val id: String,
    val title: String,
    val summary: String,
    val category: EventCategory,
    val level: ThreatLevel,
    val location: Location? = null,
    val timestamp: String,
    val source: String,
    val sourceTier: SourceTier,
    val url: String? = null,
    val actor: String? = null,
    val entities: List<String>? = null,
    val newsSource: NewsSourceDescriptor? = null
)

@Serializable
data class WeekEntry(
    val week: String,
    val uploaded: String
)

@Serializable
data class WeekIndex(
    val weeks: List<WeekEntry>
)

@Serializable
data class TopicsIndex(
    val topics: List<String>
)

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

@Serializable
data class ThinkTankWeekly(
    val week: String,
    @SerialName("start_date") val startDate: String,
    @SerialName("end_date") val endDate: String,
    @SerialName("generated_at") val generatedAt: String,
    val articles: List<ThinkTankArticle>
)
```

**Step 4: Run tests and verify GREEN**

Run the same test command.

Expected: contract tests pass.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/data/model android/app/src/test/java/com/crisismap/app/data/model
git commit -m "feat(android): add shared data contracts"
```

---

### Task 3: Add Region Mapping Domain

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/domain/regions/RegionMapping.kt`
- Create: `android/app/src/test/java/com/crisismap/app/domain/regions/RegionMappingTest.kt`

**Step 1: Write failing tests**

Test that `Region.MiddleEast` matches `middle_east` research category and `Region.EastAsia` matches Taiwan topic. Also test map marker regions exclude `All`.

**Step 2: Implement region mapping**

Port iOS `Region.matchesArticle` behavior:

```kotlin
val mapMarkerRegions = listOf(
    Region.MiddleEast,
    Region.Europe,
    Region.EastAsia,
    Region.Africa,
    Region.Americas
)
```

Add research category/topic mappings equivalent to iOS:

- Middle East: category `middle_east`, topic `Middle East`
- Europe: category `europe`, topics `Europe`, `Russia`, `Ukraine`, `NATO`
- East Asia: category `china_indopacific`, topics `China`, `Taiwan`, `Indo-Pacific`
- Africa: category `africa`
- Americas: category `americas`, topic `United States`

**Step 3: Run tests**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.domain.regions.RegionMappingTest
```

Expected: tests pass.

**Step 4: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/domain/regions android/app/src/test/java/com/crisismap/app/domain/regions
git commit -m "feat(android): map research articles to regions"
```

---

### Task 4: Add Region Intelligence Summary

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/domain/regions/RegionIntelligenceSummary.kt`
- Create: `android/app/src/test/java/com/crisismap/app/domain/regions/RegionIntelligenceSummaryTest.kt`

**Step 1: Write failing tests**

Test:

- summaries include exactly five concrete regions
- summary counts news clusters and research articles
- heat score normalizes against largest region

**Step 2: Implement models**

Create:

```kotlin
data class NewsClusterSummary(...)
data class RegionMapCoordinate(...)
data class RegionIntelligenceSummary(...)
```

Keep fields aligned with iOS:

- region
- coordinate
- newsClusterCount
- researchArticleCount
- topNewsClusters
- recentResearchArticles
- lastUpdatedAt
- heatScore
- totalCount

**Step 3: Run tests**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.domain.regions.RegionIntelligenceSummaryTest
```

Expected: tests pass.

**Step 4: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/domain/regions android/app/src/test/java/com/crisismap/app/domain/regions
git commit -m "feat(android): derive region intelligence summaries"
```

---

### Task 5: Implement Research Static JSON Repository

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/data/sources/ThinkTankApi.kt`
- Create: `android/app/src/main/java/com/crisismap/app/data/sources/ResearchRepository.kt`
- Create: `android/app/src/test/java/com/crisismap/app/data/sources/ResearchRepositoryTest.kt`

**Step 1: Write failing repository tests**

Use fake HTTP responses to verify:

- week index fetches
- weekly files decode
- partial weekly failures still return successful articles
- all weeks failing returns an error

**Step 2: Implement API client**

Use OkHttp and kotlinx.serialization.

Base URLs:

- root: `https://thinktankbriefdata.strataperture.net`
- yearly: `https://thinktankbriefdata.strataperture.net/2026`

**Step 3: Implement repository**

Match iOS behavior: fetch index, then fetch weeks in parallel, tolerate partial failures, return articles.

**Step 4: Run tests**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.sources.ResearchRepositoryTest
```

Expected: tests pass.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/data/sources android/app/src/test/java/com/crisismap/app/data/sources
git commit -m "feat(android): load think tank research"
```

---

### Task 6: Add Three-Tab Compose Shell

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/ui/shell/CrisisMapApp.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/shell/AppTab.kt`
- Create: `android/app/src/test/java/com/crisismap/app/ui/shell/AppTabTest.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/map/MapScreen.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/research/ResearchScreen.kt`

**Step 1: Write failing tab test**

Test:

```kotlin
assertEquals(listOf(AppTab.Map, AppTab.News, AppTab.Research), AppTab.mvpVisible)
```

**Step 2: Implement `AppTab`**

Create only three visible tabs. Do not add Feed/Dashboard to visible navigation.

**Step 3: Implement shell**

Use Material3 `Scaffold` and `NavigationBar` with placeholder screen content.

**Step 4: Run tests and build**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest :app:assembleDebug
```

Expected: tests and debug build pass.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/ui android/app/src/test/java/com/crisismap/app/ui
git commit -m "feat(android): add mvp tab shell"
```

---

### Task 7: Implement Research Screen

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/ui/research/ResearchScreen.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/research/ResearchViewModel.kt`

**Step 1: Add view model**

Expose loading/error/articles state.

**Step 2: Render region counts**

Match iOS Research tab first-level experience:

- All
- Middle East
- Europe
- East Asia
- Africa
- Americas

**Step 3: Build**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: build passes.

**Step 4: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/ui/research
git commit -m "feat(android): show research regions"
```

---

### Task 8: Implement News Fixtures Then Public Sources

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/data/sources/NewsDataSource.kt`
- Create: `android/app/src/main/java/com/crisismap/app/data/sources/RssNewsSource.kt`
- Create: `android/app/src/main/java/com/crisismap/app/data/sources/GdeltNewsSource.kt`
- Create: `android/app/src/main/java/com/crisismap/app/data/sources/NewsRepository.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/news/NewsViewModel.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt`

**Step 1: Start with fixture source**

Use a fixture provider so UI and clustering can work before RSS parser details are complete.

**Step 2: Add RSS/GDELT sources**

Mirror iOS source IDs:

- `rss`
- `gdelt`
- `x-grok` disabled by default

**Step 3: Render News clusters**

Display cluster label, score, source count, topics, and source type summary.

**Step 4: Build**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: build passes.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/data/sources android/app/src/main/java/com/crisismap/app/ui/news
git commit -m "feat(android): show news clusters"
```

---

### Task 9: Implement MapLibre Region Markers

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/ui/map/MapScreen.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/map/RegionMarkerSheet.kt`
- Create: `android/app/src/main/java/com/crisismap/app/ui/map/MapViewModel.kt`

**Step 1: Render MapLibre map**

Use a free basemap style. If MapLibre style setup blocks local build, keep a Compose placeholder map only temporarily and document the blocker.

**Step 2: Render five fixed region markers**

Use `RegionIntelligenceSummary` coordinates and heat score.

**Step 3: Add region sheet**

Tap marker opens sheet with:

- region name
- news count
- research count
- top news clusters
- recent reports

**Step 4: Build**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: build passes.

**Step 5: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/ui/map
git commit -m "feat(android): show region map markers"
```

---

### Task 10: Emulator Verification

**Files:**
- No source edits unless verification exposes a bug.

**Step 1: Build APK**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: build passes.

**Step 2: Install and launch**

Run:

```bash
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb install -r android/app/build/outputs/apk/debug/app-debug.apk
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb shell am start -n com.crisismap.app/.MainActivity
```

Expected: app launches on `Pixel_9a` emulator.

**Step 3: Verify UI**

Expected:

- bottom navigation has Map, News, Research only
- Research screen shows region counts after load
- News screen shows cluster list or useful fixture/live content
- Map screen shows five region markers
- tapping marker opens region sheet

**Step 4: Capture screenshot**

Use:

```bash
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb exec-out screencap -p > /tmp/crisismap-android-mvp.png
```

**Step 5: Commit fixes if needed**

If verification requires fixes:

```bash
git add android
git commit -m "fix(android): polish mvp verification issues"
```

---

## Execution Notes

- Use @superpowers:test-driven-development for each behavior change.
- Keep Android data contracts aligned with iOS raw values.
- Do not add Dashboard, Feed, Markets, Actors, or private-key sources.
- Prefer small commits after each task.
- If Gradle dependency download fails because of restricted network access, request escalation before retrying.
- If Android SDK/Gradle version conflicts occur, choose the smallest version adjustment that preserves Kotlin + Compose + serialization.
