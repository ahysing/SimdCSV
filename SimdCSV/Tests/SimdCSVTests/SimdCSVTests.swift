import XCTest
@testable import SimdCSV

final class SimdCSVTests: XCTestCase {
    func testCompilerSettings() {
        XCTAssertTrue(["neon", "x86_64"].contains(SimdCSV().compileSettings))
    }
    
    func testHasSIMD() {
       XCTAssertNotEqual(SimdCSV().hasSIMD, 0)
    }

    func testCmpMaskAgainstInput() {
        let input = SimdInput()
        let mask :UInt8 = 7
        let result = SimdCSV.cmpMaskAgainstInput(input:input, m: Int8(mask))
        
        XCTAssertEqual(result, 0)
    }
    
    static var allTests = [
        ("testCompilerSettings", testCompilerSettings),
        ("testHasSIMD", testHasSIMD)
    ]
}
