//
//  Game.swift
//  GeekQuiz
//
//  Created by Egor on 10.07.2021.
//

import Foundation

class Game {
    
    var session: GameSession?
    private let resultsCaretaker = GameResultsCaretaker()
    static let shared = Game()
    var bestResult: GameResult?
    var userName: String = ""
    
    var results: [GameResult] {
        didSet {
            resultsCaretaker.save(results: self.results)
        }
    }
    
    private init() {
        self.results = self.resultsCaretaker.retrieveRecords()
    }
    
    func createGameResult() -> GameResult? {
        
        guard let session = session else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: Date())
        
        return GameResult(name: userName, date: date, prize: session.calculateFinalPrize(), isFiftyFiftyUsed: session.isFiftyFiftyUsed, isFriendCallUsed: session.isFriendCallUsed, isHallHelpUsed: session.isHallHelpUsed)
    }
    
    func saveSessionResult() {
        
        guard let session = session else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: Date())
        
        let result = GameResult(name: session.userName, date: date, prize: session.calculateFinalPrize(), isFiftyFiftyUsed: session.isFiftyFiftyUsed, isFriendCallUsed: session.isFriendCallUsed, isHallHelpUsed: session.isHallHelpUsed)
        results.append(result)
        self.session = nil
    }
}
