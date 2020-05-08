import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CommandTests.allTests),
        testCase(CoreLogicTests.allTests),
        testCase(EventQueueTests.allTests),
        testCase(GameLoopTests.allTests),
        testCase(GuessGameTests.allTests),
        testCase(QueueTest.allTests),
        testCase(TestIfPlayerDoesNotEnterGuessThePlayerTurnIsSkipped.allTests),
        testCase(TestIfPlayerEntersCorrectGuessWinsTheGame.allTests),
        testCase(TestIfUserDoesNotEnterGuessHisTurnIsSkipped.allTests),
        testCase(TestUsersHaveLimitedTimeToEnterGuess.allTests),
        testCase(TestWhenGameConfiguredItCyclesThroughAllUsersAndFinishes.allTests)
    ]
}
#endif
