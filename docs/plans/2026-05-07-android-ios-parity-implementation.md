# Android iOS Parity Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Bring Android News and Research into parity with the iOS source coverage, localized UI/source metadata, and source transparency statement.

**Architecture:** Add Android string resources for English and Traditional Chinese, expand public RSS coverage to match iOS, keep source metadata raw in data/domain models, and render localized source summaries in Compose. Add one shared source transparency content model and sheet, presented from both News and Research.

**Tech Stack:** Kotlin, Jetpack Compose Material 3, Android string resources, JUnit 4, Gradle.

---

### Task 1: Localization Resource Foundation

**Files:**
- Create: `android/app/src/main/res/values/strings.xml`
- Create: `android/app/src/main/res/values-zh-rTW/strings.xml`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/shell/AppTab.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/shell/CrisisMapApp.kt`
- Test: `android/app/src/test/java/com/crisismap/app/ui/shell/AppTabTest.kt`

**Step 1: Write the failing test**

Update `AppTabTest` so it expects each visible tab to expose a string resource id instead of hardcoded labels.

Expected visible tab order:

```kotlin
listOf(AppTab.Map, AppTab.News, AppTab.Research)
```

Also assert each tab has a non-zero `labelRes`.

**Step 2: Run the test to verify RED**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.ui.shell.AppTabTest
```

Expected: FAIL because `labelRes` does not exist.

**Step 3: Add string resources**

Create `values/strings.xml` with at least:

```xml
<resources>
    <string name="app_name">StratAperture</string>
    <string name="tab_map">Map</string>
    <string name="tab_news">News</string>
    <string name="tab_research">Research</string>
    <string name="news_title">News</string>
    <string name="news_retry">Retry</string>
    <string name="news_source_count">%1$d sources</string>
    <string name="research_title">Research</string>
    <string name="research_retry">Retry</string>
    <string name="research_recent">Recent</string>
</resources>
```

Create `values-zh-rTW/strings.xml` with Traditional Chinese equivalents:

```xml
<resources>
    <string name="app_name">StratAperture</string>
    <string name="tab_map">地圖</string>
    <string name="tab_news">新聞</string>
    <string name="tab_research">研究</string>
    <string name="news_title">新聞</string>
    <string name="news_retry">重試</string>
    <string name="news_source_count">%1$d 個來源</string>
    <string name="research_title">研究</string>
    <string name="research_retry">重試</string>
    <string name="research_recent">近期</string>
</resources>
```

**Step 4: Update tab model and shell**

Change `AppTab` to store `@StringRes val labelRes: Int`.

In `CrisisMapApp`, render labels with:

```kotlin
Text(stringResource(tab.labelRes))
```

Keep `shortLabel` unchanged for now.

**Step 5: Run the test to verify GREEN**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.ui.shell.AppTabTest
```

Expected: PASS.

**Step 6: Commit**

```bash
git add android/app/src/main/res/values/strings.xml android/app/src/main/res/values-zh-rTW/strings.xml android/app/src/main/java/com/crisismap/app/ui/shell/AppTab.kt android/app/src/main/java/com/crisismap/app/ui/shell/CrisisMapApp.kt android/app/src/test/java/com/crisismap/app/ui/shell/AppTabTest.kt
git commit -m "feat(android): add localization resources"
```

### Task 2: Public RSS Source Parity

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/data/sources/RssNewsSource.kt`
- Test: `android/app/src/test/java/com/crisismap/app/data/sources/RssNewsSourceTest.kt`

**Step 1: Write the failing tests**

Create tests that assert `RssNewsSource.defaultFeeds` includes:

```kotlin
listOf(
    "Reuters",
    "AP News",
    "BBC News",
    "NHK World",
    "Al Jazeera",
    "DW",
    "The Guardian",
    "NPR World",
    "France 24",
    "UN News"
)
```

Also assert:

```kotlin
assertEquals(NewsSourceKind.Wire, feed("Reuters").kind)
assertEquals(NewsSourceKind.Wire, feed("AP News").kind)
assertTrue(feed("AP News").fallbackUrls.isNotEmpty())
```

