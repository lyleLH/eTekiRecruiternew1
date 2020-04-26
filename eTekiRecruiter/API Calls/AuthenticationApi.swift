//
//  AuthenticationApi.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol AuthenticationAPIProtocol {
    static func login(credentials: CredentialsManager, completion: @escaping ((_ data: SignInResponse?,_ error: ErrorResponse?) -> Void))
    static func OAthLogin(credentials: SocialSignInResponse, completion: @escaping ((_ data: OAuthLoginResponse?,_ error: ErrorResponse?) -> Void))
    static func forgotPassword(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void))
    static func resendConfirmation(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void))
    static func logout(credentials: CredentialsManager, completion: @escaping ((_ data: SignInResponse?,_ error: ErrorResponse?) -> Void))
}

class AuthenticationApi : AuthenticationAPIProtocol {
    
    static func logout(credentials: CredentialsManager, completion: @escaping ((SignInResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.signOut
        let basePath =  serverURL+ServerAttributes.basePath + path
        
        let parameters: [String: String] = ["token" : credentials.accessToken ?? ""]
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let signInResponse = SignInResponse(json: response, success: true)
                    completion(signInResponse,nil)
                }
            }
        }
        
    }
    
    
    static func OAthLogin(credentials: SocialSignInResponse, completion: @escaping ((OAuthLoginResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.oath
        let basePath =  serverURL+ServerAttributes.basePath + path
        
        let parameters: [String: String] = ["email" : credentials.emailID ?? "","provider" : credentials.provider ?? "","token" : credentials.accessToken ?? ""]
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let user  =  response["user"] as? Dictionary<String,Any> ?? Dictionary()
                    let isProfileCompleted = user["profile_created"] as? Bool ?? false
                    let role = user["role"] as? String ?? ""
                    let success = response["success"] as? Bool ?? false
                    
                    if role == ServerAttributes.interviewer {
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: .unSupportedInterviewerRole, tittle: .incompleteProfile)
                        completion(nil,errorResponse)
                        
                    } else if role == ServerAttributes.isCandidate {
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: .unSupportedCandidateRole, tittle: .incompleteProfile)
                        completion(nil,errorResponse)
                        
                    } else if role == ServerAttributes.isSuperAdmin {
                                           let errorResponse = ErrorResponse(responseCode: success.intValue, message: .appOnlyForRecruiters, tittle: "")
                                           completion(nil,errorResponse)
                   } else {
                        
                        if isProfileCompleted {
                            let oauthLoginResponse : OAuthLoginResponse = OAuthLoginResponse(json: response,success: success)
                            completion(oauthLoginResponse,nil)
                        } else {
                            let errorResponse = ErrorResponse(responseCode: success.intValue, message: .incompleteProfileDesc, tittle: .incompleteProfile)
                            completion(nil,errorResponse)
                        }
                    }
                }
            }
        }
        
        /*
         
         guard var request = RequestBuilder.shared.postRequestURL(inputString: basePath, method: "POST") else {return}
         
         guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
         return
         }
         request.httpBody = httpBody
         
         guard let configuredSession = RequestBuilder.shared.getSession() else {return}
         
         configuredSession.dataTask(with: request) { (data, response, error) in
         
         if error != nil {
         if error?.code == APIRequestError.domainErrorCode {
         let errorResponse = ErrorResponse(responseCode: false.intValue, message: "Unable to reach server, Please check your Network/VPN Settings.", tittle: "")
         completion(nil,errorResponse)
         return
         }
         }
         
         if let data = data {
         do {
         let json = try JSONSerialization.jsonObject(with: data, options: [])
         //print(json)
         if let dictFromJSON = json as? [String:Any] {
         print(dictFromJSON)
         let success = dictFromJSON["success"] as? Bool ?? false
         
         if success {
         let user  =  dictFromJSON["user"] as? Dictionary<String,Any> ?? Dictionary()
         let isProfileCompleted = user["profile_created"] as? Bool ?? false
         
         let role = user["role"] as? String ?? ""
         
         if role == ServerAttributes.interviewer {
         let errorResponse = ErrorResponse(responseCode: success.intValue, message: .unSupportedInterviewerRole, tittle: .incompleteProfile)
         completion(nil,errorResponse)
         } else if role == ServerAttributes.candidate {
         let errorResponse = ErrorResponse(responseCode: success.intValue, message: .unSupportedCandidateRole, tittle: .incompleteProfile)
         completion(nil,errorResponse)
         
         } else {
         
         if isProfileCompleted {
         let oauthLoginResponse : OAuthLoginResponse = OAuthLoginResponse(json: dictFromJSON,success: success)
         completion(oauthLoginResponse,nil)
         } else {
         let errorResponse = ErrorResponse(responseCode: success.intValue, message: .incompleteProfileDesc, tittle: .incompleteProfile)
         completion(nil,errorResponse)
         }
         
         }
         
         } else {
         let failureMessage = dictFromJSON["message"] as? [String] ?? [.unkownServerError]
         let errorResponse = ErrorResponse(responseCode: success.intValue, message: failureMessage[0], tittle: "")
         completion(nil,errorResponse)
         }
         }
         
         } catch {
         print(error)
         let errorResponse = ErrorResponse(responseCode: false.intValue, message: .unkownServerError, tittle: "")
         completion(nil,errorResponse)
         }
         }
         }.resume() */
    }
    
    static func login(credentials: CredentialsManager, completion: @escaping ((SignInResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.signIn
        let basePath =  serverURL+ServerAttributes.basePath + path
        
        
        let parameters: [String: String] = ["email" : credentials.username ?? "","password" : credentials.password ?? ""]
        
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let user  =  response["user"] as? Dictionary<String,Any> ?? Dictionary()
                    let isProfileCompleted = user["profile_created"] as? Bool ?? false
                    
                    let role = user["role"] as? String ?? ""
                    let success = response["success"] as? Bool ?? false
                    
                    
                    if role == ServerAttributes.interviewer {
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: .unSupportedInterviewerRole, tittle: .incompleteProfile)
                        completion(nil,errorResponse)
                        
                    }  else if role == ServerAttributes.isCandidate {
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: .unSupportedCandidateRole, tittle: .incompleteProfile)
                        completion(nil,errorResponse)
                        
                    } else if role == ServerAttributes.isSuperAdmin {
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: .appOnlyForRecruiters, tittle: "")
                        completion(nil,errorResponse)
                        
                    } else {
                        
                        if isProfileCompleted {
                            let signInResponse : SignInResponse = SignInResponse(json: response,success: success)
                            completion(signInResponse,nil)
                        } else {
                            let errorResponse = ErrorResponse(responseCode: success.intValue, message: .incompleteProfileDesc, tittle: .incompleteProfile)
                            completion(nil,errorResponse)
                        }
                    }
                    
                }
            }
        }
    }
    
    static func forgotPassword(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.forgotPassword
        let basePath =  serverURL+ServerAttributes.basePath + path
        
        
        let parameters: [String: String] = ["email" : credentials.username ?? "","app_role" : ServerAttributes.recruiter]
        
        print("===========parameters===========\(parameters)================")
        
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let success = response["success"] as? Bool ?? false
                    if success {
                        let forgotPasswordResponse : ForgotPasswordResponse = ForgotPasswordResponse(json: response,success: success)
                        completion(forgotPasswordResponse,nil)
                    } else {
                        let failureMessage = response["message"] as? [String] ?? [.unkownServerError]
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: failureMessage[0], tittle: "")
                        completion(nil,errorResponse)
                    }
                }
            }
        }
        
    }
    
    static func resendConfirmation(credentials: CredentialsManager, completion: @escaping ((ForgotPasswordResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.resendConfirmation
        let basePath =  serverURL+ServerAttributes.basePath + path
        
        let parameters: [String: String] = ["email" : credentials.username ?? "","app_role" : ServerAttributes.recruiter]
        
        print("====================\(parameters)====================")
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                if let response = response {
                    let success = response["success"] as? Bool ?? false
                    if success {
                        let forgotPasswordResponse : ForgotPasswordResponse = ForgotPasswordResponse(json: response,success: success)
                        completion(forgotPasswordResponse,nil)
                    } else {
                        let failureMessage = response["message"] as? [String] ?? [.unkownServerError]
                        let errorResponse = ErrorResponse(responseCode: success.intValue, message: failureMessage[0], tittle: "")
                        completion(nil,errorResponse)
                    }
                }
            }
        }
    }
    
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

