//
//  ReasonViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class ReasonViewControllerTests: XCTestCase {
     
    var reasonViewController: ReasonViewController!
    
    override func setUp() {
        reasonViewController = mainStoryboard.instantiateViewController(withIdentifier: "ReasonViewController") as? ReasonViewController
        reasonViewController.candidatesAPI = CandidateStubApi.self
        reasonViewController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = reasonViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testInstance(){
        XCTAssertNotNil(reasonViewController.cancelledAtLabel)
        XCTAssertNotNil(reasonViewController.cancelledByLabel)
        XCTAssertNotNil(reasonViewController.reasonTextView)
    }
    
    //close Popup Alert action
    func testClosePopupAlert(){
        reasonViewController.closePopupAction(0)
    }
    
    //Get Cancellation Reason
    func testGetCancellationReason(){
        let stubData : [String : Any] = ["cancellation_details": ["cancelled_by": "recruiter", "reason": "Dropped", "cancelled_at": "2020-01-08T13:03:00.000Z"], "success": true]
        CandidateStubApi.getCancellationReason = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        reasonViewController.getCancellationDetails()
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
