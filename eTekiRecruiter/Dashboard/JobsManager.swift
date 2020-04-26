//
//  JobsManager.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 29/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct JobsManager: Codable {
    
    public var page: String?
    public var perPage: String?
    /** The application to which the user is authenticating */
    public var status = [] as Array<String>?
    public var emails = [] as Array<String>?
    public var filterDueDate : String?
    public var currentType = [] as Array<String>?
    public var searchBy = [:] as Dictionary<String,String>?
    public var jobID : String?
    public var interViewerID : String?
    public var due_at : String?
    public var currentTab : String?
    public var email : String?
    public var interviewCode : String?
    public var saveAsDefault : Bool?
    public var recruiters : [Dictionary<String,[String]>]?
    public var statusFilter : Array<Dictionary<String,Array<String>>>?
    
    public init(page: String, perPage: String,jobID : String) {
        self.page = page
        self.perPage = perPage
        self.jobID = jobID
    }
    
    public init(emails : [String] ,jobID : String) {
          self.emails = emails
          self.jobID = jobID
    }
    
    public init(interviewCode : String) {
        self.interviewCode = interviewCode
    }
    
    public init(email : String ,jobID : String) {
           self.email = email
           self.jobID = jobID
     }

    public init(page: String, perPage: String, statusFilter: Array<Dictionary<String,Array<String>>> ,currentTypes: Array<String>,searchBy: Dictionary<String,String>,closingDate: String) {
        self.page = page
        self.perPage = perPage
        self.statusFilter = statusFilter
        self.currentType = currentTypes
        self.searchBy = searchBy
        self.filterDueDate = closingDate
    }
    
    public init(page: String, perPage: String, status: Array<String> ,currentTypes: Array<String>,searchBy: Dictionary<String,String>,closingDate: String) {
        self.page = page
        self.perPage = perPage
        self.status = status
        self.currentType = currentTypes
        self.searchBy = searchBy
        self.filterDueDate = closingDate
    }
    
    public init(page: String, perPage: String, status: Array<String>,currentTypes: Array<String>,searchBy: Dictionary<String,String>,closingDate: String,jobID : String) {
         self.page = page
         self.perPage = perPage
         self.status = status
         self.currentType = currentTypes
         self.searchBy = searchBy
         self.filterDueDate = closingDate
         self.jobID = jobID
     }
    
    public init(page: String, perPage: String, statusFilter: Array<Dictionary<String,Array<String>>> ,currentTypes: Array<String>,searchBy: Dictionary<String,String>,closingDate: String,jobID : String) {
        self.page = page
        self.perPage = perPage
        self.statusFilter = statusFilter
        self.currentType = currentTypes
        self.searchBy = searchBy
        self.filterDueDate = closingDate
        self.jobID = jobID
    }
    
    public init(currentTab : String ,status: Array<String>,currentTypes: Array<String>,closingDate: String) {
        self.status = status
        self.currentType = currentTypes
        self.filterDueDate = closingDate
        self.currentTab = currentTab
    }
    
    public init(jobID : String, due_at: String){
        self.jobID = jobID
        self.due_at = due_at
    }
    
    public init(jobID : String) {
        self.jobID = jobID
    }
    
    public init(interViewerID : String) {
           self.interViewerID = interViewerID
    }
    
    public init(currentTab : String) {
        self.currentTab = currentTab
    }
    
    public init(jobID: String, recruiters: [Dictionary<String,Array<String>>], saveAsDefault: Bool){
           self.jobID = jobID
           self.recruiters = recruiters
           self.saveAsDefault = saveAsDefault
       }
}

extension JobsManager: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "\nJobsManager"
        description += "\n\tpage: \(String(describing: page))"
        description += "\n\tperPage: \(String(describing: perPage))"
        return description
    }
}
