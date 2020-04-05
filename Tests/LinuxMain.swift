import XCTest

import SimdCSVTests
import LoadResultTests
import LoadStatusTests
import ParsedCSVTests
import SimdInputTests
import PortabilityTests

var tests = [XCTestCaseEntry]()
tests += SimdCSVTests.allTests()
tests += LoadResultTests.allTests()
tests += Load.allTests()
tests += SimdCSVTests.allTests()
tests += SimdInputTests.allTests()
tests += PortabilityTests.allTests()
XCTMain(tests)
