//
//  TestWhenGameOverEventSentItShouldContainWinningGuess.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 6/21/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class TestWhenGameOverEventSentItShouldContainWinningGuess: XCTestCase, GuessGameDelegate {
    var game: GuessGame!
    var players: [Player]!
    var playerIdx = 0
    var ex:XCTestExpectation!
    
    override func setUpWithError() throws {
        self.game = GuessGame(delegate: self)
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 1)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 1)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 1)
        self.players = [p1,p2,p3]
    }

    override func tearDownWithError() throws {
        
    }

    func handle(event: GameEvent) {
        if event.type == .readyForUserInput {
            guard let p = event.data["player"] as? Player else { XCTFail(); return }
            if players[playerIdx].name != p.name {
                XCTFail()
            }
            if playerIdx < players.count-1 {
                playerIdx += 1
            } else {
                playerIdx = 0
            }
            let factory = EngineCommandFactory()
            guard let nextPlayerInputCommand = factory.makeCommand(params:["player":players[playerIdx].name,"type":"PlayerInputCommand","value":1]) else { XCTFail(); return }
            self.game.enqueue(nextPlayerInputCommand)
        }
        if event.type == .gameOver {
            guard let _ = event.data["target"] as? Int else { XCTFail(); return }
            self.game.delegate = nil
            self.ex.fulfill()
        }
    }
    
    func test() {
        self.ex = expectation(description: #function)
        let factory = EngineCommandFactory()
        guard let startGameCommand = factory.makeCommand(params: ["players":players!,"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":1,"delay":1.0,"winningGuess":50]) else { XCTFail(); return }
        game.enqueue(startGameCommand)
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    static var allTests = [
        ("test",test)
    ]
}
