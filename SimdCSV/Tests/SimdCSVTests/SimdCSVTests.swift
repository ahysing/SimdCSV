import XCTest
@testable import SimdCSV

final class SimdCSVTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SimdCSV().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
