//
//  UILabel+Extensions.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 19/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

extension String {
    
    func getAttributedString(text : String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
}
