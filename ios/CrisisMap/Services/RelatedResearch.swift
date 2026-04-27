import Foundation

enum RelatedResearch {
    static func match(
        eventRegion: Region,
        entities: [String],
        articles: [ThinkTankArticle],
        limit: Int = 3
    ) -> [ThinkTankArticle] {
        let normalizedEntities = Set(entities.compactMap(Self.normalizedTerm))

        return articles
            .compactMap { article -> Candidate? in
                let regionMatch = eventRegion != .all && eventRegion.matchesArticle(article)
                let entityMatch = !normalizedEntities.isEmpty &&
                    article.relevanceTerms.contains { normalizedEntities.contains($0) }
                let isRelevant = normalizedEntities.isEmpty
                    ? regionMatch
                    : regionMatch && entityMatch

                guard isRelevant else { return nil }

                return Candidate(
                    article: article,
                    score: (regionMatch ? 2 : 0) + (entityMatch ? 1 : 0)
                )
            }
            .sorted { lhs, rhs in
                if lhs.score != rhs.score {
                    return lhs.score > rhs.score
                }
                return lhs.article.date > rhs.article.date
            }
            .prefix(limit)
            .map(\.article)
    }

    static func match(
        event: CrisisEvent,
        articles: [ThinkTankArticle],
        limit: Int = 3
    ) -> [ThinkTankArticle] {
        guard let region = eventRegion(for: event) else { return [] }

        let entities = [event.actor].compactMap { $0 } + (event.entities ?? [])

        return match(
            eventRegion: region,
            entities: entities,
            articles: articles,
            limit: limit
        )
    }

    private static func eventRegion(for event: CrisisEvent) -> Region? {
        if let inferred = LocationInference.infer(
            title: event.title,
            summary: event.summary,
            providedLocation: event.location
        ) {
            return inferred.region
        }

        let text = [
            event.location?.name,
            event.location?.country,
            event.title,
            event.summary,
            event.actor,
            (event.entities ?? []).joined(separator: " ")
        ]
        .compactMap { $0 }
        .joined(separator: " ")

        return Region.allCases.first { region in
            region != .all && region.matches(text)
        }
    }

    fileprivate static func normalizedTerm(_ term: String) -> String? {
        let normalized = term
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")

        return normalized.isEmpty ? nil : normalized
    }
}

private struct Candidate {
    let article: ThinkTankArticle
    let score: Int
}

private extension ThinkTankArticle {
    var relevanceTerms: Set<String> {
        Set((topics + [category, title, summary]).compactMap(RelatedResearch.normalizedTerm))
    }
}
