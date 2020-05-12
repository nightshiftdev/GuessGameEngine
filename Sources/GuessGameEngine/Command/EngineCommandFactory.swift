//
//  EngineCommandFactory.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/25/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

internal struct EngineCommandFactory : CommandFactory {
    func makeCommand(params: [String : Any]) -> Command? {
        guard let type = params["type"] as? String else { return nil }
        switch type {
        case PlayerInputCommand.type:
            return PlayerInputCommand(params:params)
        case ConfigureGameCommand.type:
            return ConfigureGameCommand(params:params)
        default:
            return nil
        }
    }
}
