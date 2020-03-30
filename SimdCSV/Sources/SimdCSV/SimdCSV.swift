//
//  SimdCSV.swift
//
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//
import Foundation
import simd
import os.log

public let CSV_PADDING :size_t = 64

private let PERF_COUNT_HW_CPU_CYCLES :Int32 = 1
private let PERF_COUNT_HW_INSTRUCTIONS :Int32 = 2
private let PERF_COUNT_HW_BRANCH_MISSES :Int32 = 4
private let PERF_COUNT_HW_CACHE_REFERENCES :Int32 = 8
private let PERF_COUNT_HW_CACHE_MISSES :Int32 = 16
private let PERF_COUNT_HW_REF_CPU_CYCLES :Int32 = 32

struct SimdCSV {
#if arch(x86_64)
    public let compileSettings = "x86_64"
#elseif (arch(arm64))
    public let compileSettings = "neon"
#else
    public let compileSettings = ""
#endif
    public let hasSIMD = SIMD_COMPILER_HAS_REQUIRED_FEATURES
    private let log :OSLog
    init(log :OSLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SimdCSV")) {
        self.log = log
    }
    
    private static func fillInput(ptr :UnsafeRawPointer!) -> SimdInput {
#if arch(x86_64)
        let lo :simd.__m256i = simd._mm256_load_epi64(ptr)
        let hi :simd.__m256i = simd._mm256_load_epi64(ptr + 8)
        let input = SimdInput(lo:lo, hi:hi)
#elseif (arch(arm64))
        let input = SimdInput()
        input.i0 = simd.vld1q_u8(ptr)
        input.i1 = simd.vld1q_u8(ptr + 2)
        input.i2 = simd.vld1q_u8(ptr + 4)
        input.i3 = simd.vld1q_u8(ptr + 6)
#endif
        return input
    }
    
    // a straightforward comparison of a mask against input. 5 uops; would be
    // cheaper in AVX512.
    internal static func cmpMaskAgainstInput(input :SimdInput, m :Int8) -> Int64 {
#if arch(x86_64)
        let mask = simd._mm256_set_epi8(m, m, m, m,
                                        m, m, m, m,
                                        m, m, m, m,
                                        m, m, m, m,
                                        m, m, m, m,
                                        m, m, m, m,
                                        m, m, m, m,
                                        m, m, m, m)
        let cmpRes0 = simd._mm256_cmpeq_epi8(input.lo, mask)
        // let res0 :Int64 = Int64(UInt32(simd._mm256_movemask_epi8(cmpRes0)))
        let res0 :Int64 = 0
        let cmpRes1 = simd._mm256_cmpeq_epi8(input.hi, mask)
        //let res1 :Int64 = Int64(simd._mm256_movemask_epi8(cmpRes1))
        let res1 :Int64 = 0
        return res0 | (res1 << 32)
        return Int64(0)
#elseif (arch(arm64) || arch(arm))
        let mask = simd.vmovq_n_u8(m)
        let cmpRes0 = simd.vceqq_u8(input.i0, mask)
        let cmpRes1 = simd.vceqq_u8(input.i1, mask)
        let cmpRes2 = simd.vceqq_u8(input.i2, mask)
        let cmpRes3 = simd.vceqq_u8(input.i3, mask)
        return neonmovemaskBulk(cmpRes0, cmpRes1, cmpRes2, cmpRes3)
#endif
    }
    
