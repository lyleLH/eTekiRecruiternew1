//  StubAuthenticationApi.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class StubAuthenticationApi {
     static var signInResponse = SignInResponse.stubResponse(json: ["user": ["profile_created":0]], code: true)
     static var faceBookSignInResponse = SocialSignInResponse(json: [:],  success: true)
     static var oAuthLoginResponse = OAuthLoginResponse(json: [:], success: true)
     static var forgotPasswordResponse = ForgotPasswordResponse(json: [:], success: true)
}

extension StubAuthenticationApi : AuthenticationAPIProtocol {
    public static func logout(credentials: CredentialsManager, completion: @escaping ((SignInResponse?, ErrorResponse?) -> Void)) {
         completion(signInResponse,nil)
    }

    public static func OAthLogin(credentials: SocialSignInResponse
        , completion: @escaping ((OAuthLoginResponse?, ErrorResponse?) -> Void)) {
        completion(oAuthLoginResponse,nil)
    }
    
    public static func forgotPassword(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void)) {
        completion(forgotPasswordResponse,nil)
    }
    
    public static func resendConfirmation(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void)) {
        completion(forgotPasswordResponse,nil)
    }
    
    public static func login(credentials: CredentialsManager, completion: @escaping ((SignInResponse?, ErrorResponse?) -> Void)) {
        print(signInResponse)
        
        completion(signInResponse,nil)
    } 

}
