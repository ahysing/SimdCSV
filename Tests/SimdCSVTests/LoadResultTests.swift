//
//  LoadResultTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 29/03/2020.
//
#if !os(watchOS)
import XCTest
@testable import SimdCSV

final class LoadResultTests: XCTestCase {
    func testLoadResultInit() {
        XCTAssertEqual(LoadResult(status: LoadStatus.ok).status, LoadStatus.ok)
    }

    static var allTests = [
        ("testLoadResultInit", testLoadResultInit)
    ]
}
#endif
