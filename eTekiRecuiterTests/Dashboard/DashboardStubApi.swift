//
//  DashboardStubApi.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 16/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class DashboardStubApi {
    static var getJobsApiCall = CreateJobResponse.stubResponse(json: ["jobs": [["candidates_count" : [ "completed" : 0 ,"pending" : 0, "total" : 0], "collaborated_job" : 0, "created_at" : "2019-10-18T04:28:47.000Z", "due_at" : "2019-11-18", "expertise_category" : "Enterprise & Off Shelf Applications (ERP, CRM, SCM, PLM)", "id" : 3209, "interview_access" : 0,
        "job_permissions" : [
            "Candidate Edit" : 1 ,
            "Candidate Notify" : 1,
            "Candidate View" : 1,
            "Interview Edit" : 1,
            "Interview Notify" : 1,
            "Interview View" : 1,
            "Job Edit" : 1,
            "Job Notify" : 1,
            "Job View" : 1
        ], "matched_interviewers_count" : 0, "owner_name" : "dada", "pending_candidate_availabilities" : 0,
           "skillset" : "ISDN",
           "status" : "Active",
           "title" : "NewJob18October",
    ]]
    ], code: true, message: "Jobs are filtered")
    static var defaultfilters = CreateJobResponse.stubResponse(json: [:], code: true, message: "filters saved")
    static var reactivateJobCall = CreateJobResponse.stubResponse(json: [:], code: true, message: "job moved to active status")
    static var statusFilters = CreateJobResponse.stubResponse(json: [:], code: true, message: "Filters saved successfully")
    static var closeJobs = CreateJobResponse.stubResponse(json: [:], code: true, message: "job moved to Inactive status")
    static var getJobsCall = [:] as [String : Any]
}

extension DashboardStubApi : JobListingAPIProtocol {
    public static func getMyInterviews(jobDetails: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }
    
    public static func getInterviewsWithJob(jobDetails: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }
    
    public static func getShareDetails(jobDetails: JobsManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }
    
    public static func addEmailToShare(jobDetails: JobsManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }
    
    public static func deleteEmailFromShare(jobDetails: JobsManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }
    
    public static func notifyRecruiter(jobDetails: JobsManager?, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }
    
    public static func getJobs(jobDetails: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getJobsCall,nil)
    }

    public static func getJobDetails(jobDetails: JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
         completion(getJobsApiCall,nil)
    }

    public static func reactivateJob(jobDetails: JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
         completion(getJobsApiCall,nil)
    }

    public static func closeJob(jobDetails: JobsManager, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
         completion(getJobsApiCall,nil)
    }

    public static func saveFilters(jobDetails: JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
         completion(getJobsApiCall,nil)
    }

    public static func getDefaultFilters(jobDetails: JobsManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
          completion(getJobsApiCall,nil)
    }


}

