//
//  Player.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 4/6/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public struct Player: Hashable {
    public let name: String
    public var numOfGuessesLeft: Int
    public init(name: String, numOfGuessesLeft: Int) {
        self.name = name
        self.numOfGuessesLeft = numOfGuessesLeft
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
