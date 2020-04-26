//
//  GeneratePasscodeViewModalTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class GeneratePasscodeViewModalTests: XCTestCase {
    var generatePasscodeModal = GeneratePasscodeViewModel()
    
    func testresetPasscodeSuccessResponse(){
        let resetResponse = ProfileResponse(json: [:], success: true, message: "xcvfr")
        ProfileAuthenticationApi.resetPasscodeResponse = resetResponse
      //  generatePasscodeModal.profileAPI = ProfileAuthenticationApi.self
        generatePasscodeModal.resetPasscode(requestType: "fgdf")
    }
    
    func testapiCallResponse(){
         let profileManger = ProfileManager(sameAsbilling: true)
        let resetResponse = ProfileResponse(json: ["otpRequires" : "true"], success: true, message: "true")
        ProfileAuthenticationApi.getProfileResponse = resetResponse
       // generatePasscodeModal.profileAPI = ProfileAuthenticationApi.self
//        generatePasscodeModal.profileAPI.getProfileDetails(profileManager: <#T##ProfileManager#>, completion: <#T##((ProfileResponse?, ErrorResponse?) -> Void)##((ProfileResponse?, ErrorResponse?) -> Void)##(ProfileResponse?, ErrorResponse?) -> Void#>)
        generatePasscodeModal.apiCall(profileManager: profileManger, requestType: "/get_profile_details")
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
