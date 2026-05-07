# Next Steps

Date: 2026-04-15
Scope: `ios/CrisisMap` News pipeline

## Restart Context

This thread focused on one concern: the `News` tab looked multi-source on the surface, but its source model was too flat to support real multidimensional diversity.

We aligned on a low-risk sequence:

1. Refactor data model and aggregation rules first.
2. Keep UI changes minimal and additive.
3. Avoid new filters or large layout changes until source metadata is trustworthy.

Reference docs:
- `docs/plans/2026-04-13-news-source-multidimensional-design.md`
- `docs/plans/2026-04-13-news-source-multidimensional-implementation.md`
- `docs/plans/2026-04-13-news-source-ui-surface-implementation.md`

## What Was Completed

### Data Model

- Added structured source metadata via `NewsSourceDescriptor`.
- Kept `CrisisEvent.source` as a compatibility/display field.
- Added source dimensions such as:
  - `kind`
  - `identity`
  - `group`
  - `attribution`
  - `originalOutlet`
  - `originCountry`
  - `languageCode`
  - `domain`
  - `authorHandle`

### Source Normalization

- `RSSNewsSource` now emits direct structured source metadata.
- `GDELTNewsSource` now preserves derived outlet metadata instead of collapsing everything to one `GDELT` bucket.
- `XNewsSource` now separates handle-level identity from platform-level grouping.

### Aggregation / Scoring

- Aggregation now enforces diversity across more than one dimension.
- Added controls for:
  - source group share
  - source kind share
  - derived share
  - region floor
  - kind floor
  - attribution floor
- Added conservative near-duplicate collapse across channels.
- Mention scoring now reads structured attribution and discounts derived confirmations versus direct ones.

### UI Surface

- `ClusterRow` now exposes a short source summary.
- `ClusterDetailView` now exposes:
  - attribution mix
  - source type mix
  - per-event source metadata chips
  - outlet/domain subtitle when it adds information
- Repeated outlet text is suppressed when it would duplicate the badge label.
- Row summary now prefers attribution mix only when a cluster actually contains both direct and derived material; otherwise it falls back to source kind.
- `ClusterDetailView` now hides `Attribution Mix` when a cluster is single-mode only, so low-signal summaries like `83 direct` no longer render.

### Verification

- Full iOS test suite passed at the end of the work: `74/74`.
- Simulator smoke check confirmed:
  - low-risk metadata exposure is visible
  - detail rows no longer repeat the same outlet name under the source badge

## Current State

The News pipeline is no longer pretending that a display string equals source diversity. It now has a usable internal model for:

- original outlet vs collection channel
- direct vs derived attribution
- outlet grouping
- source kind
- language and source-country metadata

The UI is still intentionally conservative. It surfaces the new metadata, but it does not yet provide new filters or a redesigned ranking experience.

## Known Gaps

These are still open:

- No user-facing filters yet for:
  - source kind
  - attribution mode
  - original outlet
  - language / origin country
- No political or editorial slant balancing. This was explicitly deferred because the repo has no reliable metadata for it.
- RSS feed health remains uneven across some upstream providers and was not cleaned up as part of this pass.
- Near-duplicate collapse is intentionally conservative and not yet a semantic deduper.

## Recommended Restart Agenda

When restarting the discussion, begin with one decision only:

1. Keep the current low-risk UI and continue tightening noise.
2. Add minimal user-facing source filters using the new metadata.
3. Audit and clean the actual upstream RSS/GDELT/X source mix now that multidimensional modeling is in place.

## Recommended Next Move

The most disciplined next step is still `1`: keep UI risk low before adding new controls.

The strongest candidate now is:

- tighten remaining detail noise without changing layout or ranking, for example only showing source-type summaries when they add differentiation beyond the source list

If you want to shift from UI cleanup to product surface, the next decision after that should be whether to do:

1. minimal user-facing filters using the new metadata
2. upstream source health cleanup for RSS / GDELT / X
