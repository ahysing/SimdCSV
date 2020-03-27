import XCTest
@testable import SimdCSV

final class SimdCSVTests: XCTestCase {
    func testCompilerSettings() {
        XCTAssertEqual(SimdCSV().compileSettings, "neon")
    }
    
    func testHasSIMD() {
       XCTAssertNotEqual(SimdCSV().hasSIMD, 0)
    }

    static var allTests = [
        ("testCompilerSettings", testCompilerSettings),
        ("testHasSIMD", testHasSIMD)
    ]
}
