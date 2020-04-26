//
//  CreateJobStubApi.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 30/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class CreateJobStubApi {
    static var getAreasOfExpertise = CreateJobResponse.stubResponse(json: ["categories": [["id" : 1, "name" : "Application"], ["id" : 2, "name": "Software"]]], code: true, message: "200 ok")
    static var skillsAutoComplete = CreateJobResponse.stubResponse(json: ["data": [["skill" : "c"]]], code: true, message: "200 ok")
    static var suggestSkill = CreateJobResponse.stubResponse(json: ["skill": "Database", "skill_type": "required"], code: true, message: "Created")
}

extension CreateJobStubApi : CreateJobAPIProtocol {
    public static func suggestSkill(createJobManager: CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        completion(suggestSkill,nil)

    }
    
    public static func getAreaOfExpertises(completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        completion(getAreasOfExpertise,nil)
    }
    
    public static func getSkillsAutoComplete(createJobManager: CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        completion(skillsAutoComplete,nil)
    }
    
    public static func updateCreateJob(createJobManager: CreateJobManager?, completion: @escaping ((CreateJobResponse?, ErrorResponse?) -> Void)) {
        completion(getAreasOfExpertise,nil)
    }
    
    
}
