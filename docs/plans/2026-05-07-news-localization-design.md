# News Localization Design

Date: 2026-05-07
Status: Draft / Direction Approved
Project: CrisisMap iOS

## Goal

Improve the `News` tab for Traditional Chinese users by localizing the News UI and adding localized display text for news titles and summaries, while preserving original source text for clustering, ranking, deduplication, attribution, and auditability.

## Product Rationale

The `News` tab is the app's fast-scanning crisis intelligence surface. If the user cannot quickly read the headline, summary, source quality, and signal metadata, the tab fails at its main job even if the data pipeline is technically correct.

Traditional Chinese localization is especially important for CrisisMap because several high-value use cases are Taiwan- and East Asia-adjacent:

- monitoring Taiwan Strait, China, Japan, Korea, and Indo-Pacific events
- scanning English-language wires and aggregators from a Chinese-language operating context
- supporting policy, security, investment, and research workflows where speed matters

The product value is not "translate every article perfectly." The product value is "make the crisis feed understandable at scan speed, without hiding the original source."

## Product Decisions

1. Ship Traditional Chinese News experience first.
2. Design the data path so additional locales can be added later.
3. Localize the News UI before translating dynamic news content.
4. Translate only display copies of news `title` and `summary`.
5. Preserve original `CrisisEvent.title` and `CrisisEvent.summary` for all source-of-truth logic.
6. Always allow fallback to original source text when translation is unavailable.
7. Keep source names, domains, URLs, author handles, and source attribution unmodified.
8. Do not change source ranking, threat scoring, clustering, or mention scoring in this feature.
9. Do not add client-side provider API keys to the app.
10. Treat full multi-language rollout as a later product decision after Traditional Chinese quality is validated.

## Scope

### In Scope

- Localize hard-coded News UI strings through `Localizable.xcstrings`.
- Add localizable labels for News source metadata:
  - direct / derived
  - wire / publisher / aggregator / social
  - source count
  - mention index
  - distinct sources
  - attribution mix
  - source types
  - recent events
  - empty, offline, and error states
- Add a localized display model for dynamic news title and summary text.
- Add translation cache keyed by event content hash and target locale.
- Add server-side translation boundary or service abstraction for future provider integration.
- Show original text when translated text is missing, stale, or failed.
- Preserve search behavior by searching both localized display text and original text when available.
- Add tests for UI string coverage, localized display fallback, cache identity, and view-model behavior.

### Out of Scope

- Translating full article bodies.
- Translating source names, outlet names, domains, URLs, handles, or publication names.
- Rewriting `CrisisEvent` into a locale-specific event type.
- Changing RSS, GDELT, or X/Grok source selection.
- Changing News clustering, scoring, source diversity, or mention weighting.
- Shipping multiple target languages beyond Traditional Chinese in the first implementation.
- Building a user-facing language picker if the app can rely on system locale for the first release.

## Current State

The iOS app already has app-wide localization support through `Localizable.xcstrings`, with English as the source language and Traditional Chinese entries for many existing keys.

The News tab is only partially localized. Several user-facing strings are still hard-coded in SwiftUI views and view-model presentation helpers. Examples include:

- `News`
- `News Unavailable`
- `No Clusters`
- `Search clusters`
- `All Topics`
- `Showing cached news while live sources are unavailable.`
- `Mention Index`
- `Distinct Sources`
- `Attribution Mix`
- `Source Types`
- `Recent Events`
- `Direct`, `Derived`
- `Wire`, `Publisher`, `Aggregator`, `Social`
- `sources`

Dynamic news content remains source-language/original text. That was an explicit v1 product decision for the dedicated News pipeline, with server-side translation listed as a future follow-up if localized News text became a product requirement.

The current `CrisisEvent` model stores only one `title` and one `summary`. Those fields are read by:

- News clustering
- location inference
- region inference
- threat/category heuristics
- deduplication
- search
- UI display

Because these fields drive both machine logic and human display, directly replacing them with translated text would create avoidable correctness risk.

## Architecture

### High-Level Direction

Keep the existing News source-of-truth flow:

`source fetch -> normalize CrisisEvent -> aggregate -> cluster -> mention dedup -> rank -> display`

Add localization after source normalization and ranking:

`ranked News clusters -> localized display resolution -> SwiftUI rendering`

This keeps translation in the presentation layer. The app can show localized content without changing the data that clustering, ranking, and audit paths depend on.

### Recommended Component Split

