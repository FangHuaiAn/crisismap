# Research Tab — Think Tank Briefings by Region

## Overview

Add a fourth tab ("Research") to the CrisisMap iOS app that lets users browse think tank articles by geographic region and topic. Data is hosted on Cloudflare as static JSON, cached locally with SwiftData for offline access and incremental updates.

**Goal:** Complement the real-time crisis feed with deep-dive research from think tanks (RAND, CSIS, Brookings, etc.), organized geographically.

## Data Source

- **Base URL:** `https://thinktankbriefdata.strataperture.net/2026`
- **Week index:** `GET /weeks.json` → `{ weeks: [{ week, uploaded }] }`
- **Weekly data:** `GET /2026-W10.json` → `{ week, start_date, end_date, generated_at, articles: [...] }`
- **Article fields:** `id, think_tank, title, url, date, summary, category, status, topics`

## Data Models

### Swift Structs

```swift
struct ThinkTankArticle: Codable, Identifiable {
    let id: String
    let thinkTank: String
    let title: String
    let url: String
    let date: String
    let summary: String
    let category: String
    let status: String
    let topics: [String]
}

struct ThinkTankWeekly: Codable {
    let week: String
    let startDate: String
    let endDate: String
    let generatedAt: String
    let articles: [ThinkTankArticle]
}

struct WeekIndex: Codable {
    let weeks: [WeekEntry]
}

struct WeekEntry: Codable {
    let week: String
    let uploaded: String
}
```

### SwiftData Cache

```swift
@Model
class CachedWeekly {
    @Attribute(.unique) var week: String
    var json: Data
    var uploadedAt: String
    var fetchedAt: Date
}
```

## Region → Topic/Category Mapping

Articles match a region if `category ∈ region.categories` **OR** `topics ∩ region.topics ≠ ∅`.

| Region     | Categories          | Topics                              |
|------------|--------------------|------------------------------------|
| East Asia  | china_indopacific  | China, Taiwan, Indo-Pacific        |
| Middle East| middle_east        | Middle East                        |
| Europe     | europe             | Europe, Russia, Ukraine, NATO      |
| Africa     | africa             | (none currently in topics.json)    |
| Americas   | americas           | United States                      |
| All        | (no filter)        | (no filter)                        |

## Data Flow

```
Research Tab onAppear
  → fetchWeekIndex()
  → compare uploaded timestamps with local SwiftData CachedWeekly
  → fetch only new/updated weeks (parallel)
  → store in SwiftData
  → decode all weeks → merge into [ThinkTankArticle]
  → local region/topic filtering
```

## APIClient Extensions

```swift
// New base URL
let thinkTankBaseURL = URL(string: "https://thinktankbriefdata.strataperture.net/2026")!

// New methods
func fetchWeekIndex() async throws -> WeekIndex
func fetchWeekly(week: String) async throws -> ThinkTankWeekly
```

## ResearchViewModel

```swift
@Observable
class ResearchViewModel {
    var articles: [ThinkTankArticle] = []
    var isLoading = false
    var error: String?

    var selectedRegion: Region = .all
    var selectedTopic: String? = nil

    var regionsWithCounts: [(Region, Int)]
    var topicsForRegion: [(String, Int)]
    var filteredArticles: [ThinkTankArticle]

    func loadData() async { ... }
}
```

## UI Structure

### Tab Bar

```
Tab 1: Map       (map.fill)
Tab 2: Feed      (list.bullet)
Tab 3: Dashboard (chart.bar.fill)
Tab 4: Research  (book.fill)      ← NEW
```

### Navigation: Region → Topics → Articles

1. **RegionListView** — List of regions with article counts
2. **TopicListView(region)** — Topics within selected region with counts
3. **ArticleListView(region, topic)** — Filtered article list, sorted by date

### ArticleRow Layout

```
┌──────────────────────────────────┐
│ 🏛 RAND · defense     2026-03-05│
│ Title text bold here             │
│ Summary text secondary 2 lines   │
│ 🏷 China · Taiwan · AI          │
└──────────────────────────────────┘
```

- Tap → opens article URL in Safari
- Dark theme consistent with other tabs

## Cache Strategy

- **First launch:** Fetch all weeks in parallel, store in SwiftData
- **Subsequent launches:** Compare `uploaded` timestamps, fetch only changed weeks
- **Offline:** Read from SwiftData, show "Offline" banner
- **No expiration:** Weekly data is historical, only re-fetched if `uploaded` changes

## Error Handling

- Single week fetch failure → skip, don't block others
- All weeks fail → show error + load from local cache
- `weeks.json` failure → show error + load from local cache

## Out of Scope

- Fulltext display (tap opens Safari)
- Search within articles
- Push notifications for new articles
- Widget integration
