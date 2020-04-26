//
//  MenuTableViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 10/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol MenuTableViewModelDelegate {
    func onAPISuccessResponse(response : SignInResponse?)
    func onAPIException(errorResponse : ErrorResponse?)
}

struct MenuTableViewModel  {
  
    var delegate : MenuTableViewModelDelegate?
    var authenticaionAPI: AuthenticationAPIProtocol.Type = AuthenticationApi.self

}

extension MenuTableViewModel {
    func callSignOutAPI(credentialsManager : CredentialsManager) {
        authenticaionAPI.logout(credentials: credentialsManager) { (signInResponse, error) in
            if error == nil {
                self.delegate?.onAPISuccessResponse(response: signInResponse)
            } else {
                self.delegate?.onAPIException(errorResponse: error)
            }
        }
    }
}
