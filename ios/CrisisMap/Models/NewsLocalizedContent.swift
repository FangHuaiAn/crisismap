import CryptoKit
import Foundation

struct NewsLocalizedContent: Codable, Equatable, Sendable {
    let eventId: String
    let localeIdentifier: String
    let sourceTitleHash: String
    let sourceSummaryHash: String
    let title: String
    let summary: String
    let provider: String
    let translatedAt: Date

    static func cacheKey(event: CrisisEvent, localeIdentifier: String) -> String {
        [
            event.id,
            localeIdentifier,
            contentHash(event.title),
            contentHash(event.summary)
        ]
        .joined(separator: "::")
    }

    static func contentHash(_ content: String) -> String {
        let digest = SHA256.hash(data: Data(content.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    func matches(event: CrisisEvent) -> Bool {
        eventId == event.id
            && sourceTitleHash == Self.contentHash(event.title)
            && sourceSummaryHash == Self.contentHash(event.summary)
    }
}

struct NewsLocalizedEventDisplay: Sendable {
    let event: CrisisEvent
    let localizedContent: NewsLocalizedContent?

    var displayTitle: String {
        normalized(localizedContentIfCurrent?.title) ?? event.title
    }

    var displaySummary: String {
        normalized(localizedContentIfCurrent?.summary) ?? event.summary
    }

    var hasLocalizedContent: Bool {
        normalized(localizedContentIfCurrent?.title) != nil
            || normalized(localizedContentIfCurrent?.summary) != nil
    }

    private var localizedContentIfCurrent: NewsLocalizedContent? {
        guard let localizedContent, localizedContent.matches(event: event) else {
            return nil
        }

        return localizedContent
    }

    private func normalized(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed?.isEmpty == false ? trimmed : nil
    }
}