**Step 2: Run the test to verify RED**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.sources.RssNewsSourceTest
```

Expected: FAIL because most feeds, `kind`, and `fallbackUrls` are missing.

**Step 3: Extend `RssFeed`**

Change `RssFeed` to:

```kotlin
data class RssFeed(
    val id: String,
    val name: String,
    val domain: String,
    val url: String,
    val fallbackUrls: List<String> = emptyList(),
    val kind: NewsSourceKind = NewsSourceKind.Publisher
)
```

Update `fetchFeed` so `NewsSourceDescriptor.kind = feed.kind`.

If adding fallback fetching in this task, try `url` first, then each fallback URL until one returns non-empty events. If keeping fallback execution separate, still add the model property and test for AP fallback configuration.

**Step 4: Expand default feeds**

Use the same public feed set as iOS:

```kotlin
RssFeed("reuters", "Reuters", "reuters.com", "https://feeds.reuters.com/Reuters/worldNews", kind = NewsSourceKind.Wire)
RssFeed("ap", "AP News", "apnews.com", "https://rsshub.app/apnews/topics/world-news", fallbackUrls = listOf("https://news.google.com/rss/search?q=site:apnews.com%20world&hl=en-US&gl=US&ceid=US:en"), kind = NewsSourceKind.Wire)
RssFeed("bbc", "BBC News", "bbc.com", "https://feeds.bbci.co.uk/news/world/rss.xml")
RssFeed("nhk", "NHK World", "nhk.or.jp", "https://www3.nhk.or.jp/rss/news/cat6.xml")
RssFeed("aljazeera", "Al Jazeera", "aljazeera.com", "https://www.aljazeera.com/xml/rss/all.xml")
RssFeed("dw", "DW", "dw.com", "https://rss.dw.com/rdf/rss-en-top")
RssFeed("guardian-world", "The Guardian", "theguardian.com", "https://www.theguardian.com/world/rss")
RssFeed("npr-world", "NPR World", "npr.org", "https://feeds.npr.org/1004/rss.xml")
RssFeed("france24", "France 24", "france24.com", "https://www.france24.com/en/rss")
RssFeed("un-news", "UN News", "news.un.org", "https://news.un.org/feed/subscribe/en/news/all/rss.xml")
```

**Step 5: Run the test to verify GREEN**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.sources.RssNewsSourceTest
```

Expected: PASS.

**Step 6: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/data/sources/RssNewsSource.kt android/app/src/test/java/com/crisismap/app/data/sources/RssNewsSourceTest.kt
git commit -m "feat(android): align public news feeds"
```

### Task 3: News Source Metadata Summaries

**Files:**
- Modify: `android/app/src/main/java/com/crisismap/app/domain/regions/RegionIntelligenceSummary.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/data/sources/NewsRepository.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt`
- Modify: `android/app/src/main/res/values/strings.xml`
- Modify: `android/app/src/main/res/values-zh-rTW/strings.xml`
- Test: `android/app/src/test/java/com/crisismap/app/data/sources/NewsRepositoryTest.kt`

**Step 1: Write the failing test**

Add a test that builds a cluster from three events:

- Two events with `NewsSourceAttribution.Direct`.
- One event with `NewsSourceAttribution.Derived`.
- At least one `Wire` and one `Publisher` source kind.

Assert the resulting `NewsClusterSummary` has:

```kotlin
assertEquals(2, cluster.directSourceCount)
assertEquals(1, cluster.derivedSourceCount)
assertEquals(listOf(NewsSourceKind.Wire, NewsSourceKind.Publisher), cluster.sourceKinds)
```

**Step 2: Run the test to verify RED**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.sources.NewsRepositoryTest
```

Expected: FAIL because `directSourceCount`, `derivedSourceCount`, and `sourceKinds` do not exist.

**Step 3: Extend `NewsClusterSummary`**

Add defaulted properties:

```kotlin
val sourceKinds: List<NewsSourceKind> = emptyList(),
val directSourceCount: Int = 0,
val derivedSourceCount: Int = 0
```

