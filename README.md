# CrisisMap

Real-time geopolitical crisis intelligence dashboard with deep-dive think tank research.

## Overview

CrisisMap is a dual-platform intelligence tool:

- **Web Dashboard** (Next.js) — Real-time crisis event monitoring with interactive map, event feed, market indicators, prediction markets, and key actor tracking. Aggregates 12 data sources with 30-second polling.
- **iOS App** (SwiftUI) — Native mobile client consuming the same data, plus a dedicated Research tab for browsing think tank analysis by region and topic.

## Features

### Real-time Crisis Monitoring (Web + iOS)

- **Interactive Map** — Events plotted by location with threat-level color coding (critical/high/medium/low/info). Click for details.
- **Event Feed** — Filterable, searchable list of events from 12 sources (USGS, GDELT, Reuters, AP, BBC, NHK, Al Jazeera, ACLED, Polymarket, Yahoo Finance, NASA FIRMS, Safe Airspace, X/Grok).
- **Dashboard** — Threat overview charts, category breakdown, market indicators (WTI, Gold, BTC), prediction markets, key actor status.
- **Filters** — By region (Middle East, Europe, East Asia, Africa, Americas), event category, threat level, search text.
- **Bilingual** — English and Traditional Chinese (zh-TW) with timezone-aware formatting.

### Think Tank Research (iOS)

Browse deep-dive analysis from major think tanks, organized by geographic region and topic.

- **Data Source** — Weekly article collections from RAND, CSIS, Brookings, CFR, Chatham House, Heritage, IISS, Mitchell, CATO, hosted on Cloudflare.
- **Region-based Navigation** — Select a region (East Asia, Middle East, Europe, Africa, Americas) to see relevant research.
- **Topic Drill-down** — Within each region, browse by topic (AI, China, Taiwan, Ukraine, NATO, Trade, etc.).
- **Smart Matching** — Articles matched to regions via both `category` field (e.g., `china_indopacific`) and `topics` array (e.g., `["China", "Taiwan"]`).
- **Offline Cache** — SwiftData-backed incremental caching. Only fetches new/updated weeks. Works offline with cached data.

#### Data Format

Weekly JSON files at `https://thinktankbriefdata.strataperture.net/2026/`:

```
GET /weeks.json              → { weeks: [{ week, uploaded }] }
GET /2026-W10.json           → { week, start_date, end_date, generated_at, articles: [...] }
```

Each article:
```json
{
  "id": "7fedfa2c",
  "think_tank": "RAND",
  "title": "Article title",
  "url": "https://...",
  "date": "2026-03-05",
  "summary": "Article summary...",
  "category": "defense",
  "status": "reviewed",
  "topics": ["AI", "China", "Taiwan"]
}
```

Categories: defense, diplomacy, economy, tech, society, energy, health, china_indopacific, europe, middle_east, africa, americas.

Topics: AI, China, Climate, Cybersecurity, Europe, Indo-Pacific, Middle East, NATO, Nuclear, Russia, Taiwan, Trade, Ukraine, United States.

## News Source Design (iOS)

The iOS `News` tab now uses a dedicated source pipeline instead of reusing `/api/events`.

- **Scope** — `News` is a first-level editorial surface focused on fast-moving geopolitical headlines. Second-level signals such as markets, FIRMS, or aviation risk stay in their own app surfaces.
- **V1 Sources** — `RSS` (Reuters, AP, BBC, NHK, Al Jazeera), `GDELT`, and `X/Grok`.
- **Normalization Target** — Every source is normalized into the existing `CrisisEvent` model so the app can reuse the same threat/category vocabulary.
- **Aggregation Rules** — Enabled sources run concurrently with per-source fault isolation and timeout handling. Results are deduplicated by normalized event ID, sorted newest-first, and trimmed to a bounded batch size.
- **Ranking Pipeline** — The normalized batch is fed into the existing clustering, mention deduplication, and mention-index scoring stack that powers News cluster ranking.
- **Offline / Stale Fallback** — The last successful normalized batch is cached in SwiftData as `CachedNewsBatch`. If live fetch fails, the app rebuilds News clusters from cache and marks the tab as offline instead of hard-failing immediately.

At a code level, this pipeline lives under `ios/CrisisMap/Services/NewsSources/` and flows through `NewsSourceAggregator -> NewsViewModel -> NewsView`.

## Architecture

### Web (Next.js 15)

```
12 DataSources -> aggregator.ts (Promise.allSettled, 10s timeout)
    -> deduplicate -> sort -> cache 30s
    -> API routes (/api/events, /api/markets, /api/actors, /api/indicators)
    -> SWR hooks (auto-poll) -> Zustand stores -> React components
```

### iOS (SwiftUI + Swift 6)

```
CrisisMap/
├── App/                    # @main entry, TabView (Map, Feed, Dashboard, Research)
├── Models/                 # Codable structs + SwiftData models
├── Services/               # APIClient (URLSession actor)
├── ViewModels/             # @Observable classes with polling
├── Views/
│   ├── Map/                # MapKit with event annotations
│   ├── Feed/               # Searchable event list
│   ├── Charts/             # Swift Charts dashboard
│   ├── Research/           # Think tank browsing (Region -> Topic -> Articles)
│   └── Shared/             # ThreatBadge, CategoryIcon, LiveIndicator, etc.
└── Utilities/              # Color theme, formatters
```

## Setup

### Web

```bash
npm install
npm run dev          # Dev server on port 3000
npm run build        # Production build
npm run lint         # ESLint
```

Environment variables (all optional — public sources work with zero config):

| Variable | Purpose |
|----------|---------|
| `FIRMS_MAP_KEY` | NASA FIRMS satellite fire data |
| `ACLED_API_KEY` + `ACLED_EMAIL` | Armed conflict events |
| `X_BEARER_TOKEN` | X API v2 direct search |
| `XAI_API_KEY` | Grok API fallback for X data |
| `GOOGLE_API_KEY` | Gemini Flash for zh-TW translation |
| `TELEGRAM_BOT_TOKEN` + `TELEGRAM_CHAT_ID` | Notifications |

### iOS

1. Open `iOS/CrisisMap.xcodeproj` in Xcode 16+
2. Set API base URL in scheme settings (default: `http://localhost:3000`)
3. Build and run on iOS 17+ simulator or device
4. For Research tab data: no configuration needed (fetches from Cloudflare automatically)

## License

All rights reserved.
