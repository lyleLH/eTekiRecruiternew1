//
//  ReachabiltyHandler.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 31/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift
import Reachability

protocol ReachablityHandlerDelegate {
    func getNetworkState(isReachable : Bool)
}

class ReachabiltyHandler {
    
    var delegate: ReachablityHandlerDelegate?
    var isNetworkAvailable = false
    var reachability: Reachability?
    let hostNames = ["www.apple.com"]
    var hostIndex = 0
    
    public init() {}
    
}

extension ReachabiltyHandler {
    
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
    }
  
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        
        do {
            if let hostName = hostName {
                   reachability =  try Reachability(hostname: hostName)
               } else {
                   reachability = try Reachability()
               }
            
            
            self.reachability = reachability
            
            if useClosures {
                reachability?.whenReachable = { reachability in
                    self.showMessageWhenReachable(reachability)
                }
                reachability?.whenUnreachable = { reachability in
                    self.showMessageWhenNotReachable(reachability)
                }
            } else {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(reachabilityChanged(_:)),
                    name: .reachabilityChanged,
                    object: reachability
                )
            }
        } catch {
            print(error)
        }

    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            //            networkStatus.textColor = .red
            //            networkStatus.text = "Unable to start\nnotifier"
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        
        if (reachability != nil) {
            reachability?.stopNotifier()
        }
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    func showMessageWhenReachable(_ reachability: Reachability) {
        isNetworkAvailable = true
        self.delegate?.getNetworkState(isReachable: isNetworkAvailable)
    }
    
    func showMessageWhenNotReachable(_ reachability: Reachability) {
        isNetworkAvailable = false
        self.delegate?.getNetworkState(isReachable: isNetworkAvailable)
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
            showMessageWhenReachable(reachability)
        } else {
            showMessageWhenNotReachable(reachability)
        }
    }
    
}
