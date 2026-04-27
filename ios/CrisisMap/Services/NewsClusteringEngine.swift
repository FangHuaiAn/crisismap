import Foundation

struct NewsClusteringEngine: Sendable {
    private let rules: [NewsClusterRule]
    private let fallbackClusterId: String
    private let fallbackLabel: String

    init(
        rules: [NewsClusterRule],
        fallbackClusterId: String = "unclassified",
        fallbackLabel: String = "Unclassified"
    ) {
        self.rules = NewsClusterRule.prioritized(rules)
        self.fallbackClusterId = fallbackClusterId
        self.fallbackLabel = fallbackLabel
    }

    func cluster(events: [CrisisEvent]) -> [ClusteredEvent] {
        events.map(cluster(event:))
    }

    func cluster(event: CrisisEvent) -> ClusteredEvent {
        let haystack = normalizedText(for: event)

        for rule in rules where matches(rule, in: haystack) {
            return ClusteredEvent(
                event: event,
                clusterId: rule.clusterId,
                clusterLabel: rule.label,
                regions: rule.regions,
                topics: rule.topics
            )
        }

        return ClusteredEvent(
            event: event,
            clusterId: fallbackClusterId,
            clusterLabel: fallbackLabel,
            regions: inferRegions(from: haystack),
            topics: []
        )
    }

    private func matches(_ rule: NewsClusterRule, in text: String) -> Bool {
        let anyMatched = rule.normalizedKeywordsAny.isEmpty
            || rule.normalizedKeywordsAny.contains(where: text.contains)

        let allMatched = rule.normalizedKeywordsAll.allSatisfy(text.contains)

        return anyMatched && allMatched
    }

    private func normalizedText(for event: CrisisEvent) -> String {
        [
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
    }

    private func inferRegions(from text: String) -> [Region] {
        Region.allCases.filter { region in
            region != .all && region.matches(text)
        }
    }
}
