# SimdCSV for Swift

SimdCSV for Swift. Delivering the fastest way to read comma separated values (csv) in Swift code.
All CSV defined by [RFC 4180](https://tools.ietf.org/html/rfc4180).

Why would anyone use a custom CSV parser when Swift comes with alternatives built in? Because SimdCSV is the fastest, most energy efficient CSV parser out there. In addition the tape format, SimdCSV uses to represent the data is highly memory efficiant and supports [Memory-mapped I/O](https://en.wikipedia.org/wiki/Memory-mapped_I/O).

The gist of it is that SimdCSV for Swift is not your ordinary parser. If machine efficiency is a key priority then SimdCSV for Swift is the right choice for you.

## Introduction

SimdCSV for Swift is a port of [simdcsv](https://github.com/geofflangdale/simdcsv) to [Swift](https://swift.org/).

It follows the same API design as the original C implementation, but uses more swift like interfaces. That means a couple of new classes are added. Swift arrays of [UInt32](https://developer.apple.com/documentation/swift/uint32) and [Data](https://developer.apple.com/documentation/foundation/data) struct are swapped in favor of the original pointer data types.

### Design Philosophy

The original implementation also relied heavily on Single Instruction Multiple Data \(SIMD\) from ARM neon and Intel SSE1, SSE2, SSE3, SSE4 and AVX2. Most modern Swift programs relies on [Apple bitcode](https://www.quora.com/What-is-Apple-Bitcode?share=1), and SimdCSV for Swift reflects that by utilising the [simd package](https://developer.apple.com/documentation/swift/simd) in stead of hand coded architecture specific SIMD instructions. The end result is different assembly, and slower code than hand coded SIMD, but the  benefits with this approach overshadows the drawbacks.
The benefits are a single common code base across all architectures with next to no preprocessor conditions, support for 32 and 64 bit ARM and X86 architectures. Support for all operating systems with swift support, and future performance improvements on future architectures when deploying Apple bitcode to the Apple Appstore.

## Prerequisites

* Xcode
* MacOS 10.13

## Getting Data in Code

This library uses tape format. In practice that means you have to open your data source (usually a file), and read your data as text or numbers. The tape format will help you seek to the right byte position, and byte length, so you know where to read.

Import the Swift package, and import the package. Do your manual inspection of the input data, and make up your mind what CSV headers, or column indecies are important. Code that in to your program.

In the example below we are reading the column 1 and 3 from the [Ticks to Ride example](https://TODO) we use.

```Swift
import SimdCSV
import os.log

public class MyLoader {
    private static var subsystem = Bundle.main.bundleIdentifier!

    func load() {
        let logger =  OSLog(subsystem: subsystem, category: "MyLoader")
        let simdCSV = SimdCSV.init(log:logger)
        let fileName = URL(string: "input.csv")
        let result = simdCSV.loadCSV(fileName)
        simdCSV.dump(result)
    }
}

func main() {
    let main = Main.init()
}

```

## Contributions

[Andreas Dreyer Hysing](https://github.com/ahysing) is the single contributor of this software. If you have suggestions for future versions feel free to send a message on [@hysing on Twitter](https://twitter.com/ahysing) or [github](https://github.com/ahysing).

Pull requests are welcomed. If you write propose pull request it should conform with the [Design Principles](docs/principles.md) as they are layed out.
