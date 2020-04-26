//
//  CandidateStubApi.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 04/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class CandidateStubApi {
    static var postCandidate =  [:] as [String : Any]
    static var candidateDetails = ["candidate" : [
      "availabilities" : ["2019-11-12T10:00:00.000Z",
        "2019-11-13T04:30:00.000Z",
        "2019-11-13T05:00:00.000Z",
        "2019-11-13T05:30:00.000Z"],
      "contact" : "+12015552639","created_at" : "2019-11-11T11:24:13.000Z",
      "email" : "kkk@gmail.com","feedback_due_by" : "2019-11-11T22:30:00.000Z","full_name" : "kkk",
        "interviews" :[ [
            "interviewers" :  [
                "Raghavendra Radhakrishna",
                "Sameena Eteki"
            ],
            "interviewers_count" : 2,
            "start_time" : "2020-12-19T18:15:00.000Z",
            "status" : "Waiting on Interviewer",
        ],[
            "interviewers" :  [],
            "interviewers_count" : 2,
            "start_time" : "<null>",
            "status" : "Completed",
        ],[
            "interviewers" :  [],
            "interviewers_count" : 2,
            "status" : "Completed",
        ]],
        "interviews_count" : 1,"job_status" : "Active","job_title" : "vv","owner_name" : "Ajay ",
        "profile_pics" :     [
            "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
            "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
        ],
        "resume" : "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3376/resumes/EV Web-Mobile App_BRD1_1.7V_17.10.2019.pdf",
        "status" : "Withdrawn", "withdraw_reason" : "Dfg.   ",
    ],"success" : true,"total_count" : 0] as? [String : Any]
    static var getCandidatesExistence = [:] as [String : Any]
    static var getCandidatesresponse = [:] as [String : Any]
    static var getCandidatesOwners = [:] as [String : Any]
    static var withDrawnCandidate = ["message" : ["Candidate has been withdrawn"], "success" : true] as [String : Any]
    static var getOwners = ["recruiters" : [["full_name": "anusha", "id" : 3968] , ["full_name": "anusha", "id" : 3968]]] as [String : Any]
    static var candidateAvailibility = ["success": 1, "candidate": [
        "feedback_due_by" : "2019-12-25T10:00:00.000Z",
        "full_name" : "Consectetur consequa Explicabo Harum max",
        "id" : 19697,
        "job_due_at" : "2019-12-26",
        "time_slots" : [
            "2019-12-09T08:00:00.000Z",
            "2019-12-10T08:00:00.000Z"
        ],
        "time_zone" : "Europe/Nicosia"
    ]] as [String : Any]
    static var updateAvailibility = ["candidate_status": "Waiting for Interviewer", "success": 1, "message": ["Availability updated successfully."]] as [String : Any]
    static var getReportViewDetails = [:] as [String : Any]
    static var getInterviewerRatingDetails = [:] as [String : Any]
    static var postInterviewerRating = [:] as [String : Any]
    static var getCancellationReason = [:] as [String : Any]
}

extension CandidateStubApi : CandidatesAPIProtocol {
    public static func getInterviewVideos(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCancellationReason,nil)
    }
    
    public static func getCancellationReason(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCancellationReason,nil)
    }
    
    public static func getViewInterviewerRating(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getInterviewerRatingDetails,nil)
    }
    
    public static func postInterviewerRating(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(postInterviewerRating,nil)
    }
    
    public static func cancelInterview(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCancellationReason,nil)
    }
    
    public static func cancelInterviewReason(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCancellationReason,nil)
    }
    
    public static func getReportViewDetails(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getReportViewDetails,nil)
    }
    
    public static func revertReport(candidateManger: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCancellationReason,nil)
    }
    
    public static func getCandidateAvailability(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(candidateAvailibility,nil)
    }
    
    public static func updateCandidateAvailability(candidateManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(updateAvailibility,nil)
    }
    
    public static func withdrawCandidate(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(withDrawnCandidate,nil)
    }
    
    public static func getCandidateROIDetails(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCandidatesresponse,nil)
    }
    
    public static func postCandidateROIDetails(candidateManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCandidatesresponse,nil)
    }
    
    public static func getCandidates(manager candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCandidatesresponse,nil)
    }
    
    public static func getOwners(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getOwners,nil)
    }
    
    public static func getCandidateDetails(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCandidatesresponse,nil)
    }
    
    public static func postCandidate(candidateManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(postCandidate,nil)
    }
    
    public static func getCandidateExistance(candidatesManager: CandidatesManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getCandidatesExistence,nil)
    }
    

}
