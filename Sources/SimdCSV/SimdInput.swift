//
//  SimdInput.swift
//  
//
//  Created by Andreas Dreyer Hysing on 30/03/2020.
//

import simd

internal struct SimdInput {
    internal var letters: SIMD64<UInt8>
    @usableFromInline init(letters: SIMD64<UInt8>) {
        self.letters = letters
    }
}
