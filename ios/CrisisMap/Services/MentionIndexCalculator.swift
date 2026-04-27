import Foundation

struct MentionIndexCalculator: Sendable {
    let config: NewsScoringConfig

    init(config: NewsScoringConfig = .default) {
        self.config = config
    }

    func calculate(
        mentions: [CachedMention],
        rules: [NewsClusterRule],
        asOf: Date = .now
    ) -> [MentionClusterScore] {
        let rulesByClusterId = Dictionary(uniqueKeysWithValues: rules.map { ($0.clusterId, $0) })
        let grouped = Dictionary(grouping: mentions, by: \.clusterId)

        return grouped.map { clusterId, clusterMentions in
            let score = clusterMentions.reduce(0.0) { partial, mention in
                partial + weight(for: mention, asOf: asOf)
            }

            let sourceCount = Set(clusterMentions.map { $0.source.lowercased() }).count
            let lastMentionAt = clusterMentions.map(\.lastSeenAt).max()
            let rule = rulesByClusterId[clusterId]

            return MentionClusterScore(
                clusterId: clusterId,
                label: rule?.label ?? fallbackLabel(for: clusterId),
                score: score,
                sourceCount: sourceCount,
                lastMentionAt: lastMentionAt,
                regions: rule?.regions ?? [],
                topics: rule?.topics ?? []
            )
        }
        .sorted {
            if $0.score == $1.score {
                return $0.clusterId < $1.clusterId
            }
            return $0.score > $1.score
        }
    }

    func weight(firstSeenAt: Date, asOf: Date) -> Double {
        let ageDays = max(0, asOf.timeIntervalSince(firstSeenAt) / 86_400)
        return pow(2.0, -ageDays / config.safeHalfLifeDays)
    }

    func weight(for mention: CachedMention, asOf: Date) -> Double {
        let baseWeight = weight(firstSeenAt: mention.firstSeenAt, asOf: asOf)
        if mention.sourceAttribution == .derived {
            return baseWeight * 0.5
        }
        return baseWeight
    }

    private func fallbackLabel(for clusterId: String) -> String {
        clusterId
            .split(separator: "-")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}
