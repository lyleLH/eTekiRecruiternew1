//
//  UILabel + Extension.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 15/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)//CGRect.inset(by:)
        super.drawText(in: rect.inset(by: insets))
    }
}


