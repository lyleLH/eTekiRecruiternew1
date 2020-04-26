//
//  WithdrawnViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 07/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class WithdrawnViewControllerTests: XCTestCase {
      var withDrawnViewController: WithDrawnViewController!
      var withDrawNavigationController: UINavigationController!
    
    override func setUp() {
        withDrawnViewController = mainStoryboard.instantiateViewController(withIdentifier: "withDrawnViewController") as? WithDrawnViewController
        withDrawNavigationController = UINavigationController(rootViewController: withDrawnViewController)
        withDrawnViewController.candidatesAPI = CandidateStubApi.self
        withDrawnViewController.view.layoutIfNeeded()
        withDrawNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = withDrawNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInstance() {
        XCTAssertNotNil(withDrawnViewController, "Not able to create withDrawnViewController Instance.")
        XCTAssertNotNil(withDrawnViewController.containerView, "Not able to create contatinerView Instance.")
        XCTAssertNotNil(withDrawnViewController.reasonTextView, "Not able to create reasonTextView Instance.")
        XCTAssertNotNil(withDrawnViewController.withdrawnButton, "Not able to create withdrawnButton Instance.")
        XCTAssertNotNil(withDrawnViewController.cancelButton, "Not able to create cancelButton Instance.")
    }
    
    /*! @brief Scenario when user taps on Cancel button*/
    func testCancelAction(){
        withDrawnViewController.cancelButton.sendActions(for: .touchUpInside)
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            guard let candidatesController = UIApplication.topMostViewController() as? CandidatesViewController else {
//                        XCTFail("CandidatesViewController is not Top most view controller.")
                        return
            }
            XCTAssertNotNil(candidatesController, "Not able to Navigate CandidatesController, instance is nil.")
            candidatesController.view.layoutIfNeeded()
        }
         wait(for: [exp1], timeout: 2.5)
    }
    
    /*! @brief Scenario when user taps on withraw button with empty reason*/
     func testWithDrawAction(){
        withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
     }
     
    /*! @brief Scenario when user taps on withraw button with reason and status is true*/
    func testWithdrawAction(){
        withDrawnViewController.reasonTextView.text = "no comments"
        let stubData4 : [String : Any] = ["message" : "candidates moved to withdrawn status","success" : false]
        CandidateStubApi.withDrawnCandidate = stubData4
        withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
         let exp4 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                   exp4.fulfill()
            XCTAssertFalse(self.withDrawnViewController.reasonTextView.isHidden, "Reason Text View is hidden")
            XCTAssertNotEqual(self.withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
        }
        wait(for: [exp4], timeout: 2.5)
        
        let stubData : [String : Any] = ["message" : "candidates moved to withdrawn status","success" : true]
        CandidateStubApi.withDrawnCandidate = stubData
        withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
         let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                   exp1.fulfill()
            XCTAssertFalse(self.withDrawnViewController.reasonTextView.isHidden, "Reason Text View is hidden")
            XCTAssertNotEqual(self.withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
        }
        wait(for: [exp1], timeout: 2.5)
        
        withDrawnViewController.reasonTextView.text = "no comments"
        withDrawnViewController.isNavigatingFrom = "myInterviews"
        let stubData1 : [String : Any] = ["message" : "candidates moved to withdrawn status","success" : true]
        CandidateStubApi.withDrawnCandidate = stubData1
        let exp2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                   exp2.fulfill()
            XCTAssertFalse(self.withDrawnViewController.reasonTextView.isHidden, "Reason Text View is hidden")
            XCTAssertNotEqual(self.withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
        }
        wait(for: [exp2], timeout: 2.5)
        withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
        
        withDrawnViewController.reasonTextView.text = "no comments"
        withDrawnViewController.isNavigatingFrom = "cancelConfirmed"
        let stubData2 : [String : Any] = ["message" : "candidates moved to withdrawn status","success" : true]
        CandidateStubApi.withDrawnCandidate = stubData2
        let exp3 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                   exp3.fulfill()
            XCTAssertFalse(self.withDrawnViewController.reasonTextView.isHidden, "Reason Text View is hidden")
            XCTAssertNotEqual(self.withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
        }
        wait(for: [exp3], timeout: 2.5)
        withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
        
        withDrawnViewController.reasonTextView.text = "no comments"
        withDrawnViewController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
        let stubData3 : [String : Any] = ["message" : "candidates moved to withdrawn status","success" : true]
        CandidateStubApi.withDrawnCandidate = stubData3
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                   exp.fulfill()
            XCTAssertFalse(self.withDrawnViewController.reasonTextView.isHidden, "Reason Text View is hidden")
            XCTAssertNotEqual(self.withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
        }
        wait(for: [exp], timeout: 2.5)
        withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
        
    }
    
    /*! @brief Scenario when user taps on withraw button with reason and status is false*/
       func testWithdrawActionwithError(){
           withDrawnViewController.reasonTextView.text = "no comments"
           let stubData : [String : Any] = ["message" : "candidates moved to withdrawn status","success" : false]
           CandidateStubApi.withDrawnCandidate = stubData
           withDrawnViewController.withdrawnButton.sendActions(for: .touchUpInside)
           let exp1 = XCTestExpectation(description: "test")
           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                      exp1.fulfill()
               XCTAssertFalse(self.withDrawnViewController.reasonTextView.isHidden, "Reason Text View is hidden")
               XCTAssertNotEqual(self.withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
           }
           wait(for: [exp1], timeout: 2.5)
       }
    
    /*! @brief Scenario when user starts to editing the reason */
     func testTextViewbeginEdititng(){
        withDrawnViewController.textViewDidBeginEditing(withDrawnViewController.reasonTextView)
        XCTAssertEqual(withDrawnViewController.reasonTextView.textColor, AppTheme.textColor)
      }
    
     /*! @brief Scenario when user stop editing the reason TextView */
     func testTextViewendEdititng(){
        withDrawnViewController.reasonTextView.text = ""
        withDrawnViewController.textViewDidEndEditing(withDrawnViewController.reasonTextView)
        XCTAssertEqual(withDrawnViewController.reasonTextView.text, "TYPE_REASON".localized)
        XCTAssertEqual(withDrawnViewController.reasonTextView.textColor, AppTheme.textViewPlaceholder)
        
        withDrawnViewController.reasonTextView.text = ""
        withDrawnViewController.isNavigatingFrom = "myInterviews"
        withDrawnViewController.textViewDidEndEditing(withDrawnViewController.reasonTextView)
        
        withDrawnViewController.reasonTextView.text = ""
        withDrawnViewController.isNavigatingFrom = RevertReport.addComment
        withDrawnViewController.textViewDidEndEditing(withDrawnViewController.reasonTextView)
      }
     
    /*! @brief Scenario when user returns the keyboard*/
    func testTextViewKeyboarReturning(){
        let range = NSRange("\n")
        withDrawnViewController.textView(withDrawnViewController.reasonTextView, shouldChangeTextIn: range ?? NSRange(), replacementText: "\n")
     }
    
     /*! @brief Scenario when user Editing with keyboard*/
     func testTextViewKeyboarNotReturning(){
         let range = NSRange("return")
         withDrawnViewController.textView(withDrawnViewController.reasonTextView, shouldChangeTextIn: range ?? NSRange(), replacementText: "return")
      }
    
    func testViewDidLoad(){
        withDrawnViewController.isNavigatingFrom =  MyinterviewsStatus.report
        withDrawnViewController.viewDidLoad()
        
        withDrawnViewController.isNavigatingFrom =  RevertReport.addComment
        withDrawnViewController.viewDidLoad()
        
        withDrawnViewController.isNavigatingFrom =  "cancelConfirmed"
        withDrawnViewController.viewDidLoad()
    }
    
    func testCancelActionFromInterviews(){
        withDrawnViewController.isNavigatingFrom = "cancelConfirmed"
         withDrawnViewController.cancelButton.sendActions(for: .touchUpInside)

        
        withDrawnViewController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
        withDrawnViewController.cancelButton.sendActions(for: .touchUpInside)
          
        
        withDrawnViewController.isNavigatingFrom = MyinterviewsStatus.report
        withDrawnViewController.cancelButton.sendActions(for: .touchUpInside)
          
    }
    
    func testRevertWithdrawAction(){
        withDrawnViewController.isNavigatingFrom = RevertReport.addComment
        withDrawnViewController.interviewReportId = "3443"
        withDrawnViewController.status = true
        
        let stubData1 : [String : Any] = ["message" : "candidates moved to withdrawn status", "interview_report_status": "Request Edits Recruiter", "success" : false]
        CandidateStubApi.getCancellationReason = stubData1
        withDrawnViewController.reasonTextView.text = "reason"
        withDrawnViewController.isNavigatingFrom = RevertReport.addComment
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
           exp.fulfill()
        }
         wait(for: [exp], timeout: 2.0)
        withDrawnViewController.withDrawnAction(0)
        
        let stubData : [String : Any] = ["message" : "candidates moved to withdrawn status", "interview_report_status": "Request Edits Recruiter", "success" : true]
        CandidateStubApi.getCancellationReason = stubData
        
        withDrawnViewController.reasonTextView.text = "Comment"
        withDrawnViewController.withDrawnAction(0)
        
        withDrawnViewController.reasonTextView.text = "TYPE_REASON".localized
        withDrawnViewController.withDrawnAction(0)
        
        withDrawnViewController.reasonTextView.text = "reason"
        withDrawnViewController.isNavigatingFrom = RevertReport.addComment
        let exp2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
           exp2.fulfill()
        }
         wait(for: [exp2], timeout: 2.0)
        withDrawnViewController.withDrawnAction(0)
        
        withDrawnViewController.reasonTextView.text = "reason"
        withDrawnViewController.isNavigatingFrom = MyinterviewsStatus.report
        let exp3 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
           exp3.fulfill()
        }
         wait(for: [exp3], timeout: 2.0)
        withDrawnViewController.withDrawnAction(0)
    }
    
    func testTextViewDidChange(){
        withDrawnViewController.isNavigatingFrom = MyinterviewsStatus.report
        withDrawnViewController.textViewDidChange(withDrawnViewController.reasonTextView)
        
        withDrawnViewController.isNavigatingFrom = RevertReport.addComment
        withDrawnViewController.reasonTextView.text = "reason"
        withDrawnViewController.textViewDidChange(withDrawnViewController.reasonTextView)
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
