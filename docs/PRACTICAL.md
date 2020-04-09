# On Practical Matters

This document covers the practical aspects of using SimdCSV for Swift. SimdCSV for Swift is from now on refered to as the software. It tries to cover when you should use the package.

The software has support for [RFC 4180](https://tools.ietf.org/html/rfc4180) CSV. Spend some time on inspecting your input data for these deviations from the RFC. If you see any of these in you'r input data the software would not support reading.

* Not UTF-8 input
* unquoted double quotes or comma in columns
* Tabs instead of comma as column separators
* Not one of ~Carrage Return then Line Feed~ or ~newline~ as the end of line marker.

The software does not support Writing CSV.

It is recommended to use the software for loading [RFC 4180](https://tools.ietf.org/html/rfc4180) compatible CSV files into your program, and use different software for writing files and handling non standard CSV files. That approach would give the benefits of the fastest CSV-reader across all apple products while at the same time being able to write the required formats.

# API Design

This library uses tape format. In practice that means you have to open your data source (usually a file), and read your data as text or numbers. The tape format will help you seek to the right byte position, and byte length, in your data source. So you know where to read.

See example

```
| "Example Name","Value" | Data in file         |
|  ^          ^   ^   ^  | Tape format pointers |
|p[0]      p[1] p[2] p[3]|                      |
```

When you know where to read you have to handle the byte sequences into meaningful data structures yourself.

This design leaves key aspects such text to numbers or dates or reading CSVs to records. In the other hand such a primitive design achieves a low memory footprint and great speed. It' sequential pattern is well fitted for physical hard drives.