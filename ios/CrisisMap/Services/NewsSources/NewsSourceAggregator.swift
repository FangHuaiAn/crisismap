import Foundation

struct NewsSourceAggregator: Sendable {
    struct DiversityPolicy: Sendable {
        let maxSourceShare: Double
        let maxKindShare: [NewsSourceKind: Double]
        let maxDerivedShare: Double?
        let minDistinctKinds: Int
        let minDistinctAttributions: Int
        let minDistinctRegions: Int

        init(
            maxSourceShare: Double = 0.25,
            maxKindShare: [NewsSourceKind: Double] = [:],
            maxDerivedShare: Double? = nil,
            minDistinctKinds: Int = 0,
            minDistinctAttributions: Int = 0,
            minDistinctRegions: Int = 3
        ) {
            self.maxSourceShare = max(0, min(1, maxSourceShare))
            self.maxKindShare = maxKindShare.reduce(into: [:]) { result, entry in
                result[entry.key] = max(0, min(1, entry.value))
            }
            if let maxDerivedShare {
                self.maxDerivedShare = max(0, min(1, maxDerivedShare))
            } else {
                self.maxDerivedShare = nil
            }
            self.minDistinctKinds = max(0, minDistinctKinds)
            self.minDistinctAttributions = max(0, minDistinctAttributions)
            self.minDistinctRegions = max(0, minDistinctRegions)
        }

        func maxItemsPerSource(limit: Int) -> Int {
            guard limit > 0 else { return 0 }
            return max(1, Int(ceil(Double(limit) * maxSourceShare)))
        }

        func maxItems(for share: Double, limit: Int) -> Int {
            guard limit > 0 else { return 0 }
            return max(1, Int(ceil(Double(limit) * share)))
        }
    }

    let sources: [any NewsDataSource]
    let sourceTimeout: Duration
    let diversityPolicy: DiversityPolicy

    init(
        sources: [any NewsDataSource],
        sourceTimeout: Duration = .seconds(10),
        diversityPolicy: DiversityPolicy = .init()
    ) {
        self.sources = sources
        self.sourceTimeout = sourceTimeout
        self.diversityPolicy = diversityPolicy
    }

    func fetchAll(limit: Int) async throws -> [CrisisEvent] {
        guard limit > 0 else { return [] }

        let batches = await withTaskGroup(of: [CrisisEvent].self) { group in
            for source in sources where source.isEnabled {
                group.addTask {
                    await fetchFromSource(source, limit: limit)
                }
            }

            var collected: [CrisisEvent] = []
            for await batch in group {
                collected.append(contentsOf: batch)
            }
            return collected
        }

        let ranked = batches
            .sorted(by: sortNewestFirst)
            .deduplicated(by: \.id)
        let collapsed = collapseNearDuplicates(ranked)

        let sourceBalanced = applySourceQuota(collapsed, limit: limit)
        let regionBalanced = applyRegionFloor(sourceBalanced, universe: collapsed, limit: limit)
        let kindBalanced = applyKindFloor(regionBalanced, universe: collapsed, limit: limit)
        let attributionBalanced = applyAttributionFloor(kindBalanced, universe: collapsed, limit: limit)

        return Array(attributionBalanced.prefix(limit))
    }

    private func fetchFromSource(_ source: any NewsDataSource, limit: Int) async -> [CrisisEvent] {
        let gate = SourceOutcomeGate()

        return await withCheckedContinuation { continuation in
            let fetchTask = Task {
                let events: [CrisisEvent]
                do {
                    events = try await source.fetch(limit: limit)
                } catch {
                    events = []
                }

                let shouldResume = await gate.claim()
                if shouldResume {
                    continuation.resume(returning: events)
                }
            }

            Task {
                try? await Task.sleep(for: sourceTimeout)
                fetchTask.cancel()

                let shouldResume = await gate.claim()
                if shouldResume {
                    continuation.resume(returning: [])
                }
            }
        }
    }

    private func sortNewestFirst(_ lhs: CrisisEvent, _ rhs: CrisisEvent) -> Bool {
        if lhs.date != rhs.date {
            return lhs.date > rhs.date
        }
        return lhs.id < rhs.id
    }

