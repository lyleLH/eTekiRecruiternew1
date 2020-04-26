//
//  AnalyticsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 12/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class AnalyticsViewControllerTests: XCTestCase {
    
    var analyticsController: AnalyticsViewController!
    var analyticsNavigationController: UINavigationController!
    
    override func setUp() {
        analyticsController = mainStoryboard.instantiateViewController(withIdentifier: "AnalyticsViewController") as? AnalyticsViewController
        analyticsNavigationController = UINavigationController(rootViewController: analyticsController)
        analyticsController.candidateID = "11358"
//        let stubData : [String : Any] = ["analytics_response" : ["analytics_completed" : true, "analytic_status": "Interviewed", "id" : 3353, "full_name" : "fullname"]]
//        CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.candidatesAPI = CandidateStubApi.self
        analyticsController.view.layoutIfNeeded()
        analyticsNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = analyticsNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testAnalyticsToCustomAlert(){
        let segue = UIStoryboardSegue(identifier: StoryboardSegueIdentifiers.analyticsToCustomMessage, source: analyticsController, destination: CustomAlertViewController())
        analyticsController.candidateID = "11358"
        analyticsController.currentAnalyticStatus = "Interviewed"
        analyticsController.analyticfinalStatus = false
        analyticsController.candidateProxied = true
        analyticsController.prepare(for: segue, sender: nil)
    }
    
    /*! @brief Scenario when user submit an anlaytics with interviewed status*/
    func testUpdateAnalyticswithInterviewed(){
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil)
        analyticsController.updateAnalytics(notfication: notification2)
        
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: [:])
        analyticsController.updateAnalytics(notfication: notification1)
        
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Analytics":["analytics_response" : ["analytics_completed" : true, "analytic_status": "Interviewed", "id" : 3353, "full_name" : "fullname", "proxied": true]]])
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        analyticsController.updateAnalytics(notfication: notification)
    }
    
    /*! @brief Scenario when user submit an anlaytics with screened status*/
    func testUpdateAnalyticswithScreened(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Analytics":["analytics_response" : ["analytics_completed" : false, "analytic_status": "Screened", "id" : 3353, "full_name" : "fullname", "proxied": false]]])
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        analyticsController.updateAnalytics(notfication: notification)
    }
    
    /*! @brief Scenario when user submit an anlaytics with offered status*/
    func testUpdateAnalyticswithOffered(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Analytics":["analytics_response" : ["analytics_completed" : false, "analytic_status": "Offered", "id" : 3353, "full_name" : "fullname", "proxied": false]]])
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        analyticsController.updateAnalytics(notfication: notification)
    }
    
    /*! @brief Scenario when user submit an anlaytics with hired status*/
    func testUpdateAnalyticswithHired(){
        analyticsController.currentAnalyticStatus = .hired
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Analytics":["analytics_response" : ["analytics_completed" : false, "analytic_status": "Hired", "id" : 3353, "full_name" : "fullname", "proxied": false]]])
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        analyticsController.updateAnalytics(notfication: notification)
    }
    
    /*! @brief Scenario when user submit an anlaytics with Submitted status*/
    func testUpdateAnalyticswithSubmitted(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Analytics":["analytics_response" : ["analytics_completed" : false, "analytic_status": "Submitted", "id" : 3353, "full_name" : "fullname", "proxied": false]]])
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        analyticsController.updateAnalytics(notfication: notification)
    }
    
    /*! @brief Scenario when user submit an anlaytics with default status*/
    func testUpdateAnalyticswithDefault(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Analytics":["analytics_response" : ["analytics_completed" : false, "analytic_status": "default", "id" : 3353, "full_name" : "fullname", "proxied": false]]])
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        analyticsController.updateAnalytics(notfication: notification)
    }
    
    func testBackAction(){
        analyticsController.backAction(0)
    }
    
    func testAdaptivePresentationStyle(){
        let controller = UIPresentationController(presentedViewController: analyticsController, presenting: analyticsController)
        analyticsController.adaptivePresentationStyle(for: controller)
    }
    
    func testCancelAction(){
        analyticsController.cancelAction(0)
    }
    
    /*! @brief Scenario when user getRoIStatistics with Screened status*/
    func testGetRoIdetailsWithScreened(){
      let stubData = ["analytics_response" : ["analytics_completed" : false, "analytic_status": "Screened", "id" : 3353, "full_name" : "fullname"]]
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
      CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.getCandidatesROI()
    }
    
    /*! @brief Scenario when user getRoIStatistics with Offered status*/
    func testGetRoIdetailsWithOffered(){
      let stubData = ["analytics_response" : ["analytics_completed" : true, "analytic_status": "Offered", "id" : 3353, "full_name" : "fullname"]]
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
      CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.getCandidatesROI()
    }
    
    /*! @brief Scenario when user getRoIStatistics with Hired status*/
    func testGetRoIdetailsWithHired(){
      let stubData = ["analytics_response" : ["analytics_completed" : true, "analytic_status": "Hired", "id" : 3353, "full_name" : "fullname"]]
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
      CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.getCandidatesROI()
    }
    
    /*! @brief Scenario when user getRoIStatistics with Submitted status*/
    func testGetRoIdetailsWithSubmitted(){
      let stubData = ["analytics_response" : ["analytics_completed" : true, "analytic_status": "Submitted", "id" : 3353, "full_name" : "fullname"]]
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
      CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.getCandidatesROI()
    }
    
    /*! @brief Scenario when user getRoIStatistics with Interviewed status*/
    func testGetRoIdetailsWithInterviewed(){
      let stubData = ["analytics_response" : ["analytics_completed" : true, "analytic_status": "Interviewed", "id" : 3353, "full_name" : "fullname"]]
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
      CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.getCandidatesROI()
    }
    
    /*! @brief Scenario when user getRoIStatistics with default status*/
    func testGetRoIdetailsWithdefault(){
      let stubData = ["analytics_response" : ["analytics_completed" : true, "analytic_status": "default", "id" : 3353, "full_name" : "fullname"]]
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
      CandidateStubApi.getCandidatesresponse = stubData
        analyticsController.getCandidatesROI()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /*
     - Test Scenario when candidate is suspected proxy
     - Step 1 - Proxy image view must be shown.
     - Step 2 - Name label with Name + Suspected of Proxy String must be shown.
     */
    
    func testProxyCandidate() {
        
          let stubData = ["analytics_response" : ["analytics_completed" : true,"proxied" : true, "analytic_status": "default", "id" : 3353, "full_name" : "fullname"]]
              let expectation = XCTestExpectation(description: "test")
              DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                XCTAssertNotNil(self.analyticsController.proxyImageView, "Proxy Image Found NIL")
                XCTAssertFalse(self.analyticsController.proxyImageView.isHidden, "Proxy image is hidden")
                XCTAssertEqual("FULLNAME Suspected of Proxy", self.analyticsController.nameLabel.text, "NameLabel with suspected proxy mismatch")
                  expectation.fulfill()
              }
            CandidateStubApi.getCandidatesresponse = stubData
            analyticsController.getCandidatesROI()
   
            wait(for: [expectation], timeout: 3.0)

    }


}
