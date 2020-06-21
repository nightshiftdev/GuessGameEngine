//
//  TestWhenReadyForUserInputEventSentItShouldContainDelay.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 6/21/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class TestWhenReadyForUserInputEventSentItShouldContainDelay: XCTestCase, GuessGameDelegate {
    var game: GuessGame!
    var ex:XCTestExpectation!
    
    override func setUpWithError() throws {
        self.game = GuessGame(delegate: self)
    }

    override func tearDownWithError() throws {
        
    }

    func handle(event: GameEvent) {
        if event.type == .readyForUserInput {
            guard let _ = event.data["delay"] as? Double else { XCTFail(); return }
            self.game.delegate = nil
            self.ex.fulfill()
        }
    }
    
    func test() {
        self.ex = expectation(description: #function)
        let factory = EngineCommandFactory()
        let p = Player(name: "Pawel", numOfGuessesLeft: 1)
        guard let startGameCommand = factory.makeCommand(params: ["players":[p],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":1,"winningGuess":50,"delay":1.0]) else { XCTFail(); return }
        game.enqueue(startGameCommand)
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    static var allTests = [
        ("test",test)
    ]
}
