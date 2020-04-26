//
//  ViewController+Extensions.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 17/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

extension UIViewController {
    
//  @objc func setStatusBarBackgroundColor(color: UIColor) {
//        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//        statusBar.backgroundColor = color
//    }
    
    func setNavigationBarColor(color: UIColor) {
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: APPFonts.romanFont, size: 18.0) ?? UIFont()]
        navigationController?.navigationBar.barTintColor = color
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}



