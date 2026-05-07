# News Mention Index v1 Design

Date: 2026-03-18
Status: Approved
Project: CrisisMap iOS

## Goal

Build a dedicated `News` tab to improve situation awareness by surfacing major events using a configurable, rule-based event clustering system and a decayed `Mention Index`.

## Product Decisions (Approved)

1. `News` is an independent tab (not merged into `Research`).
2. Primary signal is `major events`.
3. Event identity uses `rule-based coarse-grained clustering`.
4. Mention counting is deduplicated by `source + cluster` (no daily reset).
5. Mention index uses exponential decay with configurable half-life.
6. Default half-life is `180 days`.
7. Index values are `precomputed` and scheduled for next local midnight.
8. Scheduling default is `daily 00:00` in device local timezone.
9. All current event/news sources are included with equal weight in v1.
10. Clustering rules must be driven by an editable config file.
11. No sensor fusion in v1.

## Scope

### In Scope

- Add new `News` tab in iOS app.
- Add rule-config based clustering engine.
- Add mention dedup store for `source + cluster` pairs.
- Add decayed mention scoring with parameterized half-life.
- Add snapshot precompute job for next local midnight.
- Add UI for top clusters, region/topic filters, and cluster detail list.

### Out of Scope

- Source weighting model.
- ML/embedding/LLM clustering.
- Cross-tab fusion between Research and News.
- Server-side index pipeline.

## Data Model

### Cluster Rules (config file)

Create a JSON rules file under app resources, for example:

`ios/CrisisMap/Resources/ClusterRules/news-cluster-rules.v1.json`

Each rule contains:

- `clusterId`: stable identifier (e.g. `russia-ukraine-war`)
- `label`: user-facing title
- `priority`: integer for deterministic first-match behavior
- `keywordsAny`: list of keywords (title/summary/entity/source matching)
- `keywordsAll`: optional list requiring all matched
- `regions`: region tags (existing Region model values)
- `topics`: semantic tags for searching/filtering

### Mention Records (persistent)

Persist one record per unique mention key:

- mention key: `source + clusterId`
- fields: `firstSeenAt`, `lastSeenAt`, optional `sampleEventId`

This guarantees repeated reporting by the same source does not inflate mentions.

### Precomputed Snapshot (persistent)

Store score snapshot for scheduled display:

- `asOf`: target timestamp (next local midnight)
- `halfLifeDays`
- per cluster:
  - `clusterId`
  - `score`
  - `sourceCount`
  - `lastMentionAt`

## Core Algorithms

### 1) Rule-based clustering

For each `CrisisEvent`:

1. Normalize text fields (title, summary, source, entities).
2. Evaluate rules in ascending `priority`.
3. Pick first matching rule (deterministic).
4. If no rule matches, place in fallback cluster (`unclassified`).

Matching policy:

- `keywordsAny`: at least one token match
- `keywordsAll`: all tokens match (if provided)
- optional country/location boost only in deterministic rules (no fuzzy ML)

### 2) Mention dedup

Given clustered event `(clusterId, source)`:

- if mention key not present: insert mention record
- if present: update `lastSeenAt`, do not increment source count

### 3) Mention Index with decay

For each unique mention record in a cluster, compute weight at time `t`:

`weight = 2^(-ageDays / halfLifeDays)`

Where `ageDays = max(0, (t - firstSeenAt) / 86400)`.

Cluster score:

`clusterScore = sum(weight for all unique source mentions in cluster)`

Defaults:

- `halfLifeDays = 180`

Parameters are configurable for future tuning.

### 4) Precompute schedule

On app open:

1. compute immediate score set for current display.
2. compute and persist snapshot for next local midnight.

On later app open:

- if cached snapshot is valid for required view time, use it.
- otherwise refresh current score and precompute next midnight again.

## UI Design (News Tab)

### Information hierarchy

1. `Top Clusters` (major events sorted by mention index descending)
2. Filters (`Region`, `Topic`, optional search text)
3. Cluster detail (article/event list, sources, recency)

### Cluster card content

- `label`
- `mention index score`
- `distinct source count`
- `mapped regions/topics`
- `last mention time`

### Interaction

- Tap cluster opens detail view with matched events/news entries.
- Topic and region filters refine same cluster set.

## Error Handling

- Rule file load failure: fallback to `unclassified` cluster and show non-blocking warning.
- Event fetch failure: use cache and mark data as stale/offline.
- Snapshot compute failure: keep immediate calculation path; do not block rendering.

## Verification Strategy

1. Unit tests
- deterministic rule matching
- mention dedup behavior (`source + cluster` uniqueness)
- decay formula correctness and parameter effect
- next-local-midnight scheduler correctness

2. Integration tests
- fixed event fixtures produce stable cluster ranking
- filter by region/topic produces deterministic subsets

3. UI smoke
- News tab loads
- top clusters list renders
- detail navigation works

## Migration / Backward Compatibility

- Existing Map/Feed/Dashboard/Research paths unchanged.
- New models are additive.
- Existing cached weekly research data remains untouched.
