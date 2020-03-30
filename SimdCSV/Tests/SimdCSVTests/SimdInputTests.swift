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
        let hi :simd.__m256i = SIMD4<Int64>()
        let lo :simd.__m256i = SIMD4<Int64>()
        let _ = SimdInput(lo:lo, hi:hi)
    }
    
    static var allTests = [
        ("testInit", testInit)
    ]
}