class RequestBuilder {
    static let shared = RequestBuilder()
    private init(){}
    
    func postRequestURL(inputString : String,method : String) -> URLRequest? {
        
        print("=================== SERVER URL===========\(inputString)")
        
        guard let serviceUrl = URL(string: inputString) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("iOS", forHTTPHeaderField: DeviceDetails.deviceType)
        request.setValue(DeviceDetails.deviceUUID, forHTTPHeaderField: DeviceDetails.deviceID)
        request.setValue("", forHTTPHeaderField: DeviceDetails.deviceToken)
        
        
        let token = UserDefaults.standard.value(forKey: "authentication_token") as? String ?? ""
        print("=============token \(token)=============")
        request.setValue(token, forHTTPHeaderField: "authentication-token")
        
        return request
    }
    
    func getRequestURLWithoutParams(inputString : String, method : String) -> URLRequest? {
        print("=================== SERVER URL===========\(inputString)")
        
        guard let serviceUrl = URL(string: inputString) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("iOS", forHTTPHeaderField: DeviceDetails.deviceType)
        request.setValue(DeviceDetails.deviceUUID, forHTTPHeaderField: DeviceDetails.deviceID)
        request.setValue("", forHTTPHeaderField: DeviceDetails.deviceToken)
        
        
        let token = UserDefaults.standard.value(forKey: "authentication_token") as? String ?? ""
        print("=============token \(token)=============")
        request.setValue(token, forHTTPHeaderField: "authentication-token")
        
        return request
    }
    
