# SimdCSV for Swift Design Philosophy

This document describes what design principles are layed out for SimdCSV for swift, hereby refered to as the software. It highlights what key conciderations are taken. It covers what the design goals are, and what approach is taken when choosing between portability and speed.
We also sketch out what not supported.

SimdCSV for Swift is a port of [simdcsv](https://github.com/geofflangdale/simdcsv) to [Swift](https://swift.org/). We refer to [simdcsv](https://github.com/geofflangdale/simdcsv) simply as the original implementation.

## Speed or Portability

[simdcsv](https://github.com/geofflangdale/simdcsv) relies heavily on Single Instruction Multiple Data \(SIMD\) from [ARM neon] and Intel [SSE1](), [SSE2](), [SSE3](), [SSE4] and [AVX2](). Most modern Swift programs relies on [Apple bitcode](https://www.quora.com/What-is-Apple-Bitcode?share=1), and SimdCSV for Swift reflects that by utilising the [simd package](https://developer.apple.com/documentation/swift/simd) as a replacement of hand coded architecture specific SIMD instructions. The end result is different instructions, and slower code, than hand coded intrinsics. But the benefits overshadows the drawbacks.

The benefits are a single common code base across all architectures with next to no preprocessor conditions, support for 32 and 64 bit ARM and X86 architectures. Support for all operating systems with swift support, and future performance improvements on future architectures when deploying Apple bitcode to the Apple Appstore.

## What Architectures are Covered

We try to achieve full architectural coverage for Apple devices. At some point we have to draw the line, and drop support. With current version of the software the oldest devices we support are macs 
 after the [IBM PowerPC]() to [Intel X86_64]() switch as well as all iOS, tvOS and watchOS devices.
 At some point the software is solely constrained by software requirements. Software is covered by the next section.

## What Software is Supported

The software is limited to the following operating systems.

    * macOS 10.14
    * iOS 8
    * tvOS 9
    * watchOS 3

If you run a newer version of these operating systems your software is supported.

## On Testing

Testing is covered by a test suite. Based on 31 unit tests we covered all known aspects of SimdCSV. All tests should pass on every system except WatchOS. **Please run the test suite on every application and target device you build.**

We have not found a way to run unit tests for watchOS. CXTest framework is simply not compatible with watchOS.

While this software is compatible with a wide range of different devices it has not been tested on all those devices. That would be too time consuming and costly.

We have designed, and tested, on the devices below

* MacBook Pro (Retina, 15-inch, Mid 2014) with macOS Catalina