    private func applySourceQuota(_ events: [CrisisEvent], limit: Int) -> [CrisisEvent] {
        guard !events.isEmpty, limit > 0 else { return [] }

        let maxPerSource = diversityPolicy.maxItemsPerSource(limit: limit)
        var selected: [CrisisEvent] = []
        var sourceOverflow: [CrisisEvent] = []
        var countsBySourceBucket: [String: Int] = [:]
        var countsByKind: [NewsSourceKind: Int] = [:]
        var derivedCount = 0

        for event in events {
            let bucket = sourceBucket(for: event)
            let currentCount = countsBySourceBucket[bucket, default: 0]
            let kind = event.newsSource?.kind
            let exceedsSourceShare = currentCount >= maxPerSource
            let violatesKindShare = kind.map { exceedsKindShare(for: $0, countsByKind: countsByKind, limit: limit) } ?? false
            let violatesDerivedShare = exceedsDerivedShare(for: event, derivedCount: derivedCount, limit: limit)

            if !exceedsSourceShare && !violatesKindShare && !violatesDerivedShare {
                selected.append(event)
                countsBySourceBucket[bucket] = currentCount + 1
                if let kind {
                    countsByKind[kind, default: 0] += 1
                }
                if event.newsSource?.attribution == .derived {
                    derivedCount += 1
                }
                if selected.count == limit {
                    return selected
                }
            } else if violatesKindShare || violatesDerivedShare {
                continue
            } else {
                sourceOverflow.append(event)
            }
        }

        if selected.count < limit {
            for event in sourceOverflow {
                selected.append(event)
                if selected.count == limit {
                    break
                }
            }
        }

        return selected
    }

    private func applyRegionFloor(_ events: [CrisisEvent], universe: [CrisisEvent], limit: Int) -> [CrisisEvent] {
        applyFloor(
            events,
            universe: universe,
            limit: limit,
            minDistinct: diversityPolicy.minDistinctRegions,
            values: inferRegions
        )
    }

    private func applyKindFloor(_ events: [CrisisEvent], universe: [CrisisEvent], limit: Int) -> [CrisisEvent] {
        applyFloor(
            events,
            universe: universe,
            limit: limit,
            minDistinct: diversityPolicy.minDistinctKinds
        ) { event in
            if let kind = event.newsSource?.kind {
                return [kind]
            }
            return []
        }
    }

    private func applyAttributionFloor(_ events: [CrisisEvent], universe: [CrisisEvent], limit: Int) -> [CrisisEvent] {
        applyFloor(
            events,
            universe: universe,
            limit: limit,
            minDistinct: diversityPolicy.minDistinctAttributions
        ) { event in
            if let attribution = event.newsSource?.attribution {
                return [attribution]
            }
            return []
        }
    }

    private func applyFloor<Value: Hashable>(
        _ events: [CrisisEvent],
        universe: [CrisisEvent],
        limit: Int,
        minDistinct: Int,
        values: (CrisisEvent) -> [Value]
    ) -> [CrisisEvent] {
        guard !events.isEmpty, limit > 0 else { return [] }
        guard minDistinct > 1 else { return events }

        let availableValues = Set(universe.flatMap(values))
        let targetDistinct = min(minDistinct, availableValues.count, limit)
        guard targetDistinct > 1 else { return events }

        var selected = events
        var selectedIDs = Set(selected.map(\.id))
        var counts = makeValueCounts(from: selected, values: values)

        while counts.keys.count < targetDistinct {
            guard let candidate = universe.first(where: { event in
                guard !selectedIDs.contains(event.id) else { return false }
                let candidateValues = values(event)
                return candidateValues.contains(where: { counts[$0] == nil })
            }) else {
                break
            }

            selected.append(candidate)
            selectedIDs.insert(candidate.id)
            for value in values(candidate) {
                counts[value, default: 0] += 1
            }
        }

        return trim(
            selected.sorted(by: sortNewestFirst),
            to: limit,
            preservingDistinct: targetDistinct,
            values: values
        )
    }

    private func trim<Value: Hashable>(
        _ events: [CrisisEvent],
        to limit: Int,
        preservingDistinct targetDistinct: Int,
        values: (CrisisEvent) -> [Value]
    ) -> [CrisisEvent] {
        guard events.count > limit else { return events }

        var working = events
        while working.count > limit {
            if let removableIndex = oldestRemovableIndex(in: working, preservingDistinct: targetDistinct, values: values) {
                working.remove(at: removableIndex)
            } else {
                working.removeLast()
            }
        }

        return working
    }

    private func oldestRemovableIndex<Value: Hashable>(
        in events: [CrisisEvent],
        preservingDistinct targetDistinct: Int,
        values: (CrisisEvent) -> [Value]
    ) -> Int? {
        let counts = makeValueCounts(from: events, values: values)
        guard counts.count >= targetDistinct else { return events.indices.last }

        for index in events.indices.reversed() {
            let eventValues = values(events[index])
            if eventValues.isEmpty {
                return index
            }

            let uniqueValues = Set(eventValues)
            let wouldDropUniqueValue = uniqueValues.contains { value in
                counts[value, default: 0] <= 1
            }

            if !wouldDropUniqueValue {
                return index
            }
        }

        return nil
    }

