//
//  StdOutLog.swift
//  
//
//  Created by Andreas Dreyer Hysing on 15/04/2020.
//
import Foundation

extension FileHandle : TextOutputStream {
  public func write(_ string: String) {
    guard let data = string.data(using: .utf8) else { return }
    self.write(data)
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
        var standardError = FileHandle.standardError
        print(message, args, to: &standardError)
    }

    public func fault(_ message: StaticString, _ args: CVarArg...) {
        var standardError = FileHandle.standardError
        print(message, args, to: &standardError)
    }
}
