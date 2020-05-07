//
//  GameLoopTests.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 3/21/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class GameLoopTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateGameLoop() {
        let eq = EventQueue()
        let loop:GameLoop? = GameLoop(eventQueue:eq)
        XCTAssertNotNil(loop)
    }
    
    func testIfGameLoopInitializedItCanRun() {
        let eq = EventQueue()
        let loop = GameLoop(eventQueue: eq)
        loop.run()
    }
    
    func testIfGameLoopRunsItConsumesCommands() {
        let eq = EventQueue()
        let _ = GameLoop(eventQueue: eq)
        guard let c = EngineCommandFactory().makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":1]) else { XCTFail(); return }
        eq.enqueue(command:c)
        XCTAssert(eq.nextCommand() == nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
