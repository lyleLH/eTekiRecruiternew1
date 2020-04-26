//
//  CompanyViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 17/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol CompanyViewModelDelegate {
    func onGetProfileResponse(response : ProfileResponse?)
    func onAPIException(errorResponse : ErrorResponse?)
}

struct CompanyViewModel  {
    
    var delegate : CompanyViewModelDelegate?
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self

    func getCompanyDetails(profileManager : ProfileManager) {
        
        self.profileAPI.getProfileDetails(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                
                self.delegate?.onGetProfileResponse(response: response)
                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse)
            }
        }
    }
    
    func updateCompanyDetails(profileManager : ProfileManager) {
        
        self.profileAPI.updateCompanyDetails(profileManager: profileManager) { (response, errorResponse) in
            if response != nil {
                
                self.delegate?.onGetProfileResponse(response: response)
                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse)
            }
        }
    }

    
}

