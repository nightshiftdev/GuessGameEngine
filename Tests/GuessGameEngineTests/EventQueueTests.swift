//
//  EventQueueTests.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 3/21/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class EventQueueTests: XCTestCase {
    var eventQueue = EventQueue()
    
    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testTwoProducersAndConsumers() {
        self.measure {
            let q = EventQueue()
            let dispatchQ1 = DispatchQueue.global()
            let dispatchQ2 = DispatchQueue.global()
            let ecf = EngineCommandFactory()
            for n in (0...100) {
                guard let pic = ecf.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":n]) else { continue }
                if arc4random() % 2 == 0 {
                    dispatchQ1.async {
                        let nc = q.nextCommand()
                        if nc != nil {
                            print("Q1 dequeue \(nc!)")
                        } else {
                            print("Q1 enqueue \(n)")
                            q.enqueue(command: pic)
                        }
                    }
                } else {
                    dispatchQ2.async {
                        let nc = q.nextCommand()
                        if nc != nil {
                            print("Q2 dequeue \(nc!)")
                        } else {
                            print("Q2 enqueue \(n)")
                            q.enqueue(command: pic)
                        }
                    }
                }
            }
            let ex = expectation(description: #function)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                var nc = q.nextCommand()
                print("next command:\(String(describing: nc))")
                while nc != nil {
                    print("MainQ dequeue \(nc!)")
                    nc = q.nextCommand()
                }
                XCTAssertNil(nc)
                ex.fulfill()
            })
            waitForExpectations(timeout: 2.0) { (error) in
                XCTAssertNil(error)
            }
        }
    }

    func testTwoProducersOneConsumer() {
        self.measure {
            let q = EventQueue()
            let producerQ1 = DispatchQueue.global()
            let producerQ2 = DispatchQueue.global()
            let consumerQ = DispatchQueue(label: "consumerQ", attributes: .concurrent)
            var uniqueCommands = Set<Int>()
            let ecf = EngineCommandFactory()
            for n in (0...100) {
                guard let pic = ecf.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":n]) else { continue }
                if arc4random() % 2 == 0 {
                    producerQ1.async {
                        print("Q1 enqueue \(n)")
                        q.enqueue(command: pic)
                    }
                } else {
                    producerQ2.async {
                        print("Q2 enqueue \(n)")
                        q.enqueue(command: pic)
                    }
                }
                consumerQ.async(flags:.barrier) {
                    let nc = q.nextCommand()
                    if nc != nil {
                        if uniqueCommands.contains(nc!.uuid.hashValue) {
                            XCTFail()
                        } else {
                            uniqueCommands.insert(nc!.uuid.hashValue)
                        }
                        print("consumerQ command:\(String(describing: nc))")
                    }
                }
            }
            let ex = expectation(description: #function)
            consumerQ.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                var nc = q.nextCommand()
                print("next command:\(String(describing: nc))")
                while nc != nil {
                    if uniqueCommands.contains(nc!.uuid.hashValue) {
                        XCTFail()
                    } else {
                        uniqueCommands.insert(nc!.uuid.hashValue)
                    }
                    print("consumerQ command:\(String(describing: nc))")
                    nc = q.nextCommand()
                }
                XCTAssertNil(nc)
                ex.fulfill()
            })
            waitForExpectations(timeout: 2.0) { (error) in
                XCTAssertNil(error)
            }
        }
    }
    
    struct EventQueueDelegateHandler: EventQueueDelegate {
        typealias EventQueueDelegateHandlerCompletionBlock = () -> Void
        let completionBlock: EventQueueDelegateHandlerCompletionBlock
        func onCommandEnqueued() {
            self.completionBlock()
        }
    }
    
    func testIfCommandAddedToTheQueueObserverGetsNotified() {
        let q = EventQueue()
        let cf = EngineCommandFactory()
        guard let c = cf.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":55]) else { XCTFail(); return }
        let ex = expectation(description:#function)
        let handler = EventQueueDelegateHandler {
            let _ = q.hasNextCommand()
            ex.fulfill()
        }
        q.delegate = handler
        q.enqueue(command: c)
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testIfMultipleCommandsEnquedObserverGetsNotifiedAboutAllOfThem() {
        let q = EventQueue()
        let cf = EngineCommandFactory()
        let ex = expectation(description:#function)
        var counter = 0
        let handler = EventQueueDelegateHandler {
            counter += 1
            if counter == 10 {
                ex.fulfill()
            }
        }
        q.delegate = handler
        for n in (0...9) {
            guard let c = cf.makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":n]) else { XCTFail(); return }
            q.enqueue(command: c)
        }
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testIfCommandEnqueuedItCanBeDequeued() {
        let q = EventQueue()
        guard let c = EngineCommandFactory().makeCommand(params:["player":"Pawel","type":"PlayerInputCommand","value":555]) else { XCTFail(); return }
        q.enqueue(command:c)
        guard let dc = q.nextCommand() else { XCTFail(); return }
        XCTAssert(c.uuid == dc.uuid)
    }
    
    static var allTests = [
        ("testTwoProducersAndConsumers",testTwoProducersAndConsumers),
        ("testTwoProducersOneConsumer",testTwoProducersOneConsumer),
        ("testIfCommandAddedToTheQueueObserverGetsNotified",testIfCommandAddedToTheQueueObserverGetsNotified),
        ("testIfMultipleCommandsEnquedObserverGetsNotifiedAboutAllOfThem",testIfMultipleCommandsEnquedObserverGetsNotifiedAboutAllOfThem),
        ("testIfCommandEnqueuedItCanBeDequeued",testIfCommandEnqueuedItCanBeDequeued)
    ]
}
