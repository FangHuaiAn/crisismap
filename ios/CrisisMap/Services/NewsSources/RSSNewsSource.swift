import Foundation

final class RSSNewsSource: NewsDataSource, @unchecked Sendable {
    struct Feed: Sendable, Hashable {
        let id: String
        let url: URL
        let fallbackURLs: [URL]
        let sourceLabel: String
        let sourceKind: NewsSourceKind
        let sourceIdentity: String
        let sourceGroup: String
        let domain: String?

        init(
            id: String,
            url: URL,
            fallbackURLs: [URL] = [],
            sourceLabel: String,
            sourceKind: NewsSourceKind? = nil,
            sourceIdentity: String? = nil,
            sourceGroup: String? = nil,
            domain: String? = nil
        ) {
            self.id = id
            self.url = url
            self.fallbackURLs = fallbackURLs
            self.sourceLabel = sourceLabel
            self.sourceKind = sourceKind ?? Self.defaultKind(id: id, sourceLabel: sourceLabel)
            self.sourceIdentity = sourceIdentity ?? id
            self.sourceGroup = sourceGroup ?? sourceIdentity ?? id
            self.domain = domain ?? url.host
        }

        private static func defaultKind(id: String, sourceLabel: String) -> NewsSourceKind {
            let normalized = "\(id) \(sourceLabel)".lowercased()
            if normalized.contains("reuters") || normalized.contains("ap") {
                return .wire
            }
            return .publisher
        }
    }

    fileprivate struct FeedItem {
        var title: String?
        var description: String?
        var link: String?
        var linkPriority: Int = 0
        var guid: String?
        var pubDate: String?
        var updated: String?

        var summaryText: String {
            description ?? title ?? ""
        }

        var timestampText: String {
            pubDate ?? updated ?? ""
        }
    }

    private let session: URLSession
    let feeds: [Feed]

    init(
        session: URLSession = .shared,
        feeds: [Feed] = RSSNewsSource.defaultFeeds
    ) {
        self.session = session
        self.feeds = feeds
    }

    var id: String { "rss" }
    var name: String { "RSS Aggregator" }
    var isEnabled: Bool { true }

    func fetch(limit: Int) async throws -> [CrisisEvent] {
        guard limit > 0 else { return [] }

        let results = await withTaskGroup(of: [CrisisEvent].self) { group in
            for feed in feeds {
                group.addTask { [session] in
                    await Self.fetchFeed(feed: feed, session: session)
                }
            }

            var collected: [CrisisEvent] = []
            for await events in group {
                collected.append(contentsOf: events)
            }
            return collected
        }

        var deduped: [String: CrisisEvent] = [:]
        for event in results {
            deduped[event.id] = event
        }

        return deduped.values
            .sorted {
                if $0.date == $1.date {
                    return $0.id < $1.id
                }
                return $0.date > $1.date
            }
            .prefix(limit)
            .map { $0 }
    }

    private static func fetchFeed(feed: Feed, session: URLSession) async -> [CrisisEvent] {
        let candidateURLs = [feed.url] + feed.fallbackURLs

        for candidateURL in candidateURLs {
            do {
                let (data, response) = try await session.data(from: candidateURL)
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    continue
                }

                let parser = RSSFeedParser(data: data)
                let items = parser.parse()
                let events = items.compactMap { item in
                    mapItem(item, feed: feed)
                }

                if !events.isEmpty {
                    return events
                }
            } catch {
                continue
            }
        }

