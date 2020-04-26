//
//  InterviewsAPI.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 05/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

protocol InterviewsAPIProtocol {
    static func getMatchedInterviews(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getInterviewerProfile(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
}

class InterviewsAPI : InterviewsAPIProtocol {
    
    static func getMatchedInterviews(jobDetails: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        let basePath =  serverURL + path + ServerAttributes.matchedInterviews
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: ["job_id": jobDetails.jobID ?? ""]) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getInterviewerProfile(jobDetails: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let basePath =  serverURL + ServerAttributes.interViewerDetails
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: ["interviewer_id": jobDetails.interViewerID ?? ""]) { (response, error) in
            completion(response,error)
        }
    }

}
