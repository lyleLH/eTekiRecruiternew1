//
//  CancelInterviewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
import SimpleCheckbox
@testable import eTekiRecruiter

class CancelInterviewControllerTests: XCTestCase {
    
    var cancelInteviewViewController: CancelInterviewViewController!
    var cancelInteviewNavigationController: UINavigationController!
    
    override func setUp() {
        cancelInteviewViewController = mainStoryboard.instantiateViewController(withIdentifier: "CancelInterviewViewController") as? CancelInterviewViewController
        cancelInteviewNavigationController = UINavigationController(rootViewController: cancelInteviewViewController)
        cancelInteviewViewController.candidatesAPI = CandidateStubApi.self
        cancelInteviewViewController.infoData = ["title": "Title", "startTime": "22-Oct-2020 10AM"]
        cancelInteviewViewController.view.layoutIfNeeded()
        cancelInteviewNavigationController.view.layoutIfNeeded()
        cancelInteviewNavigationController.setPresentation()
        UIApplication.shared.keyWindow?.rootViewController = cancelInteviewNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    //Open textview while press on others option
    func testOthersOptionDidSelect(){
        cancelInteviewViewController.status = false
        cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, didSelectRowAt: IndexPath(row: 4, section: 0)) as? CancelInterviewCell
        
         cancelInteviewViewController.count = 6
        cancelInteviewViewController.status = false
         let cell = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, didSelectRowAt: IndexPath(row: 4, section: 0)) as? CancelInterviewCell
        cell?.commentTextView.text = "Comments"
        
        cancelInteviewViewController.count = 5
        cancelInteviewViewController.status = false
         let cell3 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, didSelectRowAt: IndexPath(row: 3, section: 0)) as? CancelInterviewCell
        cell3?.commentTextView.text = ""
        
        cancelInteviewViewController.count = 6
        cancelInteviewViewController.status = false
         let cell1 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, didSelectRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cell1?.commentTextView.text = "Comments"
        
        cancelInteviewViewController.count = 6
        cancelInteviewViewController.status = false
         let cell2 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, didSelectRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cell2?.commentTextView.text = ""
    }
    
    // Any option is selected set its value as true
    func testCheckboxSelection(){
         let cell2 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, didSelectRowAt: IndexPath(row: 3, section: 0)) as? CancelInterviewCell
        cancelInteviewViewController.checkboxSelected(cell2?.checkBox ?? Checkbox())
    }
    
    //when press on cancel action
    func testNoAction(){
        cancelInteviewViewController.noAction(0)
        
        cancelInteviewViewController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
        cancelInteviewViewController.noAction(0)
    }
    
    // when press on submit button
    func testYesAction(){
        cancelInteviewViewController.yesAction(0)
        
        cancelInteviewViewController.count = 6
        cancelInteviewViewController.data = [["name": "Data Unavailable", "isChecked": true]]
        let stubData : [String : Any] = ["message": "Successfully cancellede Interview", "interview": [],  "success": false]
        CandidateStubApi.getCancellationReason = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        cancelInteviewViewController.yesAction(0)
        
        cancelInteviewViewController.count = 6
        cancelInteviewViewController.data = [["name": "Data Unavailable", "isChecked": true]]
        let stubData1 : [String : Any] = ["message": "Successfully cancellede Interview", "interview": [],  "success": true]
        CandidateStubApi.getCancellationReason = stubData1
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        cancelInteviewViewController.yesAction(0)
    }
    
    //when textview starts editing
    func testTextViewStartsEditing(){
        let cell2 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, cellForRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cancelInteviewViewController.textViewDidBeginEditing(cell2!.commentTextView)
    }
    
    //when textview stops editing
    func testTextViewEndEditing(){
       let cell = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, cellForRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cell?.commentTextView.text = ""
        cancelInteviewViewController.textViewDidEndEditing(cell!.commentTextView)
    }
    
    //when textview  editing
    func testTextViewEditing(){
      let cell = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, cellForRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
      cancelInteviewViewController.textViewDidChange(cell!.commentTextView)
        
        let cell1 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, cellForRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cell1?.commentTextView.text = "comments"
        cancelInteviewViewController.textViewDidChange(cell1!.commentTextView)
    }
    
    func testTextViewShouldChangeChars(){
         let cell = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, cellForRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cancelInteviewViewController.textView(cell!.commentTextView, shouldChangeTextIn: NSRange(), replacementText: "\n")
        
        let cell1 = cancelInteviewViewController.tableView(cancelInteviewViewController.optionsTableView, cellForRowAt: IndexPath(row: 5, section: 0)) as? CancelInterviewCell
        cancelInteviewViewController.textView(cell1!.commentTextView, shouldChangeTextIn: NSRange(), replacementText: "DFGD")
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
