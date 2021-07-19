//
//  ParserJSON.swift
//  GeekQuiz
//
//  Created by Egor on 12.07.2021.
//

import Foundation
import SwiftyJSON
import RxSwift

class ParserJSON {

    static func getQuestions(data jsonData: Data, difficulty: QuestionDifficulty) -> Observable<[Question]> {
        
        return Observable<[Question]>.create { observer -> Disposable in
              
            let json = JSON(jsonData)
            
            var questions: [Question] = []
            json["results"].arrayObject?
                .map { JSON($0) }
                .forEach { question in
                    guard let cat = question["category"].string else { return }
                    guard let topic = String(htmlEncodedString: question["question"].string ?? "") else { return }
                    guard var answers = question["incorrect_answers"].arrayObject as? [String] else { return }
                    guard let rightAnswer = question["correct_answer"].string else { return }
                    answers.append(rightAnswer)
                    answers = answers.convertHtmlEncoded()
                    questions.append(Question(topic: topic, category: cat, rightAnswer: rightAnswer, prize: difficulty.getPrize(), answers: answers))
                }
            observer.onNext(questions)
            
            return Disposables.create()
        }
    }
}

extension Array where Element == String {
    
    func convertHtmlEncoded() -> [String] {
        
        var result: [String] = []
        self.forEach { str in
            if let encoded = String(htmlEncodedString: str) {
                result.append(encoded)
            }
        }
        
        return result
    }
}

extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }
}
