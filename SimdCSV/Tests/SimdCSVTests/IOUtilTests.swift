//
//  IOUtilTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//
import XCTest
@testable import IOUtil

final class IOUtilTests: XCTestCase {
    func testGetCorpus() {
        let ioUtil = IOUtil()
        try! ioUtil.getCorpus(nil)
    }
    
    func testGetCorpusFromBundledCSV() {
        let ioUtil = IOUtil()
        
        let url = try! Bundle.myResourceBundle().URLForResource("Ticket_to_Ride", ofType: "csv")
        try! ioUtil.getCorpus(url)
    }
    
    static var allTests = [
        ("testGetCorpus", testGetCorpus),
        ("testGetCorpusFromBundledCSV", testGetCorpusFromBundledCSV)
    ]
}
