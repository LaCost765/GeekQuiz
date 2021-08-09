//
//  SignUpViewModel.swift
//  GeekMobile
//
//  Created by Egor on 10.03.2021.
//

import Foundation
import RxSwift
import RxRelay

class SignUpViewModel {
    
    var isSignUpButtonEnabled: BehaviorSubject<Bool>
    var bag: DisposeBag = DisposeBag()
    let email: BehaviorRelay<String?>
    let name: BehaviorRelay<String?>
    let surname: BehaviorRelay<String?>
    let password: BehaviorRelay<String?>
    
    init() {
        isSignUpButtonEnabled = BehaviorSubject(value: false)
        email = BehaviorRelay<String?>(value: "")
        name = BehaviorRelay<String?>(value: "")
        surname = BehaviorRelay<String?>(value: "")
        password = BehaviorRelay<String?>(value: "")
    }
    
    func areFieldsCorrect() {
        guard let email = email.value else { return }
        guard let name = name.value else { return }
        guard let surname = surname.value else { return }
        guard let password = password.value else { return }
        
        let isCorrect =  email.isValid(.email) && name.isValid(.name) && surname.isValid(.name) && password.isValid(.password)
        isSignUpButtonEnabled.onNext(isCorrect)
    }
    
    func signUp(completion: @escaping (Bool, String?) -> Void) {
        
        guard let email = email.value else { return }
        guard let name = name.value else { return }
        guard let surname = surname.value else { return }
        guard let password = password.value else { return }
        
        let fb = FirebaseFacade()
        fb.signUpUser(email: email,
                      name: name,
                      surname: surname,
                      password: password,
                      completion: completion)
        
    }
}
