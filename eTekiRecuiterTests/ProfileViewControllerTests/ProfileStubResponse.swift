//
//  ProfileStubResponse.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter



public extension ProfileResponse {
    
    static func stubResponse(json : Dictionary<String,Any>, code  : Bool, message : String) -> ProfileResponse? {
        return ProfileResponse(json: json,success : code,message : message)
    }
    static func stubDetailsResponse(json : Dictionary<String,Any>, otpRequired  : Bool, sameAsBillingAddress : String) -> ProfileResponse? {
        return ProfileResponse(json: json,success : otpRequired, message: sameAsBillingAddress)
    }
}
