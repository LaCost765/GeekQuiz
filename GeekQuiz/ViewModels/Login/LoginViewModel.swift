//
//  LoginViewModel.swift
//  ClientVK
//
//  Created by Egor on 27.02.2021.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel {
    
    // Properties
    var isSignInButtonEnabled: BehaviorSubject<Bool>
    var bag: DisposeBag = DisposeBag()
    
    var email: BehaviorRelay<String?>
    var password: BehaviorRelay<String?>
    
    // Initializers
    init() {
        isSignInButtonEnabled = BehaviorSubject(value: false)
        email = BehaviorRelay<String?>(value: nil)
        password = BehaviorRelay<String?>(value: nil)
    }
    
    func areFieldsCorrect() {
        
        guard let email = email.value else { return }
        guard let password = password.value else { return }
        let isCorrect =  email.isValid(.email) && password.isValid(.password)
        if isCorrect {
            print("good")
        }
        isSignInButtonEnabled.onNext(isCorrect)
    }
    
    func signIn(completion: @escaping (Bool, String?) -> Void) {
        
        guard let email = email.value else { return }
        guard let password = password.value else { return }
        let fb = FirebaseFacade()
        fb.signInUser(with: email, password: password) { success, errorMessage in
            completion(success, errorMessage)
        }
    }
}
