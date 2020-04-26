//
//  JobDetailsViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 09/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
//getJobDetails
protocol JobDetailsViewModelDelegate {
    func onGetAPIResponse(response : CreateJobResponse?, requestType : String?)
    func onAPIException(errorResponse : ErrorResponse?, requestType : String?)
}

struct JobDetailsViewModel  {
    
    var delegate : JobDetailsViewModelDelegate?
    var jobListingAPI: JobListingAPIProtocol.Type = JobListingAPI.self
    
    func getJobDetails(jobsManager : JobsManager?,requestType : String) {
        
        self.jobListingAPI.getJobDetails(jobDetails: jobsManager) { (response, errorResponse) in
            if response != nil {
                
                self.delegate?.onGetAPIResponse(response: response, requestType: requestType)
                
            } else {
                self.delegate?.onAPIException(errorResponse: errorResponse, requestType: requestType)
            }

        }
        
    }
}

