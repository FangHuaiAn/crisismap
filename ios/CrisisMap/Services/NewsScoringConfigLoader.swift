import Foundation

enum NewsScoringConfigLoaderError: LocalizedError {
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            "Scoring config file not found: \(name)"
        }
    }
}

enum NewsScoringConfigLoader {
    static func load(
        bundle: Bundle = .main,
        fileName: String = "news-scoring-config.v1",
        subdirectory: String = "ClusterRules"
    ) throws -> NewsScoringConfig {
        let url = bundle.url(forResource: fileName, withExtension: "json", subdirectory: subdirectory)
            ?? bundle.url(forResource: fileName, withExtension: "json")

        guard let url else {
            throw NewsScoringConfigLoaderError.fileNotFound("\(subdirectory)/\(fileName).json")
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(NewsScoringConfig.self, from: data)
    }
}
