//
//  GuessGameEngine.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 5/11/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public struct GuessGameEngine {
    private let eventQueue = EventQueue()
    
    public var delegate: EventQueueDelegate? {
        get {
            return self.eventQueue.delegate
        }
        
        set {
            self.eventQueue.delegate = newValue
        }
    }
    func makeCommand(params:[String:Any]) -> Command? {
        let factory = EngineCommandFactory()
        return factory.makeCommand(params: params)
    }
    
    func enqueue(command:Command) {
        self.eventQueue.enqueue(command:command)
    }
}
