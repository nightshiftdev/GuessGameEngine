//
//  TestWhenTheGameEventCarriesAHintItShouldAlsoContainLastGuess.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 6/6/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class TestWhenTheGameEventCarriesAHintItShouldAlsoContainLastGuess: XCTestCase, GuessGameDelegate {
    var game: GuessGame!
    var players: [Player]!
    var playerIdx = 0
    var ex:XCTestExpectation!
    var guessIdx = 0
    var hintIdx = 0
    let guesses = [2,99,50]
    let hints = ["","more","less","found"]
    
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
        print("EVENT:\(event)")
        if event.type == .readyForUserInput {
            guard let hint = event.data["hint"] as? String else { XCTFail(); return }
            print("HINT:\(hint)")
            if !hint.isEmpty {
                guard  let lastGuess = event.data["lastGuess"] as? Int else { XCTFail(); return }
                print("LAST GUESS:\(lastGuess)")
            }
            if hints[hintIdx] != hint { XCTFail(); return }
            hintIdx += 1
            guard let p = event.data["player"] as? Player else { XCTFail(); return }
            if players[playerIdx].name != p.name {
                XCTFail()
            }
            let factory = EngineCommandFactory()
            let g = guesses[guessIdx]
            print("GUESS:\(g)")
            guard let nextPlayerInputCommand = factory.makeCommand(params:["player":players[playerIdx].name,"type":"PlayerInputCommand","value":g]) else { XCTFail(); return }
            self.game.enqueue(nextPlayerInputCommand)
            guessIdx += 1
            if playerIdx < players.count-1 {
                playerIdx += 1
            } else {
                playerIdx = 0
            }
        }
        if event.type == .playerWon {
            guard let hint = event.data["hint"] as? String else { XCTFail(); return }
            print("HINT:\(hint)")
            if hints[hintIdx] != hint { XCTFail(); return }
            self.game.delegate = nil
            ex.fulfill()
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
