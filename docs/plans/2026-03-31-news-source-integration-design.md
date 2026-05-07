# News Source Integration Design

Date: 2026-03-31
Status: Approved
Project: CrisisMap iOS

## Goal

Build a dedicated `News` data pipeline for the iOS app so the `News` tab uses its own curated news-source aggregation flow instead of reusing the generic `/api/events` feed.

## Product Decisions (Approved)

1. `News` integration is dedicated to the `News` tab only.
2. `Map`, `Feed`, and `Dashboard` remain on the existing `/api/events` API flow.
3. `News` v1 includes editorial/news-like sources only.
4. `News` v1 sources are `RSS`, `GDELT`, and `X/Grok`.
5. `USGS`, `Polymarket`, `Yahoo Finance`, `NASA FIRMS`, `Safe Airspace`, and `ACLED` are out of scope for `News` v1 and treated as second-level signals.
6. All `News` sources normalize into the existing `CrisisEvent` model.
7. Existing News clustering, mention dedup, and mention-index scoring are kept.
8. `News` content remains source-language/original text in v1.
9. App UI remains localized, but app-side news translation is out of scope.
10. `News` needs offline/stale fallback using the last successful normalized batch.

## Current State

- `EventsViewModel` fetches `/api/events` and powers `Map`, `Feed`, and `Dashboard`.
- `NewsViewModel` currently depends on `EventsViewModel.events`.
- The iOS app already has:
  - rule-based `NewsClusteringEngine`
  - `MentionStore`
  - `MentionIndexCalculator`
  - `NewsPrecomputeScheduler`
- The reference web project in `~/Documents/Projects/_crisismap` already contains source implementations for:
  - RSS aggregation
  - GDELT
  - X/Grok

## Scope

### In Scope

- Add a dedicated iOS-side `News` source layer.
- Port or adapt source logic from `_crisismap` for `RSS`, `GDELT`, and `X/Grok`.
- Normalize source output to `[CrisisEvent]`.
- Add a `NewsSourceAggregator` with fault isolation, per-source timeout, deduplication, sorting, and limit handling.
- Refactor `NewsViewModel` to fetch from the new `News` source pipeline.
- Add cached fallback for the last successful normalized `News` batch.
- Keep existing cluster/mention/index logic as the downstream ranking layer.

### Out of Scope

- Replacing the main app event pipeline.
- Merging `News` and `Research`.
- Adding app-side translation of source content.
- Source weighting or confidence scoring.
- Blending in non-news signals such as markets, disaster sensors, or structured conflict datasets.
- Server-side APIs for the new `News` flow.

## Architecture

### High-Level Split

The app will have two independent content pipelines:

1. Existing event pipeline
   - `APIClient.fetchEvents()`
   - `EventsViewModel`
   - `Map` / `Feed` / `Dashboard`

2. New News pipeline
   - `News` sources in iOS
   - `NewsSourceAggregator`
   - `NewsViewModel`
   - existing cluster / mention / score flow
   - `News` tab only

This keeps the new work isolated and avoids regressions in the existing tabs.

### Proposed Components

- `ios/CrisisMap/Services/NewsSources/NewsDataSource.swift`
  - shared protocol for News-only sources
- `ios/CrisisMap/Services/NewsSources/NewsSourceAggregator.swift`
  - orchestrates all enabled sources
- `ios/CrisisMap/Services/NewsSources/RSSNewsSource.swift`
- `ios/CrisisMap/Services/NewsSources/GDELTNewsSource.swift`
- `ios/CrisisMap/Services/NewsSources/XNewsSource.swift`
- `ios/CrisisMap/Services/NewsSources/NewsBatchCache.swift`
  - read/write stale fallback batch
- `ios/CrisisMap/Models/CachedNewsBatch.swift`
  - SwiftData storage for normalized batch payload

## Data Model

### Normalized Event Output

Each News source returns `CrisisEvent` so the downstream News stack can stay unchanged.

Required fields:

- `id`
- `title`
- `summary`
- `category`
- `level`
- `timestamp`
- `source`
- `sourceTier`

Optional fields:

