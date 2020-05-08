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
    }

    override func tearDown() {
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
    
    static var allTests = [
        ("testCreateGameLoop",testCreateGameLoop),
        ("testIfGameLoopInitializedItCanRun",testIfGameLoopInitializedItCanRun),
        ("testIfGameLoopRunsItConsumesCommands",testIfGameLoopRunsItConsumesCommands)
    ]
}
