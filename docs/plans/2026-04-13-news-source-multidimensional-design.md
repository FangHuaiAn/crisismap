# News Source Multidimensional Redesign Design

Date: 2026-04-13
Status: Approved
Project: CrisisMap iOS

## Goal

Refactor the iOS `News` pipeline so source diversity is modeled and enforced across multiple dimensions instead of relying on a single display-source string.

## Product Decisions (Approved)

1. This iteration covers data-model and aggregation-rule refactoring only.
2. UI redesign and new News filters are out of scope for this iteration.
3. `NewsViewModel` and related consumers may be updated to read new source fields, but visible UI behavior should remain effectively unchanged.
4. The pipeline should keep using `CrisisEvent` as the normalized event model.
5. The source model should be upgraded by adding a nested structured descriptor rather than replacing `CrisisEvent` with a News-only event type.
6. Aggregation must account for multiple source dimensions, not only `event.source`.
7. Political or ideological balancing is out of scope because the current repo has no reliable metadata for it.

## Problem Statement

The current pipeline gives the appearance of source diversity, but most diversity logic is shallow:

- `RSS` provides multiple publishers, but all downstream logic still collapses to one display string per event.
- `GDELT` preserves domain, language, and source-country in its response model, but that metadata is dropped during normalization, so all GDELT-derived events look like a single source.
- `X` preserves handle-level display naming, but all quota logic only treats it as a source-string bucket.
- Aggregation applies only two diversity controls:
  - max share per source bucket
  - minimum distinct regions

This means the app can overstate source breadth when a single editorial ecosystem is re-surfaced through multiple collection channels.

## Architecture

### High-Level Direction

Keep the existing News flow:

`source fetch -> normalize -> aggregate -> cluster -> mention dedup -> rank`

But change normalization so every `CrisisEvent` carries a structured source descriptor. Aggregation, mention deduplication, and ranking then read structured source dimensions instead of treating `source` as the only source identity.

### Key Decision

Use a nested source model inside `CrisisEvent`, not a separate `NormalizedNewsEvent` type.

This keeps downstream reuse intact while giving the News pipeline a stable place to store attribution, outlet, language, and grouping metadata.

## Data Model

### New Nested Type

Add `NewsSourceDescriptor` to represent structured source metadata for News events.

Recommended fields:

- `displayName`
- `kind`
- `identity`
- `group`
- `attribution`
- `originalOutlet`
- `originCountry`
- `languageCode`
- `domain`
- `authorHandle`

### Supporting Enums

- `NewsSourceKind`
  - `wire`
  - `publisher`
  - `aggregator`
  - `social`
- `NewsSourceAttribution`
  - `direct`
  - `derived`

### `CrisisEvent` Compatibility

`CrisisEvent` should keep:

- `source`
- `sourceTier`

But:

- `source` becomes a compatibility/display field
- `source` should mirror `newsSource.displayName`
- new aggregation logic should read `newsSource` instead of `source`

This allows existing UI and non-updated code paths to continue compiling during the transition.

## Source Normalization Strategy

### RSS

RSS events should use direct attribution.

- `kind` should reflect the outlet class, such as `wire` or `publisher`
- `identity` should be a stable outlet ID
- `group` should usually equal the outlet identity
- `originalOutlet` and `domain` should reflect the feed publisher

### GDELT

GDELT events should preserve both collection-channel identity and underlying outlet metadata.

- `kind = aggregator`
- `attribution = derived`
- `displayName` may remain human-readable, but should not be the only downstream identifier
- `originalOutlet`, `domain`, `languageCode`, and `originCountry` must be retained when available
- `identity` should distinguish the derived outlet when possible, for example a stable `gdelt:<domain>` shape

This is the main fix for false source diversity.

### X / Grok

X-derived events should model both handle-level identity and platform grouping.

- `kind = social`
- `group = x`
- `identity` should be stable per handle where possible
- `authorHandle` should remain available for downstream display and future filtering

## Aggregation Rules

### Current State

Current diversity controls are:

- source-share limit
- region floor

### New State

Aggregation should apply multi-dimensional quota logic.

Recommended controls:

- `maxGroupShare`
- `maxKindShare`
- `maxDerivedShare`
- `minDistinctRegions`

### Selection Order

1. Collect all enabled-source results.
2. Sort newest-first.
3. Apply exact event-ID deduplication.
4. Apply near-duplicate collapse across collection channels when possible.
5. Apply hard quotas for:
   - source group
   - source kind
   - attribution mode
6. Backfill missing diversity dimensions in this order:
   - region
   - source kind
   - attribution mode
7. Fill remaining slots by freshness using overflow items.

### Why This Works

This prevents:

- social posts dominating the feed because they are individually labeled
- GDELT counting as a fake independent outlet for every article
- one publisher or one channel occupying a disproportionate share of the News surface

## Mention Deduplication and Ranking

The current ranking logic treats distinct source strings as distinct confirming mentions.

That should be updated so mention identity is based on structured source dimensions:

- prefer `newsSource.identity` or `newsSource.group`
- do not let derived-attribution mentions count the same way as direct-attribution confirmations

Recommended behavior:

- keep mention dedup keyed by cluster plus stable source identity
- add a lighter weight for derived mentions so GDELT does not inflate cluster confidence

This preserves the existing ranking model while making confirmations more honest.

## Deduplication

### Keep

- exact dedup by `event.id`

### Add

- deterministic cross-channel near-duplicate dedup using normalized title and canonicalized URL/domain information when available

This should remain conservative. The purpose is to collapse obvious duplicates between direct publisher feeds and aggregator-resurfaced copies, not to infer semantic equivalence from loose text similarity.

## Testing Strategy

This redesign needs test coverage in five areas:

1. source normalization
2. multidimensional quota behavior
3. backfill behavior
4. GDELT derived-source preservation
5. mention scoring with direct versus derived attribution

## Scope

### In Scope

- `NewsSourceDescriptor` and supporting enums
- `CrisisEvent` compatibility updates
- RSS, GDELT, and X normalization changes
- multidimensional aggregation rules
- mention identity and weighting updates
- test updates and new regression coverage

### Out of Scope

- UI redesign
- user-facing source filters
- political slant balancing
- adding new News source adapters
- changing non-News event pipelines

## Expected Outcome

After this redesign:

- source diversity will be represented as structured metadata instead of a flat label
- News aggregation will enforce diversity across outlet grouping, source type, attribution mode, and region
- GDELT will stop acting like a fake monolithic source
- downstream cluster ranking will better reflect genuine multi-source confirmation
