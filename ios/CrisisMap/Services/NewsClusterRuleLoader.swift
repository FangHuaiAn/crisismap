import Foundation

enum NewsClusterRuleLoaderError: LocalizedError {
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            "Rule file not found: \(name)"
        }
    }
}

enum NewsClusterRuleLoader {
    static func load(
        bundle: Bundle = .main,
        fileName: String = "news-cluster-rules.v1",
        subdirectory: String = "ClusterRules"
    ) throws -> [NewsClusterRule] {
        let url = bundle.url(forResource: fileName, withExtension: "json", subdirectory: subdirectory)
            ?? bundle.url(forResource: fileName, withExtension: "json")

        guard let url else {
            throw NewsClusterRuleLoaderError.fileNotFound("\(subdirectory)/\(fileName).json")
        }

        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(NewsClusterRuleSet.self, from: data)
        return NewsClusterRule.prioritized(decoded.rules)
    }
}
