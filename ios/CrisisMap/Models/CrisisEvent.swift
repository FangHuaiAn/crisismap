import CoreLocation
import Foundation

struct CrisisEvent: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let summary: String
    let category: EventCategory
    let level: ThreatLevel
    let location: Location?
    let timestamp: String
    let source: String
    let sourceTier: SourceTier
    let url: String?
    let actor: String?
    let entities: [String]?
    let newsSource: NewsSourceDescriptor?

    init(
        id: String,
        title: String,
        summary: String,
        category: EventCategory,
        level: ThreatLevel,
        location: Location?,
        timestamp: String,
        source: String,
        sourceTier: SourceTier,
        url: String?,
        actor: String?,
        entities: [String]?,
        newsSource: NewsSourceDescriptor? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.category = category
        self.level = level
        self.location = location
        self.timestamp = timestamp
        self.source = newsSource?.displayName ?? source
        self.sourceTier = sourceTier
        self.url = url
        self.actor = actor
        self.entities = entities
        self.newsSource = newsSource
    }

    var date: Date {
        ISO8601DateFormatter().date(from: timestamp) ?? .distantPast
    }

    var coordinate: CLLocationCoordinate2D? {
        guard let location else { return nil }
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
    }

    var isPrivate: Bool {
        sourceTier == .private
    }
}

struct Location: Codable, Sendable {
    let lat: Double
    let lng: Double
    let name: String
    let country: String?
}
