//
//  SimdCSV.swift
//
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//
import Foundation
import simd
import os.log

#if arch(x86_64)
import _Builtin_intrinsics.intel
#warning("Imported Intel Intrinsics. Now we are playing with Intel SSE :)")
#endif

// What are the compile targets available?
//
// https://stackoverflow.com/questions/15036909/clang-how-to-list-supported-target-architectures#18576360
// https://en.wikipedia.org/wiki/Apple-designed_processors#Apple_S5
#if arch(arm64)
import _Builtin_intrinsics.arm
#warning("Imported ARM Intrinsics for ARM64. Now we are playing with ARM neon :)")
#endif

#if arch(arm)
import _Builtin_intrinsics.arm
#warning("Imported ARM Intrinsics for ARM7 and ARM8. Now we are playing with ARM neon :)")
#endif


private let PERF_COUNT_HW_CPU_CYCLES :Int32 = 1
private let PERF_COUNT_HW_INSTRUCTIONS :Int32 = 2
private let PERF_COUNT_HW_BRANCH_MISSES :Int32 = 4
private let PERF_COUNT_HW_CACHE_REFERENCES :Int32 = 8
private let PERF_COUNT_HW_CACHE_MISSES :Int32 = 16
private let PERF_COUNT_HW_REF_CPU_CYCLES :Int32 = 32

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
func createOSLog() -> Any {
    return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SimdCSV") as Any
}

struct SimdCSV {
#if arch(x86_64)
    public let architecture = "x86_64"
#elseif arch(arm64)
    public let architecture = "arm64"
#elseif arch(arm)
    public let architecture = "arm"
#else
    public let architecture = ""
#endif
    public let hasSIMD = SIMD_COMPILER_HAS_REQUIRED_FEATURES
    
    fileprivate static let CSV_PADDING :size_t = 64
    fileprivate static let quote = Array("\"".utf8)[0]
    fileprivate static let comma = Array(",".utf8)[0]
    fileprivate static let carrageReturn :UInt8 = 0x0d
    fileprivate static let lineFeed :UInt8 = 0x0a
    public var log :AppLogger
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    init(osLogger :AppToOSLog) {
        self.log = osLogger
    }
    
    init(appLogger :AppLogger) {
        self.log = appLogger
    }
    
