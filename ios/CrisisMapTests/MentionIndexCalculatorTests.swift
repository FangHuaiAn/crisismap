import XCTest
@testable import CrisisMap

final class MentionIndexCalculatorTests: XCTestCase {
    func testExactDecayFormulaWithHalfLife180Days() {
        let asOf = Date(timeIntervalSince1970: 360 * 86_400)
        let rules = [
            NewsClusterRule(
                clusterId: "russia-ukraine-war",
                label: "Russia-Ukraine War",
                priority: 10,
                keywordsAny: ["ukraine"],
                regions: [.europe],
                topics: ["war"]
            )
        ]

        let mentions = [
            makeMention(source: "A", clusterId: "russia-ukraine-war", firstSeenAt: asOf),
            makeMention(source: "B", clusterId: "russia-ukraine-war", firstSeenAt: asOf.addingTimeInterval(-180 * 86_400)),
            makeMention(source: "C", clusterId: "russia-ukraine-war", firstSeenAt: asOf.addingTimeInterval(-360 * 86_400))
        ]

        let calculator = MentionIndexCalculator(config: NewsScoringConfig(halfLifeDays: 180))
        let scores = calculator.calculate(mentions: mentions, rules: rules, asOf: asOf)

        let war = scores.first { $0.clusterId == "russia-ukraine-war" }
        XCTAssertNotNil(war)
        XCTAssertEqual(war?.score ?? 0, 1.75, accuracy: 0.000_001)
    }

    func testScoreDecreasesForOlderMentions() {
        let asOf = Date(timeIntervalSince1970: 400 * 86_400)
        let rules = [
            NewsClusterRule(
                clusterId: "newer",
                label: "Newer",
                priority: 10,
                keywordsAny: ["new"],
                regions: [.europe],
                topics: ["x"]
            ),
            NewsClusterRule(
                clusterId: "older",
                label: "Older",
                priority: 20,
                keywordsAny: ["old"],
                regions: [.europe],
                topics: ["x"]
            )
        ]

        let mentions = [
            makeMention(source: "A", clusterId: "newer", firstSeenAt: asOf.addingTimeInterval(-30 * 86_400)),
            makeMention(source: "B", clusterId: "older", firstSeenAt: asOf.addingTimeInterval(-300 * 86_400))
        ]

        let calculator = MentionIndexCalculator(config: NewsScoringConfig(halfLifeDays: 180))
        let scores = calculator.calculate(mentions: mentions, rules: rules, asOf: asOf)

        let newerScore = scores.first { $0.clusterId == "newer" }?.score ?? 0
        let olderScore = scores.first { $0.clusterId == "older" }?.score ?? 0
        XCTAssertGreaterThan(newerScore, olderScore)
    }

    func testShorterHalfLifeDropsScoreFaster() {
        let asOf = Date(timeIntervalSince1970: 365 * 86_400)
        let rules = [
            NewsClusterRule(
                clusterId: "cluster",
                label: "Cluster",
                priority: 10,
                keywordsAny: ["x"],
                regions: [.europe],
                topics: ["x"]
            )
        ]

        let mentions = [
            makeMention(source: "A", clusterId: "cluster", firstSeenAt: asOf.addingTimeInterval(-180 * 86_400))
        ]

        let slowDecay = MentionIndexCalculator(config: NewsScoringConfig(halfLifeDays: 180))
            .calculate(mentions: mentions, rules: rules, asOf: asOf)
            .first?.score ?? 0

        let fastDecay = MentionIndexCalculator(config: NewsScoringConfig(halfLifeDays: 90))
            .calculate(mentions: mentions, rules: rules, asOf: asOf)
            .first?.score ?? 0

        XCTAssertGreaterThan(slowDecay, fastDecay)
        XCTAssertEqual(slowDecay, 0.5, accuracy: 0.000_001)
        XCTAssertEqual(fastDecay, 0.25, accuracy: 0.000_001)
    }

    func testDerivedMentionsCarryLowerWeightThanDirectMentions() {
        let asOf = Date(timeIntervalSince1970: 360 * 86_400)
        let rules = [
            NewsClusterRule(
                clusterId: "cluster",
                label: "Cluster",
                priority: 10,
                keywordsAny: ["x"],
                regions: [.europe],
                topics: ["x"]
            )
        ]

        let mentions = [
            makeMention(source: "reuters", clusterId: "cluster", firstSeenAt: asOf, sourceAttribution: .direct),
            makeMention(source: "derived:copy", clusterId: "cluster", firstSeenAt: asOf, sourceAttribution: .derived)
        ]

        let calculator = MentionIndexCalculator(config: NewsScoringConfig(halfLifeDays: 180))
        let score = calculator.calculate(mentions: mentions, rules: rules, asOf: asOf).first?.score ?? 0

        XCTAssertLessThan(score, 2.0)
        XCTAssertEqual(score, 1.5, accuracy: 0.000_001)
    }

    private func makeMention(
        source: String,
        clusterId: String,
        firstSeenAt: Date,
        sourceAttribution: NewsSourceAttribution? = nil
    ) -> CachedMention {
        CachedMention(
            key: MentionStore.makeKey(source: source, clusterId: clusterId),
            source: source,
            clusterId: clusterId,
            firstSeenAt: firstSeenAt,
            lastSeenAt: firstSeenAt,
            sampleEventId: nil,
            sourceAttribution: sourceAttribution
        )
    }
}
