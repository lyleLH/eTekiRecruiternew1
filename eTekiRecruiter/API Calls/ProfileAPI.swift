//
//  ProfileAPI.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol ProfileAPIProtocol {
    static func getProfileDetails(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func updatePassword(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func updateCompanyDetails(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func updatePrimaryProfile(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func updateAddress(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func updateSMSSettings(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func sendOTP(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func resendOTP(completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
    static func resetPasscode(completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void))
}

class ProfileAPI : ProfileAPIProtocol {
    
    static func getProfileDetails(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getProfileDetails
        let basePath =  serverURL+ServerAttributes.profileBasePath + path
        let parameters: [String: Any] = ["type" : profileManager.type ?? ""]
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let successMessage = response["message"] as? [String] ?? [""]
                    let profileResponse : ProfileResponse = ProfileResponse(json: response,success: true,message: successMessage[0])
                    completion(profileResponse,nil)
                }
            }
        }
        
    }
    
    static func updatePassword(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.changePassword
        let basePath =  serverURL+ServerAttributes.basePath + path
        let parameters: [String: String] = ["current_password" : profileManager.currentPassword ?? "","new_password" : profileManager.newPassword ?? "" , "re_password" : profileManager.confirmPassword ?? ""]
        
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func updatePrimaryProfile(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.updatePrimaryProfile
        let basePath =  serverURL+ServerAttributes.profileBasePath + path
        
        let parameters: [String: Any] = ["social_links" : profileManager.socialLinks ?? [:]]
        print(parameters)
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
        
    }
    
    static func resetPasscode(completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.resetPasscode
        let basePath =  serverURL+ServerAttributes.profileBasePath + path
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: [:]) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func updateCompanyDetails(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.updateCompanyDetails
        let basePath =  serverURL+ServerAttributes.profileBasePath + path
        let parameters: [String: Any] = ["same_address_as_billing_address" : profileManager.sameAsBillingAddress ?? []]
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func updateAddress(profileManager: ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.updateAddress
        let basePath =  serverURL+ServerAttributes.profileBasePath + path
        
        let parameters: [String: Any] = ["address" : profileManager.address ?? "","city" : profileManager.city ?? "","country" : profileManager.country ?? "","state" : profileManager.state ?? "","time_zone" : profileManager.timeZone ?? "","zip" : profileManager.zip ?? ""]
        
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
        
    }
    
    static func updateSMSSettings(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverUrl = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.updateSMS
        let basePath =  serverUrl + ServerAttributes.smsbasebath + path
        
        
        //Params: {activate_sms: true/false, sms_contact: “9988558855”, sms_country_code: “91”, sms_area_code: “in”}
        
        let parameters: [String: Any] = ["activate_sms" : profileManager.activateSMS ?? "","sms_contact" : profileManager.smsContact ?? "","sms_country_code" : profileManager.smsCountryCode ?? "","sms_area_code" : profileManager.smsAreaCode ?? ""]
        
        print("==========params==========\(parameters)")
        
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
        
    }
    
    
    static func sendOTP(profileManager : ProfileManager, completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.verifyOTP
        let basePath =  serverURL+ServerAttributes.smsbasebath + path
        
        let parameters: [String: Any] = ["otp_code" : profileManager.otp ?? ""]
        
        print("==========params==========\(parameters)")
        
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
        
    }
    
    
    static func resendOTP(completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.resendOTP
        let basePath =  serverURL+ServerAttributes.smsbasebath + path
        ProfileAPI.httpPostCallForProfileAPI(basePath: basePath, parameters: [:]) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
}

extension ProfileAPI {
    
    static func httpPostCallForProfileAPI(basePath : String, parameters : Dictionary<String,Any> ,completion: @escaping ((ProfileResponse?, ErrorResponse?) -> Void)) {
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let successMessage = response["message"] as? [String] ?? [""]
                    let profileResponse : ProfileResponse = ProfileResponse(json: response,success: true,message: successMessage[0])
                    completion(profileResponse,nil)
                }
            }
        }
    }
    
}