    init() {
        if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            self.log = AppToOSLog()
        } else {
            self.log = StdOutLog()
        }
    }
    
    @inlinable internal static func fillInput(ptr :UnsafeRawPointer!) -> SimdInput {
        let values :UnsafePointer<UInt8> = ptr.bindMemory(to: UInt8.self, capacity: 64)
        let letters = SIMD64<UInt8>(values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], values[9], values[10], values[11], values[12], values[13], values[14], values[15], values[16], values[17], values[18], values[19], values[20], values[21], values[22], values[23], values[24], values[25], values[26], values[27], values[28], values[29], values[30], values[31], values[32], values[33], values[34], values[35], values[36], values[37], values[38], values[39], values[40], values[41], values[42], values[43], values[44], values[45], values[46], values[47], values[48], values[49], values[50], values[51], values[52], values[53], values[54], values[55], values[56], values[57], values[58], values[59], values[60], values[61], values[62], values[63])
        let input = SimdInput(letters: letters)
        return input
    }

    // a straightforward comparison of a mask against input. Would be
    // cheaper in AVX512.
    @inlinable internal static func cmpMaskAgainstInput(input :SimdInput, m :UInt8) -> UInt64 {
        let compareLetters :SIMDMask<SIMD64<Int8>> = input.letters .== m
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
        // let x : __mmask32 = simd._mm256_bitshuffle_epi64_mask(cmpRes1, collectLeastSiginificantInByte)
        //        return UInt64(cmpAsLowerBits) | (UInt64(cmpAsUpperBits) << 32)
    }
    
    // http://bitmath.blogspot.com/2013/05/carryless-multiplicative-inverse.html
    @inlinable internal static func carryLessMultiplyScalar(factorOne :UInt64, factorTwo :UInt64) -> UInt64 {
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
    @inlinable internal static func findQuoteMask(input :SimdInput, prevIterInsideQuote :inout UInt64) -> UInt64 {

// #if arch(x86_64)
        // let quoteBitsInt64 = Int64(bitPattern: quoteBits)
        // let most sigificant int64 be 0. let least significant int64 be quoteBits
        // let factorOne :SIMD2<Int64> = simd._mm_set_epi64x(Int64.zero, quoteBitsInt64)
        //
        // let most sigificant int64 be -1. let least significant int64 be -1
        // let all8BitsOn = Int8(bitPattern: 255)
        // let factorTwo :SIMD2<Int64> = simd._mm_set1_epi8(all8BitsOn) // = 11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
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
    @inlinable internal static func flattenBits(basePtr :inout [UInt32]!, base :inout Int, idx :size_t, b :UInt64) {
        var bits = b
        if b != UInt64.zero {
            var ts:UInt32 = 0
            let cntUInt = hamming(number: bits)
            let cnt = Int(cntUInt)
            let nextBase = base + cnt
            let one = UInt64(1)
            var immediate :UInt64 = 0
            let unsignedIdx = UInt32(idx)
            
            ts = countTrailingZeros(number: bits)
            basePtr[base + 0] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 1] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 2] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 3] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 4] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 5] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 6] = unsignedIdx + ts
            immediate = UInt64(bits - one)
            bits = bits & immediate
            ts = countTrailingZeros(number: bits)
            basePtr[base + 7] = unsignedIdx + ts
            
            if cnt > 8 {
                basePtr[base + 8] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 9] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 10] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 11] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 12] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 13] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 14] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
                basePtr[base + 15] = unsignedIdx + ts
                immediate = UInt64(bits - one)
                bits = bits & immediate
                ts = countTrailingZeros(number: bits)
            }
            
            if cnt > 16 {
                base += 16
                while bits != 0 {
                    ts = countTrailingZeros(number: bits)
                    basePtr[base] = unsignedIdx + ts
                    immediate = UInt64(bits - one)
                    bits = bits & immediate
                    base = base + 1
                }
            }
            
            base = nextBase
        }
    }
        
    private static func findIndexes(buf :UnsafeMutableRawPointer!, len :size_t, pcsv :inout ParseCSV, CRLF :Bool = false) {
        var prevIterInsideQuote = UInt64.zero
        // Used by CRLF
        var prevIterCrEnd = UInt64.zero
        
        let lenminus64 :size_t = len < 64 ? 0 : len - 64
        var basePtr: [UInt32]? = pcsv.indexes!
        var base :Int = 0
        // #ifdef SIMDCSV_BUFFERING

        let SIMDCSV_BUFFERSIZE = 4 // it seems to be about the sweetspot.
        if lenminus64 > 64 * SIMDCSV_BUFFERSIZE {
            var fields :[UInt64] = Array<UInt64>.init(repeating: UInt64.zero, count: SIMDCSV_BUFFERSIZE)
            var globalIdx :size_t = 0
            let finish = lenminus64 - 64 * SIMDCSV_BUFFERSIZE + 1
            let by = 64 * SIMDCSV_BUFFERSIZE
            for idx in stride(from: globalIdx, to: finish, by: by) {
                for b in 0...SIMDCSV_BUFFERSIZE {
                    let internalIdx :size_t = 64 * b + idx
                    let bufWithOffset = buf + internalIdx
                    let input = fillInput(ptr: bufWithOffset)
                    let quoteMask = findQuoteMask(input: input, prevIterInsideQuote: &prevIterInsideQuote)
                    let sep = cmpMaskAgainstInput(input: input, m: comma)
                    var end :UInt64 = UInt64.zero
                    if CRLF {
                        let cr :UInt64 = cmpMaskAgainstInput(input: input, m: carrageReturn)
                        let crAdjusted :UInt64 = (cr << 1) | prevIterCrEnd
                        let lf :UInt64 = cmpMaskAgainstInput(input: input, m: lineFeed)
                        end = (lf & crAdjusted)
                        prevIterCrEnd = cr >> 63
                    } else {
                        end = cmpMaskAgainstInput(input: input, m: lineFeed)
                    }
                    
                    fields[b] = (end | sep) & ~quoteMask
                }
                
                for b in 0...SIMDCSV_BUFFERSIZE {
                    let internalIdx :size_t = 64 * b + idx
                    flattenBits(basePtr: &basePtr, base: &base, idx: internalIdx, b: fields[b])
                }
                
                globalIdx = idx
            }
            
            pcsv.numberOfIndexes = base
        }
        
        // tail end will be unbuffered
        for idx in stride(from: 0, to: lenminus64, by: 64) {
            let input = fillInput(ptr:buf + idx)
            let quoteMask = findQuoteMask(input: input, prevIterInsideQuote: &prevIterInsideQuote)
            let sep = cmpMaskAgainstInput(input: input, m: comma)
            var end :UInt64 = UInt64.zero
            if CRLF {
                let cr :UInt64 = cmpMaskAgainstInput(input: input, m: carrageReturn)
                let crAdjusted :UInt64 = (cr << 1) | prevIterCrEnd
                let lf :UInt64 = cmpMaskAgainstInput(input: input, m: lineFeed)
                end = lf & crAdjusted
                prevIterCrEnd = cr >> 63
            } else {
                end = cmpMaskAgainstInput(input: input, m: lineFeed)
            }
            // note - a bit of a high-wire act here with quotes
            // we can't put something inside the quotes with the CR
            // then outside the quotes with LF so it's OK to "and off"
            // the quoted bits here. Some other quote convention would
            // need to be thought about carefully
            let fieldSep = (end | sep) & ~quoteMask
            flattenBits(basePtr: &basePtr, base: &base, idx:idx, b: fieldSep)
        }
    }
    
    public func loadCSV(filepath :URL, iterations :size_t = 100, verbose:Bool = false) -> LoadResult {
        let ioUtil = IOUtil()
        if verbose {
            self.log.debug("loading %s", "\(filepath)" as CVarArg)
        }
        
        do {
            let csv :Data = try ioUtil.getCorpus(filepath: filepath, padding: SimdCSV.CSV_PADDING)
            return loadCSVData64BitPadded(csv: csv, iterations: iterations, verbose: verbose)
        } catch {
            self.log.error("%s", "\(error)" as CVarArg)
            return LoadResult(status: LoadStatus.Failed)
        }
    }
        
    public func loadCSVData64BitPadded(csv :Data, iterations :size_t = 100, verbose:Bool = false) -> LoadResult {
        let p = csv
        let loadResult = LoadResult(status: LoadStatus.OK)
        var pcsv :ParseCSV = ParseCSV()
        // pcsv.indexes = UnsafeMutablePointer<UInt32>.allocate(capacity: p.count)
        pcsv.indexes = Array<UInt32>.init(repeating: UInt32.zero, count: p.count)
        if (verbose) {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useAll]
            formatter.countStyle = .file
            let sizeAsText = formatter.string(fromByteCount: Int64(p.count))
            self.log.debug("loaded CSV sized %s", sizeAsText as CVarArg)
        }
