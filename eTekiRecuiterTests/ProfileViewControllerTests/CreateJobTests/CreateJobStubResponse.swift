//
//  CreateJobStubResponse.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 30/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
@testable import eTekiRecruiter

public class CreateJobStubResponse{
    
}
public extension CreateJobResponse {
    static func stubResponse(json : Dictionary<String,Any>, code  : Bool, message : String) -> CreateJobResponse? {
        return CreateJobResponse(json: json,success : code,message : message)
    }
}
