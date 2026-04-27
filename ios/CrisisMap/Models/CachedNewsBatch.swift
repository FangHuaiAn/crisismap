import Foundation
import SwiftData

@Model
final class CachedNewsBatch {
    @Attribute(.unique) var key: String
    var fetchedAt: Date
    var payload: Data

    init(key: String = CachedNewsBatch.defaultKey, fetchedAt: Date = .now, payload: Data) {
        self.key = key
        self.fetchedAt = fetchedAt
        self.payload = payload
    }

    static let defaultKey = "news:latest"
}
