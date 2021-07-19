//
//  GameSession.swift
//  GeekQuiz
//
//  Created by Egor on 10.07.2021.
//

import Foundation
import RxSwift
import Alamofire

enum QuestionDifficulty: String {
    case easy, medium, hard
    
    mutating func increase() {
        switch self {
        case .easy:
            self = .medium
        case .medium:
            self = .hard
        default:
            break
        }
    }
    
    func getPrize() -> Int {
        
        switch self {
        case .easy:
            return 500
        case .medium:
            return 1500
        case .hard:
            return 18000
        }
    }
}

class GameSession {
    
    var userName = ""
    var questionsCount = 15
    var rightAnswers = 0
    var currentBank = 0
    var difficulty: QuestionDifficulty = .easy
    var hintsLeft: Int = 3
    var isFiftyFiftyUsed: Bool = false
    var isFriendCallUsed: Bool = false
    var isHallHelpUsed: Bool = false
    
    init(for user: String) {
        userName = user
    }
    
    func loadNewQuestions() -> Observable<Data> {
        
        let url = "https://opentdb.com/api.php"
        let params: Parameters = [
            "amount": 5,
            "difficulty": difficulty.rawValue,
            "type": "multiple",
        ]
        
        return NetworkManager.shared.makeRequest(url: url, params: params)
    }
    
    func calculateFinalPrize() -> Int {
        if rightAnswers == questionsCount {
            return ((Decimal(currentBank) * pow(2, hintsLeft)) as NSDecimalNumber).intValue
        } else {
            return currentBank / 2
        }
    }
}
