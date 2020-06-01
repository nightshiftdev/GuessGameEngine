//
//  ConfigureGameCommand.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/28/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public struct ConfigureGameCommand: Command {
    public var type: String {
        get {
            return ConfigureGameCommand.type
        }
    }
    
    public var description: String {
        get {
            return "\(PlayerInputCommand.type):\(uuid)"
        }
    }
    
    public var uuid: UUID {
        return internalUUID
    }
    
    public static var type: String {
        get {
            return "ConfigureGameCommand"
        }
    }
    fileprivate let internalUUID: UUID
    var winningGuess:Int? = nil
    let players: [Player]
    let range: ClosedRange<Int>
    let numberOfGuessesPerPlayer: Int
    let delay: TimeInterval
    public init?(params: [String : Any]) {
        guard let ps = params["players"] as? [Player] else { return nil }
        if ps.count == 0 { return nil }
        guard let r = params["range"] as? ClosedRange<Int> else { return nil }
        guard let delay = params["delay"] as? TimeInterval else { return nil }
        guard let nog = params["numberOfGuessesPerPlayer"] as? Int else { return nil }
        if nog <= 0 { return nil }
        if let winningGuess = params["winningGuess"] as? Int {
            if !r.contains(winningGuess) { return nil }
            self.winningGuess = winningGuess
        }
        self.internalUUID = UUID()
        self.players = ps
        self.range = r
        self.numberOfGuessesPerPlayer = nog
        self.delay = delay
     }
}
