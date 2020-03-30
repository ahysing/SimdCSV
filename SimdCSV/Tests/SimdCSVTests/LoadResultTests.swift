//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 29/03/2020.
//

import XCTest
@testable import LoadResult

final class LoadResultTests: XCTestCase {
    func testLoadResultInit() {
        XCTAssertEqual(LoadResult(LoadStatus.OK), LoadStatus.OK)
    }
    
    static var allTests = [
        ("testLoadResultInit", testLoadResultInit)
    ]
}
