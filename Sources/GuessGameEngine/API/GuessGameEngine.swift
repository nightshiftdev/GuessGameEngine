//
//  GuessGameEngine.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 5/11/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public struct GuessGameEngine {
    func makeCommand(params:[String:Any]) -> Command? {
        let factory = EngineCommandFactory()
        return factory.makeCommand(params: params)
    }
}
