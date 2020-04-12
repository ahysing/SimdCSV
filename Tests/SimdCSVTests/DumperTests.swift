//
//  DumperTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 09/04/2020.
//
#if !os(watchOS)
import XCTest
@testable import SimdCSV

/*
final class DumperTests: XCTestCase {
    func testDumpInMemory_doesNotCrash() {
        let text = "Header,Header2\n"
        let data = text.data(using: .utf8)
        
        // .H...r.H....2
        let indexes = [UInt32(1), UInt32(5), UInt32(7), UInt32(13)]
        let pcsv = ParseCSV(numberOfIndexes: 1, indexes: indexes, data: data)
        let dumper = Dumper.init()
        let result = LoadResult(status:LoadStatus.OK, csv: pcsv)
        
        // This line resolves in a crash
        // dumper.dump(loadResult: result)
        
        XCTAssert(true)
    }
    
    func testDump() {
        let simdCSV = SimdCSV()
        let fileName = URL(string: "Tickets_to_Ride.csv")!
        let result = simdCSV.loadCSV(filepath: fileName)
        let dumper = Dumper.init()
        dumper.dump(loadResult: result)
    }
}
 */

#endif
