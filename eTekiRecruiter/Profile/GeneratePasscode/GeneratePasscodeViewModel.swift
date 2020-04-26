//
//  GeneratePasscodeViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 13/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

protocol GeneratePasscodeViewModelDelegate {
    func onGetProfileResponse(response : ProfileResponse?,requestType : String)
    func onAPIException(errorResponse : ErrorResponse?,requestType : String)
}


struct GeneratePasscodeViewModel  {
    
    var delegate : GeneratePasscodeViewModelDelegate?
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
    
    
    func getPasscode(profileManager : ProfileManager, requestType : String) {
        self.apiCall(profileManager: profileManager, requestType : requestType)
    }
    
    func resetPasscode(requestType : String) {
        self.profileAPI.resetPasscode { (response, errorResponse) in
            if response != nil {
                self.delegate?.onGetProfileResponse(response: response,requestType : requestType )                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }
        }
    }
    
    func apiCall(profileManager : ProfileManager, requestType : String) {
        
        self.profileAPI.getProfileDetails(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                
                self.delegate?.onGetProfileResponse(response: response,requestType: requestType)
                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }
        }
    
        
    }
    
}
