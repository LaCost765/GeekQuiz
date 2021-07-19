//
//  GameResultsCaretaker.swift
//  GeekQuiz
//
//  Created by Egor on 17.07.2021.
//

import Foundation

final class GameResultsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "results"
    
    func save(results: [GameResult]) {
        do {
            let data = try self.encoder.encode(results)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveRecords() -> [GameResult] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([GameResult].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
