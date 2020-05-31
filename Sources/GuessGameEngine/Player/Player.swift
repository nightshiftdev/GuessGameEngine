//
//  Player.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 4/6/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public struct Player: Hashable {
    let name: String
    var numOfGuessesLeft: Int
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