Use defaults so existing tests and constructors remain stable.

**Step 4: Populate metadata in `buildNewsClusters`**

Use a stable order:

```kotlin
val orderedKinds = listOf(
    NewsSourceKind.Wire,
    NewsSourceKind.Publisher,
    NewsSourceKind.Social,
    NewsSourceKind.Aggregator
)
```

For each region cluster:

```kotlin
val presentKinds = regionEvents.mapNotNull { it.newsSource?.kind }.toSet()
val sourceKinds = orderedKinds.filter { it in presentKinds }
val directCount = regionEvents.count { it.newsSource?.attribution == NewsSourceAttribution.Direct }
val derivedCount = regionEvents.count { it.newsSource?.attribution == NewsSourceAttribution.Derived }
```

**Step 5: Add localized source labels**

Add strings:

```xml
<string name="news_source_direct">direct</string>
<string name="news_source_derived">derived</string>
<string name="news_source_wire">wire</string>
<string name="news_source_publisher">publisher</string>
<string name="news_source_aggregator">aggregator</string>
<string name="news_source_social">social</string>
<string name="news_source_counted">%1$d %2$s</string>
```

Traditional Chinese:

```xml
<string name="news_source_direct">直接來源</string>
<string name="news_source_derived">轉載彙整</string>
<string name="news_source_wire">通訊社</string>
<string name="news_source_publisher">發行媒體</string>
<string name="news_source_aggregator">聚合器</string>
<string name="news_source_social">社群</string>
<string name="news_source_counted">%1$d 個%2$s</string>
```

**Step 6: Render row summaries in `NewsScreen`**

For each cluster:

- If both direct and derived counts are present, render counted attribution parts joined by ` · `.
- Otherwise render source kind labels joined by ` · `.

Keep formatting in the Compose UI so it can use `stringResource`.

**Step 7: Run the test to verify GREEN**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.data.sources.NewsRepositoryTest
```

Expected: PASS.

**Step 8: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/domain/regions/RegionIntelligenceSummary.kt android/app/src/main/java/com/crisismap/app/data/sources/NewsRepository.kt android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt android/app/src/main/res/values/strings.xml android/app/src/main/res/values-zh-rTW/strings.xml android/app/src/test/java/com/crisismap/app/data/sources/NewsRepositoryTest.kt
git commit -m "feat(android): add localized source summaries"
```

### Task 4: Source Transparency Content Model

**Files:**
- Create: `android/app/src/main/java/com/crisismap/app/ui/shared/SourceTransparencyContent.kt`
- Test: `android/app/src/test/java/com/crisismap/app/ui/shared/SourceTransparencyContentTest.kt`

**Step 1: Write the failing test**

Assert:

```kotlin
assertTrue(SourceTransparencyContent.newsSources.any { it.name == "Reuters" })
assertTrue(SourceTransparencyContent.newsSources.any { it.name == "AP News" })
assertTrue(SourceTransparencyContent.newsSources.any { it.name == "GDELT" })
assertTrue(SourceTransparencyContent.newsSources.any { it.name == "X/Grok" })
assertTrue(SourceTransparencyContent.researchSources.any { it.name == "Brookings" })
assertTrue(SourceTransparencyContent.researchSources.any { it.name == "CSIS" })
assertTrue(SourceTransparencyContent.researchSources.any { it.name == "RAND" })
assertTrue(SourceTransparencyContent.researchSources.any { it.name == "USNI" })
assertTrue(SourceTransparencyContent.limitations.any { it.textRes == R.string.source_transparency_limit_coverage })
```

**Step 2: Run the test to verify RED**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.ui.shared.SourceTransparencyContentTest
```

Expected: FAIL because `SourceTransparencyContent` does not exist.

**Step 3: Implement content model**

Create:

```kotlin
data class TransparencySource(
    val name: String,
    @StringRes val detailRes: Int? = null
)

data class TransparencyLimitation(
    @StringRes val textRes: Int
)

