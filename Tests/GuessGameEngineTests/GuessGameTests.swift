//
//  GuessGameTests.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 4/9/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class GuessGameTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testCreateGuessGame() {
        let handler = GameEventHandler {_ in }
        let game: GuessGame? = GuessGame(delegate:handler)
        XCTAssertNotNil(game)
    }
    
    typealias GameEventCompletionHandler = (GameEvent) -> Void
    struct GameEventHandler: GuessGameDelegate {
        let completionHandler:GameEventCompletionHandler
        func handle(event: GameEvent) {
            completionHandler(event)
        }
    }
    
    func testWhenGuessGameConfiguredItWaitsForUserInput() {
        let ex = expectation(description: #function)
        let handler = GameEventHandler { (event) in
            if event.type == .readyForUserInput {
                ex.fulfill()
            }
        }
        let game = GuessGame(delegate:handler)
        let factory = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        guard let startGameCommand = factory.makeCommand(params: ["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3]) else { XCTFail(); return }
        game.enqueue(startGameCommand)
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testWhenGuessGameStartsItExpectsConfigureCommand() {
        let ex = expectation(description: #function)
        let handler = GameEventHandler { (event) in
            if event.type == .waitingToConfigureGame {
                ex.fulfill()
            } else {
                XCTFail()
            }
        }
        let _ = GuessGame(delegate:handler)
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testWhenGuessGameGetsUndefinedCmdItSetsTheGameIntoUndefinedState() {
        let ex = expectation(description: #function)
        let handler = GameEventHandler { (event) in
            if event.type == .undefinedState {
                ex.fulfill()
            }
        }
        guard let cmd = TestCommand(params: ["":""]) else { XCTFail(); return }
        let game = GuessGame(delegate:handler)
        game.enqueue(cmd)
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testWhenPlayerNamesNotUniqueGameReturnsConfigureGameEventWithError() {
        let ex = expectation(description: #function)
        let handler = GameEventHandler { (event) in
            if event.type == .waitingToConfigureGame && event.data["error"] != nil {
                guard let errorMsg = event.data["error"] else { XCTFail(); return }
                print(errorMsg)
                ex.fulfill()
            }
        }
        let game = GuessGame(delegate:handler)
        let factory = EngineCommandFactory()
        let p1 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        guard let startGameCommand = factory.makeCommand(params: ["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3]) else { XCTFail(); return }
        game.enqueue(startGameCommand)
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
