#if !os(watchOS)
import XCTest
@testable import SimdCSV

@available(tvOS 10.0, watchOS 3.0, iOS 10.0, macOS 10.0, *)
final class SimdCSVTests: XCTestCase {
    func testCompilerSettings() {
        XCTAssertTrue(["neon", "x86_64"].contains(SimdCSV().compileSettings))
        XCTAssertNotEqual(SimdCSV().hasSIMD, 0)
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
    
    func testFillInput() {
        let values = UnsafeMutablePointer<Int8>.allocate(capacity: 64)
        for value in 0...63 {
            values[value] = Int8(value)
        }
        
        let simdInput = SimdCSV.fillInput(ptr: values)

        let result = simdInput.letters
        XCTAssertEqual(0, result[0])
        XCTAssertEqual(1, result[1])
        XCTAssertEqual(2, result[2])
        XCTAssertEqual(3, result[3])
        XCTAssertEqual(4, result[4])
        XCTAssertEqual(5, result[5])
        XCTAssertEqual(6, result[6])
        XCTAssertEqual(7, result[7])
        XCTAssertEqual(8, result[8])
        XCTAssertEqual(9, result[9])
        XCTAssertEqual(10, result[10])
        XCTAssertEqual(11, result[11])
        XCTAssertEqual(12, result[12])
        XCTAssertEqual(13, result[13])
        XCTAssertEqual(14, result[14])
        XCTAssertEqual(15, result[15])
        XCTAssertEqual(16, result[16])
        XCTAssertEqual(17, result[17])
        XCTAssertEqual(18, result[18])
        XCTAssertEqual(19, result[19])
        XCTAssertEqual(20, result[20])
        XCTAssertEqual(21, result[21])
        XCTAssertEqual(22, result[22])
        XCTAssertEqual(23, result[23])
        XCTAssertEqual(24, result[24])
        XCTAssertEqual(25, result[25])
        XCTAssertEqual(26, result[26])
        XCTAssertEqual(27, result[27])
        XCTAssertEqual(28, result[28])
        XCTAssertEqual(29, result[29])
        XCTAssertEqual(30, result[30])
        XCTAssertEqual(31, result[31])
        XCTAssertEqual(32, result[32])
        XCTAssertEqual(33, result[33])
        XCTAssertEqual(34, result[34])
        XCTAssertEqual(35, result[35])
        XCTAssertEqual(36, result[36])
        XCTAssertEqual(37, result[37])
        XCTAssertEqual(38, result[38])
        XCTAssertEqual(39, result[39])
        XCTAssertEqual(40, result[40])
        XCTAssertEqual(41, result[41])
        XCTAssertEqual(42, result[42])
        XCTAssertEqual(43, result[43])
        XCTAssertEqual(44, result[44])
        XCTAssertEqual(45, result[45])
        XCTAssertEqual(46, result[46])
        XCTAssertEqual(47, result[47])
        XCTAssertEqual(48, result[48])
        XCTAssertEqual(49, result[49])
        XCTAssertEqual(50, result[50])
        XCTAssertEqual(51, result[51])
        XCTAssertEqual(52, result[52])
        XCTAssertEqual(53, result[53])
        XCTAssertEqual(54, result[54])
        XCTAssertEqual(55, result[55])
        XCTAssertEqual(56, result[56])
        XCTAssertEqual(57, result[57])
        XCTAssertEqual(58, result[58])
        XCTAssertEqual(59, result[59])
        XCTAssertEqual(60, result[60])
        XCTAssertEqual(61, result[61])
        XCTAssertEqual(62, result[62])
        XCTAssertEqual(63, result[63])
    }
    
    func testFlatternBits() {
        let values = UnsafeMutablePointer<Int8>.allocate(capacity: 64)
        for value in 0...63 {
            values[value] = Int8(value)
        }
        var base = Int()
        let idx = UInt32()
        let b = UInt64(64)
        
        SimdCSV.flatternBits(basePtrRaw:values, base:&base, idx:idx, b:b)
        
        XCTAssertNotEqual(Int(), base)
    }
    
    static var allTests = [
        ("testCompilerSettings", testCompilerSettings),
        ("testCmpMaskAgainstInputIsRepeatingComma", testCmpMaskAgainstInputIsRepeatingComma),
        ("testCmpMaskAgainstInputIsCommaInPosition0", testCmpMaskAgainstInputIsCommaInPosition0),
        ("testCmpMaskAgainstInputIsCommaInPosition0And1", testCmpMaskAgainstInputIsCommaInPosition0And1),
        ("testFlatternBits", testFlatternBits),
        ("testHasSIMD", testHasSIMD)
    ]
}
#endif
