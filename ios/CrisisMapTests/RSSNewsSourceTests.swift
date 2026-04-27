import Foundation
import XCTest
@testable import CrisisMap

final class RSSNewsSourceTests: XCTestCase {
    func testMapsReutersItemToCrisisEvent() async throws {
        let feedURL = URL(string: "https://feeds.reuters.com/Reuters/worldNews")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>Missile strike raises tensions near Tehran</title>
                  <description><![CDATA[<p>Officials report a military escalation after the latest attack.</p>]]></description>
                  <link>https://example.com/reuters-1</link>
                  <guid>reuters-1</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "reuters",
                    url: feedURL,
                    sourceLabel: "Reuters"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.source, "Reuters")
        XCTAssertEqual(events.first?.sourceTier, .public)
        XCTAssertEqual(events.first?.url, "https://example.com/reuters-1")
        XCTAssertEqual(events.first?.summary, "Officials report a military escalation after the latest attack.")
    }

    func testMapsRSSItemWithDirectStructuredSource() async throws {
        let feedURL = URL(string: "https://feeds.reuters.com/Reuters/worldNews")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>Missile strike raises tensions near Tehran</title>
                  <description><![CDATA[<p>Officials report a military escalation after the latest attack.</p>]]></description>
                  <link>https://www.reuters.com/world/example-1</link>
                  <guid>reuters-1</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "reuters",
                    url: feedURL,
                    sourceLabel: "Reuters"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.newsSource?.kind, .wire)
        XCTAssertEqual(events.first?.newsSource?.identity, "reuters")
        XCTAssertEqual(events.first?.newsSource?.group, "reuters")
        XCTAssertEqual(events.first?.newsSource?.attribution, .direct)
        XCTAssertEqual(events.first?.newsSource?.displayName, "Reuters")
    }

    func testSkipsItemsWithoutGeopoliticalKeywords() async throws {
        let feedURL = URL(string: "https://feeds.bbci.co.uk/news/world/rss.xml")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>City unveils new arts festival lineup</title>
                  <description>Organisers expect a record turnout this summer.</description>
                  <link>https://example.com/bbc-1</link>
                  <guid>bbc-1</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "bbc",
                    url: feedURL,
                    sourceLabel: "BBC News"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertTrue(events.isEmpty)
    }

    func testMapsAtomEntryWithAlternateLinkAndUpdatedTimestamp() async throws {
        let feedURL = URL(string: "https://example.com/atom.xml")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <feed xmlns="http://www.w3.org/2005/Atom">
              <entry>
                <title>iran warns of response after strike</title>
                <summary>Officials report a military escalation after the latest attack.</summary>
                <link rel="self" href="https://example.com/self"/>
                <link rel="alternate" href="https://example.com/atom-1"/>
                <updated>2026-03-18T08:00:00Z</updated>
                <id>tag:example.com,2026:atom-1</id>
              </entry>
            </feed>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "atom",
                    url: feedURL,
                    sourceLabel: "Example Atom"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.url, "https://example.com/atom-1")
        XCTAssertEqual(events.first?.timestamp, "2026-03-18T08:00:00Z")
        XCTAssertEqual(events.first?.actor, "Iran")
    }

    func testPreservesNestedHtmlInDescription() async throws {
        let feedURL = URL(string: "https://example.com/rss.xml")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>Missile strike raises tensions near Tehran</title>
                  <description>Officials <em>report</em> a military escalation after the latest attack.</description>
                  <link>https://example.com/rss-1</link>
                  <guid>rss-1</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "rss",
                    url: feedURL,
                    sourceLabel: "Example RSS"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.summary, "Officials report a military escalation after the latest attack.")
    }

    func testParsesContentEncodedField() async throws {
        let feedURL = URL(string: "https://example.com/content.xml")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">
              <channel>
                <item>
                  <title>Missile strike raises tensions near Tehran</title>
                  <content:encoded><![CDATA[<p>Officials report a military escalation after the latest attack.</p>]]></content:encoded>
                  <link>https://example.com/content-1</link>
                  <guid>content-1</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "content",
                    url: feedURL,
                    sourceLabel: "Example Content"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.summary, "Officials report a military escalation after the latest attack.")
    }

    func testOldFallbackTimestampDoesNotRiseToTop() async throws {
        let feedURL = URL(string: "https://example.com/timestamps.xml")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>Missile strike near Tehran with missing date</title>
                  <description>Officials report a military escalation after the latest attack.</description>
                  <link>https://example.com/old</link>
                  <guid>old</guid>
                </item>
                <item>
                  <title>Missile strike near Tehran with valid date</title>
                  <description>Officials report a military escalation after the latest attack.</description>
                  <link>https://example.com/new</link>
                  <guid>new</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "timestamps",
                    url: feedURL,
                    sourceLabel: "Example Timestamps"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first?.url, "https://example.com/new")
        XCTAssertEqual(events.last?.url, "https://example.com/old")
    }

    func testSkipsSubstringFalsePositiveKeywords() async throws {
        let feedURL = URL(string: "https://example.com/false-positive.xml")!
        let session = makeSession(xmlByURL: [
            feedURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>Wardrobe sale at the supermarket</title>
                  <description>Seasonal discounts and new arrivals.</description>
                  <link>https://example.com/false-positive</link>
                  <guid>false-positive</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "false-positive",
                    url: feedURL,
                    sourceLabel: "Example False Positive"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertTrue(events.isEmpty)
    }

    func testUsesFallbackURLWhenPrimaryFeedFails() async throws {
        let primaryURL = URL(string: "https://example.com/primary.xml")!
        let fallbackURL = URL(string: "https://example.com/fallback.xml")!
        let session = makeSession(xmlByURL: [
            fallbackURL: """
            <rss version="2.0">
              <channel>
                <item>
                  <title>Iran military escalation raises regional tensions</title>
                  <description>Officials report a missile threat near the Gulf.</description>
                  <link>https://example.com/fallback-1</link>
                  <guid>fallback-1</guid>
                  <pubDate>Tue, 18 Mar 2026 08:00:00 GMT</pubDate>
                </item>
              </channel>
            </rss>
            """
        ])
        let source = RSSNewsSource(
            session: session,
            feeds: [
                RSSNewsSource.Feed(
                    id: "ap",
                    url: primaryURL,
                    fallbackURLs: [fallbackURL],
                    sourceLabel: "AP News"
                )
            ]
        )

        let events = try await source.fetch(limit: 10)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.url, "https://example.com/fallback-1")
        XCTAssertEqual(events.first?.source, "AP News")
    }

    private func makeSession(xmlByURL: [URL: String]) -> URLSession {
        MockURLProtocol.responses = xmlByURL
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

private final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var responses: [URL: String] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard
            let url = request.url,
            let xml = Self.responses[url],
            let data = xml.data(using: .utf8)
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/rss+xml"]
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
