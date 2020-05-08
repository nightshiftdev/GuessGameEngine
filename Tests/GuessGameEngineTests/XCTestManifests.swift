import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CommandTests.allTests),
        testCase(CoreLogicTests.allTests),
    ]
}
#endif
