//
//  Dumper.swift
//  
//
//  Created by Andreas Dreyer Hysing on 09/04/2020.
//

import Foundation

class Dumper {
    init() {}
    
    public func dump(loadResult: LoadResult) {
       if loadResult.status == LoadStatus.OK {
           let count = loadResult.csv.data!.count
           loadResult.csv.data?.withUnsafeBytes { rawBufferPointer in
               let baseAddress :UnsafeRawPointer = rawBufferPointer.baseAddress!
               let dataPointer = baseAddress.bindMemory(to: CChar.self, capacity: count)
               for i in 0...loadResult.csv.numberOfIndexes {
                   print(i, ": ")
                   let first = loadResult.csv.indexes[i]
                   let next = loadResult.csv.indexes[i + 1]
                   let wordCount = Int(next - first)
                   
                   var textArray = Array<CChar>.init(repeating: CChar.zero, count: wordCount)
                   var i = 0
                   for j in first...next {
                       let idx = Int(j)
                       textArray[i] = dataPointer[idx]
                       i += 1
                   }
                   
                   let text = String.init(utf8String: textArray) ?? ""
                   print(text)
               }
           }
       } else {
           print("Printing LoadResult that failed...")
       }
    }
}
