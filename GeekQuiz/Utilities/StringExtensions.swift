//
//  StringExtensions.swift
//  GeekQuiz
//
//  Created by Egor on 20.07.2021.
//

import Foundation

extension String {
    
    enum ValidityType {
        case email
        case password
        case name
        case normal
    }
    
    enum Regex: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case password = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        case name = "[А-Я]{1}[а-я]+"
    }
    
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validityType {
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        case .name:
            regex = Regex.name.rawValue
        case .normal:
            return true
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
    var localized: String {
        
        let str = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "Language"), ofType: "lproj")
        let myBundle = Bundle(path: self)
        return (myBundle?.localizedString(forKey: str, value: "", table: nil))!
    }
}