- `location`
- `url`
- `actor`
- `entities`

### Source Identity Rules

Source labels must be stable so mention dedup by `source + clusterId` remains meaningful.

Examples:

- `Reuters`
- `AP News`
- `BBC News`
- `NHK World`
- `Al Jazeera`
- `GDELT`
- `x:@DeItaone`

### Cached Batch

`CachedNewsBatch` stores:

- `key`
- `fetchedAt`
- `payload`

`payload` is the encoded normalized `[CrisisEvent]` batch from the most recent successful refresh.

This cache is only for stale fallback, not historical analytics.

## Source Strategy

### RSS

Initial feeds:

- Reuters world
- AP world news
- BBC world
- NHK world
- Al Jazeera

Behavior:

- fetch feeds in parallel
- parse RSS/Atom
- strip HTML from summaries
- filter to geopolitical/crisis-relevant items
- infer `category`, `level`, and `location` with the existing heuristic style from `_crisismap`

### GDELT

Behavior:

- use article list endpoint
- query for crisis/geopolitical topics
- map returned articles into `CrisisEvent`
- infer `category`, `level`, and `location`

### X/Grok

Behavior:

- only enable when `X_BEARER_TOKEN` or `XAI_API_KEY` exists
- prefer X API recent search
- fallback to Grok `x_search`
- treat this as supplementary fast-moving signal, not the sole ranking basis

## Aggregation Rules

`NewsSourceAggregator` should mirror the fault-isolated pattern already used in the web project:

- run all enabled sources in parallel
- apply a timeout per source
- if one source fails, return partial results from the rest
- deduplicate by normalized event `id`
- sort descending by `timestamp`
- enforce a max event count

Default v1 targets:

- source timeout: `10s`
- overall per-refresh limit: `100-200` events

## News ViewModel Refactor

`NewsViewModel` should stop consuming `EventsViewModel.events`.

New flow:

1. `NewsView` requests `newsVM.refresh()`
2. `NewsViewModel` asks the News aggregator for normalized events
3. on success:
   - save normalized batch to cache
   - cluster events
   - update mention store
   - compute mention scores
   - persist next snapshot
4. on failure:
   - try cached normalized batch
   - if cache exists, rebuild clusters from cache and mark stale/offline
   - if no cache exists, surface `News Unavailable`

## Offline and Stale Behavior

### Success Path

- fresh data replaces current cluster list
- batch cache is updated
- stale state is cleared

### Fallback Path

If live fetch fails but cached normalized News exists:

- decode cached batch
- rebuild ranked clusters locally
- show stale/offline state without blocking the tab

### Hard Failure Path

If both live fetch and cache fail:

- keep empty state
- show blocking unavailable message

## Error Handling

- Source-level failure: log and continue.
- Source parsing failure: treat as empty for that source.
- Missing optional auth (`X_BEARER_TOKEN`, `XAI_API_KEY`): source disabled, not an error.
- Cache decode failure: discard cache and continue with live path.
- Mention/index failure after fetch success: show error and preserve last rendered clusters if possible.

## Testing Strategy

### Unit Tests

- RSS item mapping to `CrisisEvent`
- GDELT article mapping to `CrisisEvent`
- X/Grok tweet mapping to `CrisisEvent`
- stable source labels
- aggregator deduplicates repeated IDs
- aggregator survives partial source failure
- cache round-trip encode/decode

### ViewModel Tests

- `refresh()` uses provider output to produce ranked clusters
- failed live refresh falls back to cached batch
- no cache + failed refresh surfaces unavailable state

### Regression Tests

- existing News cluster tests continue to pass
- `Map`, `Feed`, `Dashboard`, and `Research` are unaffected

## Migration Notes

- Main event pipeline remains unchanged.
- Existing `News` UI remains in place and only changes its data source.
- Existing mention/snapshot persistence remains valid.
- New cache model is additive.

## Open Follow-Ups

1. Add server-side translation if localized News text becomes a product requirement.
2. Add second-level corroboration signals in a later ranking layer rather than mixing them into v1 source ingestion.
3. Consider source weighting only after baseline source quality is validated in production.
