//
//  UIApplication+TopMostController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 31/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

/*
 *  Get TopMost View Controller of Application.
 */
extension UIApplication {
    class func topMostViewController(_ root: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationBar = root as? UINavigationController {
            return topMostViewController(navigationBar.viewControllers.last)
        }
        if let tabBar = root as? UITabBarController {
            return topMostViewController(tabBar.selectedViewController)
        }
        if let presented = root?.presentedViewController {
            return topMostViewController(presented)
        }
        return root
    }
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
