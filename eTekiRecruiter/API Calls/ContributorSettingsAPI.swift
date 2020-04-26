//
//  ContributorSettingsAPI.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 11/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

protocol ContributorSettingsAPIProtocol {
    static func getContributorSettings(jobID: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getCompanyRecruiters(jobID: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func saveContributorSettings(jobManager: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func saveDefaultSettings(jobManager: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void))
    
}

class ContributorSettingsAPI : ContributorSettingsAPIProtocol {

    static func getCompanyRecruiters(jobID: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        let basePath =  serverURL + path + ServerAttributes.getCompanyRecruiters
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: ["job_id": jobID.jobID ?? ""]) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getContributorSettings(jobID: JobsManager, completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.contributorsPath
        let basePath =  serverURL + path + ServerAttributes.getContributorPermissions
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: ["job_id": jobID.jobID ?? ""]) { (response, error) in
            completion(response,error)
        }
    }
    
    static func saveDefaultSettings(jobManager: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        let basePath =  serverURL + path + ServerAttributes.addPermissionsToRecruiter
        let parameters = ["job_id": jobManager.jobID ?? "", "recruiters":jobManager.recruiters ?? [[:]], "save_as_default":jobManager.saveAsDefault ?? false] as [String : Any]
    
        print("===========\(basePath)")
        print(parameters)
        
        RequestBuilder.shared.httpPostRequest(basePath: basePath, parameters: parameters, method: APIMethods.post) { (response, error) in
            completion(response,error)
        }
    
    }
    
    static func saveContributorSettings(jobManager: JobsManager, completion: @escaping (([String : Any]?, ErrorResponse?) -> Void)) {
        let serverURL = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.jobs
        let basePath =  serverURL + path + ServerAttributes.addPermissionsToRecruiter
        let parameters = ["job_id": jobManager.jobID ?? "", "recruiters":jobManager.recruiters ?? [[:]], "save_as_default":true] as [String : Any]
           RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: parameters) { (response, error) in
               completion(response,error)
           }
    }
    
}
