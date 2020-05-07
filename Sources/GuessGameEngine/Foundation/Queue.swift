//
//  Queue.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/22/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

internal struct Queue<Element> {
    var data = [Element]()
    func isEmpty() -> Bool {
        return data.isEmpty
    }
    
    mutating func dequeue() -> Element? {
        return data.popLast()
    }
    
    mutating func enqueue(_ element:Element) {
        data.insert(element, at: 0)
    }
}
