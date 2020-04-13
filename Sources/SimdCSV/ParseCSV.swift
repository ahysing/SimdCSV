//
//  ParseCSV.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

public struct ParseCSV {
    public var CRLF: Bool = false
    public var data: Data! = nil
    public var indexEnds: [UInt32]! = []
    public var indices: [UInt32]! = []
    public var numberOfColumns: UInt32 = 0
    public var numberOfIndexes: size_t = 0
    
    public init(CRLF: Bool = false,
                data: Data! = nil,
                indexEnds: [UInt32]! = [],
                indices: [UInt32]! = [],
                numberOfColumns: UInt32 = 0,
                numberOfIndexes: size_t = 0) {
        self.CRLF = CRLF
        self.data = data
        self.indexEnds = indexEnds
        self.indices = indices
        self.numberOfColumns = numberOfColumns
        self.numberOfIndexes = numberOfIndexes
    }
    
    public mutating func shrinkToFit() {
        let oversized = indices.count - numberOfIndexes
        self.indices.removeLast(oversized)
        let oversizedEnds = indexEnds.count - numberOfIndexes
        self.indexEnds.removeLast(oversizedEnds)
    }
    
    public func getCell(idx: Int) -> String {
        let start = Data.Index(self.indices[idx])
        let end = Data.Index(self.indexEnds[idx])
        let range = start..<end
        let textblock = self.data.subdata(in: range)
        return String(decoding: textblock, as: UTF8.self)
    }
    
    fileprivate static let quote = Array("\"".utf8)[0]
    public func getCellRemoveQuotes(idx: Int) -> String {
        var start = Data.Index(self.indices[idx])
        var end = Data.Index(self.indexEnds[idx])
        if self.data[start] == ParseCSV.quote && self.data[end - 1] == ParseCSV.quote {
            start += 1
            end -= 1
        }
        
        let range = start..<end
        let textblock = self.data.subdata(in: range)
        
        return String(decoding: textblock, as: UTF8.self)
    }
}
