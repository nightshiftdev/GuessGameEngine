//
//  EventQueue.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/21/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Cocoa

public protocol EventQueueDelegate {
    func onCommandEnqueued()
}

internal class EventQueue: NSObject {
    var delegate: EventQueueDelegate?
    fileprivate var eventQueue = Queue<Command>()
    fileprivate let synchronizationQueue = DispatchQueue(label: "com.guessGame.EventQueue")
    public override init() {
        super.init()
    }
    public func enqueue(command:Command) {
        synchronizationQueue.async(flags:.barrier) {
            self.eventQueue.enqueue(command)
        }
        self.commandEnqueued()
    }
    public func nextCommand() -> Command? {
        synchronizationQueue.sync(flags:.barrier) {
            return eventQueue.dequeue()
        }
    }
    fileprivate func commandEnqueued() {
        guard let delegate = self.delegate else { return }
        delegate.onCommandEnqueued()
    }
    func hasNextCommand() -> Bool {
        synchronizationQueue.sync(flags:.barrier) {
            return eventQueue.isEmpty()
        }
    }
}
