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
    let prize: Int
    let isFiftyFiftyUsed: Bool
    let isFriendCallUsed: Bool
    let isHallHelpUsed: Bool
    
    init(name: String, date: String, prize: Int, isFiftyFiftyUsed: Bool, isFriendCallUsed: Bool, isHallHelpUsed: Bool) {
        
        self.name = name
        self.date = date
        self.prize = prize
        self.isFiftyFiftyUsed = isFiftyFiftyUsed
        self.isFriendCallUsed = isFriendCallUsed
        self.isHallHelpUsed = isHallHelpUsed
    }
    
    static func createFromDictionary(dict: Dictionary<String, Any>) -> GameResult? {
        
        guard let name = dict["name"] as? String else { return nil }
        guard let date = dict["date"] as? String else { return nil }
        guard let prize = dict["prize"] as? Int else { return nil }
        guard let isFiftyFiftyUsed = dict["isFiftyFiftyUsed"] as? Bool else { return nil }
        guard let isFriendCallUsed = dict["isFriendCallUsed"] as? Bool else { return nil }
        guard let isHallHelpUsed = dict["isHallHelpUsed"] as? Bool else { return nil }
        
        return GameResult(name: name, date: date, prize: prize, isFiftyFiftyUsed: isFiftyFiftyUsed, isFriendCallUsed: isFriendCallUsed, isHallHelpUsed: isHallHelpUsed)
    }
    
    func convertToDictionary() -> Dictionary<String, Any> {
        
        return [
            "name": name,
            "date": date,
            "prize": prize,
            "isFiftyFiftyUsed": isFiftyFiftyUsed,
            "isFriendCallUsed": isFriendCallUsed,
            "isHallHelpUsed": isHallHelpUsed
        ]
    }
}
