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
    var aiView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aiView = createActivityIndicator()
        loadUserBestResult()
        // Do any additional setup after loading the view.
    }
    
    func loadUserBestResult() {
        let fb = FirebaseFacade()
        if Game.shared.userName == "", let name = fb.getCurrentUserName() {
            Game.shared.userName = name
        }
        
        fb.loadBestResultForUser { [weak self] result in
            Game.shared.bestResult = result
            self?.aiView?.removeFromSuperview()
            self?.aiView = nil
        }
    }
    
    @IBAction func startGameButtonTapped(sender: Any) {
        
        self.createAndStartGame()
    }
    
    func createAndStartGame() {
        
        let session = GameSession(for: Game.shared.userName)
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
    
    @IBAction func signOutButtonTapped(sender: Any) {
        
        let fb = FirebaseFacade()
        fb.signOut()
        goToLoginVC()
    }
    
    func goToLoginVC() {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        }
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
