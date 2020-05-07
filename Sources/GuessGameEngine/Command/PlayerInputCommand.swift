//
//  PlayerInputCommand.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/25/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public struct PlayerInputCommand : Command {
    public var type: String {
        get {
            return PlayerInputCommand.type
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
            return "PlayerInputCommand"
        }
    }
    fileprivate let internalUUID: UUID
    let player: String
    let value: Int
    public init?(params: [String : Any]) {
        guard let p = params["player"] as? String else { return nil }
        guard let v = params["value"] as? Int else { return nil }
        self.internalUUID = UUID()
        self.player = p
        self.value = v
     }
}
