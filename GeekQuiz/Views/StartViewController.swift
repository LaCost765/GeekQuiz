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
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var switchLanguageControl: UISegmentedControl!
    var aiView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aiView = createActivityIndicator()
        loadUserBestResult()
        configureViews()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeLanguage(sender: UISegmentedControl) {
        
        guard let selectedLanguage = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
        
        Game.shared.setLanguage(string: selectedLanguage)
        configureViews()
    }
    
    func configureViews() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.switchLanguageControl.selectedSegmentIndex = Game.shared.language == .en ? 0 : 1
            self.startGameButton.setTitle("START_GAME_BTN".localized, for: .normal)
            self.showResultsButton.setTitle("LEADERBOARD_BTN".localized, for: .normal)
            self.showRulesButton.setTitle("RULES_BTN".localized, for: .normal)
            self.signOutButton.setTitle("SIGN_OUT_BTN".localized, for: .normal)
        }
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
        
        let alert = UIAlertController(title: "RULES_BTN".localized, message: "RULES_TXT".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
        
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
