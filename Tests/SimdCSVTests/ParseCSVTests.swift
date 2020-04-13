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
        let indexEnds = Array<UInt32>(repeating: 0, count: 128)
        var parseCSV = ParseCSV.init(numberOfIndexes: 2, indices: indexes, indexEnds: indexEnds, data: nil)

        // Act
        parseCSV.shrinkToFit()

        // Assert
        XCTAssertEqual(2, parseCSV.indices.count)
    }

    func testShrinkToFit_InputIsHardCase() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        result.csv.shrinkToFit()
    }

    func test_getCellRemoveQuotes() {
        let simdCSV = SimdCSV()
        let text = "\"Tyler, The Creator\",1991\r\n" +
                 "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell = result.csv.getCellRemoveQuotes(idx: 0)

        XCTAssertEqual("Tyler, The Creator", cell)
    }

    func test_getCellRemoveQuotes_InputLacksQuotes() {
        let simdCSV = SimdCSV()
        let text = "\"Tyler, The Creator\",1991\r\n" +
                 "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell = result.csv.getCellRemoveQuotes(idx: 1)

        XCTAssertEqual("1991", cell)
    }

    func test_getCell() {
        let simdCSV = SimdCSV()
        let text = "\"Tyler, The Creator\",1991\r\n" +
                 "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell = result.csv.getCell(idx: 0)

        XCTAssertEqual("\"Tyler, The Creator\"", cell)
    }
}

#endif
