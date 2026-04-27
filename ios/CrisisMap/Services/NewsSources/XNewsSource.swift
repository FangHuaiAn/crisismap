import Foundation

final class XNewsSource: NewsDataSource, @unchecked Sendable {
    struct Configuration: Sendable {
        let xBearerToken: String?
        let xaiAPIKey: String?

        init(
            xBearerToken: String? = nil,
            xaiAPIKey: String? = nil,
            environment: [String: String] = ProcessInfo.processInfo.environment
        ) {
            self.xBearerToken = Self.resolve(injected: xBearerToken, environment: environment, keys: ["X_BEARER_TOKEN"])
            self.xaiAPIKey = Self.resolve(injected: xaiAPIKey, environment: environment, keys: ["XAI_API_KEY"])
        }

        var hasAnyCredential: Bool {
            xBearerToken != nil || xaiAPIKey != nil
        }

        private static func resolve(
            injected: String?,
            environment: [String: String],
            keys: [String]
        ) -> String? {
            if let injected = injected?.trimmingCharacters(in: .whitespacesAndNewlines),
               !injected.isEmpty {
                return injected
            }

            for key in keys {
                if let raw = environment[key]?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !raw.isEmpty {
                    return raw
                }
            }

            return nil
        }
    }

    struct Tweet: Codable, Sendable {
        let id: String
        let text: String
        let created_at: String
        let author_id: String
    }

    struct XUser: Codable, Sendable {
        let id: String
        let username: String
    }

    struct XRecentSearchResponse: Codable, Sendable {
        let data: [Tweet]?
        let includes: Includes?

        struct Includes: Codable, Sendable {
            let users: [XUser]?
        }
    }

    struct GrokResponse: Codable, Sendable {
        let output: [OutputItem]?

        struct OutputItem: Codable, Sendable {
            let type: String
            let content: [ContentItem]?
        }

        struct ContentItem: Codable, Sendable {
            let type: String
            let text: String?
        }
    }

    private let session: URLSession
    private let configuration: Configuration
    private let xAPIBaseURL: URL
    private let xAIBaseURL: URL

    init(
        configuration: Configuration = .init(),
        session: URLSession = .shared,
        xAPIBaseURL: URL = URL(string: "https://api.x.com/2/tweets/search/recent")!,
        xAIBaseURL: URL = URL(string: "https://api.x.ai/v1/responses")!
    ) {
        self.configuration = configuration
        self.session = session
        self.xAPIBaseURL = xAPIBaseURL
        self.xAIBaseURL = xAIBaseURL
    }

    var id: String { "x-grok" }
    var name: String { "X/Grok" }
    var isEnabled: Bool { configuration.hasAnyCredential }

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        guard limit > 0 else { return [] }
        guard isEnabled else { return [] }

        let cappedLimit = min(limit, Self.externalResultCap)

        if configuration.xBearerToken != nil {
            let xTweets = await fetchViaXApi(limit: cappedLimit)
            if !xTweets.isEmpty {
                return tweetsToEvents(xTweets, limit: cappedLimit)
            }
        }

        guard configuration.xaiAPIKey != nil else { return [] }

