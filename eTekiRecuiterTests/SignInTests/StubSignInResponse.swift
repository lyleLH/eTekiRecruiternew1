//
//  StubSignInResponse.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter



public extension SignInResponse {
    
    static func stubResponse() -> SignInResponse? {
        return stubResponse(code: true)
    }
    
    static func stubResponse(code: Bool) -> SignInResponse? {
        return SignInResponse(json: [:],  success: code)
    }
    
    static func stubResponse(json : Dictionary<String,Any>, code  : Bool) -> SignInResponse? {
        return SignInResponse(json: json,  success: code)
    }
}

