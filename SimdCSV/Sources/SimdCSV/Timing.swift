//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

class TimingAccumulator {
    public var results :[UInt64] = []
    // reused rather than allocated in the middle of timing
    public var temp_result_vec = [UInt64]()
    public var num_phases :Int = 0
    public var num_events :Int = 0
    public var fd :Int = 0
    public var working :Bool = false
}
