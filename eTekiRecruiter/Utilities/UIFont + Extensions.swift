//
//  UIFont + Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 25/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    func light(size : CGFloat) {
        self.font = UIFont.appLightFontWith(size: size)
    }

    func roman(size : CGFloat) {
        self.font = UIFont.appRomanFontWith(size: size)
    }

    func bold(size : CGFloat) {
        self.font = UIFont.appBoldFontWith(size: size)
    }

}

extension UIButton {

    func light(size : CGFloat) {
        self.titleLabel?.font = UIFont.appLightFontWith(size: size)
    }

    func roman(size : CGFloat) {
        self.titleLabel?.font = UIFont.appRomanFontWith(size: size)
    }

    func bold(size : CGFloat) {
        self.titleLabel?.font = UIFont.appBoldFontWith(size: size)
    }

}

extension UITextView {

    func light(size : CGFloat) {
        self.font = UIFont.appLightFontWith(size: size)
    }

    func roman(size : CGFloat) {
        self.font = UIFont.appRomanFontWith(size: size)
    }

    func bold(size : CGFloat) {
        self.font = UIFont.appBoldFontWith(size: size)
    }

}

extension UITextField {

    func light(size : CGFloat) {
        self.font = UIFont.appLightFontWith(size: size)
    }

    func roman(size : CGFloat) {
        self.font = UIFont.appRomanFontWith(size: size)
    }

    func bold(size : CGFloat) {
        self.font = UIFont.appBoldFontWith(size: size)
    }

}

extension UIFont {

    class func appRomanFontWith( size:CGFloat) -> UIFont{
        return  UIFont(name: APPFonts.romanFont, size: size) ?? UIFont()
    }

    class func appBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: APPFonts.boldFont, size: size) ?? UIFont()
    }

    class func appLightFontWith( size:CGFloat) -> UIFont{
        return  UIFont(name: APPFonts.lightFont, size: size) ?? UIFont()
    }
}

extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            self.font = UIFont.appLightFontWith(size: 18.0)
        }
    }

}

extension UITextField {
    var substituteFontName : String {
        get { return self.font!.fontName }
        set {
                self.font = UIFont.appLightFontWith(size: 18.0)
            }
    }
}
