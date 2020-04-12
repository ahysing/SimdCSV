//
//  Portability.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

// #if (arch(x86_64) || arch(i386))

func countTrailingZerosSwift(number :UInt64) -> UInt32 {
    var counter :UInt32 = 0
    var mask :UInt64 = 1
    for i in 0...63 {
        let hasValue = (mask ^ number) << (63 - i) != 0
        if hasValue {
            counter += 1
        } else {
            break
        }
        
        mask = mask << 1
    }
    
    return counter
}

func countTrailingZeros(number :UInt64) -> UInt32 {
    let result =  number.trailingZeroBitCount
    return UInt32(result)
}

func countLeadingZerosSwift(number :UInt64) -> Int32 {
    var counter :Int32 = 0
    var mask :UInt64 = 1 << 63
    for i in 0...64 {
        let immediate = (mask ^ number)
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

func countLeadingZeros(number :UInt64) -> Int32 {
    // This function comes builtin with Swift.
    // it is usually backed by hardware instructions.
    // To lear more read about the ARM NEON in the documenttion below
    //
    // __builtin_neon_vclz
    // Built-in Function: int __builtin_clzll (unsigned long long)
    //   Similar to __builtin_clz, except the argument type is unsigned long long.
    // ...
    // Built-in Function: int __builtin_clz (unsigned int x)
    //   Returns the number of leading 0-bits in x, starting at the most significant bit position. If x is 0, the result is undefined.
    // https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html
    //
    let result = number.leadingZeroBitCount
    return Int32(result)
}

func countNumberOfBitsSwiftBuiltin(number :UInt64) -> UInt32 {
    let result_int = number.nonzeroBitCount
    return UInt32(result_int)
}

func countNumberOfBitsSwift(number :UInt64) -> UInt32 {
    var number = number
    var counter = UInt32(0)
    for _ in 0...63 {
        counter += UInt32(number & UInt64(1))
        number = number >> 1
    }
    
    return counter
}

// hamming
// Fast counting the number of set bits
// number: the input number to count bits in
func hamming(number :UInt64) -> UInt32 {
// #if arch(x86_64)
//     let result = simd.__popcntq(number)
//     return UInt32(result)
// #else
    let result_int = number.nonzeroBitCount
    return UInt32(result_int)
}
