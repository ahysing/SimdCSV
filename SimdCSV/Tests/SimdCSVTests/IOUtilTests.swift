//
//  IOUtilTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//
import XCTest
import Foundation
@testable import SimdCSV

final class IOUtilTests: XCTestCase {
    func testGetCorpusFromBundledCSV() {
        /*
        let ioUtil = IOUtil()
        
        let url = URL(string:"file:///Ticket_to_Ride.csv", relativeTo: URL(string:"."))
        let result = try! ioUtil.getCorpus(filepath: url, padding:32)
        XCTAssertNotEqual(0, result.count)
         */
    }
    
    static var allTests = [
        ("testGetCorpusFromBundledCSV", testGetCorpusFromBundledCSV)
    ]
}
