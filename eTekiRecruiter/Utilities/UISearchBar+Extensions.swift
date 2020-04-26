//
//  UISearchBar+Extensions.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 17/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func setCustomBackgroundColor (color: UIColor) {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = frame
        backgroundLayer.backgroundColor = color.cgColor
        if let image = UIImage.imageFromLayer(layer: backgroundLayer) {
            self.setBackgroundImage(image, for: .any, barMetrics: .default)
        }
    }
}
