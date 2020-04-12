//
//  ParseCSVTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 12/04/2020.
//


#if !os(watchOS)
import XCTest
@testable import SimdCSV

final class ParseCSVTests: XCTestCase {
    func testShrinkToFit() {
        // Arrange
        let indexes = Array<UInt32>(repeating: 0, count: 128)
        var parseCSV = ParseCSV.init(numberOfIndexes: 2, indexes: indexes, data: nil)
        
        // Act
        parseCSV.shrinkToFit()
        
        // Assert
        XCTAssertEqual(2, parseCSV.indexes.count)
    }
}

#endif
