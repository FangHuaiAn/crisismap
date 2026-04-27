import Foundation
import SwiftData

@Model
final class CachedWeekly {
    @Attribute(.unique) var week: String
    var json: Data
    var uploadedAt: String
    var fetchedAt: Date

    init(week: String, json: Data, uploadedAt: String, fetchedAt: Date = .now) {
        self.week = week
        self.json = json
        self.uploadedAt = uploadedAt
        self.fetchedAt = fetchedAt
    }
}
