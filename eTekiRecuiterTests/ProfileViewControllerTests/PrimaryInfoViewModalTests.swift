//
//  PrimaryInfoViewModalTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 20/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class PrimaryInfoViewModalTests: XCTestCase {
   var primaryInfoModal = PrimaryInfoViewModel()
    func testShouldValidateCredentials(){
        primaryInfoModal.shouldValidateCredentials()
    }
    
    func testUpdateSocialLinks(){
        let profileManager = ProfileManager(socialLinks: [["linkedin" : "https://www.linkedin.com/afreen"], ["twitter" : "https://www.twitter.com"]])
        let resetResponse = ProfileResponse(json: [:], success: true, message: "xcvfr")
        ProfileAuthenticationApi.updatePrimaryResponse = resetResponse
        //primaryInfoModal.profileAPI = ProfileAuthenticationApi.self
        primaryInfoModal.updateSocialLinks(profileManager: profileManager)
    }
    
    func testapicall() {
        let resetResponse = ProfileResponse(json: [:], success: true, message: "xcvfr")
        ProfileAuthenticationApi.getProfileResponse = resetResponse
        //primaryInfoModal.profileAPI = ProfileAuthenticationApi.self
       primaryInfoModal.apiCall()
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
