//
//  JobListingAPI.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 27/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol JobListingAPIProtocol {
    static func getJobs(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getJobDetails(jobDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func reactivateJob(jobDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func closeJob(jobDetails : JobsManager, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func saveFilters(jobDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func getDefaultFilters(jobDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void))
    static func getMyInterviews(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getInterviewsWithJob(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getShareDetails(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void))
    static func addEmailToShare(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void))
    static func deleteEmailFromShare(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void))
    static func notifyRecruiter(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void))     
}

class JobListingAPI : JobListingAPIProtocol {
    
    static func closeJob(jobDetails: JobsManager, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.closeJob
        let basePath =  serverURL + path
        let parameters : [String: Any] = ["job_id": jobDetails.jobID ?? ""]

        JobListingAPI.httpPostCallForJobListingAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
                  completion(response,errorResponse)
        }
    }
    
    static func reactivateJob(jobDetails: JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.reactivate
        let basePath =  serverURL + path
        
        let parameters : [String: Any] = ["job_id": jobDetails?.jobID ?? "", "due_at": jobDetails?.due_at ?? ""]
        
        JobListingAPI.httpPostCallForJobListingAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    
    static func getJobs(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        let basePath =  serverURL + path
        
        var searchKey = ""
        var searchValue = ""
        
        var dueDates = [String]()
        
        if jobDetails.filterDueDate != "" {
            dueDates.append(jobDetails.filterDueDate ?? "")
        }
        
        print(dueDates)
        
        for (key, value) in jobDetails.searchBy ?? [:] as Dictionary<String,String> {
            print("\(key)")
            print("\(value)")
            searchKey = key
            searchValue = value
        }
        var parameters: [String: Any] = ["page" : jobDetails.page ?? "","per_page" : jobDetails.perPage ?? "","status": jobDetails.status ?? "","jobs_type": jobDetails.currentType ?? "",searchKey:searchValue,"due_date" : dueDates]
        
        if dueDates.count == 0 {
            parameters["due_date"] = nil
        }
        
        
        if searchKey == ""  || searchValue == ""{
            parameters[searchKey] = nil
        }
        
        print(parameters)
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                completion(response,nil)
            }
        }
    }
    
    static func getMyInterviews(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.myInterviews
        let basePath =  serverURL + path + ServerAttributes.getInterviews
        
        var searchKey = ""
        var searchValue = ""
        
        for (key, value) in jobDetails.searchBy ?? [:] as Dictionary<String,String> {
            print("\(key)")
            print("\(value)")
            searchKey = key
            searchValue = value
        }
        var parameters: [String: Any] = ["page" : jobDetails.page ?? "","per_page" : jobDetails.perPage ?? "","interview_type": jobDetails.currentType ?? "",searchKey:searchValue, "status_filters": jobDetails.statusFilter ?? ""]
        
        if searchKey == ""  || searchValue == ""{
            parameters[searchKey] = nil
        }
        
        print(parameters)
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                completion(response,nil)
            }
        }
    }
    
    static func getInterviewsWithJob(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.myInterviews
        let basePath =  serverURL + path + ServerAttributes.getInterviewsWithJob
        
        var searchKey = ""
        var searchValue = ""
        
        for (key, value) in jobDetails.searchBy ?? [:] as Dictionary<String,String> {
            print("\(key)")
            print("\(value)")
            searchKey = key
            searchValue = value
        }
        
        var parameters: [String: Any] = ["status_filters": jobDetails.statusFilter ?? "","interview_type": jobDetails.currentType ?? "",searchKey:searchValue,"job_id" : jobDetails.jobID ?? ""]
        
        if searchKey == ""  || searchValue == ""{
            parameters[searchKey] = nil
        }

        print("===============getInterviewsWithJob=============")
        print(parameters)
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                completion(response,nil)
            }
        }
    }
    
    
    static func getJobDetails(jobDetails jobsDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getJobDetails
        let basePath =  serverURL+ServerAttributes.jobs + path
        
        
        let parameters: [String: Any] = ["job_id": jobsDetails?.jobID ?? ""]
        
        print("===============\(parameters)=====================")
        
        JobListingAPI.httpGetRequestJobListingAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
                   completion(response,errorResponse)
        }
    }
    
    static func saveFilters(jobDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.saveFilters
        let basePath =  serverURL + ServerAttributes.recruiterBasePath + path
        
        var parameters: [String: Any] = ["tab":jobDetails?.currentTab ?? "","jobs_type[]" : jobDetails?.currentType ?? "","status[]" : jobDetails?.status ?? "","due_date[]" : jobDetails?.filterDueDate ?? ""]
        print("=========parameters===========\(parameters)")
        
        if jobDetails?.filterDueDate?.count ==  0 {
            parameters["due_date[]"] = nil
        }
        
        JobListingAPI.httpPostCallForJobListingAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func getDefaultFilters(jobDetails : JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getDefaultFilters
        let basePath =  serverURL + ServerAttributes.recruiterBasePath + path
        
        let parameters: [String: Any] = ["tab" : jobDetails?.currentTab ?? ""]
        
        JobListingAPI.httpGetRequestJobListingAPI(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func getShareDetails(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void)) {

        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getShareDetails
        let basePath =  serverURL + ServerAttributes.interviewAccess + path
        
        let parameters: [String: Any] = ["page" : jobDetails?.page ?? "","per_page" : jobDetails?.perPage ?? "", "job_id" : jobDetails?.jobID ?? ""]
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
        
    }
    
    static func addEmailToShare(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void)) {

        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.addEmailToShare
        let basePath =  serverURL + ServerAttributes.interviewAccess + path
        
        let parameters: [String: Any] = ["emails" : jobDetails?.emails ?? [], "job_id" : jobDetails?.jobID ?? ""]

        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func deleteEmailFromShare(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void)) {

        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.deleteEmailFromShare
        let basePath =  serverURL + ServerAttributes.interviewAccess + path
        
        let parameters: [String: Any] = ["email" : jobDetails?.email ?? "", "job_id" : jobDetails?.jobID ?? ""]
        
        print("===========parameters=========")
        print(parameters)

        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func notifyRecruiter(jobDetails : JobsManager?, completion: @escaping (([String: Any]?, ErrorResponse?) -> Void)) {

        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.notifyRecruiter
        let basePath =  serverURL + ServerAttributes.interviewAccess + path
        
        let parameters: [String: Any] = ["interview_code" : jobDetails?.interviewCode ?? ""]
        
        print(parameters)

        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }


}

extension JobListingAPI {
    
    static func httpGetRequestJobListingAPI(basePath : String, parameters : Dictionary<String,Any> ,completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            
            if errorResponse != nil {
                let failureMessage = errorResponse?.message ?? "Server error"
                let errorResponse = ErrorResponse(responseCode: false.intValue, message: failureMessage, tittle: "")
                completion(nil,errorResponse)
            } else {
                if let response = response {
                    let success = response["success"] as? Bool ?? false
                    let successMessage = response["message"] as? [String] ?? [""]
                    let createJobResponse : CreateJobResponse = CreateJobResponse(json: response,success: success,message: successMessage[0])
                    completion(createJobResponse,nil)
                }
            }
        }
        
        
    }
    
    static func httpPostCallForJobListingAPI(basePath : String, parameters : Dictionary<String,Any> ,completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, errorResponse) in
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

    
}