    // return the quote mask (which is a half-open mask that covers the first
    // quote in a quote pair and everything in the quote pair)
    // We also update the prev_iter_inside_quote value to
    // tell the next iteration whether we finished the final iteration inside a
    // quote pair; if so, this  inverts our behavior of  whether we're inside
    // quotes for the next iteration.
    private static func findQuoteMask(input :SimdInput, prevIterInsideQuote :inout UInt64) -> UInt64 {
        let m = Int8(Array("\"".utf8)[0])
        let quoteBits = cmpMaskAgainstInput(input: input, m: m)
#if arch(x86_64)
        let a :simd.__m128i = simd._mm_set_epi64x(0, quoteBits)
        let b :simd.__m128i = simd._mm_set1_epi8(Int8.min)
        // TODO Figure out if the original _mm_clmulepi64_si128 can be swapped for _mm_mul_epi32
        let immediate = simd._mm_mul_epi32(a, b)
        var quoteMask = UInt64(simd._mm_cvtsi128_si64(immediate))
#elseif (arch(arm64) || arch(arm))
        let minusOne :UInt64 = -1
        let quoteMask :UInt64 = simd.vmull_p64(minusOne, quoteBits)
#endif
        quoteMask ^= prevIterInsideQuote
        // right shift of a signed value expected to be well-defined and standard
        // compliant as of C++20,
        // John Regher from Utah U. says this is fine code
        prevIterInsideQuote = UInt64(Int64(quoteMask) >> 63)
        return quoteMask
    }
    
