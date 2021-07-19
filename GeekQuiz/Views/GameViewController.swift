//
//  GameViewController.swift
//  GeekQuiz
//
//  Created by Egor on 11.07.2021.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class GameViewController: UIViewController {

    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var totalPrizeLabel: UILabel!
    @IBOutlet weak var peopleHelpButton: UIButton!
    @IBOutlet weak var chanceHelpButton: UIButton!
    @IBOutlet weak var callHelpButton: UIButton!
    
    var viewModel: GameViewModel?
    let bag = DisposeBag()
    var activityIndicatorView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GameViewModel()
        createActivityIndicator()
        subscription()
        styleButtons()
        // Do any additional setup after loading the view.
    }
    
    func createActivityIndicator() {
        
        activityIndicatorView = UIView(frame: self.view.bounds)
        activityIndicatorView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = activityIndicatorView!.center
        ai.startAnimating()
        activityIndicatorView?.addSubview(ai)
        self.view.addSubview(activityIndicatorView!)
    }
    
    func subscription() {
        guard let viewModel = viewModel else { return }
        
        viewModel.question.subscribe(onNext: { question in
            guard let question = question else { return }
            let answers = question.answers.shuffled()
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                self.answer1Button.setTitle(answers[0], for: .normal)
                self.answer2Button.setTitle(answers[1], for: .normal)
                self.answer3Button.setTitle(answers[2], for: .normal)
                self.answer4Button.setTitle(answers[3], for: .normal)
                
                self.answer1Button.isEnabled = true
                self.answer2Button.isEnabled = true
                self.answer3Button.isEnabled = true
                self.answer4Button.isEnabled = true
                
                self.questionLabel.text = question.topic
                self.prizeLabel.text = "\(question.prize) $"
                self.categoryLabel.text = question.category
            }
        }).disposed(by: bag)
        
        viewModel.totalPrize.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.totalPrizeLabel.text = "Выигрыш: \(value) $"
        }).disposed(by: bag)
        
        viewModel.gameFinished.subscribe(onNext: { [weak self] message in
            guard let self = self else { return }
            self.showInformationAlert(title: "Игра закончена", message: message, confirmButtonTitle: "Главное меню", confirmHandler: { [weak self] _ in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "BackToStartSegue", sender: self)
            })
        }).disposed(by: bag)

        guard let activityIndicatorView = activityIndicatorView else { return }
        viewModel.areQuestionsLoading.map { !$0 }.bind(to: activityIndicatorView.rx.isHidden).disposed(by: bag)
    }
    
//    func loadNewQuestion() {
//
//        guard let question = Game.shared.session?.getNextQuestion() else {
//            finishGame(with: "Поздравляем! Вы прошли нашу викторину и выигрываете \(Game.shared.session?.currentBank ?? 0) $!", resultMessage: "Победа")
//            return
//        }
//
//        currentQuestion = question
//        DispatchQueue.main.async { [weak self] in
//
//            guard let self = self else { return }
//
//            let buttons: [UIButton] = [self.answer1Button, self.answer2Button, self.answer3Button, self.answer4Button]
//            var i = 0
//            buttons.forEach { button in
//                button.setTitle(question.answers[i], for: .normal)
//                i += 1
//                button.isEnabled = true
//            }
//
//            self.questionLabel.text = question.topic
//            self.prizeLabel.text = "\(question.prize) $"
//            self.totalPrizeLabel.text = "Выигрыш: \(Game.shared.session?.currentBank ?? 0) $"
//
//        }
//    }
    
    @IBAction func answerButtonTapped(sender: UIButton) {
        
        guard let answer = sender.currentTitle else { return }
        guard let viewModel = viewModel else { return }
        viewModel.verifyAnswer(answer: answer)
    }
    
    func styleButtons() {
        
        configureAnswerButton(button: answer1Button)
        configureAnswerButton(button: answer2Button)
        configureAnswerButton(button: answer3Button)
        configureAnswerButton(button: answer4Button)
    }
    
    func configureAnswerButton(button: UIButton) {
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
//    func finishGame(with message: String, resultMessage: String) {
//
//        let alert = UIAlertController(title: resultMessage, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Главное меню", style: .cancel) { [weak self] _ in
//
//            guard let self = self else { return }
//            self.performSegue(withIdentifier: "BackToStartSegue", sender: self)
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func chanceHelpButtonTapped() {
        
        guard let viewModel = viewModel else { return }
        chanceHelpButton.isEnabled = false
        
        let answersToHide = viewModel.useFiftyFiftyHint()
        [answer1Button, answer2Button, answer3Button, answer4Button].forEach { button in
            
            if answersToHide.contains(button?.currentTitle ?? "") {
                button?.isEnabled = false
                button?.setTitle("", for: .normal)
            }
        }
    }
    
    @IBAction func peopleHelpButtonTapped() {
        
        guard let viewModel = viewModel else { return }
        peopleHelpButton.isEnabled = false
        let hintText = viewModel.getHallHelp()
        self.showInformationAlert(title: "Помощь зала", message: hintText, confirmButtonTitle: "ОК", confirmHandler: nil)
    }
    
    @IBAction func callHelpButtonTapped() {
        
        guard let viewModel = viewModel else { return }
        callHelpButton.isEnabled = false
        let hintText = viewModel.getFriendCall()
        self.showInformationAlert(title: "Звонок другу", message: hintText, confirmButtonTitle: "ОК", confirmHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func showInformationAlert(title: String, message: String, confirmButtonTitle: String, confirmHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: confirmButtonTitle, style: .cancel, handler: confirmHandler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
