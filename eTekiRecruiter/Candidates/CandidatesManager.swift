//
//  CandidatesManager.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 23/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct CandidatesManager: Codable {
    /** The application to which the user is authenticating */
    //public var status = [] as Array<String>?
    public var status : String?
    public var page: String?
    public var perPage: String?
    public var searchKeyWord: String?
    public var statusKey: String?
    public var jobID : String?
    public var candidateID : String?
    public var analyticStatus : String?
    public var analyticfinalStatus : Bool?
    public var candidateProxied : Bool?
    public var firstName : String?
    public var lastName : String?
    public var email : String?
    public var phone : String?
    public var resumeURL : String?
    public var preferredInterviewTime : String?
    public var timeZone : String?
    public var smsOPT : Bool?
    public var owner : Dictionary<String,String>?
    public var jobDueDate : String?
    public var feedBackDueDate : String?
    public var areaCode : String?
    public var countryCode : String?
    public var ownerId : String?
    public var ownerFullName : String?
    public var requestType : String?
    public var withdrawReason : String?
    public var withdrawStatus : Bool?
    public var timeSlots = [] as Array<String>?
    public var interviewID : String?
    public var interviewerID : String?
    public var rating : Double?
    public var title : String?
    public var note : String?
    public var interviewMemberId : String?
    public var cancellationReason : String?
    public var interviewCode : String?
    public var interviewReportId : String?
    public var content : String?
    public var revertStatus : Bool?

    
    public init(jobID : String, candidateId : String,currentTimeZone : String,prefferedInterViewTime : String, timeSlots : [String]) {
        self.jobID = jobID
        self.candidateID = candidateId
        self.timeZone = currentTimeZone
        self.preferredInterviewTime = prefferedInterViewTime
        self.timeSlots = timeSlots
     }

    public init(jobID : String, status: String,page : String,perPage : String,searchKeyWord : String,statusKey : String){
        self.jobID = jobID
        self.status = status
        self.page = page
        self.perPage = perPage
        self.searchKeyWord = searchKeyWord
        self.statusKey = statusKey
    }
    
    public init(candidateID : String, analyticStatus : String, analyticfinalStatus : Bool, candidateProxied : Bool) {
        self.candidateID = candidateID
        self.analyticfinalStatus = analyticfinalStatus
        self.analyticStatus = analyticStatus
        self.candidateProxied = candidateProxied
    }
    
    public init(email : String,jobID : String) {
        self.email = email
        self.jobID = jobID
    }
    
    public init(interviewReportId: String, content: String, revertStatus: Bool){
        self.interviewReportId = interviewReportId
        self.content = content
        self.revertStatus = revertStatus
    }
    
    public init(interviewCode: String){
        self.interviewCode = interviewCode
    }
    
    public init(jobID : String){
           self.jobID = jobID
    }
    
    public init(candidateID : String){
        self.candidateID = candidateID
    }
    
    public init(interviewID: String){
        self.interviewID = interviewID
    }
    
    public init(interviewerID: String){
        self.interviewerID = interviewerID
    }
    
    public init(interviewID: String, cancellationReason: String){
        self.interviewID = interviewID
        self.cancellationReason = cancellationReason
    }
    
    public init(rating: Double, title: String, note: String, interviewMemberId: String){
        self.rating = rating
        self.title = title
        self.note = note
        self.interviewMemberId = interviewMemberId
    }
    
    public init(withdrawReason : String, candidateID : String, withdrawStatus: Bool){
        self.withdrawReason = withdrawReason
        self.candidateID = candidateID
        self.withdrawStatus = withdrawStatus
    }
    
    public init(jobID : String,firstName: String,lastName : String,email : String,phone : String,resumeURL : String,preferredInterviewTime : String,timeZone : String,smsOPT : Bool,ownerFullName : String?,jobDueDate : String,areaCode : String,countryCode : String,ownerId : String?,requestType : String?,candidateID : String?) {
    
        self.jobID = jobID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.resumeURL = resumeURL
        self.preferredInterviewTime = preferredInterviewTime
        self.timeZone = timeZone
        self.smsOPT = smsOPT
        self.ownerFullName = ownerFullName
        self.jobDueDate = jobDueDate
        self.areaCode = areaCode
        self.countryCode = countryCode
        self.ownerId = ownerId
        self.requestType = requestType
        self.candidateID = candidateID
        
    }
}

extension CandidatesManager: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "\nCandidatesManager"
        description += "\n\tpage: \(String(describing: jobID))"
        description += "\n\tperPage: \(String(describing: jobID))"
        return description
    }
}
