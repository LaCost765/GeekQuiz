//
//  UITitleTextErrorView.swift
//  GeekMobile
//
//  Created by Egor on 10.03.2021.
//

import UIKit

enum ErrorViewState {
    case error
    case focused
    case none
    case ok
}

class UITitleTextErrorView: UIView {
    
    @IBOutlet weak var titlePaddingLabel: UIPaddingLabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorPaddingLabel: UIPaddingLabel!
    
    var textType: String.ValidityType = .normal
    var handleTextFieldChanged: (() -> Void)?
    
    var state: ErrorViewState = .none {
        didSet {
            setState(with: state)
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        errorPaddingLabel.alpha = 0
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    func setState(with state: ErrorViewState) {
        switch state {
        case .error:
            errorPaddingLabel.alpha = 1
            titlePaddingLabel.textColor = UIColor.systemRed
            textField.layer.borderColor = UIColor.systemRed.cgColor
        case .ok:
            errorPaddingLabel.alpha = 0
            titlePaddingLabel.textColor = UIColor.systemGreen
            textField.layer.borderColor = UIColor.systemGreen.cgColor
        case .focused:
            errorPaddingLabel.alpha = 0
            titlePaddingLabel.textColor = UIColor.systemOrange
            textField.layer.borderColor = UIColor.systemOrange.cgColor
        case .none:
            errorPaddingLabel.alpha = 0
            titlePaddingLabel.textColor = UIColor.systemGray
            textField.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        if let handle = handleTextFieldChanged {
            handle()
        }
    }
    
    @IBAction func textFieldEditingStop(_ sender: Any) {
        
        let isValid = textField.text?.isValid(textType) ?? false

        if isValid {
            state = .ok
        }
        else {
            state = .error
        }
    }
    
    @IBAction func textFieldFocused(_ sender: Any) {
        setState(with: .focused)
    }
}
