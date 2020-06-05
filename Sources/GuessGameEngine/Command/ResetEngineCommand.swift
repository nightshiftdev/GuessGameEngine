//
//  ResetEngineCommand.swift
//  
//
//  Created by Pawel Kijowski on 6/4/20.
//

import Foundation

public struct ResetEngineCommand: Command {
    public var type: String {
        get {
            return ResetEngineCommand.type
        }
    }
    
    public var description: String {
        get {
            return "\(ResetEngineCommand.type):\(uuid)"
        }
    }
    
    public var uuid: UUID {
        return internalUUID
    }
    
    public static var type: String {
        get {
            return "ResetEngineCommand"
        }
    }
    fileprivate let internalUUID: UUID
    public init?(params: [String : Any]) {
        guard let resetEngine = params["resetEngine"] as? Bool else { return nil }
        if !resetEngine { return nil }
        self.internalUUID = UUID()
     }
}
