import Foundation

actor APIClient {
    static let shared = APIClient()

    var baseURL: URL

    private let session: URLSession
    private let decoder: JSONDecoder

    private static let fallbackBaseURL = URL(string: "http://localhost:3000")!

    init(baseURL: URL = APIClient.resolveBaseURL()) {
        self.baseURL = baseURL

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)

        self.decoder = JSONDecoder()
    }

    nonisolated static func resolveBaseURL(
        environment: [String: String] = ProcessInfo.processInfo.environment,
        infoDictionary: [String: Any]? = Bundle.main.infoDictionary
    ) -> URL {
        if let url = urlFromEnvironment(environment) {
            return url
        }

        if
            let raw = infoDictionary?["API_BASE_URL"] as? String,
            let url = normalizeURL(raw)
        {
            return url
        }

        return fallbackBaseURL
    }

    nonisolated private static func urlFromEnvironment(_ environment: [String: String]) -> URL? {
        let keys = ["CRISISMAP_API_BASE_URL", "API_BASE_URL"]
        for key in keys {
            guard let raw = environment[key], let url = normalizeURL(raw) else { continue }
            return url
        }
        return nil
    }

    nonisolated private static func normalizeURL(_ raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard let url = URL(string: trimmed), let scheme = url.scheme?.lowercased() else { return nil }
        guard scheme == "http" || scheme == "https" else { return nil }
        return url
    }

    // MARK: - Public API

    func fetchEvents(locale: String = "en") async throws -> [CrisisEvent] {
        var components = URLComponents(url: baseURL.appendingPathComponent("/api/events"), resolvingAgainstBaseURL: false)!
        if locale != "en" {
            components.queryItems = [URLQueryItem(name: "locale", value: locale)]
        }
        return try await fetch(from: components.url!)
    }

    func fetchIndicators() async throws -> [MarketIndicator] {
        let url = baseURL.appendingPathComponent("/api/indicators")
        return try await fetch(from: url)
    }

    func fetchMarkets() async throws -> [PolymarketContract] {
        let url = baseURL.appendingPathComponent("/api/markets")
        return try await fetch(from: url)
    }

    func fetchActors() async throws -> [ActorStatus] {
        let url = baseURL.appendingPathComponent("/api/actors")
        return try await fetch(from: url)
    }

    // MARK: - Think Tank Data

    private let thinkTankRootURL = URL(string: "https://thinktankbriefdata.strataperture.net")!
    private let thinkTankBaseURL = URL(string: "https://thinktankbriefdata.strataperture.net/2026")!

    func fetchTopicsIndex() async throws -> TopicsIndex {
        let url = thinkTankRootURL.appendingPathComponent("topics.json")
        return try await fetchRaw(from: url)
    }

    func fetchWeekIndex() async throws -> WeekIndex {
        let url = thinkTankBaseURL.appendingPathComponent("weeks.json")
        return try await fetchRaw(from: url)
    }

    func fetchWeekly(week: String) async throws -> ThinkTankWeekly {
        let url = thinkTankBaseURL.appendingPathComponent("\(week).json")
        return try await fetchRaw(from: url)
    }

    /// Fetch and decode JSON directly (no APIResponse wrapper — think tank data is raw JSON)
    private func fetchRaw<T: Codable & Sendable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.networkError(URLError(.badServerResponse))
        }

        guard http.statusCode == 200 else {
            throw APIError.serverError("HTTP \(http.statusCode)")
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Private

    private func fetch<T: Codable & Sendable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.networkError(URLError(.badServerResponse))
        }

        guard http.statusCode == 200 else {
            throw APIError.serverError("HTTP \(http.statusCode)")
        }

        let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)

        guard apiResponse.success else {
            throw APIError.serverError(apiResponse.error ?? "Unknown server error")
        }

        guard let result = apiResponse.data else {
            throw APIError.noData
        }

        return result
    }
}

// MARK: - Errors

enum APIError: LocalizedError {
    case serverError(String)
    case noData
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .serverError(let msg): "Server error: \(msg)"
        case .noData:               "No data received"
        case .networkError(let err): "Network error: \(err.localizedDescription)"
        }
    }
}
