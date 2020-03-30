import XCTest

import SimdCSVTests
import LoadResultTests
import LoadStatusTests
import ParsedCSVTests

var tests = [XCTestCaseEntry]()
tests += SimdCSVTests.allTests()
tests += LoadResultTests.allTests()
tests += Load.allTests()
tests += SimdCSVTests.allTests()
tests += SimdCSVTests.allTests()
XCTMain(tests)
