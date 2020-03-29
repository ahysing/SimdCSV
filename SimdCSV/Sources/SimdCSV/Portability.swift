//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import simd
import Foundation

func add_overflow(value1 :UInt64, value2 :UInt64, result :UnsafeMutablePointer<UInt64>!) ->  Bool {
    return simd._addcarry_u64(0, value1, value2, result) != 0
}

func mul_overflow(value1 :UInt64, value2 :UInt64, result :UnsafeMutablePointer<UInt64>!) -> Bool {
    let high :UInt64 = 0
    simd._mulx_u64(value1, value2, result)
    return high != 0
}

// #if (arch(x86_64) || arch(i386))
func trailingZeroes(input_num :UInt64) -> Int32 {
#if arch(x86_64)
    let result = simd.__tzcnt_u64(input_num)
    return Int32(result)
#else
    return simd.__builtin_ctzll(input_num)
#endif
}

func leadingZeroes(input_num :UInt64) -> Int32 {
#if arch(x86_64)
    let result = simd._lzcnt_u64(input_num)
    return Int32(result)
#else
    return simd.__builtin_clzll(input_num)
#endif
}

func hamming(input_num :UInt64) -> UInt32 {
#if arch(x86_64)
    let result = simd.__popcntq(input_num)
    return UInt32(result)
#else
    return simd.__builtin_popcountll(input_num);
#endif
}
