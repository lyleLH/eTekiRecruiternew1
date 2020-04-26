//
//  FaceBookSignInResponse.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 14/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public struct SocialSignInResponse: Codable {
    public var accessToken : String?
    public var success : Bool?
    public var uID : String?
    public var provider : String?
    public var emailID : String?
    public var user : String?
}

extension SocialSignInResponse {
    init(json: [String: Any],success : Bool) {
        self.success = success

        if let token = AccessToken.current?.tokenString {
            let userDefult = UserDefaults.standard
            userDefult.setValue(token, forKey: "access_tocken")
            userDefult.synchronize()
            self.accessToken = token
        }
        if let user : String = json["name"] as? String {
            print("user: \(user)")
            self.user = user
        }
        if let id : String = json["id"] as? String {
            print("id: \(id)")
            self.uID = id
        }
        if let email : String = json["email"] as? String {
            print("email: \(email)")
            self.emailID = email
        }
    }
}