    private func makeValueCounts<Value: Hashable>(
        from events: [CrisisEvent],
        values: (CrisisEvent) -> [Value]
    ) -> [Value: Int] {
        var counts: [Value: Int] = [:]

        for event in events {
            for value in Set(values(event)) {
                counts[value, default: 0] += 1
            }
        }

        return counts
    }

    private func sourceBucket(for event: CrisisEvent) -> String {
        if let group = event.newsSource?.group.trimmingCharacters(in: .whitespacesAndNewlines),
           !group.isEmpty {
            return group.lowercased()
        }

        let normalized = event.source
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if normalized.hasPrefix("x:") {
            return "x"
        }

        return normalized
    }

    private func exceedsKindShare(for kind: NewsSourceKind, countsByKind: [NewsSourceKind: Int], limit: Int) -> Bool {
        guard let share = diversityPolicy.maxKindShare[kind] else { return false }
        return countsByKind[kind, default: 0] >= diversityPolicy.maxItems(for: share, limit: limit)
    }

    private func exceedsDerivedShare(for event: CrisisEvent, derivedCount: Int, limit: Int) -> Bool {
        guard event.newsSource?.attribution == .derived,
              let share = diversityPolicy.maxDerivedShare else {
            return false
        }

        return derivedCount >= diversityPolicy.maxItems(for: share, limit: limit)
    }

    private func collapseNearDuplicates(_ events: [CrisisEvent]) -> [CrisisEvent] {
        guard !events.isEmpty else { return [] }

        var selected: [CrisisEvent] = []
        var seenKeys = Set<String>()

        for event in events.sorted(by: isPreferredNearDuplicateWinner) {
            guard let duplicateKey = nearDuplicateKey(for: event) else {
                selected.append(event)
                continue
            }

            if seenKeys.insert(duplicateKey).inserted {
                selected.append(event)
            }
        }

        return selected.sorted(by: sortNewestFirst)
    }

    private func isPreferredNearDuplicateWinner(_ lhs: CrisisEvent, _ rhs: CrisisEvent) -> Bool {
        let lhsPriority = nearDuplicatePriority(for: lhs)
        let rhsPriority = nearDuplicatePriority(for: rhs)

        if lhsPriority != rhsPriority {
            return lhsPriority > rhsPriority
        }

        return sortNewestFirst(lhs, rhs)
    }

    private func nearDuplicatePriority(for event: CrisisEvent) -> Int {
        switch event.newsSource?.attribution {
        case .direct:
            2
        case .derived:
            1
        case nil:
            0
        }
    }

    private func nearDuplicateKey(for event: CrisisEvent) -> String? {
        if let urlKey = canonicalURLKey(for: event) {
            return "url::\(urlKey)"
        }

        let headline = normalizedHeadline(for: event)
        guard headline.count >= 24 else { return nil }
        return "title::\(headline)"
    }

    private func canonicalURLKey(for event: CrisisEvent) -> String? {
        guard let raw = event.url?.trimmingCharacters(in: .whitespacesAndNewlines),
              let components = URLComponents(string: raw),
              let host = components.host?.lowercased() else {
            return nil
        }

        let path = components.path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()

        guard !path.isEmpty else { return host }
        return "\(host)/\(path)"
    }

    private func normalizedHeadline(for event: CrisisEvent) -> String {
        event.title
            .lowercased()
            .replacingOccurrences(of: #"[^a-z0-9\s]"#, with: " ", options: .regularExpression)
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
    }

    private func inferRegions(_ event: CrisisEvent) -> [Region] {
        let haystack = [
            event.title,
            event.summary,
            event.source,
            event.actor ?? "",
            event.location?.name ?? "",
            event.location?.country ?? "",
            (event.entities ?? []).joined(separator: " ")
        ]
        .joined(separator: " ")
        .lowercased()

        return Region.allCases.filter { region in
            region != .all && region.matches(haystack)
        }
    }
}

private actor SourceOutcomeGate {
    private var resolved = false

    func claim() -> Bool {
        guard !resolved else { return false }
        resolved = true
        return true
    }
}

private extension Array where Element == CrisisEvent {
    func deduplicated(by keyPath: KeyPath<CrisisEvent, String>) -> [CrisisEvent] {
        var seen = Set<String>()
        return filter { event in
            seen.insert(event[keyPath: keyPath]).inserted
        }
    }
}
