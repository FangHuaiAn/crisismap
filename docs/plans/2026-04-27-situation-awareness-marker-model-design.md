# Situation Awareness Marker Model Design

## Goal

Turn CrisisMap from a news list with a map into a map-first situation awareness tool. The user should be able to scan the map and quickly understand where relevant events are happening, which actors are involved, and which research helps explain the situation.

## Product Decision

The next MVP step uses event-location markers as the primary map layer. Region markers remain as a fallback and aggregation layer for intelligence that cannot yet be placed at a specific location.

This keeps the product distinct from generic news feeds:

- News lists answer: what happened?
- CrisisMap should answer: where is it happening, why does it matter, and what evidence supports that read?

## Core Model

`CrisisEvent.location` is the geographic anchor. If an event has a reliable latitude and longitude, it appears as an event marker at that point.

`Region` is the aggregation and fallback layer. It groups events and research into Middle East, Europe, East Asia, Africa, and Americas when exact coordinates are unavailable or when the user is zoomed out.

`actor` and `entities` describe involved parties. They do not decide marker placement. For example, an event about Russian forces in Mali belongs on the Mali/Africa map position, while Russia remains an actor/entity associated with the event.

Research articles are the support layer. They should attach to events, regions, or topics through region/topic relevance, but they should not flood the map as standalone markers in the MVP.

## Data Responsibilities

### CrisisEvent

- `location`: event occurrence point, used for event-level markers.
- `region`: derived or inferred region, used for grouping and fallback markers.
- `actor`: primary actor when available.
- `entities`: related countries, organizations, people, and topics.
- `source` / `newsSource`: attribution and trust context.

Android and iOS should preserve the same meanings even if implementation details differ.

### Region Intelligence Summary

Region summaries remain useful when:

- events have no reliable `location`;
- research is region-level rather than event-level;
- the map is zoomed out and needs compact aggregation;
- users want a regional briefing view.

## Marker Rules

1. If a news event has a reliable `location`, render an event marker.
2. If a news event lacks `location`, attach it to its inferred `region`.
3. If a region has unplaced news or research, render a region marker at the region anchor.
4. Marker click opens a sheet scoped to that marker:
   - Event marker: one event, related actors, sources, and supporting research.
   - Region marker: regional news clusters, research, and unplaced items.
5. Actor/entity matches should enrich the sheet, not move the marker.

## Location Inference

Use a low-cost built-in geoparsing approach before considering server-side geocoding:

- Maintain a curated location dictionary for strategic places.
- Scan event title, summary, provided location name, and country.
- Prefer physical location terms over actor terms.
- Return no coordinate when confidence is weak.
- Fall back to region marker when no reliable coordinate exists.

This preserves cost control while improving map usefulness.

## User Experience

The map should be the primary information surface.

At a glance:

- Marker position shows where attention is needed.
- Marker severity/visual weight reflects importance.
- Region markers indicate unresolved or aggregate intelligence.

On tap:

- Show event title, summary, location, time, source, and threat level.
- Show actors/entities separately from location.
- Show related research and regional context.

## Error Handling

If location inference fails, do not hide the item. Attach it to a region marker.

If research has only broad topical relevance, show it in the region sheet and avoid pretending it has a precise location.

If actor and location conflict, prefer explicit physical location. Keep actor in metadata.

## Testing Strategy

Unit tests should lock these rules:

- Event with coordinates becomes an event marker.
- Event without coordinates becomes a region fallback item.
- Actor keywords do not override physical location keywords.
- Research appears in region support without becoming a standalone marker.
- Android and iOS fixtures decode the same data shape.

## Rollout

Phase 1: Align Android/iOS data contracts and marker models.

Phase 2: Add built-in location inference and event marker generation.

Phase 3: Update Android map to render event markers plus region fallback markers.

Phase 4: Update sheets so users can distinguish location, actors, sources, and supporting research.

