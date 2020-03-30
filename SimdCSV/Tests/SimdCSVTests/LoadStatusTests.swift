//
//  LoadStatusTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//

import XCTest
@testable import SimdCSV

final class LoadStatusTests: XCTestCase {
    func testSturctHasOK() {
        XCTAssertEqual(LoadStatus.OK, LoadStatus.OK)
    }
    func testSturctHasFailed() {
        XCTAssertEqual(LoadStatus.Failed, LoadStatus.Failed)
    }
    
    static var allTests = [
        ("testSturctHasOK", testSturctHasOK),
        ("testSturctHasFailed", testSturctHasFailed)
    ]
}
