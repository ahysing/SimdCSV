//
//  ApplicationLog.swift
//  
//
//  Created by Andreas Dreyer Hysing on 12/04/2020.
//

import os.log
import Foundation

public protocol AppLogger {
    func debug(_ message: StaticString, _ args: CVarArg...)
    func info(_ message: StaticString, _ args: CVarArg...)
    func error(_ message: StaticString, _ args: CVarArg...)
    func fault(_ message: StaticString, _ args: CVarArg...)
}

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public class AppToOSLog: AppLogger {
    internal var log: os.OSLog
    public init(logger: os.OSLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SimdCSV")
    ) {
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

public class StdOutLog: AppLogger {
    public init() {
    }

    public func debug(_ message: StaticString, _ args: CVarArg...) {
        debugPrint(message, args)
    }

    public func info(_ message: StaticString, _ args: CVarArg...) {
        print(message, args)
    }

    public func error(_ message: StaticString, _ args: CVarArg...) {
        print(message, args)
    }

    public func fault(_ message: StaticString, _ args: CVarArg...) {
        print(message, args)
    }
}
