# Source Transparency Statement Design

Status: Direction approved
Date: 2026-05-07

## Purpose

Add a lightweight transparency statement that helps general users understand where StratAperture's news and research signals come from.

This is not a technical methodology page. It is a trust surface: short, readable, and honest about coverage limits. The product promise is not "we see everything"; it is "we show you the sources and signals behind the analysis."

## Product Rationale

Trust is foundational for intelligence analysis. When a user sees crisis signals, source mix, and related research, they should be able to quickly answer:

- Which news sources are being monitored?
- Which think tank and policy research sources are included?
- How does the app organize these materials?
- What should I not assume from this coverage?

The statement should reduce ambiguity without interrupting the core Map, News, and Research workflows.

## Recommended Surface

Use a small `info.circle` entry point that opens a sheet titled:

`Data Sources & Transparency`

Traditional Chinese title:

`資料來源與透明度`

Preferred placement:

- News toolbar: explains monitored news sources and source attribution.
- Research toolbar: explains think tank data coverage.

If implementation needs to stay even lighter, the same reusable sheet can be shown from both tabs.

## Content Scope

The statement should have four short sections.

### News Sources

Explain that the app monitors a curated set of public news feeds and indexes, including:

- Reuters
- AP News
- BBC News
- NHK World
- Al Jazeera
- DW
- The Guardian
- NPR World
- France 24
- UN News

Also explain that GDELT is used as a global news index / aggregation signal rather than a single publisher.

For X/Grok, use cautious wording: it is an optional fast-moving signal source enabled only when credentials are configured, and it may include posts from monitored accounts and keyword searches.

### Research Sources

Explain that the Research tab uses a curated weekly research dataset. Current observed think tank / policy sources include:

- Brookings
- CATO
- CFR
- CSIS
- Chatham House
- Foreign Affairs
- Heritage
- IISS
- INSS
- Mitchell
- RAND
- USNI

This list should be presented as "currently included sources" rather than a permanent contract.

### How Information Is Organized

Use general-user language:

- The app collects items from monitored sources.
- Similar items may be grouped by topic, region, or crisis theme.
- Duplicate or overlapping coverage may be reduced.
- Source labels help distinguish direct reporting from aggregated or derived signals.

Avoid implementation terms such as cache, scoring algorithm, task group, API route, or fetch timeout.

### Limits

Be explicit and concise:

- This is not a complete index of all news or research.
- Source availability can change.
- Automated grouping can miss context or over-group related items.
- Users should open original sources before making important judgments.

## Tone

The page should sound transparent, calm, and plainspoken.

Good tone:

> We include source labels so you can understand whether a signal comes from direct reporting, a news index, or another monitored channel.

Avoid:

> Our proprietary multi-source intelligence engine guarantees comprehensive situational awareness.

## Localization

The statement should ship in English and Traditional Chinese. Traditional Chinese copy should prefer natural product language over literal translation.

Example Chinese framing:

`我們希望你能看見每個訊號背後的資料來源。StratAperture 會整理公開新聞、全球新聞索引、可用的快訊來源，以及精選智庫研究；但這不是完整的新聞或研究資料庫。`

## Non-Goals

- Do not create a full FAQ.
- Do not add a new primary tab.
- Do not expose raw URLs for every feed in the UI.
- Do not promise complete coverage.
- Do not explain internal scoring formulas in this first version.

## Success Criteria

- A general user can understand the source coverage in under one minute.
- The page improves trust without becoming a legal disclaimer.
- The language supports both News and Research contexts.
- The copy leaves room for source coverage to evolve.

## Source Basis

Code references used for this design:

- News stack: `ios/CrisisMap/ViewModels/NewsViewModel.swift`
- RSS feed list: `ios/CrisisMap/Services/NewsSources/RSSNewsSource.swift`
- GDELT source: `ios/CrisisMap/Services/NewsSources/GDELTNewsSource.swift`
- X/Grok source: `ios/CrisisMap/Services/NewsSources/XNewsSource.swift`
- Think tank fetch root: `ios/CrisisMap/Services/APIClient.swift`

Remote research index checked on 2026-05-07:

- `https://thinktankbriefdata.strataperture.net/2026/weeks.json`
