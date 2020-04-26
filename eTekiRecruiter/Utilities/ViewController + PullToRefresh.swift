//
//  ViewController + PullToRefresh.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 10/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import Foundation
import UIKit

var tableRefreshControl:UIRefreshControl = UIRefreshControl()

//MARK: VIEWCONTROLLER EXTENSION METHODS
public extension UIViewController {
    func makePullToRefreshToTableView(tableName: UITableView,withTitle title: String,action: Selector) -> UIRefreshControl {
        
        tableRefreshControl = UIRefreshControl()
        tableRefreshControl.attributedTitle = NSAttributedString(string: title)
        tableRefreshControl.backgroundColor = UIColor.white
        tableRefreshControl.addTarget(self, action: action, for: UIControl.Event.valueChanged)
        tableName.refreshControl = tableRefreshControl
        return tableRefreshControl
    }
    
    func makePullToRefreshEndRefreshing(tableName: String) {
        tableRefreshControl.endRefreshing()
        //additional codes
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
   }
}
