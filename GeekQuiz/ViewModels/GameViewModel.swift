//
//  GameViewModel.swift
//  GeekQuiz
//
//  Created by Egor on 11.07.2021.
//

import Foundation
import RxSwift
import RxRelay

class GameViewModel {
    
    // comment for pull request
    var question: BehaviorRelay<Question?>
    var questions: [Question] = []
    let bag = DisposeBag()
    let gameFinished = PublishSubject<String>() // true - win, false - lose + message
    let areQuestionsLoading = BehaviorRelay<Bool>(value: false)
    let totalPrize: BehaviorRelay<Int>
    
    init() {
        question = BehaviorRelay(value: nil)
        totalPrize = BehaviorRelay(value: 0)
        loadNewQuestions()
    }
    
    func subscription() {
    }
    
    func loadNewQuestions() {
        
        if Game.shared.session?.rightAnswers == 15 {
            finishGame(result: true)
            return
        }
        
        areQuestionsLoading.accept(true)
        Game.shared.session?.loadNewQuestions()
            .flatMap { ParserJSON.getQuestions(data: $0, difficulty: Game.shared.session?.difficulty ?? .easy)}
            .subscribe(onNext: { [weak self] questions in
                
                guard let self = self else { return }
                guard questions.count == 5 else { return }
                self.questions = questions.shuffled()
                self.question.accept(self.questions.removeLast())
                Game.shared.session?.difficulty.increase()
                self.areQuestionsLoading.accept(false)
            }).disposed(by: bag)
    }
    
    func verifyAnswer(answer: String) {
        
        guard let q = question.value else { return }
        
        if q.rightAnswer == answer {
            Game.shared.session?.currentBank += q.prize
            totalPrize.accept(Game.shared.session?.currentBank ?? totalPrize.value)
            if questions.count > 0 {
                question.accept(questions.removeLast())
            } else {
                loadNewQuestions()
            }
        } else {
            finishGame(result: false)
        }
    }
    
    func finishGame(result: Bool) {
        
        var message: String = ""
        guard let prize = Game.shared.session?.calculateFinalPrize() else { return }
        
        if result == true {
            message = "Поздравляем, вы верно ответили на все 10 вопросов и выигрываете приз в размере \(prize) $!"
        } else {
            message = "К сожалению, вы не смогли полностью пройти викторину, поэтому ваш выигрыш составляет \(prize) $. Не расстрайвайтесь и попробуйте еще раз!"
        }
       
        if let gameResult = Game.shared.createGameResult() {
            
            let fb = FirebaseFacade()
            
            if (Game.shared.bestResult?.prize ?? 0) <= gameResult.prize {
                Game.shared.bestResult = gameResult
                fb.addResultToFirestore(result: gameResult)
            }
        }
        
        Game.shared.saveSessionResult()
        gameFinished.onNext(message)
    }
    
    func useFiftyFiftyHint() -> [String] {

        Game.shared.session?.isFiftyFiftyUsed = true
        
        guard let q = question.value else { return [] }
        var deleteCount = 2
        var answersToDelete: [String] = []
        let answers = q.answers.shuffled()
        
        answers.forEach { answer in
            if deleteCount > 0 {
                if answer != q.rightAnswer {
                    answersToDelete.append(answer)
                    deleteCount -= 1
                }
            }
        }
        
        return answersToDelete
    }
    
    func getFriendCall() -> String {
        
        Game.shared.session?.isFriendCallUsed = true
        
        var answer = ""
        let chance = Int.random(in: 0...80)
        guard let q = question.value else { return "" }
        if chance <= 80 {
            answer = q.rightAnswer
        } else {
            answer = q.answers.filter { $0 != q.rightAnswer}.randomElement() ?? ""
        }
        
        return "Вы позвонили другу, и он считает, что правильный ответ - \(answer)"
    }
    
    func getHallHelp() -> String {
        
        Game.shared.session?.isHallHelpUsed = true
        
        let rightAnswerChance = Int.random(in: 35...55)
        let secondHighChance = 80 - rightAnswerChance
        let lowChance = Int.random(in: 0...20)
        let secondLowChance = 20 - lowChance
        
        guard let q = question.value else { return "" }
        let wrongAnswers = q.answers.filter { $0 != q.rightAnswer }
        return "Мы собрали следующую статистику: \(wrongAnswers[0]) - \(secondHighChance) %, \(q.rightAnswer) - \(rightAnswerChance) %, \(wrongAnswers[1]) - \(lowChance) %, \(wrongAnswers[2]) - \(secondLowChance) %"
    }
}
