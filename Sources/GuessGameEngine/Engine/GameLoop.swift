//
//  GameLoop.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/21/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

internal struct GameLoop: EventQueueDelegate {
    let eventQueue: EventQueue
    init(eventQueue: EventQueue) {
        self.eventQueue = eventQueue
        self.eventQueue.delegate = self
    }
    func onCommandEnqueued() {
        self.run()
    }
    func run() {
        guard let c = eventQueue.nextCommand() else { return }
        print("GameLoop command to process: \(c)")
    }
}
