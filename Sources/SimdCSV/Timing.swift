//
//  Timing.swift
//  
//
//  Created by Andreas Dreyer Hysing on 15/04/2020.
//

/*!
* @header Timing
*
* a that is designed to start counting on coming into scope and stop counting, putting its results into
* an Accumulator, when leaving scope. Optional - can just use explicit start/stop
*/
public protocol Timing {
    func start()
    func stop()
}
