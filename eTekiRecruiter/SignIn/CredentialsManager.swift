//
//  CredentialsManager.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct CredentialsManager: Codable {
    
    public var accessToken : String?
    public var username: String?
    public var password: String?
    /** The application to which the user is authenticating */
    public var applicationId: String?
    
    public init(username: String, password: String, applicationId: String) {
        self.username = username
        self.password = password
        self.applicationId = applicationId
    }
    
    public init(accessToken : String) {
        self.accessToken = accessToken
    }
    
    
}

extension CredentialsManager: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "\nCredentialsCM"
        description += "\n\tusername: \(String(describing: username))"
        description += "\n\tpassword: \(String(describing: password))"
        description += "\n\tapplicationId: \(String(describing: applicationId))"
        return description
    }
}
