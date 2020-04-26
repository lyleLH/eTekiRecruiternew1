//
//  File.swift
//  eTekiRecruiter
//
//  Created by Bharat shankar on 16/04/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import Foundation
import UIKit
import Amplitude

extension UIViewController {
    
    
    func generateEventLogToAnalytics(eventName : String , status : String )  {
        
         let amplitudeInstance = Amplitude()
                                  amplitudeInstance.initializeApiKey("e3b77be60e7267be70c74f7e26876569")
        var params = [String:String]()
                                  //user name,user type,status
                                   amplitudeInstance.setUserProperties(params)
                                   amplitudeInstance.logEvent(eventName)
                                   params["user name"] = UserDefaults.standard.string(forKey: "displayName") ?? ""
                                   params["user type"] = UserDefaults.standard.string(forKey: "Role") ?? ""
                                   params["status"] = status
                                   amplitudeInstance.logEvent(eventName, withEventProperties: params)

                                   amplitudeInstance.uploadEvents()
    }
    
    
}
