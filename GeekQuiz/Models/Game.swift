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
    
    var results: [GameResult] {
        didSet {
            resultsCaretaker.save(results: self.results)
        }
    }
    
    private init() {
        self.results = self.resultsCaretaker.retrieveRecords()
    }
    
    func saveSessionResult() {
        
        guard let session = session else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: Date())
        
        let result = GameResult(name: session.userName, date: date, prize: String(session.calculateFinalPrize()), isFiftyFiftyUsed: session.isFiftyFiftyUsed, isFriendCallUsed: session.isFriendCallUsed, isHallHelpUsed: session.isHallHelpUsed)
        results.append(result)
        self.session = nil
    }
}