        return []
    }

    private static func mapItem(_ item: FeedItem, feed: Feed) -> CrisisEvent? {
        let title = item.title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let summary = NewsSourceHeuristics.stripHTML(item.summaryText)
        let combined = "\(title) \(summary)"

        guard NewsSourceHeuristics.looksGeopolitical(combined) else {
            return nil
        }

        let category = NewsSourceHeuristics.detectCategory(title: title, description: summary)
        let level = NewsSourceHeuristics.scoreThreatLevel(title: title, description: summary, category: category)
        let url = item.link?.trimmingCharacters(in: .whitespacesAndNewlines)
        let idSource = item.guid?.trimmingCharacters(in: .whitespacesAndNewlines)
            ?? url
            ?? item.title
            ?? UUID().uuidString

        return CrisisEvent(
            id: "rss:\(feed.id):\(NewsSourceHeuristics.hashString(idSource))",
            title: title.isEmpty ? summary : title,
            summary: summary.isEmpty ? (title.isEmpty ? feed.sourceLabel : title) : summary,
            category: category,
            level: level,
            location: nil,
            timestamp: parseTimestamp(item.timestampText),
            source: feed.sourceLabel,
            sourceTier: .public,
            url: url?.isEmpty == false ? url : nil,
            actor: NewsSourceHeuristics.extractActor(from: combined),
            entities: nil,
            newsSource: NewsSourceDescriptor(
                displayName: feed.sourceLabel,
                kind: feed.sourceKind,
                identity: feed.sourceIdentity,
                group: feed.sourceGroup,
                attribution: .direct,
                originalOutlet: feed.sourceLabel,
                domain: feed.domain
            )
        )
    }

    private static func parseTimestamp(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return NewsSourceHeuristics.oldTimestampFallback
        }

        let formats = [
            "EEE, dd MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX"
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

    static let defaultFeeds: [Feed] = [
        Feed(
            id: "reuters",
            url: URL(string: "https://feeds.reuters.com/Reuters/worldNews")!,
            sourceLabel: "Reuters",
            sourceKind: .wire
        ),
        Feed(
            id: "ap",
            url: URL(string: "https://rsshub.app/apnews/topics/world-news")!,
            fallbackURLs: [
                URL(string: "https://news.google.com/rss/search?q=site:apnews.com%20world&hl=en-US&gl=US&ceid=US:en")!
            ],
            sourceLabel: "AP News",
            sourceKind: .wire
        ),
        Feed(id: "bbc", url: URL(string: "https://feeds.bbci.co.uk/news/world/rss.xml")!, sourceLabel: "BBC News"),
        Feed(id: "nhk", url: URL(string: "https://www3.nhk.or.jp/rss/news/cat6.xml")!, sourceLabel: "NHK World"),
        Feed(id: "aljazeera", url: URL(string: "https://www.aljazeera.com/xml/rss/all.xml")!, sourceLabel: "Al Jazeera"),
        Feed(id: "dw", url: URL(string: "https://rss.dw.com/rdf/rss-en-top")!, sourceLabel: "DW"),
        Feed(id: "guardian-world", url: URL(string: "https://www.theguardian.com/world/rss")!, sourceLabel: "The Guardian"),
        Feed(id: "npr-world", url: URL(string: "https://feeds.npr.org/1004/rss.xml")!, sourceLabel: "NPR World"),
        Feed(id: "france24", url: URL(string: "https://www.france24.com/en/rss")!, sourceLabel: "France 24"),
        Feed(id: "un-news", url: URL(string: "https://news.un.org/feed/subscribe/en/news/all/rss.xml")!, sourceLabel: "UN News")
    ]
}

private final class RSSFeedParser: NSObject, XMLParserDelegate {
    private enum Field: String {
        case title
        case description
        case link
        case guid
        case pubDate
        case updated
        case summary
        case content
        case contentEncoded = "content:encoded"
        case date = "dc:date"
    }

    private enum LinkPriority: Int {
        case none = 0
        case fallback = 1
        case alternate = 2
    }

    private var items: [RSSNewsSource.FeedItem] = []
    private var currentItem: RSSNewsSource.FeedItem?
    private var currentField: Field?
    private var currentFieldDepth = 0
    private var currentText = ""

    private let parser: XMLParser

    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
        parser.shouldResolveExternalEntities = false
    }

    func parse() -> [RSSNewsSource.FeedItem] {
        guard parser.parse() else {
            return []
        }
        return items
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" || elementName == "entry" {
            currentItem = RSSNewsSource.FeedItem()
            currentField = nil
            currentFieldDepth = 0
            currentText = ""
            return
        }

        guard currentItem != nil else { return }

        if currentField != nil {
            currentFieldDepth += 1
            return
        }

        if elementName == "link" {
            let href = attributeDict["href"]?.trimmingCharacters(in: .whitespacesAndNewlines)
            let rel = attributeDict["rel"]?.lowercased()

            if let href, !href.isEmpty {
                let priority: LinkPriority = rel == "alternate" ? .alternate : .fallback
                updateLink(href, priority: priority)
                return
            }

            currentField = .link
            currentFieldDepth = 1
            currentText = ""
            return
        }

        if let field = Field(rawValue: elementName) {
            currentField = field
            currentFieldDepth = 1
            currentText = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard currentField != nil else { return }
        currentText += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard var item = currentItem else {
            return
        }

        if elementName == "item" || elementName == "entry" {
            items.append(item)
            currentItem = nil
            currentField = nil
            currentFieldDepth = 0
            currentText = ""
            return
        }

        guard let field = currentField else {
            return
        }

        if currentFieldDepth > 1 {
            currentFieldDepth -= 1
            return
        }

        guard field.rawValue == elementName else {
            return
        }

        let trimmed = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            switch field {
            case .title:
                item.title = trimmed
            case .description:
                item.description = trimmed
            case .summary:
                if item.description == nil { item.description = trimmed }
            case .content:
                if item.description == nil { item.description = trimmed }
            case .contentEncoded:
                if item.description == nil { item.description = trimmed }
            case .link:
                if item.linkPriority <= LinkPriority.fallback.rawValue {
                    item.link = trimmed
                    item.linkPriority = LinkPriority.fallback.rawValue
                }
            case .guid:
                item.guid = trimmed
            case .pubDate:
                item.pubDate = trimmed
            case .updated, .date:
                item.updated = trimmed
            }
        }

        currentItem = item
        currentField = nil
        currentFieldDepth = 0
        currentText = ""
    }

    private func updateLink(_ href: String, priority: LinkPriority) {
        guard var item = currentItem else { return }
        guard priority.rawValue >= item.linkPriority else { return }
        item.link = href
        item.linkPriority = priority.rawValue
        currentItem = item
    }
}
