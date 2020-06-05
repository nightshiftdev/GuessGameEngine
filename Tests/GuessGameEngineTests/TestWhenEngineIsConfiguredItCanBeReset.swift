//
//  TestWhenEngineIsConfiguredItCanBeReset.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 6/4/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class TestWhenEngineIsConfiguredItCanBeReset: XCTestCase, GuessGameDelegate {
    var game: GuessGame!
    var players: [Player]!
    var playerIdx = 0
    var resetCmdEnqueued = false
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
            let factory = EngineCommandFactory()
            guard let player0InputCommand = factory.makeCommand(params:["player":players[0].name,"type":"PlayerInputCommand","value":1]) else { XCTFail(); return }
            self.game.enqueue(player0InputCommand)
            guard let resetCmd = factory.makeCommand(params: ["resetEngine":true,"type":"ResetEngineCommand"]) else { XCTFail(); return }
            self.game.enqueue(resetCmd)
            self.resetCmdEnqueued = true
            guard let player1InputCommand = factory.makeCommand(params:["player":players[1].name,"type":"PlayerInputCommand","value":1]) else { XCTFail(); return }
            self.game.enqueue(player1InputCommand)
        }
        if event.type == .waitingToConfigureGame && self.resetCmdEnqueued {
            self.game.delegate = nil
            self.ex.fulfill()
        }
    }
    
    func test() {
        self.ex = expectation(description: #function)
        let factory = EngineCommandFactory()
        guard let startGameCommand = factory.makeCommand(params: ["players":players!,"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":1,"delay":1.0,"winningGuess":50]) else { XCTFail(); return }
        game.enqueue(startGameCommand)
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    static var allTests = [
        ("test",test)
    ]
}
