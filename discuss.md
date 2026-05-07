# Discussion Summary

Date: 2026-04-15
Scope: `ios/CrisisMap` News source multidimensional refactor

## Why This Work Started

The core concern was that the `News` tab looked multi-source on the surface, but the underlying source model was too flat.

The practical risk was:

- source diversity was being inferred from display strings
- `GDELT` looked like a separate source even when it was only re-surfacing the same editorial ecosystem
- aggregation rules could limit source count, but not real source dimensions
- UI could suggest diversity that the pipeline had not actually modeled

## What We Aligned On

We explicitly chose a low-risk sequence:

1. Refactor data model first.
2. Refactor aggregation and scoring second.
3. Keep UI changes minimal and additive.
4. Avoid new filters or layout changes until metadata became trustworthy.

We also chose the structured-model route:

- use a nested structured source model on `CrisisEvent`
- keep `source` as a compatibility/display field
- allow consumer updates such as `NewsViewModel`
- defer major UI redesign

## What Was Found In The Existing Pipeline

Before the refactor:

- `News` used a small set of adapters: RSS, GDELT, and X/Grok
- RSS gave some outlet breadth, but still mostly one editorial band
- GDELT preserved useful metadata upstream but collapsed too much of it downstream
- X represented a narrow watchlist, not a broad social dimension
- aggregator diversity controls were mostly source-share and region-oriented
- source modeling was not strong enough to support multidimensional governance

We also checked endpoint health and found that connectivity was not the main blocker. The more important problem was source quality and modeling:

- some RSS feeds were unhealthy or blocked
- GDELT was reachable but rate-limited
- X endpoints were reachable but gated by credentials

## What Was Implemented

### 1. Structured Source Model

Added structured metadata via `NewsSourceDescriptor`, including:

- `kind`
- `identity`
- `group`
- `attribution`
- `originalOutlet`
- `originCountry`
- `languageCode`
- `domain`
- `authorHandle`

`CrisisEvent.source` remains in place for compatibility and display.

### 2. Source Normalization

- `RSSNewsSource` now emits direct structured source metadata.
- `GDELTNewsSource` now preserves derived outlet metadata instead of flattening everything into one `GDELT` bucket.
- `XNewsSource` now separates platform grouping from account-level identity.

### 3. Aggregation And Scoring

The News pipeline now governs more than one dimension.

Added:

- source-group quota
- source-kind quota
- derived-share quota
- region floor
- kind floor
- attribution floor

Also added:

- conservative near-duplicate collapse across channels
- attribution-aware mention weighting, where derived confirmations count less than direct ones

### 4. Low-Risk UI Exposure

The UI was updated conservatively:

- `ClusterRow` now shows a short source summary
- `ClusterDetailView` now shows source metadata chips and source-type context
- repeated outlet text under the badge is suppressed
- row summary only prefers attribution summary when direct and derived actually mix
- detail now hides `Attribution Mix` when a cluster is single-mode only, so noise like `83 direct` no longer renders

## Verification

Verified during the work:

- targeted `NewsViewModelTests` passed after the last UI noise reduction
- full iOS test suite passed: `74/74`
- simulator smoke checks earlier in the thread confirmed the low-risk UI exposure rendered correctly

## Current Product State

The News pipeline is now materially better aligned with the product claim of multidimensional sourcing.

It can now model:

- original outlet vs collection channel
- direct vs derived attribution
- outlet grouping
- source kind
- language and source-country metadata

The UI remains intentionally restrained. It surfaces the new metadata but does not yet expose full user-facing controls.

## Open Gaps

Still not done:

- user-facing source filters
- outlet / language / origin-country filters
- editorial or political slant balancing
- upstream RSS source cleanup
- semantic deduplication beyond the current conservative near-duplicate rules

## Recommended Restart Point

When restarting the discussion, begin with one decision:

1. Continue low-risk UI cleanup.
2. Add minimal user-facing source filters.
3. Audit and clean the upstream RSS / GDELT / X source mix.

Current recommendation:

- stay on low-risk UI cleanup first
- the next candidate is reducing remaining detail noise without changing ranking or layout

## Reference Docs

- `NextSteps.md`
- `docs/plans/2026-04-13-news-source-multidimensional-design.md`
- `docs/plans/2026-04-13-news-source-multidimensional-implementation.md`
- `docs/plans/2026-04-13-news-source-ui-surface-implementation.md`
