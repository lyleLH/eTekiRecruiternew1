//
//  InterviewersStubApi.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 11/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class InterviewersStubApi {
    static var getMatchedInterviewers =  [:] as [String : Any]
    static var interviewerProfile = [:] as [String: Any]
}

extension InterviewersStubApi : InterviewsAPIProtocol {
    static func getMatchedInterviews(jobDetails: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getMatchedInterviewers,nil)
    }
    
    static func getInterviewerProfile(jobDetails: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(interviewerProfile,nil)
    }
    
   

}
