//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import Foundation

struct IOUtil {
    fileprivate func allocatePaddedBuffer(length :size_t, padding :size_t) -> NSData? {
        return nil
    }
    
    public func getCorpus(filename :String, padding: size_t) -> NSData? {
        let allData = NSData(contentsOfFile: filename)
        return allData;
    }
}
