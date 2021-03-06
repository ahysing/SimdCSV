//
//  Dumper.swift
//  
//
//  Created by Andreas Dreyer Hysing on 09/04/2020.
//

import Foundation

public class Dumper {
    private let log: AppLogger
    public init(log: AppLogger = StdOutLog()) {
        self.log = log
    }

    public func dumpWithIndices(loadResult: LoadResult) {
        if loadResult.status == .ok {
            for i in 0..<loadResult.csv.numberOfIndices {
                let first = Data.Index(loadResult.csv.indices[i])
                let next = Data.Index(loadResult.csv.indexEnds[i])
                let range: Range<Data.Index> = first..<next
                let textSegment = loadResult.csv.data.subdata(in: range)
                let text = String(decoding: textSegment, as: UTF8.self)
                self.log.info("", i, ": ", text)
            }
       } else if loadResult.status == .failed {
            self.log.error("Printing LoadResult that failed...")
        } else if loadResult.status == .ready {
            self.log.error("Printing LoadResult that has not started...")
        }
    }
    
    public func dump(loadResult: LoadResult) {
           if loadResult.status == .ok {
               for i in 0..<loadResult.csv.numberOfIndices {
                   let first = Data.Index(loadResult.csv.indices[i])
                   let next = Data.Index(loadResult.csv.indexEnds[i])
                   let range: Range<Data.Index> = first..<next
                   let textSegment = loadResult.csv.data.subdata(in: range)
                   let text = String(decoding: textSegment, as: UTF8.self)
                   self.log.info("", text)
               }
          } else if loadResult.status == .failed {
               self.log.error("Printing LoadResult that failed...")
           } else if loadResult.status == .ready {
               self.log.error("Printing LoadResult that has not started...")
           }
       }
}
