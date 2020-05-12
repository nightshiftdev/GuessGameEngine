//
//  CommandFactory.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 3/25/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

protocol CommandFactory {
    func makeCommand(params:[String:Any]) -> Command?
}
