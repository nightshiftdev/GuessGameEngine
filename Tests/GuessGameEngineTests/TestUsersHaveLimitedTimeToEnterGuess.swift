//
//  TestIfUserDoesNotEnterGuessHisTurnIsSkipped.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 4/20/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class TestUsersHaveLimitedTimeToEnterGuess: XCTestCase, GuessGameDelegate {
    var game: GuessGame!
    var players: [Player]!
    var playersSet:Set<Player>!
    var playerIdx = 0
    var ex:XCTestExpectation!
    
    override func setUpWithError() throws {
        self.game = GuessGame(delegate: self)
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 1)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 1)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 1)
        self.players = [p1,p2,p3]
        self.playersSet = Set<Player>(self.players)
    }

    override func tearDownWithError() throws {
        
    }

    func handle(event: GameEvent) {
        print("Test:Handle event:\(event.type)")
        if event.type == .readyForUserInput {
            guard let p = event.data["player"] as? Player else { XCTFail(); return }
            if !self.playersSet.contains(p) {
                XCTFail()
            } else {
                self.playersSet.remove(p)
            }
        }
        if event.type == .gameOver {
            self.game.delegate = nil
            self.ex.fulfill()
        }
    }
    
    func test() {
        self.ex = expectation(description: #function)
        let factory = EngineCommandFactory()
        guard let startGameCommand = factory.makeCommand(params: ["players":players!,"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":1,"delay":1.0,"winningGuess":50]) else { XCTFail(); return }
        game.enqueue(startGameCommand)
        waitForExpectations(timeout: 100.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    static var allTests = [
        ("test",test)
    ]
}
