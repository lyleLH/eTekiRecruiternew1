//
//  CreateJobResponse.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 26/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct CreateJobResponse: Codable {
    
    public var message: String?
    public var categoryName: String?
    public var categoryID : String?
    public var categories = [String]()
    public var autoSkills = [String]()
    public var success : Bool?
    
    public var clientCompanyName : String?
    public var codingRequired : Bool?
    public var jobDescription : String?
    public var dueDate : String?
    public var experirenceRequired : String?
    public var expertiseCategory : String?
    public var idRequired : Bool?
    public var interViewMode : String?
    public var interviewMinimumPricing : String?
    public var interviewMaximuPrice : String?
    public var interViewLanguagePreference : String?
    public var interViewLocationPreference : String?
    public var jobCode : String?
    public var numberOfProspects : String?
    public var specialInstructions : String?
    public var preferedSkillSet : String?
    public var skillset : String?
    public var interViewersCount : Int?
    public var whiteboradRequired : Bool?
    public var companyLogo : String?
    public var jobDescriptionAwsurl : String?
    public var jobTitle : String?
    public var skillsAutoCompleteText : String?
    public var autoSource : Bool?
    public var agent : String?
    public var skill : String?
    public var skillType : String?
    public var jobId : String?
    public var status : String?
    public var recordingEnabled : Bool?
    
    public var statusFilters = [String]()
    public var filterDueDate : String?
    public var jobTypes = [String]()
    public var interViewTypes = [String]()
    public var isIndependentRecruiter : Bool?
    public var myInterviewsFilters : Array<Dictionary<String,Array<String>>>?

    
}

extension CreateJobResponse {
    
