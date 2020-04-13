//
//  DumperTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 09/04/2020.
//
#if !os(watchOS)
import XCTest
@testable import SimdCSV

final class DumperTests: XCTestCase {
    func testDumpInMemory_doesNotCrash() {
        let text = "Header,Header2\n"
        let data = text.data(using: .utf8)

        // .H...r.H....2
        let indexes = [UInt32(0), UInt32(7)]
        let indexEnds = [UInt32(6), UInt32(14)]

        let pcsv = ParseCSV(data: data, indexEnds: indexEnds, indices: indexes)
        let dumper = Dumper.init()
        let result = LoadResult(status: LoadStatus.OK, csv: pcsv)

        // This line resolves in a crash
        dumper.dump(loadResult: result)

        XCTAssert(true)
    }

    func testDump_InputIsCSVWithDoubleQuotes() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!

        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)
        let dumper = Dumper.init()
        dumper.dump(loadResult: result)
    }

}

#endif
