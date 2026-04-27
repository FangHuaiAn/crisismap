import Foundation

final class GDELTNewsSource: NewsDataSource, @unchecked Sendable {
    struct Article: Codable, Sendable {
        let url: String
        let title: String
        let seendate: String
        let domain: String?
        let language: String?
        let sourcecountry: String?
    }

    struct Response: Codable, Sendable {
        let articles: [Article]?
    }

    private let session: URLSession
    private let apiBaseURL: URL
    private let query: String

    init(
        session: URLSession = .shared,
        apiBaseURL: URL = URL(string: "https://api.gdeltproject.org/api/v2/doc/doc")!,
        query: String = GDELTNewsSource.defaultQuery
    ) {
        self.session = session
        self.apiBaseURL = apiBaseURL
        self.query = query
    }

    var id: String { "gdelt" }
    var name: String { "GDELT Project" }
    var isEnabled: Bool { true }

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        guard limit > 0 else { return [] }

        let request = try makeRequest(limit: limit)
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let contentType = http.value(forHTTPHeaderField: "Content-Type")?.lowercased() ?? ""
        if !contentType.isEmpty, !contentType.contains("json") {
            throw URLError(.cannotParseResponse)
        }

        let decoded = try JSONDecoder().decode(Response.self, from: data)
        let articles = decoded.articles ?? []

        return articles
            .compactMap(mapArticle)
            .sorted {
                if $0.date == $1.date {
                    return $0.id < $1.id
                }
                return $0.date > $1.date
            }
            .prefix(limit)
            .map { $0 }
    }

    private func makeRequest(limit: Int) throws -> URLRequest {
        let clampedLimit = max(1, min(limit, 250))
        var components = URLComponents(url: apiBaseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "mode", value: "ArtList"),
            URLQueryItem(name: "maxrecords", value: String(clampedLimit)),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "timespan", value: "60min")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        return request
    }

    private func mapArticle(_ article: Article) -> CrisisEvent? {
        let title = article.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return nil }

        let summary = title
        let category = NewsSourceHeuristics.detectCategory(title: title, description: summary)
        let level = NewsSourceHeuristics.scoreThreatLevel(title: title, description: summary, category: category)
        let domain = normalizedDomain(for: article)

        return CrisisEvent(
            id: "gdelt:\(NewsSourceHeuristics.hashString(article.url))",
            title: title,
            summary: summary,
            category: category,
            level: level,
            location: nil,
            timestamp: parseTimestamp(article.seendate),
            source: "GDELT",
            sourceTier: .public,
            url: article.url,
            actor: nil,
            entities: nil,
            newsSource: NewsSourceDescriptor(
                displayName: "GDELT",
                kind: .aggregator,
                identity: domain.map { "gdelt:\($0)" } ?? "gdelt",
                group: domain.map { "gdelt:\($0)" } ?? "gdelt",
                attribution: .derived,
                originalOutlet: domain,
                originCountry: article.sourcecountry,
                languageCode: article.language,
                domain: domain
            )
        )
    }

    private func normalizedDomain(for article: Article) -> String? {
        if let domain = article.domain?.trimmingCharacters(in: .whitespacesAndNewlines),
           !domain.isEmpty {
            return domain.lowercased()
        }

        if let host = URL(string: article.url)?.host?.trimmingCharacters(in: .whitespacesAndNewlines),
           !host.isEmpty {
            return host.lowercased()
        }

        return nil
    }

    private func parseTimestamp(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return NewsSourceHeuristics.oldTimestampFallback
        }

        let formats = [
            "yyyyMMdd'T'HHmmss'Z'",
            "yyyyMMdd'T'HHmmssZ",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssZ"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: trimmed) {
                return ISO8601DateFormatter().string(from: date)
            }
        }

        if let date = ISO8601DateFormatter().date(from: trimmed) {
            return ISO8601DateFormatter().string(from: date)
        }

        return NewsSourceHeuristics.oldTimestampFallback
    }

    private static let defaultQuery = "(crisis OR conflict OR military OR attack)"
}
