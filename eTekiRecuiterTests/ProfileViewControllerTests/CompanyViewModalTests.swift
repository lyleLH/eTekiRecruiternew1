//
//  CompanyViewModalTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 23/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class CompanyViewModalTests: XCTestCase {
   var companyViewModal = CompanyViewModel()
    
    func testGetCompanyDetails(){
        let profileManger = ProfileManager(sameAsbilling: true)
        let resetResponse = ProfileResponse(json: ["user": ["profile_created":0]], success: true, message: "true")
        ProfileAuthenticationApi.getProfileResponse = resetResponse
        companyViewModal.profileAPI = ProfileAuthenticationApi.self
        companyViewModal.getCompanyDetails(profileManager: profileManger)
    }
    
    func testupdateCompanyDetails(){
        let profileManger = ProfileManager(sameAsbilling: true)
        let response = ProfileResponse(json: [:], success: true, message: "company")
        ProfileAuthenticationApi.updateCompanyResponse = response
        companyViewModal.profileAPI = ProfileAuthenticationApi.self
        companyViewModal.updateCompanyDetails(profileManager: profileManger)
    }
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
