//
//  VerificationViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol VerificationViewModelDelegate {
    func onGetProfileResponse(response : ProfileResponse?,requestType : String)
    func onAPIException(errorResponse : ErrorResponse?,requestType : String)
}

struct VerificationViewModel {
    
    var delegate : VerificationViewModelDelegate?
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
 
    
    func verifyOTP(profileManager : ProfileManager, requestType : String) {
        
        self.profileAPI.sendOTP(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                self.delegate?.onGetProfileResponse(response: response,requestType: requestType)
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }
        }
        
    }
    
    func resendOTP(requestType : String) {
        
        self.profileAPI.resendOTP() { (response, errorResponse) in
            if response != nil {
                self.delegate?.onGetProfileResponse(response: response,requestType: requestType)
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }
        }
        
    }
    
}
