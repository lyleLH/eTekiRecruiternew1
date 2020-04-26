//
//  UITextField+Extensions.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 23/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    enum Direction {
        case left
        case right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor) {
        let mainView = UIView(frame: CGRect(x: 2, y: 0, width: 35, height: 45))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 2, y: 0, width: 35, height: 45))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 8.0, y: 15.0, width: 19.94, height: 13.6)
        view.addSubview(imageView)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)
        
        if(Direction.left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    
}

extension UITextField {
    func isValidEmail(emailStr : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func isValidPassword(passwordStr : String) -> Bool {
        if passwordStr.count < 8 {
            return false
        } else {
            return true
        }
    }
    
    func isValidZip(zipStr : String) -> Bool {
        if zipStr.count > 6 {
            return false
        } else {
            return true
        }
    }
}

extension UITextField {
    
    func setBottomBorderOnlyWith(color: CGColor) {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setFontforTextFieldPlaceHolder(customfont : UIFont , placeholderString : String,color : UIColor) {
        attributedPlaceholder = NSAttributedString(string : placeholderString, attributes:[NSAttributedString.Key.foregroundColor: color,NSAttributedString.Key.font : customfont])
    }
    
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")
        
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}


extension UITextField {
    
    func addDoneButtonOnKeyboard(_ target: AnyObject?, action: Selector) {
        
        let customToolBar = UIView()
        customToolBar.frame = CGRect(x: 0, y: 0, width: ScreenSize.width,
                                     height: 50)
        let doneButton = UIButton(frame: CGRect(x: 8, y: 0, width: 50, height: 50))
        doneButton.addTarget(target, action: action, for: .touchUpInside)
        doneButton.light(size: 18.0)
        doneButton.setTitle("Done", for: .normal)
        customToolBar.addSubview(doneButton)
        customToolBar.backgroundColor = AppTheme.brandColor
        customToolBar.sizeToFit()
        self.inputAccessoryView = customToolBar
    }
    
    func addCancelButtonOnKeyboard(_ target: AnyObject?, action: Selector) {
        let customToolBar = UIView()
        customToolBar.frame = CGRect(x: 0, y: 0, width: ScreenSize.width,
                                     height: 50)
        let cancelButton = UIButton(frame: CGRect(x: ScreenSize.width-68, y: 0, width: 60, height: 50))
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.light(size: 18.0)
        customToolBar.addSubview(cancelButton)
        customToolBar.backgroundColor = AppTheme.brandColor
        customToolBar.sizeToFit()
        self.inputAccessoryView = customToolBar
    }
}
