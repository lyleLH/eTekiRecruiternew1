//
//  CreateJobManager.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 24/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct CreateJobManager: Codable {
    
//    Params:{ "client_company_name": "fm", "coding_required": "true/false", "description": "Note: If you are unable to find the skill in auto suggested list. Please let us know about skill here.", "due_at": "30/09/2019", "experience_required": "3", "expertise_category": "Application/Software Development", "id_required": "true", "interview_mode": "Video/Audio", "interviewer_language_preference": "preffered_language", "interviewer_location_preference": "preferred_location", "job_code": "job_code", "number_of_prospects": "2", "preferred_skillset": "Testing", "-+": "Database Testing,Automated Testing", "special_instructions": "", "title": "data analyst", "whiteboard_required": "true/false",”company_logo”: "1568889299028.png", “job_description_file”: "1568889310377.pdf" }
    
    public var clientCompanyName : String?
    public var codingRequired : Bool?
    public var jobDescription : String?
    public var dueDate : String?
    public var experirenceRequired : String?
    public var expertiseCategory : String?
    
    public var idRequired : Bool?
    public var interViewMode : String?
    public var interViewLanguagePreference : String?
    public var interViewLocationPreference : String?
    public var jobCode : String?
    
    public var numberOfProspects : String?
    public var specialInstructions : String?
    public var preferedSkillSet : String?
    public var skillset : String?

    public var whiteboradRequired : Bool?
    
    public var companyLogo : String?
    public var jobDescriptionAwsurl : String?
    public var jobTitle : String?
    public var skillsAutoCompleteText : String?

    
    public var skill : String?
    public var skillType : String?
    
    public var requestType : String?
    public var jobID : String?

    
    public init(skillsAutoCompleteText: String) {
       self.skillsAutoCompleteText = skillsAutoCompleteText
    }
    
    public init(skill : String, skillType : String) {
        self.skill = skill
        self.skillType = skillType
    }

    public init(clientCompanyName: String?, codingRequired: Bool, description: String, dueDate: String, experirenceRequired: String, expertiseCategory: String, idRequired: Bool, interViewMode: String, whiteboradRequired: Bool,numberOfProspects : String,specialInstructions : String, preferedSkillSet : String,skillset : String,jobTitle : String,jobDescriptionAwsurl : String,interViewLanguagePreference : String,interViewLocationPreference : String,jobCode : String,companyLogo : String,requestType : String,jobID : String?) {
        
        self.clientCompanyName = clientCompanyName ?? ""
        self.codingRequired = codingRequired
        self.jobDescription = description
        self.dueDate = dueDate
        self.experirenceRequired = experirenceRequired
        self.expertiseCategory = expertiseCategory
        self.idRequired =  idRequired
        self.interViewMode = interViewMode
        self.whiteboradRequired = whiteboradRequired
        self.numberOfProspects = numberOfProspects
        self.specialInstructions = specialInstructions
        self.preferedSkillSet = preferedSkillSet
        self.jobTitle = jobTitle
        self.skillset = skillset
        self.jobDescriptionAwsurl = jobDescriptionAwsurl
        self.interViewLanguagePreference = interViewLanguagePreference
        self.interViewLocationPreference = interViewLocationPreference
        self.jobCode = jobCode
        self.companyLogo = companyLogo
        self.requestType = requestType
        self.jobID = jobID

    }

  
}
