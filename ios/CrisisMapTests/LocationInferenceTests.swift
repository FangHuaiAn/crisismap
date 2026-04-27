import XCTest
@testable import CrisisMap

final class LocationInferenceTests: XCTestCase {
    func testPrefersPhysicalLocationOverActorKeyword() {
        let result = LocationInference.infer(
            title: "What's driving attacks against gov't and Russian forces in Mali?",
            summary: "Russian personnel remain exposed to attacks in Mali.",
            providedLocation: nil
        )

        XCTAssertEqual(result?.location.name, "Mali")
        XCTAssertEqual(result?.location.country, "ML")
        XCTAssertEqual(result?.region, .africa)
    }

    func testReturnsNilWhenNoReliableLocationExists() {
        let result = LocationInference.infer(
            title: "NATO governments review support timelines",
            summary: "Security planning remains active.",
            providedLocation: nil
        )

        XCTAssertNil(result)
    }
}
