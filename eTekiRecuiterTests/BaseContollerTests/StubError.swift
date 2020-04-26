//
//  StubError.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public enum StubError: Error {
    case invalidUserName
    case incompleteProfile
    case invalidPassword
    case authenticationFailed
    case misssingRequiredField(String, String)
    case unknown(String)
}


public extension StubError {
    
    var code: Int {
        switch self {
        case .invalidUserName:
            return CannedDataConstant.httpBadRequestCode
        case .invalidPassword:
            return CannedDataConstant.httpBadRequestCode
        case .authenticationFailed:
            return CannedDataConstant.httpAuthenticationFailedCode
        case .misssingRequiredField:
            return CannedDataConstant.httpBadRequestCode
        case .unknown:
            return ErrorResponse.UnknownError
        case .incompleteProfile:
            return CannedDataConstant.failureCode
        }
    }
    

}


extension StubError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidUserName:
            return NSLocalizedString(CannedDataConstant.usernameInvalid, comment: "")
        case .invalidPassword:
            return NSLocalizedString(CannedDataConstant.passwordInvalid, comment: "")
        case .authenticationFailed:
            return NSLocalizedString(CannedDataConstant.loginFailedMessage, comment: "")
        case .misssingRequiredField(let fieldName, let apiName):
            let description = String(format: CannedDataConstant.missingRequiredField, fieldName, apiName)
            return NSLocalizedString(description, comment: "")
        case .incompleteProfile:
            return NSLocalizedString(CannedDataConstant.incompleteProfile, comment: "")
        case .unknown(let description):
            return NSLocalizedString(description, comment: "")
        }
    }
}
