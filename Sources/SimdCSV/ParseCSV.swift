//
//  ParseCSV.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

public struct ParseCSV {
    var CRLF: Bool = false
    var numberOfIndexes: size_t = 0
    var indices: [UInt32]! = []
    var indexEnds: [UInt32]! = []
    var data: Data! = nil

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
