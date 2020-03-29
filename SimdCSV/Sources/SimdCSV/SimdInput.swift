//
//  SimdInput.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//

import simd

#if arch(x86_64)
struct SimdInput {
    var lo :simd.__m256i
    var hi :simd.__m256i
    init(lo:simd.__m256i, hi:simd.__m256i) {
        self.lo = lo
        self.hi = hi
    }
}
#elseif (arch(arm64) || arch(arm))
struct SimdInput {
    var i0 :simd.simd_uchar16
    var i1 :simd.simd_uchar16
    var i2 :simd.simd_uchar16
    var i3 :simd.simd_uchar16
}
#else
    #error ("It's called SIMDcsv for a reason, bro")
#endif
