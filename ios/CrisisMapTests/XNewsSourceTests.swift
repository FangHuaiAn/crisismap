import Foundation
import XCTest
@testable import CrisisMap

final class XNewsSourceTests: XCTestCase {
    func testDisablesWithoutCredentialsUsingEmptyEnvironment() {
        let source = XNewsSource(configuration: .init(environment: [:]))

        XCTAssertFalse(source.isEnabled)
    }

    func testPrefersXRecentSearchAndNormalizesRecentSearchOutput() async throws {
        let session = makeSession { request in
            if request.url?.host == "api.x.com" {
                return .json(
                    """
                    {
                      "data": [
                        {
                          "id": "1841260000000000001",
                          "text": "Daily team update on maintenance work",
                          "created_at": "2026-03-18T11:00:00Z",
                          "author_id": "99"
                        }
                      ],
                      "includes": {
                        "users": [
                          {
                            "id": "99",
                            "username": "newsdesk"
                          }
                        ]
                      }
                    }
                    """
                )
            }

            XCTFail("Unexpected request to \(request.url?.absoluteString ?? "nil")")
            return .failure
        }

        let source = XNewsSource(
            configuration: .init(xBearerToken: "token", xaiAPIKey: "xai-key", environment: [:]),
            session: session
        )

        let events = try await source.fetch(limit: 5)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.url, "https://x.com/i/status/1841260000000000001")
        XCTAssertEqual(events.first?.source, "x:@newsdesk")
        XCTAssertEqual(events.first?.category, .statement)
        XCTAssertEqual(events.first?.level, .info)
        XCTAssertNotEqual(events.first?.category, .conflict)
        XCTAssertEqual(MockURLProtocol.requests.map { $0.url?.host }, ["api.x.com"])
        XCTAssertEqual(
            queryItem(named: "query"),
            "(from:DeItaone OR from:BNONews OR from:disclosetv) (Iran OR strike OR nuclear OR military OR missile OR conflict)"
        )
    }

    func testMapsXEventWithHandleIdentityAndPlatformGroup() async throws {
        let session = makeSession { request in
            if request.url?.host == "api.x.com" {
                return .json(
                    """
                    {
                      "data": [
                        {
                          "id": "1841260000000000001",
                          "text": "Missile strike update from monitored account",
                          "created_at": "2026-03-18T11:00:00Z",
                          "author_id": "99"
                        }
                      ],
                      "includes": {
                        "users": [
                          {
                            "id": "99",
                            "username": "BNONews"
                          }
                        ]
                      }
                    }
                    """
                )
            }

            XCTFail("Unexpected request to \(request.url?.absoluteString ?? "nil")")
            return .failure
        }

        let source = XNewsSource(
            configuration: .init(xBearerToken: "token", xaiAPIKey: nil, environment: [:]),
            session: session
        )

        let events = try await source.fetch(limit: 5)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.newsSource?.kind, .social)
        XCTAssertEqual(events.first?.newsSource?.group, "x")
        XCTAssertEqual(events.first?.newsSource?.identity, "x:bnonews")
        XCTAssertEqual(events.first?.newsSource?.authorHandle, "@BNONews")
        XCTAssertEqual(events.first?.newsSource?.attribution, .direct)
    }

    func testCapsXApiRequestAtTenResults() async throws {
        let session = makeSession { request in
            if request.url?.host == "api.x.com" {
                return .json(
                    """
                    {
                      "data": [],
                      "includes": {
                        "users": []
                      }
                    }
                    """
                )
            }

            XCTFail("Unexpected request to \(request.url?.absoluteString ?? "nil")")
            return .failure
        }

        let source = XNewsSource(
            configuration: .init(xBearerToken: "token", xaiAPIKey: nil, environment: [:]),
            session: session
        )

        let events = try await source.fetch(limit: 50)

        XCTAssertTrue(events.isEmpty)
        XCTAssertEqual(queryItem(named: "max_results"), "10")
        XCTAssertEqual(MockURLProtocol.requests.map { $0.url?.host }, ["api.x.com"])
    }

    func testFallsBackToGrokWhenXAPIReturnsNoTweetsAndXAIKeyExists() async throws {
        let session = makeSession { request in
            if request.url?.host == "api.x.com" {
                return .json(
                    """
                    {
                      "data": [],
                      "includes": {
                        "users": []
                      }
                    }
                    """
                )
            }

            if request.url?.host == "api.x.ai" {
                return .json(
                    #"""
                    {
                      "output": [
                        {
                          "type": "message",
                          "content": [
                            {
                              "type": "output_text",
                              "text": "[{\"text\":\"Grok confirms escalation\",\"author\":\"@grokdesk\",\"time\":\"2026-03-18T12:00:00Z\",\"url\":\"https://x.com/i/status/999\"}]"
                            }
                          ]
                        }
                      ]
                    }
                    """#
                )
            }

            XCTFail("Unexpected request to \(request.url?.absoluteString ?? "nil")")
            return .failure
        }

        let source = XNewsSource(
            configuration: .init(xBearerToken: "token", xaiAPIKey: "xai-key", environment: [:]),
            session: session
        )

        let events = try await source.fetch(limit: 50)

        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.title, "Grok confirms escalation")
        XCTAssertEqual(events.first?.url, "https://x.com/i/status/999")
        XCTAssertEqual(events.first?.source, "x:@grokdesk")
        XCTAssertEqual(events.first?.category, .statement)
        XCTAssertEqual(events.first?.level, .low)
        XCTAssertEqual(MockURLProtocol.requests.map { $0.url?.host }, ["api.x.com", "api.x.ai"])
    }

    func testXApiUsesMinimumAllowedRequestSizeButStillTrimsOutput() async throws {
        let session = makeSession { request in
            if request.url?.host == "api.x.com" {
                return .json(
                    """
                    {
                      "data": [
                        {
                          "id": "1841260000000000001",
                          "text": "First update",
                          "created_at": "2026-03-18T11:00:00Z",
                          "author_id": "99"
                        },
                        {
                          "id": "1841260000000000002",
                          "text": "Second update",
                          "created_at": "2026-03-18T10:59:00Z",
                          "author_id": "99"
                        }
                      ],
                      "includes": {
                        "users": [
                          {
                            "id": "99",
                            "username": "newsdesk"
                          }
                        ]
                      }
                    }
                    """
                )
            }

            XCTFail("Unexpected request to \(request.url?.absoluteString ?? "nil")")
            return .failure
        }

        let source = XNewsSource(
            configuration: .init(xBearerToken: "token", xaiAPIKey: nil, environment: [:]),
            session: session
        )

        let events = try await source.fetch(limit: 1)

        XCTAssertEqual(events.map(\.id).count, 1)
        XCTAssertEqual(queryItem(named: "max_results"), "10")
    }

    func testConfigurationPrefersInjectedValuesOverEnvironment() {
        let config = XNewsSource.Configuration(
            xBearerToken: "injected-token",
            xaiAPIKey: nil,
            environment: [
                "X_BEARER_TOKEN": "env-token",
                "XAI_API_KEY": "env-xai"
            ]
        )

        XCTAssertEqual(config.xBearerToken, "injected-token")
        XCTAssertEqual(config.xaiAPIKey, "env-xai")
    }

    private func makeSession(handler: @escaping (URLRequest) -> MockResponse) -> URLSession {
        MockURLProtocol.handler = handler
        MockURLProtocol.requests = []

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    private func queryItem(named name: String) -> String? {
        guard let url = MockURLProtocol.requests.last?.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        return components.queryItems?.first(where: { $0.name == name })?.value
    }
}

private struct MockResponse {
    let statusCode: Int
    let headers: [String: String]
    let data: Data

    static var failure: MockResponse {
        .init(statusCode: 500, headers: [:], data: Data())
    }

    static func json(_ body: String) -> MockResponse {
        .init(
            statusCode: 200,
            headers: ["Content-Type": "application/json"],
            data: Data(body.utf8)
        )
    }
}

private final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var handler: ((URLRequest) -> MockResponse)?
    nonisolated(unsafe) static var requests: [URLRequest] = []

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.requests.append(request)

        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        let response = handler(request)
        let url = request.url ?? URL(string: "https://api.x.com")!
        let http = HTTPURLResponse(
            url: url,
            statusCode: response.statusCode,
            httpVersion: nil,
            headerFields: response.headers
        )!
        client?.urlProtocol(self, didReceive: http, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: response.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
