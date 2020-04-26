 //
//  VerificationViewModalTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 03/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class VerificationViewModalTests: XCTestCase {
    var verificationModal = VerificationViewModel()
    
    func testResendOtp(){
        let resendResponse = ProfileResponse(json: ["otp_required": "true"], success: true, message: "200")
        ProfileAuthenticationApi.resendOtp = resendResponse
        verificationModal.profileAPI = ProfileAuthenticationApi.self
        verificationModal.resendOTP(requestType: "ResendOTP")
    }
    
    func testverifyOtp(){
        let manager = ProfileManager(otp: "1234")
        let verifyResponse = ProfileResponse(json: ["otp_required": "true"], success: true, message: "200")
        ProfileAuthenticationApi.verifyOtp = verifyResponse
        verificationModal.profileAPI = ProfileAuthenticationApi.self
        verificationModal.verifyOTP(profileManager: manager, requestType: "VerifyOTP")
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
