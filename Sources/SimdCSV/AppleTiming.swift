//
//  AppleTiming.swift
//  
//
//  Created by Andreas Dreyer Hysing on 15/04/2020.
//
import Foundation
import os.signpost
/*!
* @header AppleTiming
*
* AppleTiming replies on the os_signpost APIs let clients add lightweight instrumentation.
* It can do collection and visualization by performance analysis.
*
* Clients of os_signpost can instrument interesting periods of time
* ('intervals') and single points in time ('events'). Intervals can span
* processes, be specific to one process, or be specific to a single thread.
*/

@available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
public class AppleTiming: Timing {
    private let category: StaticString
    private let OSlog: os.OSLog
    private let signpostID: OSSignpostID

    required init(category: StaticString, log: AppleLogger) {
        self.OSlog = log.log
        self.category = category
        self.signpostID = OSSignpostID(log: log.log)
    }

    public func start() {
        os_signpost(
            .begin,
            log: self.OSlog,
            name: self.category,
            signpostID: self.signpostID)
    }

    public func stop() {
        os_signpost(
            .end,
            log: self.OSlog,
            name: self.category,
            signpostID: self.signpostID)
    }
    
    public func log() {
    }
}