    func getRequestURL(inputString : String,method : String,parameters : Dictionary<String,String>) -> URLRequest? {
        
        var components = URLComponents(string: inputString)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let requestUrl = components.url else {return nil}
        
        print("====================\(requestUrl.absoluteString)=============")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("iOS", forHTTPHeaderField: DeviceDetails.deviceType)
        request.setValue(DeviceDetails.deviceUUID, forHTTPHeaderField: DeviceDetails.deviceID)
        request.setValue("", forHTTPHeaderField: DeviceDetails.deviceToken)
        //authentication-token
        print(DeviceDetails.deviceUUID)
        let token = UserDefaults.standard.value(forKey: "authentication_token") as? String ?? ""
        print("=============token \(token)=============")
        request.setValue(token, forHTTPHeaderField: "authentication-token")
        return request
    }
    
    func getRequestURLWithBody(inputString : String,method : String,parameters : Dictionary<String,Any>) -> URLRequest? {
        
        var postUrl = URL(string: inputString)!
        for (key,value) in parameters {
            if let valueString = value as? String {
                postUrl = postUrl.appending(key, value: valueString)
            }
            if let valueArray = value as? Array<String> {
                for valueString in valueArray {
                    let newKey = "\(key)\([])"
                    postUrl = postUrl.appending(newKey, value: valueString)
                }
            }
            
            if let valueArray = value as? Array<Dictionary<String,Array<String>>> {
                for valueString in valueArray {
                    for val in valueString {
                        for v in val.value {
                            let newKey = "\(val.key)\([])"
                            print(newKey)
                            print(v)
                           postUrl = postUrl.appending(newKey, value: v)
                        }
                    }
                    
                }
            }
        }
        
        guard let serviceUrl = URL(string: postUrl.absoluteString) else { return nil }
        
        print("=====serviceUrl=======\(serviceUrl)")
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = method
        
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("iOS", forHTTPHeaderField: DeviceDetails.deviceType)
        request.setValue(DeviceDetails.deviceUUID, forHTTPHeaderField: DeviceDetails.deviceID)
        request.setValue("", forHTTPHeaderField: DeviceDetails.deviceToken)
        
        
        let token = UserDefaults.standard.value(forKey: "authentication_token") as? String ?? ""
        request.setValue(token, forHTTPHeaderField: "authentication-token")
        return request
    }
    
    func getSession() -> URLSession? {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(20)
        configuration.timeoutIntervalForResource = TimeInterval(20)
        if #available(iOS 11, *) {
            configuration.waitsForConnectivity = false
        }
        let session = URLSession(configuration: configuration)
        return session
    }
    
    func parsePostDictionary(postBody : Dictionary<String,Any>) -> Dictionary<String,String> {
        
        var postDict = [String : String]()
        for (key,value) in postBody {
            print(key)
            if let valueString = value as? String {
                postDict[key] = valueString
            }
            
            
            if let valueArray = value as? Array<String> {
                
                for valueString in valueArray {
                    if let index = valueArray.firstIndex(of: valueString) {
                        let newkey = "\(key)\([index])"
                        print(newkey)
                        postDict[newkey] = valueString
                    }
                    
                }
            }
        }
        return postDict
        
    }
    
    func queryItems(dictionary: [String:Any]) -> String {
        var components = URLComponents()
        print(components.url!)
        components.queryItems = dictionary.map {
            URLQueryItem(name: $0, value: String(describing: $1))
        }
        return (components.url?.absoluteString)!
    }
    
}

