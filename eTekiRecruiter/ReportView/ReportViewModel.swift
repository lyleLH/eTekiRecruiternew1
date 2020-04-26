//
//  ReportViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 24/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//
import Foundation
import UIKit

protocol ReportViewModelDelegate {
    func updateReportDetails(response : [String:Any]?)
    func updateErrorReponse(errorResponse : ErrorResponse?)
}

struct SkillsData {
    var opened = Bool()
    var title = String()
    var sectionData = [Dictionary<String, Any>]()
}

struct CodeData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

struct ReportViewModel {
    var candidateAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var delegate : ReportViewModelDelegate?
    var skillstableViewData = [SkillsData]()
    var codeTableViewData = [CodeData]()
    var averageCompentancyScore = [0.0, 0.0]
    var averageExperienceScore = [0.0, 0.0]

    func getReportViewDetails(interviewCode : String) {
        self.candidateAPI.getReportViewDetails(candidateManger: CandidatesManager(interviewCode: interviewCode)){(response , error) in
            if(response != nil) {
                let success = response?["success"] as? Bool ?? false
                if(success) {
                   self.delegate?.updateReportDetails(response: response ?? [String : Any]())
                } else {
                    self.delegate?.updateErrorReponse(errorResponse: error)
                }
            } else {
                self.delegate?.updateErrorReponse(errorResponse: error)
            }
        }
    }
}
