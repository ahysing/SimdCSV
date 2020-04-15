//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 12/04/2020.
//

import simd

#if arch(x86_64)
import _Builtin_intrinsics.intel
#warning("Imported Intel Intrinsics. Now we are playing with Intel SSE and Intel SSE2")
#endif

#if arch(arm64)
import _Builtin_intrinsics.arm
#warning("Imported ARM Intrinsics for ARM64. Now we are playing with ARM neon :)")
#endif

#if arch(arm)
import _Builtin_intrinsics.arm
#warning("Imported ARM Intrinsics for ARM7 and ARM8. Now we are playing with ARM neon :)")
#endif

public struct Architecture {
    #if arch(x86_64)
        public let architecture = "x86_64"
    #elseif arch(i386)
        public let architecture = "i386"
    #elseif arch(arm64)
        public let architecture = "arm64"
    #elseif arch(arm)
        public let architecture = "arm"
    #else
        public let architecture = ""
    #endif
}
