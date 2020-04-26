//
//  PrimaryInfoViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 10/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol PrimaryInfoViewModelDelegate {
    func onGetProfileResponse(response : ProfileResponse?)
    func onAPIException(errorResponse : ErrorResponse?)
}

struct Profile {
   public static let primaryDetails = "Primary Details"
   public static let passcode = "Passcode"
   public static let smsSettings = "SMS Settings"
   public static let addressDetails = "Address Details"
   public static let companyDetails = "Company Details"
}


struct PrimaryInfoViewModel  {
    
    var socialLinkField = UITextField()
    var delegate : PrimaryInfoViewModelDelegate?
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self

    func shouldValidateCredentials() -> (Bool,String) {
        return (true,"Success")
    }
    
    func getPrimaryInfoDetails() {
        self.apiCall()
    }
    
    func updateSocialLinks(profileManager : ProfileManager) {
                
        self.profileAPI.updatePrimaryProfile(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                
                self.delegate?.onGetProfileResponse(response: response)
                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse)
            }
        }
    }
    
    func apiCall() {
        
        let profileManager = ProfileManager(type: Profile.primaryDetails)
        
        self.profileAPI.getProfileDetails(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                
                self.delegate?.onGetProfileResponse(response: response)
                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse)
            }
        }
    }

}

