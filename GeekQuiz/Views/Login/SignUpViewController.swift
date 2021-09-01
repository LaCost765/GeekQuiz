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
        localizeViews()
        bindViewModel()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        viewModel.signUp { success, message in
            if success {
                self.performSegue(withIdentifier: "successfullSignUp", sender: sender)
            } else {
                self.showInformationAlert(title: "FAILED_REG_LBL".localized, message: message ?? "FAIL_MSG".localized, confirmButtonTitle: "CANCEL".localized, confirmHandler: nil)
            }
        }
    }
    
    func localizeViews() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.emailView.configure(title: "EMAIL_LBL".localized, errorText: "CORRECT_EMAIL_MSG".localized)
            self.nameView.configure(title: "NAME_LBL".localized, errorText: "CORRECT_NAME_MSG".localized)
            self.surnameView.configure(title: "SURNAME_LBL".localized, errorText: "CORRECT_NAME_MSG".localized)
            self.passwordView.configure(title: "PASSWORD_LBL".localized, errorText: "CORRECT_PASSWORD_MSG".localized)
            self.signUpButton.setTitle("SIGN_UP_BTN".localized, for: .normal)
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
