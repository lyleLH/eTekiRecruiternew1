//
//  ContributorsStubApi.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 18/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class ContributorsStubApi {
    static var getContributors =  [:] as [String : Any]
    static var saveDefaultSettings = ["message": ["Permissions Successfully Updated"], "success": true] as [String : Any]
}

extension ContributorsStubApi : ContributorSettingsAPIProtocol {
    static func getContributorSettings(jobID: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getContributors,nil)
    }
    
    static func getCompanyRecruiters(jobID: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getContributors,nil)
    }
    
    static func saveContributorSettings(jobManager: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(getContributors,nil)
    }
    
    static func saveDefaultSettings(jobManager: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        completion(saveDefaultSettings,nil)
    }
    

}
