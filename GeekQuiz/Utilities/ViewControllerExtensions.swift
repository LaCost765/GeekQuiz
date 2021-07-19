//
//  ViewControllerExtensions.swift
//  GeekQuiz
//
//  Created by Egor on 14.07.2021.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    
    func showActivityIndicator() {
        
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeActivityIndicator() {
        
        aView?.removeFromSuperview()
        aView = nil
    }
}
