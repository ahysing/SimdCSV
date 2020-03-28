//
//  MemUtil.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import Foundation

internal func alignedMalloc(alignment :size_t, size :size_t) -> UnsafeMutableRawPointer {
    let pointer = UnsafeMutableRawPointer.allocate(
        byteCount: size,
        alignment: alignment);
    return pointer;
}

internal func alignedFree(memory :UnsafeMutableRawPointer) {
    // if (memory == NSNull)
    // {
    //     return;
    // }
    memory.deallocate();
}
