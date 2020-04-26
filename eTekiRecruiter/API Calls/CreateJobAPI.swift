//
//  CreateJobAPI.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 25/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol CreateJobAPIProtocol {
    static func getAreaOfExpertises(completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func getSkillsAutoComplete(createJobManager : CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func updateCreateJob(createJobManager : CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func suggestSkill(createJobManager : CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
}

class CreateJobAPI : CreateJobAPIProtocol {
    
    static func suggestSkill(createJobManager : CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.suggestSkills
        let basePath =  serverURL + path
        
        let parameters: [String: String] = ["skill": createJobManager?.skill ?? "", "skill_type": createJobManager?.skillType ?? ""]
        
        print("=================\(parameters)========================")
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, error) in
            if error != nil {
                completion(nil,error)
            } else {
                let successMessage = response?["message"] as? [String] ?? ["Success"]
                let createJobResponse : CreateJobResponse = CreateJobResponse(json: response ?? [:],success: true,message: successMessage[0])
                completion(createJobResponse,nil)
            }
        }
    }
    
    static func updateCreateJob(createJobManager : CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        var basePath =  serverURL + path
        
        var postMethod = ""
        
        let requestType = createJobManager?.requestType ?? ""
        
        if requestType == .editJob {
            postMethod = APIMethods.put
            basePath = basePath + "/" + (createJobManager?.jobID ?? "")
            
        } else {
            postMethod = APIMethods.post
        }
                
        let codingRequired = String(createJobManager?.codingRequired ?? false)
        let whiteBoardRequired = String(createJobManager?.whiteboradRequired ?? false)
        
        let candidateIDrequired = String(createJobManager?.idRequired ?? false)
        

        var parameters: [String: String] = ["client_company_name": createJobManager?.clientCompanyName ?? "" , "coding_required": codingRequired , "description": createJobManager?.jobDescription ?? "", "due_at" : createJobManager?.dueDate ?? "", "experience_required" : createJobManager?.experirenceRequired ?? "", "expertise_category" : createJobManager?.expertiseCategory ?? "", "id_required" : candidateIDrequired, "interview_mode" : createJobManager?.interViewMode ?? "", "interviewer_language_preference": createJobManager?.interViewLanguagePreference ?? "", "interviewer_location_preference": createJobManager?.interViewLocationPreference ?? "", "job_code" : createJobManager?.jobCode ?? "", "number_of_prospects" : createJobManager?.numberOfProspects ?? "", "preferred_skillset": createJobManager?.preferedSkillSet ?? "", "skillset": createJobManager?.skillset ?? "", "special_instructions" : createJobManager?.specialInstructions ?? "", "title" : createJobManager?.jobTitle ?? "", "whiteboard_required" : whiteBoardRequired, "company_logo" : createJobManager?.companyLogo ?? "","job_description_file": createJobManager?.jobDescriptionAwsurl ?? ""]
        
        
        if createJobManager?.companyLogo == "" {
            parameters["company_logo"] = nil
        }
        
        if createJobManager?.preferedSkillSet == "" {
            
            parameters["preferred_skillset"] = nil

        }
        
        if createJobManager?.skillset == "" {
                 parameters["skillset"] = nil
        }
        
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: postMethod) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server Error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                
                if let response = response {
                    let successMessage = response["message"] as? [String] ?? [""]
                    let createJobResponse : CreateJobResponse = CreateJobResponse(json: response,success: true,message: successMessage[0])
                    completion(createJobResponse,nil)
                }
            }
        }

    }
    
    
    
    static func getSkillsAutoComplete(createJobManager : CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)){
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.skillsAutoComplete
        let basePath =  serverURL+ServerAttributes.jobs + path
        
        let parameters: [String: Any] = ["skill": createJobManager?.skillsAutoCompleteText ?? ""]
        
        print("===============\(parameters)=====================")
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, error) in
            if error != nil {
                completion(nil,error)
            } else {
                let successMessage = response?["message"] as? String ?? "Success"
                let createJobResponse : CreateJobResponse = CreateJobResponse(json: response ?? [:],success: true,message: successMessage)
                completion(createJobResponse,nil)
            }
        }
        
    }
    
    static func getAreaOfExpertises(completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.areaOfExpertise
        let basePath =  serverURL+ServerAttributes.interViewersPath + path
        
        let parameters: [String: Any] = ["":""]
        
        print("===============\(parameters)=====================")
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, error) in
            if error != nil {
                completion(nil,error)
            } else {
                let successMessage = response?["message"] as? String ?? "Success"
                let createJobResponse : CreateJobResponse = CreateJobResponse(json: response ?? [:],success: true,message: successMessage)
                completion(createJobResponse,nil)
            }
        }
    }
    
}






