//
//  ProfileAuthenticationApi.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class ProfileAuthenticationApi {
    
    static var resetPasscodeResponse = ProfileResponse.stubResponse(json: ["user": ["profile_created":0]], code: true, message: "xxcv")
    static var getProfileResponse = ProfileResponse.stubResponse(json: ["user": ["profile_created":0]], code: true, message: "true")
    static var updatePrimaryResponse = ProfileResponse.stubResponse(json: [:], code: true, message: "Primary")
    static var updateCompanyResponse = ProfileResponse.stubResponse(json: [:], code: true, message: "Company")
    static var resendOtp = ProfileResponse.stubResponse(json: ["otp_required": "true"], code: true, message:"200")
    static var verifyOtp = ProfileResponse.stubResponse(json: ["otp_required":"true"], code: true, message: "200")
}

extension ProfileAuthenticationApi : ProfileAPIProtocol {
    public static func sendOTP(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(verifyOtp,nil)
    }
    
    public static func resendOTP(completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(resendOtp,nil)
    }
    
    public static func getProfileDetails(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(getProfileResponse,nil)
    }
    
    public static func updatePassword(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(resetPasscodeResponse,nil)
    }
    
    public static func updateCompanyDetails(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(updateCompanyResponse,nil)
    }
    
    public static func updatePrimaryProfile(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(updatePrimaryResponse,nil)
    }
    
    public static func updateAddress(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(resetPasscodeResponse,nil)
    }
    
    public static func updateSMSSettings(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(resetPasscodeResponse,nil)
    }
    
    public static func resetPasscode(completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        completion(resetPasscodeResponse,nil)
    }
    
    
    
}
