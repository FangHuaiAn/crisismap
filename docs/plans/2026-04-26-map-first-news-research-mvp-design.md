# Map-First News/Research MVP Design

Date: 2026-04-26

## Decision

CrisisMap MVP should focus on a map-first intelligence reader powered by built-in public news sources and static think tank research data. The app will defer costly dynamic feeds, market dashboards, actor status, and private-key sources until there is evidence of user demand.

The first map version will use region-level markers only:

- Middle East
- Europe
- East Asia
- Africa
- Americas

`All` remains a list/filter concept and should not become a map marker.

## Product Goal

The MVP should answer:

> Which geopolitical regions are receiving meaningful news and research attention right now, and what should I read to understand them?

It should not yet try to answer:

- How are markets reacting?
- Which actors changed state?
- What is the exact incident-level timeline?
- What is the authoritative severity score for each crisis?

Those questions require higher-cost data pipelines and can be revisited after the map-first reader proves useful.

## Information Flow

### News

News remains built into the mobile app for MVP cost control.

Sources:

- RSS public feeds
- GDELT public API
- X/Grok only when credentials exist; disabled by default

Flow:

1. Fetch public source batches with timeout and failure isolation.
2. Convert items into `CrisisEvent`.
3. Cluster events with existing news cluster rules and region inference.
4. Score clusters with the mention index.
5. Cache the latest successful batch locally.
6. Expose region summaries to the map.

The News tab remains the list/detail view for cluster exploration.

### Research

Research should not scrape think tank sites on device. It should consume the existing static JSON dataset:

- `https://thinktankbriefdata.strataperture.net/topics.json`
- `https://thinktankbriefdata.strataperture.net/2026/weeks.json`
- `https://thinktankbriefdata.strataperture.net/2026/{week}.json`

Flow:

1. Fetch week index and weekly static JSON.
2. Decode articles into `ThinkTankArticle`.
3. Cache weekly payloads locally.
4. Map articles to `Region` using existing category/topic mappings.
5. Expose recent region summaries to the map.

The Research tab remains the list/detail view for article exploration.

## Region Intelligence Model

Create a derived region summary model rather than treating map markers as single events.

Each summary should include:

- Region
- News cluster count
- Research article count
- Top news clusters
- Recent research articles
- Last updated timestamp
- Optional top topics
- Optional heat score

The first heat score can be simple:

```text
heat = normalized(news cluster count + recent research article count)
```

More nuanced scoring can come later.

## Map Behavior

The map should display five fixed region markers at representative coordinates.

Marker behavior:

- Size or opacity reflects region heat.
- Label shows region name and total count.
- Tap opens a region sheet.

Region sheet:

- Header: region name, news count, research count, last updated
- Section: top news clusters
- Section: recent think tank reports
- Actions: open cluster detail, open article detail or external URL

The map is the primary entry point. News and Research remain alternate list views.

## Deferred

These are explicitly out of scope for the MVP pass:

- Country/city-level markers
- Dashboard metrics backed by paid APIs
- Market data
- Actor status
- Push notifications
- Server-side aggregator
- Gemini translation
- Private API sources

## Success Criteria

- App can launch into a useful map without a running local server.
- News/Research content appears on map regions.
- Region marker tap reveals readable source material.
- Partial source failure does not empty the map if cached data exists.
- No private API key is required for the MVP experience.
