import Foundation
import SwiftData

@Model
final class CachedMention {
    @Attribute(.unique) var key: String
    var source: String
    var clusterId: String
    var firstSeenAt: Date
    var lastSeenAt: Date
    var sampleEventId: String?
    var sourceAttributionRawValue: String?

    init(
        key: String,
        source: String,
        clusterId: String,
        firstSeenAt: Date,
        lastSeenAt: Date,
        sampleEventId: String?,
        sourceAttribution: NewsSourceAttribution? = nil
    ) {
        self.key = key
        self.source = source
        self.clusterId = clusterId
        self.firstSeenAt = firstSeenAt
        self.lastSeenAt = lastSeenAt
        self.sampleEventId = sampleEventId
        self.sourceAttributionRawValue = sourceAttribution?.rawValue
    }

    var sourceAttribution: NewsSourceAttribution? {
        get {
            guard let sourceAttributionRawValue else { return nil }
            return NewsSourceAttribution(rawValue: sourceAttributionRawValue)
        }
        set {
            sourceAttributionRawValue = newValue?.rawValue
        }
    }
}
