//
//  ViewControllerExtensions.swift
//  GeekQuiz
//
//  Created by Egor on 14.07.2021.
//

import UIKit

extension UIViewController {
    
    func createActivityIndicator() -> UIView {
        
        let activityIndicatorView = UIView(frame: self.view.bounds)
        activityIndicatorView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = activityIndicatorView.center
        ai.startAnimating()
        activityIndicatorView.addSubview(ai)
        self.view.addSubview(activityIndicatorView)
        return activityIndicatorView
    }
    
    func showInformationAlert(title: String, message: String, confirmButtonTitle: String, confirmHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: confirmButtonTitle, style: .cancel, handler: confirmHandler)
        alert.addAction(action)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
