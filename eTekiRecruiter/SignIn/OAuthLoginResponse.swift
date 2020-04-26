//
//  OAuthLoginResponse.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 14/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct OAuthLoginResponse: Codable {
    public var authenticationToken : String?
    public var userDetails : UserDetails?
    public var success : Bool?
}

extension OAuthLoginResponse {
    init(json: [String: Any],success : Bool) {
        self.success = success
        self.authenticationToken = json["authentication_token"] as? String ?? ""
        if let authToken = json["authentication_token"] {
            UserDefaults.standard.set(authToken, forKey: "authentication_token")
        }
        self.userDetails = UserDetails(json: json["user"] as? Dictionary<String,Any> ?? Dictionary())
    }
}
