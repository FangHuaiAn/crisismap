import Foundation

struct InferredEventLocation: Sendable {
    let location: Location
    let region: Region
}

enum LocationInference {
    static func infer(
        title: String,
        summary: String,
        providedLocation: Location?
    ) -> InferredEventLocation? {
        let textFields = [
            providedLocation?.name,
            providedLocation?.country,
            title,
            summary
        ].compactMap { $0 }

        let normalizedCountry = providedLocation?.country?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let candidate = strategicLocations.first(where: { location in
            location.countryCode.caseInsensitiveCompare(normalizedCountry ?? "") == .orderedSame ||
                textFields.contains { field in
                    location.keywords.contains { keyword in
                        field.containsTerm(keyword)
                    }
                }
        }) else {
            return nil
        }

        return InferredEventLocation(
            location: Location(
                lat: candidate.lat,
                lng: candidate.lng,
                name: candidate.name,
                country: candidate.countryCode
            ),
            region: candidate.region
        )
    }
}

private struct StrategicLocation: Sendable {
    let name: String
    let countryCode: String
    let lat: Double
    let lng: Double
    let region: Region
    let keywords: Set<String>
}

private let strategicLocations = [
    StrategicLocation(
        name: "Mali",
        countryCode: "ML",
        lat: 17.5707,
        lng: -3.9962,
        region: .africa,
        keywords: ["mali"]
    )
]

private extension String {
    func containsTerm(_ term: String) -> Bool {
        let escapedTerm = NSRegularExpression.escapedPattern(for: term)
        let pattern = #"(?i)\b\#(escapedTerm)\b"#
        return range(of: pattern, options: .regularExpression) != nil
    }
}
