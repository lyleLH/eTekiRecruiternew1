//
//  ExceptionAuthenticationApi.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class ExceptionAuthenticationApi {
    public static var errorResponse: ErrorResponse?
}

extension ExceptionAuthenticationApi : AuthenticationAPIProtocol {
    public static func logout(credentials: CredentialsManager, completion: @escaping ((SignInResponse?, ErrorResponse?) -> Void)) {
        completion(nil, errorResponse)
    }
    

    public static func login(credentials: CredentialsManager, completion: @escaping ((SignInResponse?, ErrorResponse?) -> Void)) {
        precondition(errorResponse != nil, "errorResponse Object is Nil, so can't simulate exception.")
        completion(nil, errorResponse)
        
    }
    
    public static func OAthLogin(credentials: SocialSignInResponse, completion: @escaping ((OAuthLoginResponse?, ErrorResponse?) -> Void)) {
        completion(nil, errorResponse)
    }

    
    public static func forgotPassword(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void)) {
        completion(nil, errorResponse)
    }
    
    public static func resendConfirmation(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void)) {
        completion(nil, errorResponse)
    }
    
    
}