    init(json: [String: Any],success : Bool,message : String) {
        self.success = success
        self.message = message

        if let filters = json["filter"] as? Dictionary<String,Any> {
            
            if let searchQuery = filters["search_query"] as? Dictionary<String,Any>  {
                
                if let jobsType = searchQuery["jobs_type[]"] as? Array<String>{
                    jobTypes = jobsType
                } else {
                    print("Parsing failed for jobsType ")
                }
                
                if let interviewsType = searchQuery["interview_type[]"] as? Array<String>{
                        interViewTypes = interviewsType
                } else {
                        print("Parsing failed for interviews type")
                }
                
                if let status = searchQuery["status_filters[]"] as? Array<Dictionary<String,Array<String>>> {
                    myInterviewsFilters = status
                } else {
                    print("Parsing failed for Interview status ")
                }
                
                if let status = searchQuery["status[]"] as? Array<String> {
                         statusFilters = status
                } else {
                        print("Parsing failed for job status ")
                 }
                
                if let dueDates = searchQuery["due_date[]"] as? String {
                    filterDueDate = dueDates
                } else {
                    print("Parsing failed for dueDates ")
                }
                
            } else {
                print("Parsing failed for searchQuery ")
                
            }
            
            
        } else {
            print("Parsing failed for filters ")
            
        }
        
        if let jobDetails = json["job"] as? Dictionary<String,Any> {
            
            if let agent = jobDetails["agent"] as? String {
                self.agent = agent
            } else {
                self.agent = ""
            }
            
            if let autoSource = jobDetails["auto_source"] as? Bool {
                self.autoSource = autoSource
            } else {
                self.autoSource = false
            }
            
            
            if let clientCompanyName = jobDetails["client_company_name"] as? String {
                self.clientCompanyName = clientCompanyName
            } else {
                self.clientCompanyName = ""
            }
            
            if let codingRequired = jobDetails["coding_required"] as? Bool {
                self.codingRequired = codingRequired
            } else {
                self.codingRequired = false
            }
            
            if let companyLogo = jobDetails["company_logo"] as? String {
                self.companyLogo = companyLogo
            } else {
                self.companyLogo = ""
            }
            
            if let description = jobDetails["description"] as? String {
                self.jobDescription = description
            } else {
                self.jobDescription = ""
            }
            
            if let dueDate = jobDetails["due_at"] as? String {
                self.dueDate = dueDate
            } else {
                self.dueDate = ""
            }

            if let experirenceRequired = jobDetails["experience_required"] as? Int {
                self.experirenceRequired = "\(experirenceRequired)"
            } else {
                //self.experirenceRequired = "\()"
            }

            if let expertiseCategory = jobDetails["expertise_category"] as? String {
                self.expertiseCategory = expertiseCategory
            } else {
                self.expertiseCategory = ""
            }

            if let interviewMaximuPrice = jobDetails["interview_max_price"] as? String {
                self.interviewMaximuPrice = interviewMaximuPrice
            } else {
                self.interviewMaximuPrice = ""
            }
            
            if let interviewMinimumPricing = jobDetails["interview_min_price"] as? String {
                self.interviewMinimumPricing = interviewMinimumPricing
            } else {
                self.interviewMinimumPricing = ""
            }

            if let idRequired = jobDetails["id_required"] as? Bool {
                self.idRequired = idRequired
            } else {
                self.idRequired = false
            }
            
            if let jobId = jobDetails["id"] as? String {
                self.jobId = jobId
            } else if let jobId = jobDetails["id"] as? Int {
                self.jobId = "\(jobId)"
            } else {
                self.jobId = ""
            }
            
            if let interViewMode = jobDetails["interview_mode"] as? String {
                self.interViewMode = interViewMode
            } else {
                self.interViewMode = ""
            }

            if let interViewLanguagePreference = jobDetails["interviewer_language_preference"] as? String {
                self.interViewLanguagePreference = interViewLanguagePreference
            } else {
                self.interViewLanguagePreference = ""
            }
            
            if let interViewLocationPreference = jobDetails["interviewer_location_preference"] as? String {
                self.interViewLocationPreference = interViewLocationPreference
            } else {
                self.interViewLocationPreference = ""
            }

            if let interViewersCount = jobDetails["interviewers_count"] as? Int {
                self.interViewersCount = interViewersCount
            } else {
                self.interViewersCount = 0
            }
            
            if let jobCode = jobDetails["job_code"] as? String {
                self.jobCode = jobCode
            } 
            
            if let jobDescriptionAwsurl = jobDetails["job_description_file"] as? String {
                self.jobDescriptionAwsurl = jobDescriptionAwsurl
            } else {
                self.jobDescriptionAwsurl = ""
            }

            if let numberOfProspects = jobDetails["number_of_prospects"] as? Int {

                self.numberOfProspects = "\(numberOfProspects)"
            } else {
                self.numberOfProspects =  "0"
            }
            
            
            if let preferedSkillSet = jobDetails["preferred_skillset"] as? String {
                self.preferedSkillSet = preferedSkillSet
            }
            
            
            if let recordingEnabled = jobDetails["recording_enabled"] as? Bool {
                self.recordingEnabled = recordingEnabled
            } else {
                self.recordingEnabled = false
            }
            
            if let independentRecruiter = json["independent_recruiter"] as? Bool {
                self.isIndependentRecruiter = independentRecruiter
            }
            
            if let skillset = jobDetails["skillset"] as? String {
                self.skillset = skillset
            }
            
            if let specialInstructions = jobDetails["special_instructions"] as? String {
                self.specialInstructions = specialInstructions
            } else {
                self.specialInstructions = ""
            }
            
            if let status = jobDetails["status"] as? String {
                self.status = status
            } else {
                self.status = ""
            }

            if let jobTitle = jobDetails["title"] as? String {
                self.jobTitle = jobTitle
            } else {
                self.jobTitle = ""
            }

            if let whiteboradRequired = jobDetails["whiteboard_required"] as? Bool {
                self.whiteboradRequired = whiteboradRequired
            } else {
                self.whiteboradRequired = false
            }

        } else {
            
            print("Parsing failed for jobDetails ")
            
        }
        
        if let skills = json["data"] as? Array<String> {
            for skill in skills {
                self.autoSkills.append(skill)
            }
            
        } else {
            print("Parsing failed for autoSkills ")
            
        }
        
        
        if let categories = json["categories"] as? Array<Dictionary<String,Any>> {
            
            for category in categories {
                if let name = category["name"] as? String {
                    self.categories.append(name)
                }
            }
            
            
        } else {
            print("Parsing failed for categories ")
            
        }
        
        
    }
    
}
