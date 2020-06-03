//
//  CommandTests.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 3/24/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class CommandTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testCreateNilCommand() {
        let ecf = EngineCommandFactory()
        let c = ecf.makeCommand(params:["unexpectedKey":"wrongValue"])
        XCTAssertNil(c)
    }
    
    func testCreatePlayerInputCommand() {
        let ecf = EngineCommandFactory()
        let pic = ecf.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":1])
        XCTAssertNotNil(pic)
    }
    
    func testIfMissingPlayerInPlayerInputCommandThenNil() {
        let ecf = EngineCommandFactory()
        let pic = ecf.makeCommand(params:["type":"PlayerInputCommand","value":1])
        XCTAssertNil(pic)
    }
    
    func testIfMissingValueInPlayerInputCommandThenNil() {
        let ecf = EngineCommandFactory()
        let pic = ecf.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand"])
        XCTAssertNil(pic)
    }
    
    func testCreateConfigureGameCommand() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3,"delay":1.0,"winningGuess":50])
        XCTAssertNotNil(cgc)
    }
    
    func testIfRangeIsNotAClosedRangeConfigureGameCommandIsNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0..<100),"numberOfGuessesPerPlayer":3])
        XCTAssertNil(cgc)
    }
    
    func testIfNumberOfGuessesPerPlayerLessThanZeroConfigureGameCommandIsNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":-1])
        XCTAssertNil(cgc)
    }
    
    func testIfNumberOfGuessesPerPlayerEqualZeroConfigureGameCommandIsNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":0])
        XCTAssertNil(cgc)
    }
    
    func testIfNumberOfGuessesIsMissingConfigureGameCommandIsNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100)])
        XCTAssertNil(cgc)
    }
    
    func testIfOptionalWinningGuessMoreThanEndRangeThenConfigureGameCommandNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3,"winningGuess":101])
        XCTAssertNil(cgc)
    }
    
    func testIfOptionalWinningGuessLessThanStartRangeThenConfigureGameCommandNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3,"winningGuess":-1])
        XCTAssertNil(cgc)
    }
    
    func testIfOptionalWinningGuessEqualsToStartRangeThenConfigureGameCommandReturned() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3,"winningGuess":0,"delay":1.0])
        XCTAssertNotNil(cgc)
    }
    
    func testIfOptionalWinningGuessInBetweenStartAndEndRangeThenConfigureGameCommandReturned() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3,"winningGuess":50,"delay":1.0])
        XCTAssertNotNil(cgc)
    }
    
    func testIfOptionalWinningGuessEqualsToEndRangeThenConfigureGameCommandReturned() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3,"winningGuess":100,"delay":1.0])
        XCTAssertNotNil(cgc)
    }
    
    func testIfMissingPlayersInConfigureGameCommandThenNil() {
        let ecf = EngineCommandFactory()
        let cgc = ecf.makeCommand(params:["type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3])
        XCTAssertNil(cgc)
    }
    
    func testIfMissingRangeInConfigureGameCommandThenNil() {
        let ecf = EngineCommandFactory()
        let cgc = ecf.makeCommand(params:["players":["Pawel","Eva","Zoe"],"type":"ConfigureGameCommand","numberOfGuessesPerPlayer":3])
        XCTAssertNil(cgc)
    }
    
    func testIfMissingNumberOfGuessesPerPlayerInConfigureGameCommandThenNil() {
        let ecf = EngineCommandFactory()
        let cgc = ecf.makeCommand(params:["players":["Pawel","Eva","Zoe"],"type":"ConfigureGameCommand","range":(0...100)])
        XCTAssertNil(cgc)
    }
    
    func testIfPlayersArrayEmptyInConfigureGameCommandThenNil() {
        let ecf = EngineCommandFactory()
        let cgc = ecf.makeCommand(params:["players":[],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3])
        XCTAssertNil(cgc)
    }
    
    func testIfNumberOfGuessesPerPlayerNegativeInConfigureGameCommandThenNil() {
        let ecf = EngineCommandFactory()
        let cgc = ecf.makeCommand(params:["players":["Pawel","Eva","Zoe"],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":-1])
        XCTAssertNil(cgc)
    }

    func testIfUnknownTypeThenNoCommandCreated() {
        let ecf = EngineCommandFactory()
        let c = ecf.makeCommand(params:["type":"UnknownType"])
        XCTAssertNil(c)
    }
    
    func testCreateTestCommand() {
        guard let tc = TestCommand(params: [:]) else { XCTFail(); return }
        XCTAssert(tc.description == "\(TestCommand.type):\(tc.uuid)")
        XCTAssert(tc.type == TestCommand.type)
        XCTAssertFalse(tc.uuid.uuidString.isEmpty)
    }
    
    func testIfDelayParameterMissingThenCommandIsNil() {
        let ecf = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        let cgc = ecf.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3])
        XCTAssertNil(cgc)
    }
    
    static var allTests = [
        ("testCreateNilCommand", testCreateNilCommand),
        ("testCreatePlayerInputCommand", testCreatePlayerInputCommand),
        ("testIfMissingPlayerInPlayerInputCommandThenNil", testIfMissingPlayerInPlayerInputCommandThenNil),
        ("testIfMissingValueInPlayerInputCommandThenNil",testIfMissingValueInPlayerInputCommandThenNil),
        ("testIfRangeIsNotAClosedRangeConfigureGameCommandIsNil",testIfRangeIsNotAClosedRangeConfigureGameCommandIsNil),
        ("testIfNumberOfGuessesPerPlayerLessThanZeroConfigureGameCommandIsNil",testIfNumberOfGuessesPerPlayerLessThanZeroConfigureGameCommandIsNil),
        ("testIfNumberOfGuessesPerPlayerEqualZeroConfigureGameCommandIsNil",testIfNumberOfGuessesPerPlayerEqualZeroConfigureGameCommandIsNil),
        ("testIfNumberOfGuessesIsMissingConfigureGameCommandIsNil",testIfNumberOfGuessesIsMissingConfigureGameCommandIsNil),
        ("testIfOptionalWinningGuessMoreThanEndRangeThenConfigureGameCommandNil",testIfOptionalWinningGuessMoreThanEndRangeThenConfigureGameCommandNil),
        ("testIfOptionalWinningGuessLessThanStartRangeThenConfigureGameCommandNil",testIfOptionalWinningGuessLessThanStartRangeThenConfigureGameCommandNil),
        ("testIfOptionalWinningGuessEqualsToStartRangeThenConfigureGameCommandReturned",testIfOptionalWinningGuessEqualsToStartRangeThenConfigureGameCommandReturned),
        ("testIfOptionalWinningGuessInBetweenStartAndEndRangeThenConfigureGameCommandReturned",testIfOptionalWinningGuessInBetweenStartAndEndRangeThenConfigureGameCommandReturned),
        ("testIfOptionalWinningGuessEqualsToEndRangeThenConfigureGameCommandReturned",testIfOptionalWinningGuessEqualsToEndRangeThenConfigureGameCommandReturned),
        ("testIfMissingPlayersInConfigureGameCommandThenNil",testIfMissingPlayersInConfigureGameCommandThenNil),
        ("testIfMissingRangeInConfigureGameCommandThenNil",testIfMissingRangeInConfigureGameCommandThenNil),
        ("testIfMissingNumberOfGuessesPerPlayerInConfigureGameCommandThenNil",testIfMissingNumberOfGuessesPerPlayerInConfigureGameCommandThenNil),
        ("testIfPlayersArrayEmptyInConfigureGameCommandThenNil",testIfPlayersArrayEmptyInConfigureGameCommandThenNil),
        ("testIfNumberOfGuessesPerPlayerNegativeInConfigureGameCommandThenNil",testIfNumberOfGuessesPerPlayerNegativeInConfigureGameCommandThenNil),
        ("testIfUnknownTypeThenNoCommandCreated",testIfUnknownTypeThenNoCommandCreated),
        ("testCreateTestCommand",testCreateTestCommand)
    ]
}
