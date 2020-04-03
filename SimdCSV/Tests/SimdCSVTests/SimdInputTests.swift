//
//  SimdInputTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//
import XCTest
@testable import SimdCSV

import simd
final class SimdInputTests: XCTestCase {
    func testInit() {
        let _ = SimdInput(letters: SIMD64<Int8>.zero)
    }
    
    static var allTests = [
        ("testInit", testInit)
    ]
}
