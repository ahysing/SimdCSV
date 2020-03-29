//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import Foundation

struct IOUtil {
    public func getCorpus(filepath :URL, padding: size_t) throws -> Data {
        let options = Data.ReadingOptions.dataReadingMapped
        let data = try! Data.init(contentsOf: filepath, options: options)
        return data
    }
}
