//
//  Command.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/25/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public protocol Command: CustomStringConvertible {
    static var type: String { get }
    var uuid: UUID { get }
    init?(params:[String:Any])
    var description: String { get }
    var type: String { get }
}
