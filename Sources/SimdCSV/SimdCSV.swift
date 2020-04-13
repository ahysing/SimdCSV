//
//  SimdCSV.swift
//
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//
import Foundation
import simd

struct SimdCSV {
    fileprivate static let CsvPadding: size_t = 64
    fileprivate static let quote = Array("\"".utf8)[0]
    fileprivate static let comma = Array(",".utf8)[0]
    fileprivate static let carrageReturn: UInt8 = 0x0d
    fileprivate static let lineFeed: UInt8 = 0x0a
    public var log: AppLogger
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    init(osLogger: AppToOSLog) {
        self.log = osLogger
    }

    init(appLogger: AppLogger) {
        self.log = appLogger
    }

    init() {
        if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            self.log = AppToOSLog()
        } else {
            self.log = StdOutLog()
        }
    }

    @inlinable internal static func fillInput(ptr: UnsafeRawPointer!) -> SimdInput {
        let values: UnsafePointer<UInt8> = ptr.bindMemory(to: UInt8.self, capacity: 64)
        let letters = SIMD64<UInt8>(values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], values[9], values[10], values[11], values[12], values[13], values[14], values[15], values[16], values[17], values[18], values[19], values[20], values[21], values[22], values[23], values[24], values[25], values[26], values[27], values[28], values[29], values[30], values[31], values[32], values[33], values[34], values[35], values[36], values[37], values[38], values[39], values[40], values[41], values[42], values[43], values[44], values[45], values[46], values[47], values[48], values[49], values[50], values[51], values[52], values[53], values[54], values[55], values[56], values[57], values[58], values[59], values[60], values[61], values[62], values[63])
        let input = SimdInput(letters: letters)
        return input
    }

    // a straightforward comparison of a mask against input. Would be
    // cheaper in AVX512.
    @inlinable internal static func cmpMaskAgainstInput(input: SimdInput, m: UInt8) -> UInt64 {
        let compareLetters: SIMDMask<SIMD64<Int8>> = input.letters .== m
        var result = SIMD64<Int8>.zero
        result.replace(with: 1, where: compareLetters)
        var bitmaskForM = UInt64(result[0])
            bitmaskForM |= (UInt64(result[1]) << 1)
            bitmaskForM |= (UInt64(result[2]) << 2)
            bitmaskForM |= (UInt64(result[3]) << 3)
            bitmaskForM |= (UInt64(result[4]) << 4)
            bitmaskForM |= (UInt64(result[5]) << 5)
            bitmaskForM |= (UInt64(result[6]) << 6)
            bitmaskForM |= (UInt64(result[7]) << 7)
            bitmaskForM |= (UInt64(result[8]) << 8)
            bitmaskForM |= (UInt64(result[9]) << 9)
            bitmaskForM |= (UInt64(result[10]) << 10)
            bitmaskForM |= (UInt64(result[11]) << 11)
            bitmaskForM |= (UInt64(result[12]) << 12)
            bitmaskForM |= (UInt64(result[13]) << 13)
            bitmaskForM |= (UInt64(result[14]) << 14)
            bitmaskForM |= (UInt64(result[15]) << 15)
            bitmaskForM |= (UInt64(result[16]) << 16)
            bitmaskForM |= (UInt64(result[17]) << 17)
            bitmaskForM |= (UInt64(result[18]) << 18)
            bitmaskForM |= (UInt64(result[19]) << 19)
            bitmaskForM |= (UInt64(result[20]) << 20)
            bitmaskForM |= (UInt64(result[21]) << 21)
            bitmaskForM |= (UInt64(result[22]) << 22)
            bitmaskForM |= (UInt64(result[23]) << 23)
            bitmaskForM |= (UInt64(result[24]) << 24)
            bitmaskForM |= (UInt64(result[25]) << 25)
            bitmaskForM |= (UInt64(result[26]) << 26)
            bitmaskForM |= (UInt64(result[27]) << 27)
            bitmaskForM |= (UInt64(result[28]) << 28)
            bitmaskForM |= (UInt64(result[29]) << 29)
            bitmaskForM |= (UInt64(result[30]) << 30)
            bitmaskForM |= (UInt64(result[31]) << 31)
            bitmaskForM |= (UInt64(result[32]) << 32)
            bitmaskForM |= (UInt64(result[33]) << 33)
            bitmaskForM |= (UInt64(result[34]) << 34)
            bitmaskForM |= (UInt64(result[35]) << 35)
            bitmaskForM |= (UInt64(result[36]) << 36)
            bitmaskForM |= (UInt64(result[37]) << 37)
            bitmaskForM |= (UInt64(result[38]) << 38)
            bitmaskForM |= (UInt64(result[39]) << 39)
            bitmaskForM |= (UInt64(result[40]) << 40)
            bitmaskForM |= (UInt64(result[41]) << 41)
            bitmaskForM |= (UInt64(result[42]) << 42)
            bitmaskForM |= (UInt64(result[43]) << 43)
            bitmaskForM |= (UInt64(result[44]) << 44)
            bitmaskForM |= (UInt64(result[45]) << 45)
            bitmaskForM |= (UInt64(result[46]) << 46)
            bitmaskForM |= (UInt64(result[47]) << 47)
            bitmaskForM |= (UInt64(result[48]) << 48)
            bitmaskForM |= (UInt64(result[49]) << 49)
            bitmaskForM |= (UInt64(result[50]) << 50)
            bitmaskForM |= (UInt64(result[51]) << 51)
            bitmaskForM |= (UInt64(result[52]) << 52)
            bitmaskForM |= (UInt64(result[53]) << 53)
            bitmaskForM |= (UInt64(result[54]) << 54)
            bitmaskForM |= (UInt64(result[55]) << 55)
            bitmaskForM |= (UInt64(result[56]) << 56)
            bitmaskForM |= (UInt64(result[57]) << 57)
            bitmaskForM |= (UInt64(result[58]) << 58)
            bitmaskForM |= (UInt64(result[59]) << 59)
            bitmaskForM |= (UInt64(result[60]) << 60)
            bitmaskForM |= (UInt64(result[61]) << 61)
            bitmaskForM |= (UInt64(result[62]) << 62)
            bitmaskForM |= (UInt64(result[63]) << 63)
        return bitmaskForM
        // let res0 = simd._mm256_movemask_epi8(cmpRes0) // this command is faster, but caused havok in XCode. The compiler errors tells us nothing. we blame bugs in xcode for this matter.
        // let x:  __mmask32 = simd._mm256_bitshuffle_epi64_mask(cmpRes1, collectLeastSiginificantInByte)
        //        return UInt64(cmpAsLowerBits) | (UInt64(cmpAsUpperBits) << 32)
    }

    // http://bitmath.blogspot.com/2013/05/carryless-multiplicative-inverse.html
    @inlinable internal static func carryLessMultiplyScalar(factorOne: UInt64, factorTwo: UInt64) -> UInt64 {
        var answer = UInt64.zero
        var first = factorOne
        var second = factorTwo
        while second != UInt64.zero {
            let shouldMultiply = first & UInt64(1)
            answer ^= second &* shouldMultiply
            first >>= 1
            second <<= 1
        }

        return answer
    }

    @inlinable internal static func carryLessMultiply(factorOne:SIMD2<UInt64>, factorTwo:SIMD2<UInt64>) -> SIMD2<UInt64> {
        var answer = SIMD2<UInt64>.zero
        var first = factorOne
        var second = factorTwo
        while any(second .!= UInt64.zero) {
            let shouldMultiply = first & UInt64(1)
            answer ^= second &* shouldMultiply
            first &>>= 1
            second &<<= 1
        }

        return answer
    }

    @inlinable internal static func carryLessMultiplySigned(factorOne:SIMD2<Int64>, factorTwo:SIMD2<Int64>) -> SIMD2<Int64> {
        var answer = SIMD2<Int64>.zero
        var first = factorOne
        var second = factorTwo
        for _ in 0...63 {
            let shouldMultiply = first & Int64(1)
            answer ^= second &* shouldMultiply
            first &>>= 1
            second &<<= 1
        }

        return answer
    }

    // return the quote mask (which is a half-open mask that covers the first
    // quote in a quote pair and everything in the quote pair)
    // We also update the prevIterInsideQuote value to
    // tell the next iteration whether we finished the final iteration inside a
    // quote pair; if so, this  inverts our behavior of  whether we're inside
    // quotes for the next iteration.
    @inlinable internal static func findQuoteMask(input: SimdInput, prevIterInsideQuote: inout UInt64) -> UInt64 {

// #if arch(x86_64)
        // let quoteBitsInt64 = Int64(bitPattern: quoteBits)
        // let most sigificant int64 be 0. let least significant int64 be quoteBits
        // let factorOne: SIMD2<Int64> = simd._mm_set_epi64x(Int64.zero, quoteBitsInt64)
        //
        // let most sigificant int64 be -1. let least significant int64 be -1
        // let all8BitsOn = Int8(bitPattern: 255)
        // let factorTwo: SIMD2<Int64> = simd._mm_set1_epi8(all8BitsOn) // = 11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
        // _mm_clmulepi64_si128 (carry-less multiply) can be swapped for *&
        // (_mm_clmulepi64_si128(_mm_set_epi64x(0ULL, quote_bits), _mm_set1_epi8(0xFF), 0)
        // let a = carryLessMultiplySigned(factorOne:factorOne, factorTwo: factorTwo) // carryLessMultiply(factorOne: factorOne, factorTwo: factorTwo)
        // Copy the lower 64-bit integer in a to dst.
        // let immediate = simd._mm_cvtsi128_si64(a)
//#elseif arch(arm64)
        // uint64_t quote_mask = vmull_p64( -1ULL, quote_bits)
        // Polynomial Multiply Long. This instruction multiplies corresponding elements in the lower or upper half of the vectors of the two source SIMD&FP registers, places the results in a vector, and writes the vector to the destination SIMD&FP register. The destination vector elements are twice as long as the elements that are multiplied.
        //#endif
        let quoteBits = cmpMaskAgainstInput(input: input, m: quote)
        var quoteMask = carryLessMultiplyScalar(factorOne: quoteBits, factorTwo: UInt64.max)
        quoteMask ^= prevIterInsideQuote
        let quoteMaskInt64 = Int64(bitPattern: quoteMask)
        let quoteMaskInt64Shifted = quoteMaskInt64 >> 63
        prevIterInsideQuote = UInt64(bitPattern: quoteMaskInt64Shifted)
        return quoteMask
    }

    // Flatten out values in 'bits' assuming that they are to have values of idx
    // plus their position in the bitvector, and store these indexes at
    // base_ptr[base] incrementing base as we go.
    //
    // Will potentially store extra values beyond end of valid bits, so base_ptr
    // needs to be large enough to handle this
    @inlinable internal static func flattenBits(pcsv: inout ParseCSV, base: inout Int, idx: size_t, columnBitMask: UInt64, CRLFseenBitMask: UInt32) {
        var bits = columnBitMask
        var twoByteEnd = CRLFseenBitMask
        if columnBitMask != UInt64.zero {
            let cnt = Int(countColumnBoundariesFromBitMask(number: bits))
            let nextBase = base + cnt
            let index = UInt32(idx)

            var twoByteBoundary: UInt32 = 0
            var columnWidth: UInt32 = 0
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base - 1] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 0] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 0] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 1] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 1] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 2] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 2] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 3] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 3] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 4] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 4] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 5] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 5] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 6] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            columnWidth = countTrailingZeros(number: bits)
            twoByteBoundary = twoByteEnd & 1
            pcsv.indexEnds[base + 6] = index + columnWidth - twoByteBoundary
            twoByteEnd >>= 1
            pcsv.indices[base + 7] = index + columnWidth + 1
            bits = bits & bits.subtractingReportingOverflow(1).partialValue
            
            if cnt > 8 {
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 7] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 8] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 8] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 9] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 9] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 10] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 10] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 11] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 11] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 12] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 12] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 13] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 13] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 14] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
                
                columnWidth = countTrailingZeros(number: bits)
                twoByteBoundary = twoByteEnd & 1
                pcsv.indexEnds[base + 14] = index + columnWidth - twoByteBoundary
                twoByteEnd >>= 1
                pcsv.indices[base + 15] = index + columnWidth + 1
                bits = bits & bits.subtractingReportingOverflow(1).partialValue
            }

            if cnt > 16 {
                base += 16
                while bits != UInt64.zero {
                    columnWidth = countTrailingZeros(number: bits)
                    twoByteBoundary = twoByteEnd & 1
                    pcsv.indexEnds[base - 1] = index + columnWidth - twoByteBoundary
                    twoByteEnd >>= 1
                    pcsv.indices[base] = index + columnWidth + 1
                    bits = bits & bits.subtractingReportingOverflow(1).partialValue
                    
                    base += 1
                    /*
                    columnWidth = countTrailingZeros(number: bits)
                    pcsv.indexEnds[base - 1] = index + columnWidth - twoByteBoundary
                    pcsv.indices[base] = index + columnWidth + 1
                    bits = bits & bits.subtractingReportingOverflow(1).partialValue

                    base += 1
                    */
                }
            }

            base = nextBase
        }
    }
    
    private static func buildTwoByteEndMask(_ end: UInt64, _ sep: UInt64, _ quo: UInt64) -> UInt32 {
        var recordEnds = end & quo
        var columnEnds = sep & quo
        var CRLFseenBitMask = UInt32.zero
        while recordEnds != 0 {
            if countTrailingZeros(number: recordEnds) < countTrailingZeros(number: columnEnds) {
                recordEnds = recordEnds & (recordEnds - 1)
                CRLFseenBitMask |= 1
            } else {
                columnEnds = columnEnds & columnEnds.subtractingReportingOverflow(1).partialValue
                CRLFseenBitMask |= 0
            }
            CRLFseenBitMask <<= 1
        }
        
        return CRLFseenBitMask
    }

    private static func findIndexes(buf: UnsafeMutableRawPointer!, len: size_t, pcsv: inout ParseCSV, CRLF: Bool = false) {
        var prevIterInsideQuote = UInt64.zero
        // Used by CRLF
        var prevIterCrEnd = UInt64.zero

        let lenminus64: size_t = len < 64 ? 0:  len - 64
        var base: Int = len > 0 ? 1 : 0
        if len > 0 {
            pcsv.indices[0] = 0
        }
        
        let CSVbufferSize = 4 // it seems to be about the sweetspot.
        if lenminus64 > 64 * CSVbufferSize {
            var fields: [UInt64] = Array<UInt64>(repeating: UInt64.zero, count: CSVbufferSize)
            var twoByteBoundaryBitMasks: [UInt32] = Array<UInt32>(repeating: UInt32.zero, count: CSVbufferSize)
            var globalIdx: size_t = 0
            let finish = lenminus64 - 64 * CSVbufferSize + 1
            let by = 64 * CSVbufferSize
            for idx in stride(from: globalIdx, to: finish, by: by) {
                for i in 0...CSVbufferSize {
                    let internalIdx: size_t = 64 * i + idx
                    let bufWithOffset = buf + internalIdx
                    let SIMDinput = fillInput(ptr: bufWithOffset)
                    let quoteMask = findQuoteMask(input: SIMDinput, prevIterInsideQuote: &prevIterInsideQuote)
                    let sep = cmpMaskAgainstInput(input: SIMDinput, m: comma)
                    var end: UInt64 = UInt64.zero
                    
                    if CRLF {
                        let cr: UInt64 = cmpMaskAgainstInput(input: SIMDinput, m: carrageReturn)
                        let crAdjusted: UInt64 = (cr << 1) | prevIterCrEnd
                        let lf: UInt64 = cmpMaskAgainstInput(input: SIMDinput, m: lineFeed)
                        end = lf & crAdjusted
                        prevIterCrEnd = cr >> 63
                    } else {
                        end = cmpMaskAgainstInput(input: SIMDinput, m: lineFeed)
                    }

                    let notQuoteMask = ~quoteMask
                    fields[i] = (end | sep) & notQuoteMask
                    twoByteBoundaryBitMasks[i] = CRLF ? buildTwoByteEndMask(end, sep, notQuoteMask) : 0
                }

                for i in 0...CSVbufferSize {
                    let internalIdx: size_t = 64 * i + idx
                    flattenBits(pcsv: &pcsv, base: &base, idx: internalIdx, columnBitMask: fields[i], CRLFseenBitMask: twoByteBoundaryBitMasks[i])
                }

                globalIdx = idx
            }
        }

        // tail end will be unbuffered
        for idx in stride(from: 0, to: lenminus64, by: 64) {
            let bufWithOffset = buf + idx

            let simdInput = fillInput(ptr:bufWithOffset)
            let quoteMask = findQuoteMask(input: simdInput, prevIterInsideQuote: &prevIterInsideQuote)
            let sep = cmpMaskAgainstInput(input: simdInput, m: comma)
            var end: UInt64 = UInt64.zero
            
            if CRLF {
                let cr: UInt64 = cmpMaskAgainstInput(input: simdInput, m: carrageReturn)
                let crAdjusted: UInt64 = (cr << 1) | prevIterCrEnd
                let lf: UInt64 = cmpMaskAgainstInput(input: simdInput, m: lineFeed)
                end = lf & crAdjusted
                prevIterCrEnd = cr >> 63
            } else {
                end = cmpMaskAgainstInput(input: simdInput, m: lineFeed)
            }
            // note - a bit of a high-wire act here with quotes
            // we can't put something inside the quotes with the CR
            // then outside the quotes with LF so it's OK to "and off"
            // the quoted bits here. Some other quote convention would
            // need to be thought about carefully
            let notQuoteMask = ~quoteMask
            let fieldSep = (end | sep) & notQuoteMask
            
            let twoByteBoundary = CRLF ? buildTwoByteEndMask(end, sep, notQuoteMask) : 0
            flattenBits(pcsv: &pcsv, base: &base, idx: idx, columnBitMask: fieldSep, CRLFseenBitMask: twoByteBoundary)
        }

        pcsv.numberOfIndexes = base
    }

    public func loadCSV(filepath: URL, CRLF: Bool = false, verbose: Bool = false) -> LoadResult {
        let ioUtil = IOUtil()
        if verbose {
            self.log.debug("loading %s", "\(filepath)" as CVarArg)
        }

        do {
            let csv: Data = try ioUtil.getCorpus(filepath: filepath, padding: SimdCSV.CsvPadding)
            return loadCSVData64BitPadded(csv: csv, CRLF:CRLF, verbose: verbose)
        } catch {
            self.log.error("%s", "\(error)" as CVarArg)
            return LoadResult(status: LoadStatus.Failed)
        }
    }

    internal func formatByteCount(count: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        let byteCount = Int64(count)
        let sizeAsText = formatter.string(fromByteCount: byteCount)
        return sizeAsText
    }

    public func loadCSVData64BitPadded(csv: Data, CRLF: Bool = false, verbose:Bool = false) -> LoadResult {
        var pcsv: ParseCSV = ParseCSV()
        pcsv.indices = Array<UInt32>(repeating: UInt32.zero, count: csv.count)
        pcsv.indexEnds = Array<UInt32>(repeating: UInt32.zero, count: csv.count)
        pcsv.data = csv
        pcsv.CRLF = CRLF
        if verbose {
            let sizeAsText = formatByteCount(count: csv.count)
            self.log.debug("loaded CSV sized ", sizeAsText)
        }

        csv.withUnsafeBytes { rawBufferPointer in
            let baseAddress: UnsafeRawPointer = rawBufferPointer.baseAddress!
            let CSVinMemory = UnsafeMutableRawPointer(mutating: baseAddress)
            let len = rawBufferPointer.count

            var timingPhase: TimingPhase
            if #available(OSX 10.12, iOS 12.0, watchOS 5.0, tvOS 12.0, *) {
                timingPhase = OSTimingPhase(category: "Find indexes", log: self.log as! AppToOSLog)
            } else {
                timingPhase = PosixTimingPhase(category: "Find indexes", log: self.log)
            }
            timingPhase.start()
            SimdCSV.findIndexes(buf: CSVinMemory, len:len, pcsv: &pcsv, CRLF: CRLF)
            timingPhase.stop()
        }

        if verbose {
        /*
            os_log("[verbose] Number of cycles %@", self.log, cycles)

            os_log("[verbose] Number of cycles per byte %@", self.log, cycles)
*/
            self.log.debug("Number of indexes found:  %@", pcsv.numberOfIndexes)
            /*
            os_log("[verbose] Number of bytes per index: ", self.log, pcsv.indexes.)
              os_log("[verbose] Number of cycles (ref) %@", self.log, cycles)
              os_log("[verbose] Number of cycles (ref) per byte %@", self.log, cycles)
              os_log("[verbose] Number of instructions %@", self.log, cycles)
              os_log("[verbose] Number of instructions per byte %@", self.log, cycles)
              os_log("[verbose] Number of instructions per cycle %@", self.log, cycles)
              os_log("[verbose] Number of branch misses %@", self.log, cycles)
              os_log("[verbose] Number of branch misses per byte %@", self.log, cycles)
              os_log("[verbose] Number of cache references %@", self.log, cycles)
              os_log("[verbose] Number of cache references per byte %@", self.log, cycles)
              os_log("[verbose] Number of cache misses %@", self.log, cycles)
              os_log("[verbose] Number of cache misses per byte %@", self.log, cycles)
              os_log("[verbose] CPU frequency (effective) %@", self.log, cycles)
              os_log("[verbose] CPU frequency (base) %@", self.log, cycles)
              */
            self.log.info("done")
        }

        return LoadResult(status: LoadStatus.OK, csv: pcsv)
    }
}
