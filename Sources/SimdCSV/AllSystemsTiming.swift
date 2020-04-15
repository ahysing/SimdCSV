//
//  AllSystemsTiming.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//
/*!
* @header AllSystemsTiming
*
* AllSystemsTiming relies on the POSIX click() APIs let clients add lightweight instrumentation.
* It can do collection and visualization by performance analysis.
*
*/
import Foundation

public class AllSystemsTiming: Timing {
    public var startedAt: clock_t
    public var stoppedAt: clock_t
    private let category: StaticString
    private let appLogger: AppLogger
    
    public init(category: StaticString, log: AppLogger = StdOutLog()) {
        self.appLogger = log
        self.category = category
        self.startedAt = 0 as clock_t
        self.stoppedAt = 0 as clock_t
    }

    public func start() {
        self.startedAt = clock()
    }

    public func stop() {
        self.stoppedAt = clock()
    }
    
    public func log() {
        let duration = self.stoppedAt - self.stoppedAt
        self.appLogger.info(self.category," Spent ", duration, " ms")
    }
}
