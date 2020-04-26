//
//  ForgotPasswordResponse.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 14/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct ForgotPasswordResponse: Codable {
    public var success : Bool?
    public var message: String?
}

extension ForgotPasswordResponse {
    init(json: [String: Any],success : Bool) {
        self.success = success
        if let resetLinkMessage = json["message"] as? [String] {
            self.message = resetLinkMessage[0]
        }
    }
}
