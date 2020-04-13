# SimdCSV for Swift

SimdCSV for Swift. Delivering the fastest way to read comma separated values (csv) in Swift code.
All CSV defined by [RFC 4180](https://tools.ietf.org/html/rfc4180).

Why would anyone use a custom CSV parser when Swift comes with alternatives built in? Because SimdCSV is the fastest, most energy efficient CSV parser out there. In addition the tape format, SimdCSV uses to represent the data is highly memory efficient.

The gist of it is that SimdCSV for Swift is not your ordinary parser. If machine efficiency is a key priority then SimdCSV for Swift is the right choice for you.

## Introduction

SimdCSV for Swift is a port of [simdcsv](https://github.com/geofflangdale/simdcsv) to [Swift](https://swift.org/).

It follows the same API design as the original C implementation, but uses more swift like interfaces. That means a couple of new classes are added. Swift arrays of [UInt32](https://developer.apple.com/documentation/swift/uint32) and [Data](https://developer.apple.com/documentation/foundation/data) struct are swapped in favor of the original pointer data types.

## Prerequisites

These are the prerequisites for building the software.

* Xcode
* MacOS 10.13

## Getting Data in Code

Import the Swift package in your prject, and `import SimdCSV` in your code. Do your manual inspection of the input data, and make up your mind what CSV cells are important. The software supports reading columns by header names or column indecies. Code that into your program.

In the example below we are reading the column 1 and 3 from the [Ticks to Ride example](https://TODO) we use.

```Swift
import SimdCSV

public class MyLoader {
    func load() {
        let simdCSV = SimdCSV()
        let fileName = URL(string: "input.csv")!
        let result = simdCSV.loadCSV(filepath: fileName, CRLF:true)
        simdCSV.dump(result)
    }
}

func main() {
    let main = Main.init()
}

```

If you are still concidering to use the software I highly recommend you read through [On Practical Matters](docs/PRACTICAL.md).

## Contributions

[Andreas Dreyer Hysing](https://github.com/ahysing) is the single contributor of this software. If you have suggestions for future versions feel free to send a message on [@hysing on Twitter](https://twitter.com/ahysing) or [github](https://github.com/ahysing).

Pull requests are welcomed. If you write propose pull request it should conform with the [Design Principles](docs/PRINCIPLES.md) as they are layed out.
