//
//  SimdInputTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//
#if !os(watchOS)

import XCTest
@testable import SimdCSV

import simd
final class SimdInputTests: XCTestCase {
    func testInit() {
        let _ = SimdInput(letters: SIMD64<UInt8>.zero)
    }
    
    static var allTests = [
        ("testInit", testInit)
    ]
}

#endif
