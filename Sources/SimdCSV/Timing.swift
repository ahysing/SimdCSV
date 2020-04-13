//
//  Timing.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation
import os.signpost

// a that is designed to start counting on coming into scope and stop counting, putting its results into
// an Accumulator, when leaving scope. Optional - can just use explicit start/stop
public protocol TimingPhase {
    func start()
    func stop()
}

@available(OSX 10.12, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
public class OSTimingPhase: TimingPhase {
    private let category: StaticString
    private let log: os.OSLog
    private let signpostID: OSSignpostID

    required init(category: StaticString, log: AppToOSLog) {
        self.log = log.log
        self.category = category
        self.signpostID = OSSignpostID(log: log.log)
    }

    public func start() {
        os_signpost(
            .begin,
            log: log,
            name: self.category,
            signpostID: self.signpostID)
    }

    public func stop() {
        os_signpost(
            .end,
            log: log,
            name: self.category,
            signpostID: self.signpostID)
    }
}

public class PosixTimingPhase: TimingPhase {
    public var startedAt: clock_t
    public var stoppedAt: clock_t
    private let category: StaticString
    private let log: AppLogger
    init(category: StaticString, log: AppLogger = StdOutLog()) {
        self.log = log
        self.category = category
        self.startedAt = 0 as clock_t
        self.stoppedAt = 0 as clock_t
    }

    public func start() {
        self.startedAt = clock()
    }

    public func stop() {
        self.stoppedAt = clock()
        let duration = self.stoppedAt - self.stoppedAt
        self.log.info(self.category," Spent ", duration, " ms")
    }
}
