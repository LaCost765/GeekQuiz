//
//  StartViewController.swift
//  GeekQuiz
//
//  Created by Egor on 10.07.2021.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var showResultsButton: UIButton!
    @IBOutlet weak var showRulesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startGameButtonTapped(sender: Any) {
        
        let alert = UIAlertController(title: "Введите ваше имя", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Ваше имя"
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Старт", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            guard let userName = alert.textFields?[0].text else { return }
            self.createAndStartGame(for: userName)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAndStartGame(for user: String) {
        
        let session = GameSession(for: user)
        Game.shared.session = session
        self.performSegue(withIdentifier: "StartGameSegue", sender: nil)
    }
    
    @IBAction func showRulesButtonTapped(sender: Any) {
        
        let alert = UIAlertController(title: "Правила", message: "GeekQuiz - это викторина с денежным призом. Всего 15 вопросов, после каждых 5 вопросов сложность увеличивается. Простые вопросы стоят 500 $, посложнее - 1500 $, самые сложные - 18000 $. На каждый вопрос есть 4 варианта ответа. Ответив неверно - игра заканчивается и вы получаете лишь половину от суммы, которую заработали. Также есть 3 подсказки, каждой можно воспользоваться лишь 1 раз за игру, при этом каждая неиспользованная подсказка в случае выигрыша увеличит приз в 2 раза. Удачи!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
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

extension StartViewController: UITextFieldDelegate {
    
}
