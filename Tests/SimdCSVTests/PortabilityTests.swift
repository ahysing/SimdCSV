//
//  PortabilityTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 03/04/2020.
//
#if !os(watchOS)
import XCTest
@testable import SimdCSV

final class PortabilityTests: XCTestCase {
    func testHamming() {
        let input_num :UInt64 = 0
        
        let result = hamming(input_num: input_num)
        
        XCTAssertEqual(0, result)
    }
    
    func testHammingInputIs1() {
        let input_num :UInt64 = 1
        
        let result = hamming(input_num: input_num)
        
        XCTAssertEqual(1, result)
    }

    func testHammingInputIs2() {
        let input_num :UInt64 = 2
        
        let result = hamming(input_num: input_num)
        
        XCTAssertEqual(1, result)
    }
    
    func testHammingInputIs3() {
        let input_num :UInt64 = 3
        
        let result = hamming(input_num: input_num)
        
        XCTAssertEqual(2, result)
    }

    func testCountLeadingZerosInputIsZero() {
        let result = countLeadingZeros(input_num: UInt64.min)
        XCTAssertEqual(64, result)
    }
    
    func testCountLeadingZeros() {
        let result = countLeadingZeros(input_num: UInt64.max)
        XCTAssertEqual(0, result)
    }
    
    func testTrailingZerosInputIsZero() {
        let result = trailingZeros(input_num: UInt64.min)
        XCTAssertEqual(64, result)
    }
    
    func testCountLeadingZerosSwift() {
        let result = countLeadingZerosSwift(input_num: UInt64.min)
        
        XCTAssertEqual(result, 64)
    }
    
    func testCountLeadingZerosSwiftInputIsMostSignificatBit() {
        let input = UInt64(1) << 63
        
        let result = countLeadingZerosSwift(input_num: input)
        
        XCTAssertEqual(result, 0)
    }
    
    func testCountLeadingZerosSwiftInputIsSecondMostSignificatBit() {
        let input = UInt64(1) << 62
        
        let result = countLeadingZerosSwift(input_num: input)
        
        XCTAssertEqual(result, 1)
    }
    
    func testCountLeadingZerosSwiftInputIs32BIt() {
        let input = UInt64(UInt32.max)
        
        let result = countLeadingZerosSwift(input_num: input)
        
        XCTAssertEqual(result, 32)
    }
    
    func testCountLeadingZerosSoftwareVersionEqualsSwiftVersion() {
        for i in 0...64 {
           let input = UInt64(i)
           
           let expected = countLeadingZerosSwift(input_num: input)
           let result = countLeadingZeros(input_num: input)
       
           XCTAssertEqual(expected, result)
       }
    }
    
    func testCountTrailingZerosSwiftInputIsOne() {
        let input = UInt64(1)
        
        let result = countTrailingZerosSwift(input_num: input)
              
        XCTAssertEqual(result, 0)
    }
    
    func testCountTrailingZerosSwiftInputIs32BIt() {
        let input = UInt64(UInt32.max) << 32
        
        let result = countTrailingZerosSwift(input_num: input)
              
        XCTAssertEqual(result, 32)
    }
    
    func testCountTrailingZerosSoftwareVersionEqualsSwiftVersion() {
        for i in 0...64 {
           let input = UInt64(i)
           
           let expected = countTrailingZerosSwift(input_num: input)
           let result = trailingZeros(input_num: input)
       
           XCTAssertEqual(expected, result)
       }
    }
    
    func testcountNumberOfBitsSwiftBuiltin() {
        let input = UInt64.max
        
        let result = countNumberOfBitsSwiftBuiltin(input_num: input)
        
        XCTAssertEqual(64, result)
    }
    
    func testcountNumberOfBitsSwiftBuiltinInputIsZero() {
        let input = UInt64(0)
        
        let result = countNumberOfBitsSwiftBuiltin(input_num: input)
        
        XCTAssertEqual(0, result)
    }
    
    func testcountNumberOfBitsSwiftBuiltinInputIsOne() {
        let input = UInt64(1)
        
        let result = countNumberOfBitsSwiftBuiltin(input_num: input)
        
        XCTAssertEqual(1, result)
    }

    func testcountNumberOfBitsSwiftBuiltinInputIsPowerOfTwo() {
        let input = UInt64(32)
        
        let result = countNumberOfBitsSwiftBuiltin(input_num: input)
        
        XCTAssertEqual(1, result)
    }
    
    
    func testcountNumberOfBitsSoftwareVersionEqualsSwiftVersion() {
        for i in 0...64 {
            let input = UInt64(i)
            
            let expected = countNumberOfBitsSwift(input_num: input)
            let result = countNumberOfBitsSwiftBuiltin(input_num: input)
        
            XCTAssertEqual(expected, result)
        }
    }
    
    static var allTests = [
        ("testHamming", testHamming),
        ("testHammingInputIs1", testHammingInputIs1),
        ("testHammingInputIs2", testHammingInputIs2),
        ("testHammingInputIs3", testHammingInputIs3),
        ("testCountLeadingZeros", testCountLeadingZeros),
        ("testCountLeadingZerosInputIsZero", testCountLeadingZerosInputIsZero),
        ("testTrailingZerosInputIsZero", testTrailingZerosInputIsZero),
        ("testCountLeadingZerosSwift", testCountLeadingZerosSwift),
        ("testCountLeadingZerosSwiftInputIs32BIt", testCountLeadingZerosSwiftInputIs32BIt),
        ("testCountTrailingZerosSwiftInputIsOne", testCountTrailingZerosSwiftInputIsOne),
        ("testCountTrailingZerosSwiftInputIs32BIt", testCountTrailingZerosSwiftInputIs32BIt)
    ]
}
#endif
