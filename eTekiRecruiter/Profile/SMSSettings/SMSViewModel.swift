//
//  SMSViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 18/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol SMSViewModelDelegate {
    func onGetProfileResponse(response : ProfileResponse?,requestType : String)
    func onAPIException(errorResponse : ErrorResponse?,requestType : String)
}

struct SMSViewModel {
  
    var delegate : SMSViewModelDelegate?
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self

    
    func getSMSSettings(profileManager : ProfileManager, requestType : String) {
        
        self.profileAPI.getProfileDetails(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                self.delegate?.onGetProfileResponse(response: response,requestType: requestType)
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }
        }
        
    }
    
    func updateSMSSettings(profileManager : ProfileManager, requestType : String) {
        
        self.profileAPI.updateSMSSettings(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                self.delegate?.onGetProfileResponse(response: response,requestType: requestType)
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }
        }
        
    }
    
}
