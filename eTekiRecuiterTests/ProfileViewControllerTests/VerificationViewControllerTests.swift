//
//  VerificationViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 03/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class VerificationViewControllerTests: XCTestCase {
    var verificationController: VerificationViewController!
    var verificationNavigationController: UINavigationController!
    
    func testgoBackAction(){
        verificationController.dismiss(animated: false, completion: nil)
        verificationController.goBackAction(0)
    }
    
    func testverifyAction(){
        let v = verificationController.otpView.hasValidCode()
        verificationController.showSpinner()
        let manager = ProfileManager(otp: verificationController.otpView.getVerificationCode())
        verificationController.viewModel.verifyOTP(profileManager: manager, requestType: "VerifyOTP")
        verificationController.verifyAction(0)
    }
    
    func testresendOTPAction(){
        verificationController.showSpinner()
        verificationController.viewModel.resendOTP(requestType: "ResendOTP")
        verificationController.resendOTPAction(0)
    }
    
    func testonGetProfileResponse(){
        let reponse = ProfileResponse(json: ["otp_code": "1234"],success : true, message: "Updated")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
            self.verificationController.showBanner(title: "", withMessage: "Updated", style: .success)
            self.verificationController.otpView.clear()
            self.verificationController.dismiss(animated: false, completion: nil)
            self.verificationController.removeSpinner()
        }
        wait(for: [expectation], timeout: 2.5)
        verificationController.onGetProfileResponse(response: reponse, requestType: "VerifyOTP")
    }
    
    func testonGetProfileResponseofResendOtp(){
        let reponse = ProfileResponse(json: ["otp_code": "1234"],success : true, message: "Updated")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
            self.verificationController.showBanner(title: "", withMessage: "Updated", style: .success)
            self.verificationController.otpView.clear()
            self.verificationController.removeSpinner()
        }
        wait(for: [expectation], timeout: 2.5)
        verificationController.onGetProfileResponse(response: reponse, requestType: "ResendOTP")
    }
    
    func testonAPIException(){
        let errResponse = ErrorResponse(responseCode: 500, message: "Server Error", tittle : "fail")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
//            self.verificationController.showBannerWithError(title: "", withMessage: "Server Error")
            self.verificationController.otpView.clear()
            self.verificationController.removeSpinner()
        }
        wait(for: [expectation], timeout: 2.5)
        verificationController.onAPIException(errorResponse: errResponse, requestType: "exception")
    }
    
    override func setUp() {
        verificationController = mainStoryboard.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController
        verificationNavigationController = UINavigationController(rootViewController: verificationController)
        verificationController.view.layoutIfNeeded()
        verificationNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = verificationNavigationController
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
