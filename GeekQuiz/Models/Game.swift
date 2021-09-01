//
//  Game.swift
//  GeekQuiz
//
//  Created by Egor on 10.07.2021.
//

import Foundation

enum Language: String {
    case ru, en
    
    static let key = "Language"
    
    static func getFromUserDefaults() -> Language {
        
        let lang = UserDefaults.standard.string(forKey: Language.key)
        if lang == nil || lang == "en" {
            return .en
        } else {
            return .ru
        }
    }
    
    static func getFromString(string: String) -> Language {
        
        switch string.lowercased() {
        case "ru":
            return .ru
        case "en":
            return .en
        default:
            print("Cant cast \(string) to any available language, returned default EN")
            return .en
        }
    }
}

class Game {
    
    var session: GameSession?
    private let resultsCaretaker = GameResultsCaretaker()
    static let shared = Game()
    
    var bestResult: GameResult?
    var userName: String = ""
    private(set) var language: Language {
        didSet {
            UserDefaults.standard.setValue(language.rawValue, forKey: Language.key)
        }
    }
    
    var results: [GameResult] {
        didSet {
            resultsCaretaker.save(results: self.results)
        }
    }
    
    private init() {
        self.results = self.resultsCaretaker.retrieveRecords()
        self.language = Language.getFromUserDefaults()
    }
    
    func setLanguage(language: Language) {
        self.language = language
    }
    
    func setLanguage(string: String) {
        self.language = Language.getFromString(string: string)
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
