//
//  FeedBackCommentsView.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 20/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class FeedBackCommentsView: XCTestCase {

    var feedbackViewController: FeedbackViewController!
    var feedbackNavigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        feedbackViewController = mainStoryboard.instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController
        self.addStubData()
        feedbackNavigationController = UINavigationController(rootViewController: feedbackViewController)
        feedbackViewController.view.layoutIfNeeded()
        feedbackNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = feedbackNavigationController
    }
    
    func addStubData() {
        feedbackViewController.grievancePeriodValue = false
        let stubData : [String : Any] = ["comments": [["commented_by": "amanda", "default_role": "Admin", "content": "Nothing", "profile_urls": ["profile_thumb_url": "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png", "created_at": "2020-02-18T12:44:57.000Z"]]], "report_id": 2334, "success" : true,"total_count" : 1]
            CandidateStubApi.getReportViewDetails = stubData
            feedbackViewController.candidatesAPI = CandidateStubApi.self
    }
    
    func testgetCommentsWithEmptyArray(){
        let stubData : [String : Any] = ["comments": [], "report_id": 2334, "success" : true,"total_count" : 1]
        CandidateStubApi.getReportViewDetails = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        feedbackViewController.getComments()
        let expectation2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation2.fulfill()
            XCTAssertTrue(self.feedbackViewController.commentsTableView.isHidden)
            XCTAssertFalse(self.feedbackViewController.noCommentsLabel.isHidden)
            XCTAssertTrue(self.feedbackViewController.addCommentButton.isHidden)
        }
        wait(for: [expectation2], timeout: 4.0)
        
        
        
        let stubData1 : [String : Any] = ["comments": [], "report_id": 2334, "success" : false,"total_count" : 1]
        CandidateStubApi.getReportViewDetails = stubData1
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        feedbackViewController.getComments()
    }
    
    func testScenarioWhenAddCommentButtonTapped(){
//        let expectation = XCTestExpectation(description: "test")
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
//                        guard let WithDrawn = UIApplication.topMostViewController() as? WithDrawnViewController else {
//                                XCTFail("WithDrawnViewController is not Top most view controller.")
//                                return
//                        }
//                        XCTAssertNotNil(WithDrawn, "Not able to Navigate WithDrawnViewController, instance is nil.")
//                        WithDrawn.view.layoutIfNeeded()
//                        expectation.fulfill()
//                   }
//               wait(for: [expectation], timeout: 5.0)
        feedbackViewController.addCommentButton.sendActions(for: .touchUpInside)
    }
    
    func testReloadComments(){
        let notification = NSNotification(name: NSNotification.Name(rawValue: "reloadComments"), object: 0, userInfo: nil)
        feedbackViewController.reloadComments(notfication: notification)
    }
    
    override func tearDown() {
        feedbackViewController = nil
        feedbackNavigationController = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
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
