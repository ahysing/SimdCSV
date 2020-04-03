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
        let input = SimdInput(letters: SIMD64<Int8>.zero)
        let mask :UInt8 = 7
        let result = SimdCSV.cmpMaskAgainstInput(input:input, m: Int8(mask))
        
        XCTAssertEqual(result, 0)
    }
    
    fileprivate static let comma = Int8(Array("\"".utf8)[0])
    
    func testCmpMaskAgainstInputIsRepeatingComma() {
        let input = SimdInput(letters: SIMD64<Int8>(repeating:SimdCSVTests.comma))
        let mask = SimdCSVTests.comma
        let result = SimdCSV.cmpMaskAgainstInput(input:input, m: Int8(mask))
        
        XCTAssertNotEqual(0, result)
    }
    
    
    func testCmpMaskAgainstInputIsCommaInPosition0() {
        var input = SimdInput(letters: SIMD64<Int8>.zero)
        input.letters[0] = SimdCSVTests.comma
        let mask = SimdCSVTests.comma
        let result = SimdCSV.cmpMaskAgainstInput(input:input, m: mask)
        
        XCTAssertEqual(1, result)
    }
    
    func testCmpMaskAgainstInputIsCommaInPosition0And1() {
        var input = SimdInput(letters: SIMD64<Int8>.zero)
        input.letters[0] = SimdCSVTests.comma
        input.letters[1] = SimdCSVTests.comma
        let mask = SimdCSVTests.comma
        let result = SimdCSV.cmpMaskAgainstInput(input:input, m: mask)
        
        XCTAssertEqual(3, result)
    }
    
    static var allTests = [
        ("testCompilerSettings", testCompilerSettings),
        ("testCmpMaskAgainstInputIsRepeatingComma", testCmpMaskAgainstInputIsRepeatingComma),
        ("testCmpMaskAgainstInputIsCommaInPosition0", testCmpMaskAgainstInputIsCommaInPosition0),
        ("testCmpMaskAgainstInputIsCommaInPosition0And1", testCmpMaskAgainstInputIsCommaInPosition0And1),
        ("testHasSIMD", testHasSIMD)
    ]
}