        let grokTweets = await fetchViaGrok(query: Self.defaultQuery, limit: cappedLimit)
        return tweetsToEvents(grokTweets, limit: cappedLimit)
    }

    private func fetchViaXApi(limit: Int) async -> [Tweet] {
        guard let token = configuration.xBearerToken else { return [] }

        let accountClause = Self.accounts.map { "from:\($0)" }.joined(separator: " OR ")
        let query = "(\(accountClause)) (\(Self.keywords))"
        let requestLimit = max(10, min(limit, Self.externalResultCap))
        var components = URLComponents(url: xAPIBaseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "max_results", value: String(requestLimit)),
            URLQueryItem(name: "tweet.fields", value: "created_at,author_id"),
            URLQueryItem(name: "expansions", value: "author_id")
        ]

        guard let url = components?.url else { return [] }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return []
            }

            let decoded = try JSONDecoder().decode(XRecentSearchResponse.self, from: data)
            let users = Dictionary(
                uniqueKeysWithValues: (decoded.includes?.users ?? []).map { ($0.id, $0.username) }
            )

            return (decoded.data ?? []).map { tweet in
                Tweet(
                    id: tweet.id,
                    text: tweet.text,
                    created_at: tweet.created_at,
                    author_id: users[tweet.author_id] ?? "unknown"
                )
            }
        } catch {
            return []
        }
    }

    private func fetchViaGrok(query: String, limit: Int) async -> [Tweet] {
        guard let apiKey = configuration.xaiAPIKey else { return [] }

        do {
            let body: [String: Any] = [
                "model": "grok-4-1-fast-reasoning",
                "tools": [
                    ["type": "x_search"]
                ],
                "input": [
                    [
                        "role": "user",
                        "content": "Search X/Twitter for: \(query)\n\nReturn ONLY a JSON array of the \(limit) most recent results. Each object must have: {\"text\": \"full tweet\", \"author\": \"@handle\", \"time\": \"ISO 8601\", \"url\": \"tweet url\"}\n\nNo explanation, just the JSON array."
                    ]
                ]
            ]

            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            var request = URLRequest(url: xAIBaseURL)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            request.timeoutInterval = 20

            let (responseData, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return []
            }

            let decoded = try JSONDecoder().decode(GrokResponse.self, from: responseData)
            let content = extractContent(decoded)

            guard let match = content.range(of: #"\[[\s\S]*\]"#, options: .regularExpression) else {
                return []
            }

            let arrayString = String(content[match])
            let jsonData = Data(arrayString.utf8)
            let tweets = try JSONDecoder().decode([GrokTweet].self, from: jsonData)
            return tweets.map { Tweet(id: $0.url, text: $0.text, created_at: $0.time, author_id: $0.author) }
        } catch {
            return []
        }
    }

    private func extractContent(_ response: GrokResponse) -> String {
        for item in response.output ?? [] where item.type == "message" {
            for content in item.content ?? [] where content.type == "output_text" {
                if let text = content.text {
                    return text
                }
            }
        }
        return ""
    }

    private func tweetsToEvents(_ tweets: [Tweet], limit: Int) -> [CrisisEvent] {
        tweets
            .prefix(limit)
            .map { tweet in
                let text = tweet.text
                let category = detectCategory(text: text)
                let level = NewsSourceHeuristics.scoreThreatLevel(title: text, description: "", category: category)
                let url = normalizedTweetURL(tweet.id)
                let handle = normalizedAuthorHandle(tweet.author_id)
                let identity = "x:\(handle.dropFirst())".lowercased()

                return CrisisEvent(
                    id: "x-grok:\(NewsSourceHeuristics.hashString(tweet.id.isEmpty ? text : tweet.id))",
                    title: text.isEmpty ? "X post" : String(text.prefix(120)),
                    summary: text,
                    category: category,
                    level: level,
                    location: nil,
                    timestamp: parseTimestamp(tweet.created_at),
                    source: "x:\(handle)",
                    sourceTier: .private,
                    url: url,
                    actor: NewsSourceHeuristics.extractActor(from: text),
                    entities: nil,
                    newsSource: NewsSourceDescriptor(
                        displayName: "x:\(handle)",
                        kind: .social,
                        identity: identity,
                        group: "x",
                        attribution: .direct,
                        authorHandle: handle
                    )
                )
            }
    }

    private func detectCategory(text: String) -> EventCategory {
        NewsSourceHeuristics.detectCategory(title: text, description: "")
    }

    private func parseTimestamp(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return NewsSourceHeuristics.oldTimestampFallback
        }

        if let date = ISO8601DateFormatter().date(from: trimmed) {
            return ISO8601DateFormatter().string(from: date)
        }

        return NewsSourceHeuristics.oldTimestampFallback
    }

    private func normalizedTweetURL(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           (scheme == "http" || scheme == "https") {
            return trimmed
        }

        return "https://x.com/i/status/\(trimmed)"
    }

    private func normalizedAuthorHandle(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "@unknown" }
        return trimmed.hasPrefix("@") ? trimmed : "@\(trimmed)"
    }

    private static let accounts = ["DeItaone", "BNONews", "disclosetv"]
    private static let keywords = "Iran OR strike OR nuclear OR military OR missile OR conflict"
    private static let defaultQuery = "Iran strike OR nuclear OR military attack OR conflict OR missile from:DeItaone OR from:BNONews OR from:disclosetv"
    private static let externalResultCap = 10
}

private struct GrokTweet: Codable, Sendable {
    let text: String
    let author: String
    let time: String
    let url: String
}
