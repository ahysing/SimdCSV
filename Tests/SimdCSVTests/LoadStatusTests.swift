//
//  LoadStatusTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//
#if !os(watchOS)
import XCTest
@testable import SimdCSV

final class LoadStatusTests: XCTestCase {
    func testSturctHasOK() {
        XCTAssertEqual(LoadStatus.ok, LoadStatus.ok)
    }
    
    func testSturctHasFailed() {
        XCTAssertEqual(LoadStatus.failed, LoadStatus.failed)
    }

    static var allTests = [
        ("testSturctHasOK", testSturctHasOK),
        ("testSturctHasFailed", testSturctHasFailed)
    ]
}
#endif
