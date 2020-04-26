//
//  ErrorResponse.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation


public struct ErrorResponse: Codable {
    public static let UnknownError = -1001
    public var responseCode: Int
    public var message: String
    public var tittle : String
    
    public init(responseCode: Int, message: String, tittle : String) {
        self.responseCode = responseCode
        self.message = message
        self.tittle = tittle
    }
}

extension ErrorResponse: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "\nresponse"
        description += "\n\tresponseCode: \(String(describing: responseCode))"
        return description
    }
}
