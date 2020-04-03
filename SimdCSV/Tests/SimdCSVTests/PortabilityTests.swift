//
//  PortabilityTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 03/04/2020.
//

import XCTest
@testable import SimdCSV

final class PortabilityTests: XCTestCase {
    func testHamming() {
        let input_num :UInt64 = 0
        
        let _ = hamming(input_num: input_num)
        
        XCTAssertTrue(true)
    }
    
    static var allTests = [
        ("testHamming", testHamming)
    ]
}
