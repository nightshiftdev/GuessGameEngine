//
//  APITests.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 5/11/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class APITests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testThatCanCreateGuessGameEngineAPI() {
        let handler = GuessGameDelegateHandler { _ in }
        let api:GuessGameEngine = GuessGameEngine(delegate: handler)
        XCTAssertNotNil(api)
    }
    
    func testThatAPIAllowsToCreateCommands() {
        let handler = GuessGameDelegateHandler { _ in }
        let api = GuessGameEngine(delegate: handler)
        let cmd = api.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":1])
        XCTAssertNotNil(cmd)
    }
    
    struct GuessGameDelegateHandler: GuessGameDelegate {
        typealias GuessGameDelegateCompletionBlock = (GameEvent) -> Void
        let completionBlock: GuessGameDelegateCompletionBlock
        func handle(event: GameEvent) {
            completionBlock(event)
        }
    }
    
    func testThatCanSetupDelegateOnGuessGameEngine() {
        let ex = expectation(description: #function)
        let handler = GuessGameDelegateHandler { event in
            if event.type == .readyForUserInput {
                ex.fulfill()
            }
        }
        let api = GuessGameEngine(delegate: handler)
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        guard let c = api.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3]) else { XCTFail(); return }
        api.enqueue(command: c)
        waitForExpectations(timeout:1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    static var allTests = [
        ("testThatCanCreateGuessGameEngineAPI",testThatCanCreateGuessGameEngineAPI),
        ("testThatAPIAllowsToCreateCommands",testThatAPIAllowsToCreateCommands),
        ("testThatCanSetupDelegateOnGuessGameEngine",testThatCanSetupDelegateOnGuessGameEngine),
    ]
}