- `NewsLocalizedContent`
  - value type representing localized display copies for an event
- `NewsLocalizationService`
  - protocol used by `NewsViewModel` or a presentation adapter to request localized copies
- `NewsLocalizationCache`
  - cache for translated title/summary by locale and content hash
- `NewsLocalizedEventDisplay`
  - lightweight view data that chooses translated text when available and original text as fallback
- `NewsSourcePresentation`
  - continue handling source metadata presentation, but return localized labels

The first implementation can keep the service as an app-side abstraction with fixture/no-op behavior until the server-side translation endpoint exists. That lets UI and model boundaries land without committing to one translation provider too early.

## Data Model

### Preserve `CrisisEvent`

Do not replace or mutate:

- `CrisisEvent.title`
- `CrisisEvent.summary`
- `CrisisEvent.source`
- `CrisisEvent.newsSource`

Those fields remain the original normalized source record.

### Add Localized Display Content

Recommended shape:

```swift
struct NewsLocalizedContent: Codable, Sendable, Equatable {
    let eventId: String
    let localeIdentifier: String
    let sourceTitleHash: String
    let sourceSummaryHash: String
    let title: String
    let summary: String
    let provider: String?
    let translatedAt: Date
}
```

The content hash is important because event IDs can remain stable while source text changes or corrections arrive.

### Add Display View Data

Recommended shape:

```swift
struct NewsLocalizedEventDisplay: Sendable, Equatable {
    let event: CrisisEvent
    let localizedContent: NewsLocalizedContent?

    var displayTitle: String {
        guard let title = localizedContent?.title, !title.isEmpty else {
            return event.title
        }
        return title
    }

    var displaySummary: String {
        guard let summary = localizedContent?.summary, !summary.isEmpty else {
            return event.summary
        }
        return summary
    }

    var hasLocalizedContent: Bool {
        localizedContent != nil
    }
}
```

## Data Flow

### Refresh Flow

1. `NewsViewModel.refresh()` fetches and ranks News events as it does today.
2. The view model or presentation adapter identifies events visible in the current cluster list.
3. For each visible event, request localized content for the current target locale.
4. The localization service checks local cache first.
5. Cache misses are translated through a server-side endpoint or deferred provider.
6. Results are saved to cache.
7. Views render translated title/summary when available and original text otherwise.

### Search Flow

Search should include both original and localized text:

- cluster label
- topic labels
- source names
- original event title/summary
- localized event title/summary when available

This prevents a Chinese query from only matching translated rows and an English query from only matching original rows.

### Offline Flow

If live News fetch fails but cached News batches exist, the existing stale/offline path remains valid.

If translation fetch fails:

- keep rendering original event text
- do not fail the News tab
- optionally show no banner unless the product later wants a subtle "some translations unavailable" state

Translation failure is a display degradation, not a data failure.

## Translation Boundary

Translation should be server-side or mediated through an app-owned backend boundary. The iOS app should not store provider keys.

The request should send only the minimum required data:

- event ID
- title
- summary
- source language when known
- target locale
- optional domain context such as geopolitical/security terminology

The response should return:

- translated title
- translated summary
- provider metadata
- source content hashes
- translation timestamp

The provider prompt or translation instruction should preserve:

- proper nouns
- source names
- military unit names
- official organization names
- treaty names
- quoted statements where mistranslation would be risky

## Localization Policy

### UI Labels

All News UI strings should use explicit localization keys, not implicit English source strings. Recommended prefix:

- `news.title`
- `news.search`
- `news.empty.title`
- `news.empty.description`
- `news.error.unavailable`
- `news.offline.cached`
- `news.topic.all`
- `news.signal.section`
- `news.signal.mentionIndex`
- `news.signal.distinctSources`
- `news.signal.attributionMix`
- `news.signal.sourceTypes`
- `news.events.recent`
- `news.sources.count`
- `news.source.attribution.direct`
- `news.source.attribution.derived`
- `news.source.kind.wire`
- `news.source.kind.publisher`
- `news.source.kind.aggregator`
- `news.source.kind.social`

### Dynamic Cluster Labels and Topics

Cluster labels and topics come from rule configuration and are currently English-first. For this feature:

- UI can continue displaying existing cluster labels in English for MVP if needed.
- Prefer adding optional localized labels to cluster rules in a follow-up.
- Do not block title/summary translation on full cluster taxonomy localization.

### Original Text Access

Cluster detail should continue to expose original text in one of these ways:

