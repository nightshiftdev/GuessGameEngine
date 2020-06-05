//
//  GuessGame.swift
//  GuessGame
//
//  Created by Pawel Kijowski on 4/9/20.
//  Copyright © 2020 Pawel Kijowski. All rights reserved.
//

import Foundation

public enum GameEventType {
    case undefinedState
    case waitingToConfigureGame
    case readyForUserInput
    case gameOver
    case playerWon
}

public struct GameEvent {
    public let type:GameEventType
    public let data:[String:Any]
}

public protocol GuessGameDelegate {
    func handle(event:GameEvent)
}

internal class GuessGame {
    var delegate:GuessGameDelegate?
    var players:[Player]
    var currentPlayerIdx = NSNotFound
    let synchQ = DispatchQueue(label: "com.guessGame.SyncQ")
    var nextTurnTimer:Timer
    var winningGuess:Int
    var delay:TimeInterval
    init(delegate:GuessGameDelegate) {
        self.delegate = delegate
        self.players = []
        let configEvent = GameEvent(type: .waitingToConfigureGame, data: [:])
        self.delegate?.handle(event:configEvent)
        self.nextTurnTimer = Timer()
        self.winningGuess = Int.max
        self.delay = 0
    }
    
    func playerTurnExpired(timer:Timer) {
        let player = players[currentPlayerIdx]
        print("Timer expired for player:\(player.name)")
        let factory = EngineCommandFactory()
        let nextPlayerInputCommand = factory.makeCommand(params:["player":player.name,"type":"PlayerInputCommand","value":Int.min])!
        print("Skipping player move:\(player.name)")
        enqueue(nextPlayerInputCommand)
    }
    
    func waitForPlayerInput(delay:TimeInterval) {
        DispatchQueue.main.async {
            self.nextTurnTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: self.playerTurnExpired)
            RunLoop.current.add(self.nextTurnTimer, forMode: .default)
        }
    }
    
    func cancelWaitForPlayerInput() {
        self.nextTurnTimer.invalidate()
    }
    
    func handleConfigureGameCommand(_ inputCommand:ConfigureGameCommand) -> GameEvent {
        let playersNotUniqueError = GameEvent(type: .waitingToConfigureGame, data: ["error":"Player names are not unique"])
        if inputCommand.players.count != Set(inputCommand.players).count { self.delegate?.handle(event: playersNotUniqueError) }
        self.currentPlayerIdx = 0
        self.players = inputCommand.players
        self.winningGuess = inputCommand.winningGuess
        let player = self.players[self.currentPlayerIdx]
        self.delay = inputCommand.delay
        waitForPlayerInput(delay: self.delay)
        return GameEvent(type: .readyForUserInput, data: ["player":player])
    }
    
    func handlePlayerInputCommand(_ cmd:PlayerInputCommand) -> GameEvent {
        if self.currentPlayerIdx == NSNotFound || self.players.count <= 0 {
            return GameEvent(type: .waitingToConfigureGame, data: [:])
        }
        let player = self.players[self.currentPlayerIdx]
        if cmd.value == self.winningGuess && cmd.player == player.name {
            cancelWaitForPlayerInput()
            let updatedPlayer = Player(name:player.name, numOfGuessesLeft:player.numOfGuessesLeft - 1)
            return GameEvent(type: .playerWon, data: ["player":updatedPlayer])
        }
        print("Handling input for player:\(player.name)")
        let updatedPlayer = Player(name:player.name, numOfGuessesLeft:player.numOfGuessesLeft - 1)
        self.players[self.currentPlayerIdx] = updatedPlayer
        if self.currentPlayerIdx < self.players.count-1 {
            self.currentPlayerIdx += 1
        } else {
            self.currentPlayerIdx = 0
        }
        let nextPlayer = self.players[self.currentPlayerIdx]
        if nextPlayer.numOfGuessesLeft > 0 {
            cancelWaitForPlayerInput()
            waitForPlayerInput(delay: self.delay)
            return GameEvent(type: .readyForUserInput, data: ["player":nextPlayer])
        }
        cancelWaitForPlayerInput()
        return GameEvent(type: .gameOver, data: [:])
    }
    
    func resetEngine() {
        self.currentPlayerIdx = NSNotFound
        self.players = []
        self.nextTurnTimer = Timer()
        self.winningGuess = Int.max
        self.delay = 0
    }
    
    func handleResetEngineCommand(_ cmd: ResetEngineCommand) -> GameEvent {
        cancelWaitForPlayerInput()
        resetEngine()
        return GameEvent(type: .waitingToConfigureGame, data: [:])
    }
    
    func enqueue(_ cmd:Command) {
        synchQ.async { [weak self] in
            guard let self = self else { return }
            var event = GameEvent(type: .undefinedState, data: [:])
            switch cmd.type {
            case ConfigureGameCommand.type:
                event = self.handleConfigureGameCommand(cmd as! ConfigureGameCommand)
            case PlayerInputCommand.type:
                event = self.handlePlayerInputCommand(cmd as! PlayerInputCommand)
            case ResetEngineCommand.type:
                event = self.handleResetEngineCommand(cmd as! ResetEngineCommand)
            default:
                print("Unknown command")
            }
            self.delegate?.handle(event:event)
        }
    }
}
