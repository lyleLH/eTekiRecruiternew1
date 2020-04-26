//  UIButton+Extensions.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 10/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    func setImageWithText(image : UIImage , withTitle title : String) {
        self.tintColor = UIColor.white
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 8,left: 8,bottom: 8,right: 8)
        self.titleEdgeInsets = UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 0)
        self.borderColor = UIColor(red: 64.0/255.0, green: 189.0/255.0, blue: 230.0/255, alpha: 1.0)
        self.setTitle(title, for: .normal)
    }

 
}


extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.bounds.contains(point) ? self : nil
    }
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}
