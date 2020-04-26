//
//  ChangePasswordViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 13/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

protocol ChangePasswordViewModelDelegate {
    func onGetProfileResponse(response : ProfileResponse?)
    func onAPIException(errorResponse : ErrorResponse?)
}


struct ChangePasswordViewModel  {
    
    var delegate : ChangePasswordViewModelDelegate?
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
    
   
    func updatePassword(profileManager : ProfileManager) {
        self.apiCall(profileManager: profileManager)
    }
    
    func apiCall(profileManager : ProfileManager) {
        
        self.profileAPI.updatePassword(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                self.delegate?.onGetProfileResponse(response: response)
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse)
            }
            
        }

    }
    
}
