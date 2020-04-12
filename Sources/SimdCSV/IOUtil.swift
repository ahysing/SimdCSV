//
//  IOUtil.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import Foundation

struct IOUtil {
    public func getCorpus(filepath: URL?, padding: size_t) throws -> Data {
        let fileAttrs = try FileManager.default.attributesOfItem(atPath: filepath!.absoluteString)
        let fileSize = fileAttrs[FileAttributeKey.size] as! size_t

        let actualFileSize: size_t = fileSize + padding
        var data = Data.init(count: actualFileSize)
        let file: FileHandle = try FileHandle(forReadingFrom: filepath!)
        file.write(data)
        let paddingRange = fileSize...actualFileSize
        data.replaceSubrange(paddingRange, with: CollectionOfOne(UInt8.zero))
        return data
    }
}
