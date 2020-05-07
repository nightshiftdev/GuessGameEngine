//
//  Player.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 4/6/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

internal struct Player: Hashable {
    let name: String
    var numOfGuessesLeft: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
