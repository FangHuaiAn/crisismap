import Foundation

enum NewsSourceKind: String, Codable, Sendable {
    case wire
    case publisher
    case aggregator
    case social
}

enum NewsSourceAttribution: String, Codable, Sendable {
    case direct
    case derived
}

struct NewsSourceDescriptor: Codable, Sendable, Equatable {
    let displayName: String
    let kind: NewsSourceKind
    let identity: String
    let group: String
    let attribution: NewsSourceAttribution
    let originalOutlet: String?
    let originCountry: String?
    let languageCode: String?
    let domain: String?
    let authorHandle: String?

    init(
        displayName: String,
        kind: NewsSourceKind,
        identity: String,
        group: String,
        attribution: NewsSourceAttribution,
        originalOutlet: String? = nil,
        originCountry: String? = nil,
        languageCode: String? = nil,
        domain: String? = nil,
        authorHandle: String? = nil
    ) {
        self.displayName = displayName
        self.kind = kind
        self.identity = identity
        self.group = group
        self.attribution = attribution
        self.originalOutlet = originalOutlet
        self.originCountry = originCountry
        self.languageCode = languageCode
        self.domain = domain
        self.authorHandle = authorHandle
    }
}
