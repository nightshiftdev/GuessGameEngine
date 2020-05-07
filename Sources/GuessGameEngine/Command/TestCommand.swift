//
//  TestCommand.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 5/2/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

internal struct TestCommand: Command {
    var type: String {
        get {
            return TestCommand.type
        }
    }
    
    var uuid: UUID {
        return internalUUID
    }
    
    fileprivate let internalUUID: UUID
    init?(params: [String : Any]) {
        self.internalUUID = UUID()
    }
    
    static var type: String {
        get {
            return "TestCommand"
        }
    }
    
    var description: String {
        get {
            return "\(TestCommand.type):\(uuid)"
        }
    }
    
}
