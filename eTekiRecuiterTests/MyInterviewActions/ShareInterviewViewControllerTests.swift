//
//  ShareInterviewViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class ShareInterviewViewControllerTests: XCTestCase {
    
    var shareInteviewViewController: ShareInterviewViewController!
    var shareInteviewNavigationController: UINavigationController!
    
    override func setUp() {
        shareInteviewViewController = mainStoryboard.instantiateViewController(withIdentifier: "ShareInterviewViewController") as? ShareInterviewViewController
        shareInteviewNavigationController = UINavigationController(rootViewController: shareInteviewViewController)
        shareInteviewViewController.jobListingAPI = DashboardStubApi.self
        shareInteviewViewController.currentIndex = 1
        shareInteviewViewController.inteviewStatus = .completed
        shareInteviewViewController.view.layoutIfNeeded()
        shareInteviewNavigationController.view.layoutIfNeeded()
        shareInteviewNavigationController.setPresentation()
        UIApplication.shared.keyWindow?.rootViewController = shareInteviewNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
   
    func testInstance() {
        XCTAssertNotNil(shareInteviewViewController, "Not able to create matchedInterviewersController Instance.")
        XCTAssertNotNil(shareInteviewViewController.addButton, "add Button item instance is not nil.")
        XCTAssertNotNil(shareInteviewViewController.interviewersTableView, "Not able to create interviewsTableView Instance.")
        XCTAssertNotNil(shareInteviewViewController.shareInterviewButton, "shareInterviewButton item instance is not nil.")
        XCTAssertNotNil(shareInteviewViewController.emailTextField, "emailTextField item instance is not nil.")
    }
    
    //get Email List
    func testGetEmailList(){
        shareInteviewViewController.responseArray = [["email": "afrin@mail.com"]]
        let stubData : [String : Any] = ["total_count": 2, "interview_accesses": [["email": "afrin@mail.com"], ["email": "afrin@mail.com"]], "success": true]
        DashboardStubApi.getJobsCall = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        shareInteviewViewController.getEmailList(jobID: "1234")
    }
    
    // while adding email check validations
    func testAddAction(){
        //when email field is Empty
        shareInteviewViewController.addButtonAction(0)
        XCTAssertEqual(shareInteviewViewController.emailTextField.text, "")
        
        //when invalid email enters
        shareInteviewViewController.emailTextField.text = "sdfdsfs"
        shareInteviewViewController.addButtonAction(0)
        XCTAssertNotNil(shareInteviewViewController.emailTextField.text)
        
        //Adding already exsited mail
        shareInteviewViewController.emailTextField.text = "afrin@mail.com"
        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"], ["email": "afrin123@mail.com"]]
        shareInteviewViewController.addButtonAction(0)
        
        //Adding a new valid email
        shareInteviewViewController.emailTextField.text = "afrin222@mail.com"
        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"], ["email": "afrin123@mail.com"]]
        let stubData : [String : Any] = ["message": "Provided Email is added", "success": true]
        DashboardStubApi.getJobsCall = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        shareInteviewViewController.addButtonAction(0)
    }
    
    // Listing email into tableview
    func testcellForRowat(){
        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"], ["email": "afrin123@mail.com"]]
        let cell = shareInteviewViewController.tableView(shareInteviewViewController.interviewersTableView, cellForRowAt:  IndexPath(row: 0, section: 0)) as? ShareInterviewTableViewCell
        XCTAssertEqual(cell?.emailId.text, "afrin@mail.com")
    }
    
    // cell height for row should be 48
    func testCellHeight(){
      shareInteviewViewController.tableView(shareInteviewViewController.interviewersTableView, heightForRowAt: IndexPath(row: 0, section: 0)) as? ShareInterviewTableViewCell
    }
    
    // Exsited mail is removing Action
    func testRemoveMailAction(){
        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"], ["email": "afrin123@mail.com"]]
        let cell = shareInteviewViewController.tableView(shareInteviewViewController.interviewersTableView, cellForRowAt:  IndexPath(row: 0, section: 0)) as? ShareInterviewTableViewCell
        shareInteviewViewController.removeMailAction(cell?.deleteButton ?? UIButton())
    }
    
    // remove mail call
    func testRemoveMail(){
        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"], ["email": "afrin123@mail.com"]]
        let notification = NSNotification(name: NSNotification.Name(rawValue: StoryboardSegueIdentifiers.shareInterviewToCustomAlert), object: 0, userInfo: nil)
        let stubData : [String : Any] = ["message": "Provided Email is removed", "success": true]
        DashboardStubApi.getJobsCall = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        shareInteviewViewController.removeMail(notification: notification)
        
//        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"]]
        let notification1 = NSNotification(name: NSNotification.Name(rawValue: StoryboardSegueIdentifiers.shareInterviewToCustomAlert), object: 0, userInfo: nil)
        let stubData1 : [String : Any] = ["message": "Provided Email is removed", "success": true]
        DashboardStubApi.getJobsCall = stubData1
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 4.0)
        shareInteviewViewController.removeMail(notification: notification1)
    }
    
    //Share added email by clicking on share button
    func testShareEmailsAction(){
        shareInteviewViewController.interviewCode = "123"
        let stubData1 : [String : Any] = ["message": "Job is shared with respective emails", "success": true]
               DashboardStubApi.getJobsCall = stubData1
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        shareInteviewViewController.shareInterviewAction(0)
    }
    
    //back navigation action
    func testBackAction(){
        shareInteviewViewController.backAction(0)
    }
    
    func testScrollDidEndDragging(){
        shareInteviewViewController.scrollViewDidEndDragging(shareInteviewViewController.interviewersTableView, willDecelerate: false)
        shareInteviewViewController.totalCount = 5
        shareInteviewViewController.dataArray = [["email": "afrin@mail.com"], ["email": "afrin123@mail.com"]]
        shareInteviewViewController.scrollViewDidEndDragging(shareInteviewViewController.interviewersTableView, willDecelerate: false)
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
