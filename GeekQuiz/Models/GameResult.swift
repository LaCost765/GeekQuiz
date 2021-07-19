//
//  GameResult.swift
//  GeekQuiz
//
//  Created by Egor on 11.07.2021.
//

import Foundation

class GameResult: Codable {
    
    let name: String
    let date: String
    let prize: String
    let isFiftyFiftyUsed: Bool
    let isFriendCallUsed: Bool
    let isHallHelpUsed: Bool
    
    init(name: String, date: String, prize: String, isFiftyFiftyUsed: Bool, isFriendCallUsed: Bool, isHallHelpUsed: Bool) {
        
        self.name = name
        self.date = date
        self.prize = prize
        self.isFiftyFiftyUsed = isFiftyFiftyUsed
        self.isFriendCallUsed = isFriendCallUsed
        self.isHallHelpUsed = isHallHelpUsed
    }
}
