//
//  ParseCSV.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

public struct ParseCSV {
    var numberOfIndexes :size_t = 0
    // var indexes :UnsafeMutablePointer<UInt32>! = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    var indexes :[UInt32]! = []
    var data :Data! = nil
}
