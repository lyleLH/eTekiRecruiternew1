//
//  CustomAlertViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 24/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class CustomAlertViewControllerTests: XCTestCase {
   var customViewController: CustomAlertViewController!
    var customPopOverController : CustomPopoverViewController!
    var datePickerController : DatePcikerViewController!
    var customTickController : CustomTickViewController!
    func testYesAction(){
        let manager = JobsManager(jobID: "3968")
        let response = CreateJobResponse(json: ["message": "job status move to Inactive"], success: true, message: "job status move to Inactive")
        DashboardStubApi.closeJobs = response
        customViewController.yesAction(0)
    }
    
    func testNoAction(){
        customViewController.noAction(0)
    }
    
    func testDismissAction(){
        datePickerController.dismissAction(0)
    }
    
    
    func testReactivateJobAction(){
        let exp2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 1.5)
        datePickerController.reactivateJobAction(UIButton())
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 3, to: today)
        datePickerController.datePicker.date = tomorrow ?? Date()
        datePickerController.showSpinner()
        let manager = JobsManager(jobID: "3968", due_at: "30-10-2019")
        let response = CreateJobResponse(json: ["message": "job status move to active"], success: true, message: "job status move to active")
        DashboardStubApi.reactivateJobCall = response
        datePickerController.reactivateJobAction(UIButton())
    }
    
    func testUpdateView(){
        customViewController.isNavigatingFrom = StoryboardSegueIdentifiers.analyticsToCustomMessage
        customViewController.updateView()
        
        customViewController.isNavigatingFrom = "withdraw"
        customViewController.updateView()
        
        customViewController.isNavigatingFrom = "myInterviewsCancelInterview"
        customViewController.updateView()
    }
    
    func testClosePopUpAction(){
        customViewController.closePopUpAction(0)
        customTickController.closeAction(0 )
    }
    
    func testNoActionforAnalytics(){
        customViewController.isNavigatingFrom = StoryboardSegueIdentifiers.analyticsToCustomMessage
        customViewController.noAction(0)
    }
    
    func testYesActionForAnalytics(){
        customViewController.isNavigatingFrom = StoryboardSegueIdentifiers.analyticsToCustomMessage
        customViewController.yesAction(0)
    }
    
    func testYesActionForAvailibility(){
        customViewController.infoData = ["selectedEvent": Date()]
        customViewController.isNavigatingFrom = StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage
        customViewController.yesAction(0)
    }
    
    func testYesActionForContributors(){
        customViewController.isNavigatingFrom = StoryboardSegueIdentifiers.contributorsToCustomMessage
        customViewController.yesAction(0)
    }
    
    func testYesActionForShareinterview(){
        customViewController.isNavigatingFrom = StoryboardSegueIdentifiers.shareInterviewToCustomAlert
        customViewController.yesAction(0)
    }
    
    func testYesActionForWithdrawn(){
        customViewController.isNavigatingFrom = "withdraw"
        customViewController.yesAction(0)
    }
    
    func testYesActionForMyInreviews(){
        customViewController.isNavigatingFrom = "myInterviewsCancelInterview"
        customViewController.infoData = ["id": "3232", "title": "title"]
        
        let stubData2 = ["message": "No payment required for this cancellation", "success": false, "interview_id": 2334] as [String : Any]
        CandidateStubApi.getCancellationReason = stubData2
        let exp2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 2.5)
        customViewController.yesAction(0)
        
        let stubData = ["message": ["Successfully cancelled Interview"], "success": true, "interview_id": 2334] as [String : Any]
        CandidateStubApi.getCancellationReason = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        customViewController.yesAction(0)
        
        let stubData1 = ["message": ["No payment required for this cancellation"], "success": true, "interview_id": 2334] as [String : Any]
        CandidateStubApi.getCancellationReason = stubData1
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.5)
        customViewController.yesAction(0)
    }
    
    func testYesActionForCloseJob(){
        let stubData1 = CreateJobResponse(json: ["message": "Job Closed"] , success: true, message: "")
        DashboardStubApi.getJobsApiCall = stubData1
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.5)
        customViewController.yesAction(0)
    }
    
    func testUpdateCandidateHiredStatus(){
        customViewController.infoData = ["candidate_id" : "3348", "analytic_status" : "Interviewed", "proxied": true]
        let stubData = ["message": "Analytics Updated"]
        CandidateStubApi.getCandidatesresponse = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        customViewController.updateCandidateHiredStatus()
    }
    
    override func setUp() {
        customPopOverController = mainStoryboard.instantiateViewController(withIdentifier: "customPopoverViewController") as? CustomPopoverViewController
        customPopOverController.view.layoutIfNeeded()
        customTickController = mainStoryboard.instantiateViewController(withIdentifier: "CustomTickViewController") as? CustomTickViewController
        customTickController.view.layoutIfNeeded()
        customViewController = mainStoryboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController
        customViewController.candidatesAPI = CandidateStubApi.self
        customViewController.view.layoutIfNeeded()
        datePickerController = mainStoryboard.instantiateViewController(withIdentifier: "datePickerViewController") as? DatePcikerViewController
        datePickerController.view.layoutIfNeeded()
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
