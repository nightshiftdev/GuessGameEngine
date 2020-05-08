import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CommandTests.allTests),
        testCase(CoreLogicTests.allTests),
        testCase(EventQueueTests.allTests),
        testCase(GameLoopTests.allTests),
        testCase(GuessGameTests.allTests)
    ]
}
#endif
