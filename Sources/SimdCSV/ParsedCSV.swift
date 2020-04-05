//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

internal struct ParseCSV {
    var numberOfIndexes :UInt32 = 0
    var indexes :[UInt32] = []
    var data :UnsafeMutableRawPointer! = UnsafeMutableRawPointer.init(bitPattern: 8) ?? nil
}
