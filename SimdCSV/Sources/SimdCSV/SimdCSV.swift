import simd

public let CSV_PADDING :UInt32 = 64

struct SimdCSV {
    public var compileSettings = "neon"
    public var hasSIMD = SIMD_COMPILER_HAS_REQUIRED_FEATURES
    public func loadCSV(filename :String, verbose:Bool) -> LoadResult {
        return LoadResult()
    }
}