    private static func flatternBits(basePtrRaw :UnsafeMutableRawPointer!, base :inout Int, idx :UInt32, b :UInt64) {
        var bits = b
        if bits != UInt64(0) {
            let basePtr: UnsafeMutablePointer<UInt32> = basePtrRaw.assumingMemoryBound(to: UInt32.self)
            let cnt = Int(hamming(input_num: bits))
            let nextBase = base + cnt
            let one = UInt64(1)
            var immediate :UInt64 = 0
            basePtr[base + 0] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 1] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 2] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 3] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 4] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 5] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 6] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            immediate = UInt64(bits - one)
            bits = bits & immediate
            basePtr[base + 7] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
            
            if cnt > 8 {
                basePtr[base + 8] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 9] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 10] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 11] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 12] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 13] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 14] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
                basePtr[base + 15] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                immediate = UInt64(bits - one)
                bits = bits & immediate
            }
            
            if cnt > 16 {
                base += 16
                while bits != 0 {
                    basePtr[base] = UInt32(idx) + UInt32(trailingZeroes(input_num: bits))
                    immediate = UInt64(bits - one)
                    bits = bits & immediate
                    base = base + 1
                }
            }
            
            base = nextBase
        }
    }
    
    private static func findIndexes(buf :UnsafeMutableRawPointer!, len :size_t, pcsv :inout ParseCSV, CRLF :Bool = false) {
        var prevIterInsideQuote :UInt64 = 0
        var prevIterCrEnd :UInt64 = 0
        let lenminus64 :size_t = len < 64 ? 0 : len - 64
        // idx
        let basePtr = pcsv.data
        var base = 0
        let comma :Int8 = Int8(Array(",".utf8)[0])
        let SIMDCSV_BUFFERSIZE = 4 // it seems to be about the sweetspot.
        if lenminus64 > 64 * SIMDCSV_BUFFERSIZE {
            var fields :[UInt64] = [0, 0, 0, 0]
            let finish = (lenminus64 - 64 * SIMDCSV_BUFFERSIZE + 1)
            let by = 64 * SIMDCSV_BUFFERSIZE
            for idx in stride(from: 0, to: finish, by: by) {
                for b in 0...SIMDCSV_BUFFERSIZE {
                    let internalIdx :size_t = 64 * b + idx
                    // __builtin_prefetch(buf + internal_idx + 128); on microsoft c++ compilers
                    let bufWithOffset = buf + internalIdx
                    let input = fillInput(ptr: bufWithOffset)
                    let quoteMask = findQuoteMask(input: input, prevIterInsideQuote: &prevIterInsideQuote)
                    let sep = cmpMaskAgainstInput(input: input, m: comma)
                    var end :UInt64
                    if CRLF {
                        let cr :UInt64 = UInt64(cmpMaskAgainstInput(input: input, m: 0x0d))
                        let crAdjusted :UInt64 = (cr << 1) | prevIterCrEnd
                        let lf :UInt64 = UInt64(cmpMaskAgainstInput(input: input, m: 0x0a))
                        end = (lf & crAdjusted)
                        prevIterCrEnd = cr >> 63
                    } else {
                        end = UInt64(cmpMaskAgainstInput(input: input, m: 0x0a))
                    }
                    
                    fields[b] = (end | UInt64(sep)) & ~quoteMask
                }
                
                for b in 0...SIMDCSV_BUFFERSIZE
                {
                    let internalIdx = 64 * b + idx
                    flatternBits(basePtrRaw: basePtr, base: &base, idx: UInt32(internalIdx), b: fields[b])
                }
            }
        }
        
        // tail end will be unbuffered
        for idx in stride(from: 0, to: lenminus64, by: 64) {
            //       __builtin_prefetch(buf + idx + 128); on Microsoft visual studio compilers
            let input = fillInput(ptr:buf + idx)
            let quoteMask = findQuoteMask(input: input, prevIterInsideQuote: &prevIterInsideQuote)
            let sep = UInt64(cmpMaskAgainstInput(input: input, m: comma))
            var end :UInt64
            if CRLF {
                let cr :UInt64 = UInt64(cmpMaskAgainstInput(input: input, m: 0x0d))
                let crAdjusted :UInt64 = (cr << 1) | prevIterCrEnd
                let lf :UInt64 = UInt64(cmpMaskAgainstInput(input: input, m: 0x0a))
                end = lf & crAdjusted
                prevIterCrEnd = cr >> 63
            } else {
                end = UInt64(cmpMaskAgainstInput(input: input, m: 0x0a))
            }
            // note - a bit of a high-wire act here with quotes
            // we can't put something inside the quotes with the CR
            // then outside the quotes with LF so it's OK to "and off"
            // the quoted bits here. Some other quote convention would
            // need to be thought about carefully
            let fieldSep = (end | sep) & ~quoteMask
            flatternBits(basePtrRaw: basePtr, base: &base, idx: UInt32(idx), b: fieldSep)
        }
    }
    
    public func loadCSV(filepath :URL, iterations :size_t = 100, verbose:Bool = false) -> LoadResult {
        let loadResult = LoadResult(status: LoadStatus.OK)
        var pcsv :ParseCSV = ParseCSV()
        let evts :[Int32] = [PERF_COUNT_HW_CPU_CYCLES, PERF_COUNT_HW_INSTRUCTIONS, PERF_COUNT_HW_BRANCH_MISSES, PERF_COUNT_HW_CACHE_REFERENCES, PERF_COUNT_HW_CACHE_MISSES, PERF_COUNT_HW_REF_CPU_CYCLES]
        let ioUtil = IOUtil()
        do {
            let p :Data = try ioUtil.getCorpus(filepath: filepath, padding: CSV_PADDING)
            // let size = p.count
            // pcsv.indexes = Array(repeating: nil, count: size)
            // if pcsv.indexes.count == 0 {
            //     os_log("[ERROR] You are running out of memory.")
            //     return LoadResult(status: LoadStatus.Failed)
            // }
            let ta = TimingAccumulator(numPhasesIn:2, configVec: evts)
            var total :UInt = 0 // naive accumulator
            p.withUnsafeBytes { rawBufferPointer in
                let size = rawBufferPointer.count
                let baseAddress :UnsafeRawPointer = rawBufferPointer.baseAddress!
                let CSVinMemory = UnsafeMutableRawPointer(mutating: baseAddress)
                pcsv.data = CSVinMemory
                for _ in 0...iterations {
                    let start = clock()
                    _ = TimingPhase(accIn: ta, phaseIn: 0)
                    SimdCSV.findIndexes(buf: CSVinMemory, len: size, pcsv: &pcsv)
                    _ = TimingPhase(accIn:ta, phaseIn: 1)
                    total += (clock() - start)
                }
            }
            
            let volume = iterations * p.count
            let timeInS = total / UInt(CLOCKS_PER_SEC)
            if verbose {
                os_log("[verbose] Total time in (s) %@", self.log, timeInS)
                os_log("[verbose] Number of iterations %@", self.log, volume)
                 /*
                os_log("[verbose] Number of cycles %@", self.log, cycles)
               
                os_log("[verbose] Number of cycles per byte %@", self.log, cycles)
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
                os_log("[verbose] %@", self.log, "done")
            }
            
            return loadResult
        } catch {
            os_log("[ERROR] %@", "\(error).")
            return LoadResult(status: LoadStatus.Failed)
        }
    }
}
