//
//  SearchAPI.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 15/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

protocol SearchAPIProtocol {
    static func getCountries(completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
    static func getTimeZones(completion: @escaping (([String:Any]?, ErrorResponse?) -> Void))
}

class SearchAPI : SearchAPIProtocol {

    static func getCountries(completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
        let server_url = Environments().configuration(PlistKey.ServerURL)
        let path = ServerAttributes.getCountries
        let basePath =  server_url + path
        RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: [:]) { (response, error) in
            completion(response,error)
        }
    }
    
    static func getTimeZones(completion: @escaping (([String:Any]?, ErrorResponse?) -> Void)) {
           let server_url = Environments().configuration(PlistKey.ServerURL)
           let path = ServerAttributes.getTimeZones
           let basePath =  server_url + path
           RequestBuilder.shared.httpGetRequest(basePath: basePath, parameters: [:]) { (response, error) in
               completion(response,error)
           }
       }
    
    
}
