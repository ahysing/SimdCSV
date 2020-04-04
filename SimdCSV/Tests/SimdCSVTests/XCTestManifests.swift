#if !os(watchOS)

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SimdCSVTests.allTests),
        testCase(LoadResultTests.allTests),
        testCase(LoadStatusTests.allTests),
        testCase(SimdInputTests.allTests),
        testCase(IOUtilTests.allTests)
    ]
}
#endif

#endif
