//
//  SignInResponseModel.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 29/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct SignInResponse: Codable {
    
    public var selfServiceEnabled: Int?
    public var accountType: String?
    public var authenticationToken : String?
    public var currentSubscription : String?
    public var userDetails : UserDetails?
    public var success : Bool
    public var message : String?


}

extension SignInResponse {
    init(json: [String: Any],success : Bool) {
        self.success = success
        let successMessage = json["message"] as? [String] ?? [.unkownServerError]
        self.message = successMessage[0]

        self.selfServiceEnabled = json["self_service_enabled"] as? Int ?? 2
        self.accountType = json["account_type"] as? String ?? ""
        self.authenticationToken = json["authentication_token"] as? String ?? ""
        if let authToken = json["authentication_token"] {
            UserDefaults.standard.set(authToken, forKey: "authentication_token")
        }
        self.currentSubscription = json["current_subscription"] as? String ?? ""
        self.userDetails = UserDetails(json: json["user"] as? Dictionary<String,Any> ?? Dictionary())
    }
}
