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
    
    static var allTests = [
        ("testThatCanCreateGuessGameEngineAPI",testThatCanCreateGuessGameEngineAPI),
        ("testThatAPIAllowsToCreateCommands",testThatAPIAllowsToCreateCommands),
    ]
}
