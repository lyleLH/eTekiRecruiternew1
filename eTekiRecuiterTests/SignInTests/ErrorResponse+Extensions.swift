//
//  ErrorResponse+Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public extension ErrorResponse {
    
    static func stubInvalidUserName() -> ErrorResponse? {
        return ErrorResponse.new(StubError.invalidUserName)
    }
    
    static func stubInvalidPassword() -> ErrorResponse? {
        return ErrorResponse.new(StubError.invalidPassword)
    }
    
    static func stubAuthenticationFailed() -> ErrorResponse? {
        return ErrorResponse.new(StubError.authenticationFailed)
    }
    
    static func stubMisssingRequiredField(_ fieldName: String, apiName: String) -> ErrorResponse? {
        return ErrorResponse.new(StubError.misssingRequiredField(fieldName, apiName))
    }
    
    static func stubUnknown(_ errorDescription: String) -> ErrorResponse? {
        return ErrorResponse.new(StubError.unknown(errorDescription))
    }
    

}

fileprivate extension ErrorResponse {
    
    static func new(_ error: StubError) -> ErrorResponse? {
        return ErrorResponse(responseCode: error.code, message: "Stub Error", tittle: "Stub Error")
    }
}
