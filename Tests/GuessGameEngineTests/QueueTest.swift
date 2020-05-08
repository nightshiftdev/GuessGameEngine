//
//  QueueTest.swift
//  GuessGameUnitTests
//
//  Created by Pawel Kijowski on 3/22/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import XCTest
@testable import GuessGameEngine

final class QueueTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testThatCanCreateQueue() {
        let q:Queue<Int>? = Queue<Int>()
        XCTAssertNotNil(q)
    }
    
    func testThatJustCreatedQueueIsEmpty() {
        let q = Queue<Int>()
        XCTAssert(q.isEmpty())
    }
    
    func testIfEnqueuedThenNotEmpty() {
        var q = Queue<Int>()
        q.enqueue(5)
        XCTAssert(!q.isEmpty())
    }
    
    func testIfEnquedAndDequedThenEmpty() {
        var q = Queue<Int>()
        q.enqueue(5)
        XCTAssert(q.dequeue() == 5)
        XCTAssert(q.isEmpty())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            var q = Queue<Int>()
            for n in (0...100000) {
                q.enqueue(n)
                let _ = q.dequeue()
            }
        }
    }
    
    static var allTests = [
        ("testThatCanCreateQueue",testThatCanCreateQueue),
        ("testThatJustCreatedQueueIsEmpty",testThatJustCreatedQueueIsEmpty),
        ("testIfEnqueuedThenNotEmpty",testIfEnqueuedThenNotEmpty),
        ("testIfEnquedAndDequedThenEmpty",testIfEnquedAndDequedThenEmpty),
        ("testPerformanceExample",testPerformanceExample)
    ]
}