object SourceTransparencyContent {
    val newsSources = listOf(...)
    val researchSources = listOf(...)
    val limitations = listOf(...)
}
```

Use the same source names as the iOS `SourceTransparencyContent`.

**Step 4: Add required strings**

Add source transparency strings in both resource files for:

- title
- button accessibility label
- intro
- news title/description
- GDELT detail
- X/Grok detail
- research title/description
- organized title/description
- limits title
- coverage/availability/originals limits
- done button

**Step 5: Run the test to verify GREEN**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest --tests com.crisismap.app.ui.shared.SourceTransparencyContentTest
```

Expected: PASS.

**Step 6: Commit**

```bash
git add android/app/src/main/java/com/crisismap/app/ui/shared/SourceTransparencyContent.kt android/app/src/main/res/values/strings.xml android/app/src/main/res/values-zh-rTW/strings.xml android/app/src/test/java/com/crisismap/app/ui/shared/SourceTransparencyContentTest.kt
git commit -m "feat(android): add source transparency content"
```

### Task 5: Source Transparency Sheet and Entry Points

**Files:**
- Modify: `android/app/build.gradle.kts`
- Create: `android/app/src/main/java/com/crisismap/app/ui/shared/SourceTransparencySheet.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt`
- Modify: `android/app/src/main/java/com/crisismap/app/ui/research/ResearchScreen.kt`

**Step 1: Add icon dependency**

Add:

```kotlin
implementation("androidx.compose.material:material-icons-extended")
```

Keep the Compose BOM in place.

**Step 2: Implement the sheet**

Create a reusable Compose sheet using Material 3:

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SourceTransparencySheet(
    onDismissRequest: () -> Unit
) {
    ModalBottomSheet(onDismissRequest = onDismissRequest) {
        LazyColumn(contentPadding = PaddingValues(24.dp)) {
            item { Text(stringResource(R.string.source_transparency_title), style = MaterialTheme.typography.titleLarge) }
            item { Text(stringResource(R.string.source_transparency_intro)) }
            // News section
            // Research section
            // Organized section
            // Limits section
        }
    }
}
```

Keep sections compact and source names scannable.

**Step 3: Add News entry point**

In `NewsScreen`, add local sheet state:

```kotlin
var showSourceTransparency by rememberSaveable { mutableStateOf(false) }
```

Add an `IconButton` with `Icons.Outlined.Info` in the header row. When pressed, show `SourceTransparencySheet`.

**Step 4: Add Research entry point**

Repeat the same shared sheet state and info icon in `ResearchScreen`.

**Step 5: Build to verify Compose/resources**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: BUILD SUCCESSFUL.

**Step 6: Commit**

```bash
git add android/app/build.gradle.kts android/app/src/main/java/com/crisismap/app/ui/shared/SourceTransparencySheet.kt android/app/src/main/java/com/crisismap/app/ui/news/NewsScreen.kt android/app/src/main/java/com/crisismap/app/ui/research/ResearchScreen.kt
git commit -m "feat(android): show source transparency sheet"
```

### Task 6: Full Verification and Emulator Deployment

**Files:**
- All Android files touched in this plan.

**Step 1: Run unit tests**

Run:

```bash
cd android
./gradlew :app:testDebugUnitTest
```

Expected: all unit tests pass.

**Step 2: Build debug APK**

Run:

```bash
cd android
./gradlew :app:assembleDebug
```

Expected: BUILD SUCCESSFUL.

**Step 3: Deploy to emulator**

Use the currently running Android emulator:

```bash
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb install -r android/app/build/outputs/apk/debug/app-debug.apk
/Users/fanghuaian/Library/Android/sdk/platform-tools/adb shell monkey -p net.strataperture.StratAperture 1
```

Expected: app launches.

**Step 4: Manual checks**

Verify:

- News page opens.
- News source rows show source counts and source metadata summaries.
- News info icon opens the transparency sheet.
- Research page opens.
- Research info icon opens the same transparency sheet.
- Chinese emulator locale shows Traditional Chinese UI strings.

**Step 5: Final status**

Run:

```bash
git status -sb
```

Expected: clean except for intentionally ignored or user-owned files.
