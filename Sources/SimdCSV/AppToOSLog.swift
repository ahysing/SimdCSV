//
//  AppleLogger.swift
//  
//
//  Created by Andreas Dreyer Hysing on 15/04/2020.
//
import Foundation
import os.log

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public class AppleLogger: AppLogger {
    internal var log: os.OSLog
    public init(logger: os.OSLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SimdCSV")) {
        self.log = logger
    }

    public init(subsystem: String, category: String) {
        self.log = OSLog(subsystem: subsystem, category: category)
    }

    public func debug(_ message: StaticString, _ args: CVarArg...) {
        os_log(message, log: log, type: .debug, args)
    }

    public func info(_ message: StaticString, _ args: CVarArg...) {
        os_log(message, log: log, type: .info, args)
    }

    public func error(_ message: StaticString, _ args: CVarArg...) {
        os_log(message, log: log, type: .error, args)
    }

    public func fault(_ message: StaticString, _ args: CVarArg...) {
        os_log(message, log: log, type: .fault, args)
    }
}
