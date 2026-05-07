import XCTest
@testable import CrisisMap

final class SourceTransparencyContentTests: XCTestCase {
    func testNewsSourcesIncludePrimaryMonitoredChannels() {
        let names = SourceTransparencyContent.newsSources.map(\.name)

        XCTAssertTrue(names.contains("Reuters"))
        XCTAssertTrue(names.contains("AP News"))
        XCTAssertTrue(names.contains("GDELT"))
        XCTAssertTrue(names.contains("X/Grok"))
    }

    func testResearchSourcesIncludeCurrentPolicyResearchCoverage() {
        let names = SourceTransparencyContent.researchSources.map(\.name)

        XCTAssertTrue(names.contains("Brookings"))
        XCTAssertTrue(names.contains("CSIS"))
        XCTAssertTrue(names.contains("RAND"))
        XCTAssertTrue(names.contains("USNI"))
    }

    func testLimitationsExplainCoverageIsNotComplete() {
        XCTAssertFalse(SourceTransparencyContent.limitations.isEmpty)
        XCTAssertTrue(
            SourceTransparencyContent.limitations.contains { limitation in
                limitation.localizationKey == "sourceTransparency.limit.coverage"
            }
        )
    }
}
