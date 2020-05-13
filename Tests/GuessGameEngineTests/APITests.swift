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
        let api:GuessGameEngine = GuessGameEngine()
        XCTAssertNotNil(api)
    }
    
    func testThatAPIAllowsToCreateCommands() {
        let api = GuessGameEngine()
        let cmd = api.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":1])
        XCTAssertNotNil(cmd)
    }
    
    struct EventQueueDelegateHandler: EventQueueDelegate {
        typealias EventQueueDelegateHandlerCompletionBlock = () -> Void
        let completionBlock: EventQueueDelegateHandlerCompletionBlock
        func onCommandEnqueued() {
            self.completionBlock()
        }
    }
    
    func testThatCanSetupDelegateOnGuessGameEngine() {
        let factory = EngineCommandFactory()
        let p1 = Player(name: "Pawel", numOfGuessesLeft: 3)
        let p2 = Player(name: "Eva", numOfGuessesLeft: 3)
        let p3 = Player(name: "Zoe", numOfGuessesLeft: 3)
        guard let c = factory.makeCommand(params:["players":[p1,p2,p3],"type":"ConfigureGameCommand","range":(0...100),"numberOfGuessesPerPlayer":3]) else { XCTFail(); return }
        var api = GuessGameEngine()
        let ex = expectation(description: #function)
        let handler = EventQueueDelegateHandler {
            ex.fulfill()
        }
        api.delegate = handler
        api.enqueue(command: c)
        waitForExpectations(timeout:1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testThatIfDelegateSetOnTheGameEngineItCanBeRetrieved() {
        var api = GuessGameEngine()
        let handler = EventQueueDelegateHandler {}
        api.delegate = handler
        XCTAssertNotNil(api.delegate)
    }
    
    static var allTests = [
        ("testThatCanCreateGuessGameEngineAPI",testThatCanCreateGuessGameEngineAPI),
        ("testThatAPIAllowsToCreateCommands",testThatAPIAllowsToCreateCommands),
        ("testThatCanSetupDelegateOnGuessGameEngine",testThatCanSetupDelegateOnGuessGameEngine),
        ("testThatIfDelegateSetOnTheGameEngineItCanBeRetrieved",testThatIfDelegateSetOnTheGameEngineItCanBeRetrieved)
    ]
}
