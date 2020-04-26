//
//  BaseViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class BaseViewModel : ReachablityHandlerDelegate {
    
    var isNetworkAvailable = false
    static let shared = BaseViewModel()
    let reachabiltyHandler = ReachabiltyHandler()
    
    private init() {}
    
    func setUpReachabilty() {
        reachabiltyHandler.delegate = self
        reachabiltyHandler.startHost(at: 0)
    }
    
    func getNetworkState(isReachable: Bool) {
        isNetworkAvailable = isReachable
        reachabiltyHandler.stopNotifier()
    }
}
