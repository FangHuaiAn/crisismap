import Foundation

struct SourceTransparencyContent {
    struct Source: Identifiable, Equatable {
        let name: String
        let detailLocalizationKey: String?

        var id: String { name }
    }

    struct Limitation: Identifiable, Equatable {
        let localizationKey: String

        var id: String { localizationKey }
    }

    static let newsSources: [Source] = [
        Source(name: "Reuters", detailLocalizationKey: nil),
        Source(name: "AP News", detailLocalizationKey: nil),
        Source(name: "BBC News", detailLocalizationKey: nil),
        Source(name: "NHK World", detailLocalizationKey: nil),
        Source(name: "Al Jazeera", detailLocalizationKey: nil),
        Source(name: "DW", detailLocalizationKey: nil),
        Source(name: "The Guardian", detailLocalizationKey: nil),
        Source(name: "NPR World", detailLocalizationKey: nil),
        Source(name: "France 24", detailLocalizationKey: nil),
        Source(name: "UN News", detailLocalizationKey: nil),
        Source(name: "GDELT", detailLocalizationKey: "sourceTransparency.news.gdelt"),
        Source(name: "X/Grok", detailLocalizationKey: "sourceTransparency.news.xGrok")
    ]

    static let researchSources: [Source] = [
        Source(name: "Brookings", detailLocalizationKey: nil),
        Source(name: "CATO", detailLocalizationKey: nil),
        Source(name: "CFR", detailLocalizationKey: nil),
        Source(name: "CSIS", detailLocalizationKey: nil),
        Source(name: "Chatham House", detailLocalizationKey: nil),
        Source(name: "Foreign Affairs", detailLocalizationKey: nil),
        Source(name: "Heritage", detailLocalizationKey: nil),
        Source(name: "IISS", detailLocalizationKey: nil),
        Source(name: "INSS", detailLocalizationKey: nil),
        Source(name: "Mitchell", detailLocalizationKey: nil),
        Source(name: "RAND", detailLocalizationKey: nil),
        Source(name: "USNI", detailLocalizationKey: nil)
    ]

    static let limitations: [Limitation] = [
        Limitation(localizationKey: "sourceTransparency.limit.coverage"),
        Limitation(localizationKey: "sourceTransparency.limit.availability"),
        Limitation(localizationKey: "sourceTransparency.limit.originals")
    ]
}