extension RequestBuilder {
    
    func httpGetRequest(basePath : String, parameters : Dictionary<String,Any> ,completionHandler: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        //BaseViewModel.shared.setUpReachabilty()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//            if !BaseViewModel.shared.isNetworkAvailable {
//                      let errorResponse = ErrorResponse(responseCode: false.intValue, message: .checkYourNetwork, tittle: .checkYourNetwork)
//                BaseViewModel.shared.reachabiltyHandler.stopNotifier()
//                      completionHandler(nil,errorResponse)
//            }
//        })
        
        guard let request = RequestBuilder.shared.getRequestURLWithBody(inputString: basePath, method: "GET", parameters: parameters) else {return}
        
        
        guard let configuredSession = RequestBuilder.shared.getSession() else {return}
        
        configuredSession.dataTask(with: request) { (data, response, error) in
            if error != nil {
                if error?.code == APIRequestError.domainErrorCode {
                    let errorResponse = ErrorResponse(responseCode: false.intValue, message: "Unable to reach server, Please check your Network/VPN Settings.", tittle: "")
                    completionHandler(nil,errorResponse)
                    return
                }
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictFromJSON = json as? [String:Any] {
                        let success = dictFromJSON["success"] as? Bool ?? false
                        print("============APi response=============")
                        
                        print(dictFromJSON)
                        
                        if success {
                            completionHandler(dictFromJSON,nil)
                        } else {
                            let failureMessage = dictFromJSON["message"] as? [String] ?? [.unkownServerError]
                            let errorResponse = ErrorResponse(responseCode: success.intValue, message: failureMessage[0], tittle: "")
                            completionHandler(nil,errorResponse)
                        }
                    }
                } catch {
                    let errorResponse = ErrorResponse(responseCode: false.intValue, message: .unkownServerError, tittle: "")
                    completionHandler(nil,errorResponse)
                }
            }
        }.resume()
    }
    
    func httpPostRequest(basePath : String, parameters : Dictionary<String,Any>,method : String,completionHandler: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
//        BaseViewModel.shared.setUpReachabilty()
//        
//          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//              
//              if !BaseViewModel.shared.isNetworkAvailable {
//                        let errorResponse = ErrorResponse(responseCode: false.intValue, message: .checkYourNetwork, tittle: .checkYourNetwork)
//                   completionHandler(nil,errorResponse)
//              }
//          })
//          
        guard var request = RequestBuilder.shared.postRequestURL(inputString: basePath, method: method) else {return}
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        guard let configuredSession = RequestBuilder.shared.getSession() else {return}
        
        configuredSession.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: error?.localizedDescription ?? "Unable to reach server, Please check your Network/VPN Settings.", tittle: "")
                completionHandler(nil,errorResponse)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                    if let dictFromJSON = json as? [String:Any] {
                        print(dictFromJSON)
                        let success = dictFromJSON["success"] as? Bool ?? false
                        
                        if success {
                            completionHandler(dictFromJSON,nil)
                        } else {
                            let failureMessage = dictFromJSON["message"] as? [String] ?? [.unkownServerError]
                            let errorResponse = ErrorResponse(responseCode: success.intValue, message: failureMessage[0], tittle: "")
                            completionHandler(nil,errorResponse)
                        }
                    }
                } catch {
                    print(error)
                    let errorResponse = ErrorResponse(responseCode: false.intValue, message: .unkownServerError, tittle: "")
                    completionHandler(nil,errorResponse)
                }
            }
        }.resume()
    }
    
    func resetToSignInOnTokenExpire() {
        UserDefaults.standard.set("", forKey: "authentication_token")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        signInViewController?.showBanner(title: "", withMessage: "Session Expired", style: .warning)
        UIApplication.shared.keyWindow?.rootViewController = signInViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
}

extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
    }
}
