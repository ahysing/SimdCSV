//
//  IOUtilTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//
#if !os(watchOS)

import XCTest
import Foundation
@testable import SimdCSV
/*
final class IOUtilTests: XCTestCase {
    func testGetCorpusFromBundledCSV() {
        let ioUtil = IOUtil()
        if let filepath = Bundle.main.path(forResource: "Tickets_to_ride", ofType: "csv") {
            // do {
                let url = URL(string:filepath)
            
                let result = try! ioUtil.getCorpus(filepath: url, padding:32)
            
                XCTAssertNotEqual(0, result.count)
            // } catch {
            //     XCTAssertTrue(false, "Failed to load Ticket_to_Ride.csv.")
            // }
        } else {
            XCTAssertTrue(false, "Failed to load Ticket_to_Ride.csv.")
        }
    }
    
    static var allTests = [
        ("testGetCorpusFromBundledCSV", testGetCorpusFromBundledCSV)
    ]

}
 */
#endif // !os(watchOS)
