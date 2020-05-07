//
//  CoreLogic.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 4/4/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

internal struct CoreLogic {
    let players:[Player]
    let range:ClosedRange<Int>
    let numOfGuessesPerPlayer:Int
    let winningNumber:Int
    func evaluate(input:Int,player:Player) -> GuessResult {
        if player.numOfGuessesLeft <= 0 { return .lost }
        switch input {
        case winningNumber:
            return .won
        case (winningNumber+1...range.upperBound):
            return .less
        case (range.lowerBound...winningNumber-1):
            return .more
        default:
            return .outOfRange
        }
    }
}
