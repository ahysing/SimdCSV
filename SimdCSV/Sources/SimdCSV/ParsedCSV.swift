//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

internal struct ParseCSV {
    var indexes :UnsafeMutablePointer<Int32>
    init(count:size_t = 0) {
        if count != 0 {
            indexes = UnsafeMutablePointer<Int32>.allocate(capacity: count)
        } else {
            indexes = UnsafeMutablePointer<Int32>.allocate(capacity: 32)
        }
    }
}
