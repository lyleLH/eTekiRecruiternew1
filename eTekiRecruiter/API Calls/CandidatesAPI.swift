//
//  CandidatesAPI.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 23/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol CandidatesAPIProtocol {
    static func getCandidates(manager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getOwners(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getCandidateDetails(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func postCandidate(candidateManager : CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getCandidateExistance(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func withdrawCandidate(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getCandidateROIDetails(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func postCandidateROIDetails(candidateManager : CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getCandidateAvailability(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func updateCandidateAvailability(candidateManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getCancellationReason(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getViewInterviewerRating(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func postInterviewerRating(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func cancelInterview(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func cancelInterviewReason(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getReportViewDetails(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func revertReport(candidateManger: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getInterviewVideos(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void))
}

class CandidatesAPI : CandidatesAPIProtocol {
    
    static func revertReport(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
         let path = ServerAttributes.comments + ServerAttributes.createComment
        
        let basePath =  serverURL + path
        let params = ["interview_report_id": candidateManger?.interviewReportId ?? "", "content": candidateManger?.content ?? "", "revert": candidateManger?.revertStatus ?? false] as [String : Any]
        
        print(params)
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: params, method: APIMethods.post) { (response, error) in
             completion(response,error)
         }
    }
    
    static func getReportViewDetails(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
         let path = ServerAttributes.interviewsPath + ServerAttributes.reportView
        
        let basePath =  serverURL + path
        let params = ["interview_code": candidateManger?.interviewCode ?? ""] as [String : Any]
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: params) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getInterviewVideos(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
         let path = ServerAttributes.interviewsPath + ServerAttributes.inteviewVideos
        
        let basePath =  serverURL + path
        let params = ["interview_code": candidateManger?.interviewCode ?? ""] as [String : Any]
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: params) { (response, error) in
            completion(response,error)
        }
    }
    
    static func cancelInterviewReason(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
         let path = ServerAttributes.interviewsPath + ServerAttributes.cancel
        
         let basePath =  serverURL + path
        let params = ["interview_id": candidateManger?.interviewID ?? "", "reason": candidateManger?.cancellationReason ?? ""] as [String : Any]
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: params, method: APIMethods.post) { (response, error) in
             completion(response,error)
         }
    }
    
    static func cancelInterview(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
         let path = ServerAttributes.interviewsPath + ServerAttributes.cancellationDetails
        
         let basePath =  serverURL + path
        let params = ["interview_id": candidateManger?.interviewID ?? ""] as [String : Any]
         RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: params) { (response, error) in
             completion(response,error)
         }
    }
    
    static func postInterviewerRating(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
         let serverURL = Environments().configuration(PlistKey.ServerURL)
         let path = ServerAttributes.interviewsPath + ServerAttributes.rateInterviewer
        
         let basePath =  serverURL + path
        let params = ["rating": candidateManger?.rating ?? "", "title": candidateManger?.title ?? "", "note": candidateManger?.note ?? "", "interview_member_id": candidateManger?.interviewMemberId ?? ""] as [String : Any]
         RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: params, method: APIMethods.post) { (response, error) in
             completion(response,error)
         }
    }
    
    static func getViewInterviewerRating(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getInterviewerRatingDetails

        let basePath =  serverURL + path
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: ["interview_id": candidateManger?.interviewID ?? ""]) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getCancellationReason(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.interviewsPath

        let basePath =  serverURL + path + ServerAttributes.getCanccellationReason
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: ["interview_id": candidateManger?.interviewID ?? ""]) { (response, error) in
            completion(response,error)
        }
    }

    static func updateCandidateAvailability(candidateManager : CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.candidates

        let basePath =  serverURL + path + "/" + (candidateManager?.candidateID ?? "") + ServerAttributes.candidateAvailabilties
        var parameters: [String: Any] = ["candidate_id" : candidateManager?.candidateID ?? "","job_id": candidateManager?.jobID ?? "" ,"currentTimezone" : candidateManager?.timeZone ?? "","preferred_interview_time" : candidateManager?.preferredInterviewTime ?? "","time_slots" : candidateManager?.timeSlots ?? []]
        
        print("=============Before empty=============\(parameters)")
        
        for (key,value) in parameters {
            if let str = value as? String {
                if str == "" {
                    parameters[key] = nil
                }
            }
        }
        
        print("=============After empty=============\(parameters)")
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getCandidateAvailability(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.candidates
        let basePath =  serverURL + path + "/" + (candidatesManager?.candidateID ?? "") + ServerAttributes.candidateAvailabilties
       //let parameters: [String: Any] = ["candidate_id" : candidatesManager?.candidateID ?? ""]
        

       // print(parameters)
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: [:]) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func withdrawCandidate(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.candidate
        let basePath =  serverURL + path + ServerAttributes.withdrawCandidate
        let parameters: [String: Any] = ["withdraw_reason" : candidatesManager?.withdrawReason ?? "" , "candidate_id" : candidatesManager?.candidateID ?? "", "withdraw_status": candidatesManager?.withdrawStatus ?? ""]
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response , errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    
    static func postCandidateROIDetails(candidateManager : CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.candidatesBaseBath
        
        let basePath =  serverURL + path + ServerAttributes.updateROIStatus
        
        var parameters: [String: Any] = ["candidate_id" : candidateManager?.candidateID ?? "","analytic_status": candidateManager?.analyticStatus ?? "" ,"is_final" : candidateManager?.analyticfinalStatus ?? false,"proxied" : candidateManager?.candidateProxied ?? false]
        
        print("=============Before empty=============\(parameters)")
        
        for (key,value) in parameters {
            if let str = value as? String {
                if str == "" {
                    parameters[key] = nil
                }
            }
        }
        
        print("=============After empty=============\(parameters)")
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getCandidateROIDetails(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getROIStatus
        let basePath =  serverURL + path
        let parameters: [String: Any] = ["candidate_id" : candidatesManager?.candidateID ?? ""]
        print(parameters)
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
    }
    
    static func getCandidateExistance(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        let basePath =  serverURL + path + ServerAttributes.getCandidateExistance
        
        let parameters: [String: Any] = ["email" : candidatesManager?.email ?? "","job_id" : candidatesManager?.jobID ?? ""]
        print(parameters)
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, errorResponse) in
            completion(response,errorResponse)
        }
        
    }

    static func postCandidate(candidateManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        
        let path = ServerAttributes.addCandidate
        let requestType = candidateManager?.requestType ?? ""
        var basePath =  serverURL + path

        if requestType == .editCandidate {
            basePath += ServerAttributes.updateCandidate
        }

        guard let ownerID = candidateManager?.ownerId else {return}
        guard let ownerFullName = candidateManager?.ownerFullName else {return}
        
        print(ownerID)
        
        var candidate : [String: Any] = ["id" : candidateManager?.candidateID ?? "","first_name": candidateManager?.firstName ?? "","last_name" : candidateManager?.lastName ?? "", "email" : candidateManager?.email ?? "","phone" : candidateManager?.phone ?? "","resume" : candidateManager?.resumeURL ?? "" ,"preferred_interview_time": candidateManager?.preferredInterviewTime ?? "","time_zone":candidateManager?.timeZone ?? "","sms_opt_in" : candidateManager?.smsOPT ?? false,"owner" : ["id":ownerID,"full_name" : ownerFullName],"area_code" : candidateManager?.areaCode ?? "","country_code" : candidateManager?.countryCode ?? "","owner_id" : candidateManager?.ownerId ?? "","job_due_date":candidateManager?.jobDueDate ?? ""]
        
        for (key,value) in candidate {
            if let str = value as? String {
                if str == "" {
                    candidate[key] = nil
                }
            }
        }
        
        var parameters: [String: Any] = ["job_id" : candidateManager?.jobID ?? "","candidate": candidate]
        
        print("=============Before empty=============\(parameters)")
        
        for (key,value) in parameters {
            if let str = value as? String {
                if str == "" {
                    parameters[key] = nil
                }
            }
        }
        
        print("=============After empty=============\(parameters)")
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, error) in
            completion(response,error)
        }
        
    }

    static func getOwners(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getOwners
        let basePath =  serverURL + path
        
        let parameters: [String: Any] = ["job_id" : candidatesManager?.jobID ?? ""]
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getCandidates(manager : CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let basePath =  serverURL + ServerAttributes.getJobCandidates
        var statusKey = manager?.statusKey ?? ""
        if manager?.statusKey == "" {
            statusKey = "status"
        }
        
        var parameters: [String: Any] = ["job_id" : manager?.jobID ?? "",statusKey: manager?.status ?? "","keyword": manager?.searchKeyWord ?? "","per_page" : manager?.perPage ?? "","page": manager?.page ?? ""]
        
        for (key,value) in parameters {
            if let str = value as? String {
                if str == "" {
                    parameters[key] = nil
                }
            }
        }
        
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getCandidateDetails(candidatesManager: CandidatesManager?, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let basePath =  serverURL + ServerAttributes.getCandidates + "/" + (candidatesManager?.candidateID ?? "")
        
        // let parameters: [String: Any] = ["candidate_id" : candidatesManager?.candidateID ?? ""]
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: [:]) { (response, error) in
            completion(response,error)
        }
    }
}