#if os(Linux)
        let events :[Int32] = [PERF_COUNT_HW_CPU_CYCLES, PERF_COUNT_HW_INSTRUCTIONS, PERF_COUNT_HW_BRANCH_MISSES, PERF_COUNT_HW_CACHE_REFERENCES, PERF_COUNT_HW_CACHE_MISSES, PERF_COUNT_HW_REF_CPU_CYCLES]
#else
        let events :[Int32] = []
#endif

        let timingAccumulator = TimingAccumulator(numPhasesIn:2, configVec: events)
        var total :Double = 0 // naive accumulator
        p.withUnsafeBytes { rawBufferPointer in
            let baseAddress :UnsafeRawPointer = rawBufferPointer.baseAddress!
            let CSVinMemory = UnsafeMutableRawPointer(mutating: baseAddress)
            let len = rawBufferPointer.count
            for _ in 0...iterations {
                let startTime :clock_t = clock()
                repeat {
                    let timinigPhase = TimingPhase(accIn: timingAccumulator, phaseIn: 0)
                    timinigPhase.start()
                    SimdCSV.findIndexes(buf: CSVinMemory, len:len, pcsv: &pcsv)
                } while (false)
                repeat {
                    let timingPhase = TimingPhase(accIn: timingAccumulator, phaseIn: 1)
                    timingPhase.start()
                } while (false)
                
                let endTime = clock()
                total += Double(endTime - startTime)
            }
        }
        
        let volume :Double = Double(iterations * p.count)
        let timeInS :Double = total / Double(CLOCKS_PER_SEC)
        if verbose {
            self.log.debug("Total time in (s) %@", timeInS as CVarArg)
            
            self.log.debug("Number of iterations %@", volume)
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
        } else {
            timingAccumulator.dump()
        }
        
        return loadResult
        /*
        } catch {
            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                os_log("[ERROR] \(error).")
            } else {
                print("[ERROR] \(error).")
            }

            return LoadResult(status: LoadStatus.Failed)
        }
 */
    }
}
