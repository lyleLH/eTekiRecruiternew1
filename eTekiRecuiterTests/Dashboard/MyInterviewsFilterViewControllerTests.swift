//
//  MyInterviewsFilterViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 12/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
import SimpleCheckbox
@testable import eTekiRecruiter

class MyInterviewsFilterViewControllerTests: XCTestCase {
    
    var myInterviewsFilterViewController: MyInterviewsFiltersViewController!
    var myInterviewFilterNavigationController: UINavigationController!

    override func setUp() {
        myInterviewsFilterViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyInterviewsFiltersViewController") as? MyInterviewsFiltersViewController
        myInterviewFilterNavigationController = UINavigationController(rootViewController: myInterviewsFilterViewController)
        myInterviewsFilterViewController.selectedfilterArray = [MyinterviewsStatus.scheduled, MyinterviewsStatus.inProgress, MyinterviewsStatus.pendingSubmission, MyinterviewsStatus.pendingApproval, MyinterviewsStatus.pendingResubmission, MyinterviewsStatus.pendingReport, MyinterviewsStatus.completed, MyinterviewsStatus.priorHour, MyinterviewsStatus.lateCancellation, MyinterviewsStatus.waitingOnCandidate, MyinterviewsStatus.waitingOnInterviewer, MyinterviewsStatus.candidatePending, MyinterviewsStatus.candidateConfirmed, MyinterviewsStatus.interViewerPending, MyinterviewsStatus.interviewerConfirmed, MyinterviewsStatus.pendingPayment, MyinterviewsStatus.myInterviews, MyinterviewsStatus.contributorInterviews ]
        
        myInterviewsFilterViewController.view.layoutIfNeeded()
        myInterviewFilterNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = myInterviewFilterNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testScenarioWhileFiltersDropdownExpandingAndCollapsing(){
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[0].opened)
        myInterviewsFilterViewController.tableView(myInterviewsFilterViewController.myInterviewsFilterTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? MyInterviewsFilterTableViewCell
        
        XCTAssertTrue(myInterviewsFilterViewController.tableViewData[0].opened)
        
        myInterviewsFilterViewController.tableView(myInterviewsFilterViewController.myInterviewsFilterTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? MyInterviewsFilterTableViewCell
        
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[0].opened)
    }
    
    func testScenarioWhenSubmittingFilterStatus(){
        myInterviewsFilterViewController.saveFiltersAction(0)
        checkInterviewFilterStatusesCheckedOrNot()
        checkReportFilterStatusesCheckedOrNot()
        checkCancelledFilterStatusesCheckedOrNot()
        checkNoShowFilterStatusesCheckedOrNot()
        checkSchedulingFilterStatusesCheckedOrNot()
    }
    
    func checkInterviewFilterStatusesCheckedOrNot(){
       XCTAssertEqual(myInterviewsFilterViewController.tableViewData[0].title, "Interview")
        
       XCTAssertEqual(myInterviewsFilterViewController.tableViewData[0].sectionData[0]["name"] as? String ?? "", MyinterviewsStatus.scheduled)
       XCTAssertTrue(myInterviewsFilterViewController.tableViewData[0].sectionData[0]["status"] as? Bool ?? false)
        
       XCTAssertEqual(myInterviewsFilterViewController.tableViewData[0].sectionData[1]["name"] as? String ?? "", MyinterviewsStatus.inProgress)
       XCTAssertTrue(myInterviewsFilterViewController.tableViewData[0].sectionData[1]["status"] as? Bool ?? false)
    }
    
    func checkReportFilterStatusesCheckedOrNot(){
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[1].title, "Report")
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[1].sectionData[0]["name"] as? String ?? "", MyinterviewsStatus.pendingReport)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[1].sectionData[0]["status"] as? Bool ?? false)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[1].sectionData[1]["name"] as? String ?? "", MyinterviewsStatus.pendingApproval)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[1].sectionData[1]["status"] as? Bool ?? false)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[1].sectionData[2]["name"] as? String ?? "", MyinterviewsStatus.pendingResubmission)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[1].sectionData[2]["status"] as? Bool ?? false)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[1].sectionData[3]["name"] as? String ?? "", MyinterviewsStatus.completed)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[1].sectionData[3]["status"] as? Bool ?? false)
    }
    
    func checkCancelledFilterStatusesCheckedOrNot(){
        XCTAssertEqual(myInterviewsFilterViewController.tableViewData[2].title, MyinterviewsStatus.cancelled)
          
        XCTAssertEqual(myInterviewsFilterViewController.tableViewData[2].sectionData[0]["name"] as? String ?? "", MyinterviewsStatus.priorHour)
        XCTAssertTrue(myInterviewsFilterViewController.tableViewData[2].sectionData[0]["status"] as? Bool ?? false)
          
        XCTAssertEqual(myInterviewsFilterViewController.tableViewData[2].sectionData[1]["name"] as? String ?? "", MyinterviewsStatus.lateCancellation)
        XCTAssertTrue(myInterviewsFilterViewController.tableViewData[2].sectionData[1]["status"] as? Bool ?? false)
    }
    
    func checkNoShowFilterStatusesCheckedOrNot(){
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[3].title, MyinterviewsStatus.noShow)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[3].sectionData[0]["name"] as? String ?? "", MyinterviewsStatus.candidatePending)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[3].sectionData[0]["status"] as? Bool ?? false)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[3].sectionData[1]["name"] as? String ?? "", MyinterviewsStatus.candidateConfirmed)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[3].sectionData[1]["status"] as? Bool ?? false)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[3].sectionData[2]["name"] as? String ?? "", MyinterviewsStatus.interViewerPending)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[3].sectionData[2]["status"] as? Bool ?? false)
        
      XCTAssertEqual(myInterviewsFilterViewController.tableViewData[3].sectionData[3]["name"] as? String ?? "", MyinterviewsStatus.interviewerConfirmed)
      XCTAssertTrue(myInterviewsFilterViewController.tableViewData[3].sectionData[3]["status"] as? Bool ?? false)
        
    }
    
    func checkSchedulingFilterStatusesCheckedOrNot(){
        XCTAssertEqual(myInterviewsFilterViewController.tableViewData[4].title, "Scheduling")
          
        XCTAssertEqual(myInterviewsFilterViewController.tableViewData[4].sectionData[0]["name"] as? String ?? "", MyinterviewsStatus.waitingOnCandidate)
        XCTAssertTrue(myInterviewsFilterViewController.tableViewData[4].sectionData[0]["status"] as? Bool ?? false)
          
        XCTAssertEqual(myInterviewsFilterViewController.tableViewData[4].sectionData[1]["name"] as? String ?? "", MyinterviewsStatus.waitingOnInterviewer)
        XCTAssertTrue(myInterviewsFilterViewController.tableViewData[4].sectionData[1]["status"] as? Bool ?? false)
    }
    
    func testCheckBoxActions(){
        let cell = myInterviewsFilterViewController.tableView(myInterviewsFilterViewController.myInterviewsFilterTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? MyInterviewsFilterTableViewCell
        myInterviewsFilterViewController.checkBoxActions(cell?.filterCheckBox ?? Checkbox())
    }
    
    func testClearFilterStatuses(){
        myInterviewsFilterViewController.applyAction(0)
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[0].sectionData[0]["status"] as? Bool ?? false)
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[1].sectionData[0]["status"] as? Bool ?? false)
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[2].sectionData[0]["status"] as? Bool ?? false)
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[3].sectionData[0]["status"] as? Bool ?? false)
        XCTAssertFalse(myInterviewsFilterViewController.tableViewData[4].sectionData[0]["status"] as? Bool ?? false)
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
