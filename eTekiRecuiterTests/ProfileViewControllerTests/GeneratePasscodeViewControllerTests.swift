//
//  GeneratePasscodeViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class GeneratePasscodeViewControllerTests: XCTestCase {
    var generatePasscodeController: GeneratePasscodeViewController!
    var generatePasscodeNavigationController: UINavigationController!
    
    func testBackAction(){
        generatePasscodeController.dismiss(animated: true, completion: nil)
        generatePasscodeController.backAction(0)
    }
    
    func testGenerateNewPasscode(){
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
            self.generatePasscodeController.showSpinner()
        }
        wait(for: [exp], timeout: 2.5)
        generatePasscodeController.generateNewPasscode("")
    }
    
    func testGetOnprofileResponse(){
        var response = ProfileResponse()
        response.currentPasscode = "XVYE"
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
            self.generatePasscodeController.removeSpinner()
            self.generatePasscodeController.showBanner(title: "", withMessage: response.message ?? "Success", style: .success)
        }
        wait(for: [exp], timeout: 2.5)
       generatePasscodeController.onGetProfileResponse(response: response, requestType: "res")
    }
    
    func testGetOnProfileResponsefails(){
        var response = ProfileResponse()
        response.currentPasscode = nil
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.generatePasscodeController.removeSpinner()
            self.generatePasscodeController.showBanner(title: "", withMessage: response.message ?? "Success", style: .success)
        }
        wait(for: [exp1], timeout: 2.5)
        generatePasscodeController.onGetProfileResponse(response: response, requestType: "res")
    }
    
    func testOnApiException(){
        let err_response = ErrorResponse(responseCode: 2, message: "success", tittle: "success")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.generatePasscodeController.showBanner(title: "", withMessage: err_response.message, style: .success)
            self.generatePasscodeController.removeSpinner()
        }
        wait(for: [exp1], timeout: 2.5)
      generatePasscodeController.onAPIException(errorResponse: err_response, requestType: "res")
    }
    
    override func setUp() {
        generatePasscodeController = mainStoryboard.instantiateViewController(withIdentifier: "GeneratePasscodeViewController") as? GeneratePasscodeViewController
        generatePasscodeNavigationController = UINavigationController(rootViewController: generatePasscodeController)
        generatePasscodeController.view.layoutIfNeeded()
        generatePasscodeNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = generatePasscodeController
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
