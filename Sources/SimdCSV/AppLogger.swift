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
