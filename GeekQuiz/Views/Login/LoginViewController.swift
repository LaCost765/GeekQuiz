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

    @IBOutlet weak var emailView: UITitleTextErrorView!
    @IBOutlet weak var passwordView: UITitleTextErrorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fb = FirebaseFacade()
        if fb.isUserSignedIn() {
            self.gotToStartVC()
        }
        
        configureSubviews()
        bindViewModel()
    }
    
    func bindViewModel() {

        emailView.textField.rx.text.bind(to: viewModel.email).disposed(by: viewModel.bag)
        passwordView.textField.rx.text.bind(to: viewModel.password).disposed(by: viewModel.bag)
        
        viewModel.isSignInButtonEnabled.bind(to: loginButton.rx.isEnabled).disposed(by: viewModel.bag)
    }
    
    func configureSubviews() {
        emailView.textType = .email
        passwordView.textType = .password
        
        emailView.handleTextFieldChanged = viewModel.areFieldsCorrect
        passwordView.handleTextFieldChanged = viewModel.areFieldsCorrect
        
    }
    
    @IBAction func successfullSignUp(segue: UIStoryboardSegue) {
        self.showInformationAlert(title: "Регистрация прошла успешно!",
                                  message: "Войдите в систему с созданной учетной записью",
                                  confirmButtonTitle: "ОК",
                                  confirmHandler: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        viewModel.signIn { [weak self] success, message in
            
            guard let self = self else { return }
            if success {
                self.gotToStartVC()
            } else {
                self.showInformationAlert(title: "Ошибка входа!",
                                          message: message ?? "Что-то пошло не так, повторите попытку",
                                          confirmButtonTitle: "Отмена",
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


