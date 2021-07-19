//
//  Question.swift
//  GeekQuiz
//
//  Created by Egor on 10.07.2021.
//

import Foundation

class Question {
    
    let topic: String
    let answers: [String]
    let rightAnswer: String
    let category: String
    let prize: Int
    
    init(topic: String, category: String, rightAnswer: String, prize: Int, answers: [String]) {
        
        self.topic = topic
        self.category = category
        self.rightAnswer = rightAnswer
        self.answers = answers.shuffled()
        self.prize = prize
    }
}
