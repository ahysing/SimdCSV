//
//  Portability.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import simd

func countTrailingZerosSwift(input_num :UInt64) -> Int32 {
    var counter :Int32 = 0
    var mask :UInt64 = 1
    for i in 0...63 {
        let hasValue = (mask ^ input_num) << (63 - i) != 0
        if hasValue {
            counter += 1
        } else {
            break
        }
        
        mask = mask << 1
    }
    
    return counter
}
// #if (arch(x86_64) || arch(i386))
func trailingZeros(input_num :UInt64) -> Int32 {
#if arch(x86_64)
    let result = simd.__tzcnt_u64(input_num)
    return Int32(result)
#else
    return countTrailingZerosSwift(input_num: input_num)
#endif
}

func countLeadingZerosSwift(input_num :UInt64) -> Int32 {
    var counter :Int32 = 0
    var mask :UInt64 = 1 << 63
    for i in 0...64 {
        let immediate = (mask ^ input_num)
        let shiftDown :Int = (63 - i)
        let immediate2 = immediate >> shiftDown
        if immediate2 == 0 {
            break
        }
        
        counter += Int32(immediate2)
        mask = mask >> 1
    }
    
    return counter
}

func leadingZeros(input_num :UInt64) -> Int32 {
#if arch(x86_64)
    let result = simd._lzcnt_u64(input_num)
    return Int32(result)
#else
    return countLeadingZerosSwift(input_num: input_num)
#endif
}

func countNumberOfBitsSwift(input_num :UInt64) -> UInt32 {
    var number = input_num
    var counter = UInt32(0)
    for _ in 0...63 {
        counter += UInt32(number & UInt64(1))
        number = number >> 1
    }
    
    return counter
}
// hamming
// Fast counting the number of set bits
// input_num: the input number to count bits in
func hamming(input_num :UInt64) -> UInt32 {
#if arch(x86_64)
    let result = simd.__popcntq(input_num)
    return UInt32(result)
#else
    return countNumberOfBitsSwift(input_num: input_num)
#endif
}
