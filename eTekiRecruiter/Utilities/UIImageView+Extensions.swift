//
//  UIImageView+Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

@IBDesignable extension UIImageView {
    
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

}


extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}


extension UIImageView {

    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

//MARK: This extension is for Blinker animations in Dashboard.
extension UIImageView {

    func animate(images: [UIImage], index: Int = 0, completionHandler: (() -> Void)?) {

        UIView.transition(with: self, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.image = images[index]

        }, completion: { value in
            let idx = index == images.count-1 ? 0 : index+1

            if idx == 0 {
                
                self.animate(images: images, index: 0, completionHandler: completionHandler)

            } else {
                self.animate(images: images, index: idx, completionHandler: completionHandler)
            }

        })
    }
}
