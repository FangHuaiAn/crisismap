import Foundation
import XCTest
@testable import CrisisMap

final class GDELTNewsSourceTests: XCTestCase {
    func testMapsArticleToCrisisEvent() async throws {
        let session = makeSession(json: """
        {
          "articles": [
            {
              "url": "https://example.com/gdelt-1",
              "title": "Missile strike raises tensions near Tehran",
              "seendate": "20260318T110000Z",
              "domain": "example.com",
              "language": "en",
              "sourcecountry": "IR"
            }
          ]
        }
        """)

        let source = GDELTNewsSource(session: session)

        let events = try await source.fetch(limit: 5)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.source, "GDELT")
        XCTAssertEqual(events.first?.sourceTier, .public)
        XCTAssertEqual(events.first?.url, "https://example.com/gdelt-1")
        XCTAssertEqual(events.first?.title, "Missile strike raises tensions near Tehran")
        XCTAssertEqual(events.first?.timestamp, "2026-03-18T11:00:00Z")
        XCTAssertNil(events.first?.actor)
    }

    func testMapsGDELTArticleWithDerivedOutletMetadata() async throws {
        let session = makeSession(json: """
        {
          "articles": [
            {
              "url": "https://example.com/gdelt-1",
              "title": "Missile strike raises tensions near Tehran",
              "seendate": "20260318T110000Z",
              "domain": "example.com",
              "language": "en",
              "sourcecountry": "US"
            }
          ]
        }
        """)

        let source = GDELTNewsSource(session: session)

        let events = try await source.fetch(limit: 5)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.newsSource?.kind, .aggregator)
        XCTAssertEqual(events.first?.newsSource?.attribution, .derived)
        XCTAssertEqual(events.first?.newsSource?.domain, "example.com")
        XCTAssertEqual(events.first?.newsSource?.languageCode, "en")
        XCTAssertEqual(events.first?.newsSource?.originCountry, "US")
        XCTAssertEqual(events.first?.newsSource?.identity, "gdelt:example.com")
    }

    func testAllowsArticlesWhenUnusedFieldsAreMissing() async throws {
        let session = makeSession(json: """
        {
          "articles": [
            {
              "url": "https://example.com/gdelt-1",
              "title": "Missile strike raises tensions near Tehran",
              "seendate": "20260318T110000Z"
            },
            {
              "url": "https://example.com/gdelt-2",
              "title": "Military buildup reported near border",
              "seendate": "20260318T100000Z",
              "language": "en"
            }
          ]
        }
        """)

        let source = GDELTNewsSource(session: session)

        let events = try await source.fetch(limit: 5)

        XCTAssertEqual(events.map(\.id).count, 2)
        XCTAssertEqual(events.map(\.url), ["https://example.com/gdelt-1", "https://example.com/gdelt-2"])
    }

    private func makeSession(json: String) -> URLSession {
        MockURLProtocol.responseData = Data(json.utf8)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

private final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var responseData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let data = Self.responseData else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        let url = request.url ?? URL(string: "https://api.gdeltproject.org")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
