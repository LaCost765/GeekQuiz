//
//  LoginViewController.swift
//  ClientVK
//
//  Created by Egor on 27.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class LoginViewController: UIScrollableViewController {

    @IBOutlet weak var languageSwitchControl: UISegmentedControl!
    @IBOutlet weak var emailView: UITitleTextErrorView!
    @IBOutlet weak var passwordView: UITitleTextErrorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        let fb = FirebaseFacade()
        if fb.isUserSignedIn() {
            self.gotToStartVC()
        }
        
        configureSubviews()
        localizeViews()
        bindViewModel()
    }
    
    @IBAction func changeLanguage(sender: UISegmentedControl) {
        
        guard let selectedLanguage = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
        
        Game.shared.setLanguage(string: selectedLanguage)
        localizeViews()
    }
    
    func localizeViews() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            self.emailView.titlePaddingLabel.text = "EMAIL_LBL".localized
            self.emailView.errorPaddingLabel.text = "CORRECT_EMAIL_MSG".localized
            self.passwordView.titlePaddingLabel.text = "PASSWORD_LBL".localized
            self.passwordView.errorPaddingLabel.text = "CORRECT_PASSWORD_MSG".localized
            self.loginButton.setTitle("SIGN_IN_BTN".localized, for: .normal)
            self.signUpButton.setTitle("IS_REGISTERED_BTN".localized, for: .normal)
        }
    }
    
    func bindViewModel() {

        emailView.textField.rx.text.bind(to: viewModel.email).disposed(by: viewModel.bag)
        passwordView.textField.rx.text.bind(to: viewModel.password).disposed(by: viewModel.bag)
        
        viewModel.isSignInButtonEnabled.bind(to: loginButton.rx.isEnabled).disposed(by: viewModel.bag)
    }
    
    func configureSubviews() {
        DispatchQueue.main.async { [weak self] in
            self?.languageSwitchControl.selectedSegmentIndex = Game.shared.language == .en ? 0 : 1
        }
        emailView.textType = .email
        passwordView.textType = .password
        
        emailView.handleTextFieldChanged = viewModel.areFieldsCorrect
        passwordView.handleTextFieldChanged = viewModel.areFieldsCorrect
    }
    
    @IBAction func successfullSignUp(segue: UIStoryboardSegue) {
        self.showInformationAlert(title: "SUCCESSFULL_REG_LBL".localized,
                                  message: "SUCCESSFULL_REG_MSG".localized,
                                  confirmButtonTitle: "ОК".localized,
                                  confirmHandler: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        viewModel.signIn { [weak self] success, message in
            
            guard let self = self else { return }
            if success {
                self.gotToStartVC()
            } else {
                self.showInformationAlert(title: "FAILED_LOGIN_LBL".localized,
                                          message: message ?? "FAIL_MSG".localized,
                                          confirmButtonTitle: "CANCEL".localized,
                                          confirmHandler: nil)
            }
        }
    }
    
    func gotToStartVC() {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as! StartViewController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}