- show translated title/summary as primary and original text as secondary expandable content
- or show translated text with a compact "Original" disclosure row

The first implementation can start with translated primary display and original fallback only, but the design should leave room for explicit original-text reveal.

## Project Management View

### Phase 1: News UI Localization

Deliverables:

- replace hard-coded News UI strings with localization keys
- add English and Traditional Chinese values
- localize source metadata chips and source summaries
- verify News tab under English and Traditional Chinese app locales

Risk: low.

### Phase 2: Localized News Display Model

Deliverables:

- add localized content model
- add no-op/cache-first localization service protocol
- add view-model or presentation adapter fallback behavior
- search original and localized text
- test fallback and cache identity

Risk: medium-low.

### Phase 3: Translation Provider Boundary

Deliverables:

- add server-side translation endpoint or backend adapter
- add batching
- add cache TTL / invalidation policy
- add provider failure handling
- validate translation quality on high-risk geopolitical terms

Risk: medium.

### Phase 4: Multi-Locale Expansion

Deliverables:

- decide next target locales based on users
- add localized cluster labels/topics
- add product QA process per locale
- consider language picker only if system locale is insufficient

Risk: medium-high because QA and terminology consistency scale by locale.

## Technical Feasibility

### Easy

- localizing hard-coded News UI strings
- localizing source metadata labels
- preserving original text as fallback
- adding cache keys based on event ID, locale, and content hash

### Moderate

- integrating localized display data into `NewsViewModel` without making it too stateful
- making search work well across original and localized text
- adding a server-side translation boundary
- batching translation requests to control latency and cost

### Hard / Risky

- translating full article bodies
- supporting many languages immediately
- changing clustering/scoring to operate on translated text
- guaranteeing terminology quality without review data

## Testing Strategy

### Unit Tests

- `NewsLocalizedContent` cache key changes when title or summary changes.
- localized display falls back to original title/summary when translation is missing.
- localized display uses translated title/summary when available.
- source metadata presentation returns localized direct/derived/kind labels.
- News search matches original text.
- News search matches localized text.

### ViewModel Tests

- refresh succeeds when translation service fails.
- offline News batch still renders when translation cache is empty.
- changing locale requests a different localized content key.

### UI / Snapshot Checks

- News list in English locale has no accidental Traditional Chinese UI labels.
- News list in Traditional Chinese locale has no obvious hard-coded English UI labels except source names and original news content.
- long Traditional Chinese headlines wrap cleanly in `ClusterRow` and `ClusterDetailView`.

### Manual QA

Use a small fixed set of events containing:

- Taiwan Strait military headline
- Middle East conflict headline
- economic sanctions headline
- GDELT-derived source
- X/social post
- missing translation
- failed translation provider response

## Error Handling

- Translation service failure must not set `NewsViewModel.error`.
- Translation failure should not clear clusters.
- Translation cache decode failure should evict or ignore the bad localized entry.
- Server timeout should fall back to original text.
- If translated text is empty, use original text.
- If only title is translated, use translated title and original summary.

## Privacy, Cost, and Compliance

News translation sends source text to a provider, so the app should avoid sending unnecessary user data. Requests should not include device identifiers, user identity, or unrelated cached content.

Cost should be controlled by:

- translating only visible or recently ranked events
- batching requests
- caching by content hash
- avoiding retranslating unchanged source text
- capping translations per refresh

Because news publishers may have usage constraints, the feature should translate snippets already used in the app, not scrape or translate full article bodies.

## Success Metrics

- News UI string coverage reaches practical completeness in Traditional Chinese.
- News tab remains usable when translation is unavailable.
- Median News refresh does not materially regress after translation is enabled.
- Translation cache hit rate improves after repeated refreshes.
- Users can scan critical/high events in Traditional Chinese without opening the original source.
- No known ranking, clustering, or deduplication regression is introduced.

## Open Questions

1. Should Phase 1 rely on system locale only, or should the app expose an explicit language override?
2. Should translated News display be enabled by default for `zh-Hant-TW`, or behind a setting/feature flag first?
3. Which backend should own the server-side translation endpoint?
4. Which provider should be used for the first translation implementation?
5. Should cluster rule labels and topic names be localized in Phase 2 or deferred to Phase 4?

## Recommended Next Step

Create an implementation plan that starts with Phase 1 UI localization, then adds the localized display model behind a no-op translation service. This produces user-visible improvement immediately while preparing the architecture for server-side translation without risking the current News ranking pipeline.
