//
//  UIImageSize+Extension.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 23/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

extension UIImage {

    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(data: image.pngData()!)!
    }
    
 

}

 public extension UIImage {

  /**
   Returns image with size 1x1px of certain color.
   */
 class func imageWithColor(color : UIColor) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()

    context?.setFillColor(color.cgColor)

    context?.fill(rect)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
}

 }
