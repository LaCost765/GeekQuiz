//
//  SignUpViewController.swift
//  ClientVK
//
//  Created by Egor on 10.03.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIScrollableViewController {
    
    @IBOutlet weak var emailView: UITitleTextErrorView!
    @IBOutlet weak var nameView: UITitleTextErrorView!
    @IBOutlet weak var surnameView: UITitleTextErrorView!
    @IBOutlet weak var passwordView: UITitleTextErrorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel: SignUpViewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        bindViewModel()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        viewModel.signUp { success, message in
            if success {
                self.performSegue(withIdentifier: "successfullSignUp", sender: sender)
            } else {
                self.showInformationAlert(title: "Ошибка регистрации!", message: message ?? "Что-то пошло не так, повторите попытку", confirmButtonTitle: "Отмена", confirmHandler: nil)
            }
        }
    }
    
    func bindViewModel() {

        viewModel.isSignUpButtonEnabled.bind(to: signUpButton.rx.isEnabled).disposed(by: viewModel.bag)
        emailView.textField.rx.text.bind(to: viewModel.email).disposed(by: viewModel.bag)
        nameView.textField.rx.text.bind(to: viewModel.name).disposed(by: viewModel.bag)
        surnameView.textField.rx.text.bind(to: viewModel.surname).disposed(by: viewModel.bag)
        passwordView.textField.rx.text.bind(to: viewModel.password).disposed(by: viewModel.bag)
    }
    
    func configureSubviews() {
        emailView.textType = .email
        nameView.textType = .name
        surnameView.textType = .name
        passwordView.textType = .password
        
        emailView.handleTextFieldChanged = viewModel.areFieldsCorrect
        nameView.handleTextFieldChanged = viewModel.areFieldsCorrect
        surnameView.handleTextFieldChanged = viewModel.areFieldsCorrect
        passwordView.handleTextFieldChanged = viewModel.areFieldsCorrect
        
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
