//
//  CoreLogicTests.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 4/4/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class CoreLogicTests: XCTestCase {
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testThatCanCreateCoreLogic() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl:CoreLogic? = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:1)
        XCTAssertNotNil(cl)
    }
    
    func testIfGameObjectExistsThenCanEvaluateUserInput() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:1)
        let r = cl.evaluate(input:1,player:p)
        XCTAssert(r == .won)
    }
    
    func testIfGuessIsLessThanTargetAndNumberOfGuessesGreaterThanZeroLogicReturnLess() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:70,player:p)
        XCTAssert(r == .less)
    }
    
    func testIfGuessIsMoreThanTargetAndNumberOfGuessesGreaterThanZeroLogicReturnMore() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:7,player:p)
        XCTAssert(r == .more)
    }
    
    func testIfGuessIsMoreThanUpperBoundLogicReturnsOutOfRange() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:1000,player:p)
        XCTAssert(r == .outOfRange)
    }
    
    func testIfGuessIsLessThanLowerBoundLogicReturnsOutOfRange() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:-1000,player:p)
        XCTAssert(r == .outOfRange)
    }
    
    func testIfGuessIsEqualToLowerBoundLogicReturnsMore() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:0,player:p)
        XCTAssert(r == .more)
    }
    
    func testIfGuessIsEqualToUpperBoundLogicReturnsLess() {
        let p = Player(name:"Pawel",numOfGuessesLeft:3)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:100,player:p)
        XCTAssert(r == .less)
    }
    
    func testIfNumberOfGuessesZeroThenLogicReturnsLost() {
        let p = Player(name:"Pawel",numOfGuessesLeft:0)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:7,player:p)
        XCTAssert(r == .lost)
    }
    
    func testIfNumberOfGuessesLessThanZeroThenLogicReturnsLost() {
        let p = Player(name:"Pawel",numOfGuessesLeft:-100)
        let cl = CoreLogic(players:[p],range:(0...100),numOfGuessesPerPlayer:3,winningNumber:17)
        let r = cl.evaluate(input:7,player:p)
        XCTAssert(r == .lost)
    }
}
