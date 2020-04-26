//
//  DashboardViewModalTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 18/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class DashboardViewModalTests: XCTestCase {
   let viewModal =  DashBoardViewModel()
    var datepickerController: DatePcikerViewController!
    func testUpdatesegment(){
        viewModal.updateSegementController()
    }
    
    func testDismissAction(){
        datepickerController.dismiss(animated: false, completion: nil)
        datepickerController.dismissAction(0)
    }
    
    func testreactivateJob() {
        datepickerController.reactivateJobAction(UIButton())
        let dateString = "12-11-2015 10:50:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date2 = dateFormatter.date(from: dateString)!
        datepickerController.datePicker.setDate(date2, animated: false)
        let manager = JobsManager(jobID: "3968", due_at: "12-09-2019")
        let response = CreateJobResponse(json: [:], success: true, message: "job status move to active")
        DashboardStubApi.reactivateJobCall = response
        JobListingAPI.reactivateJob(jobDetails: manager) {(response, Error) in
            print(response)
        }
        datepickerController.reactivateJobAction(UIButton())
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.async {
            expectation.fulfill()
        
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testsetUpCreateJob(){
        viewModal.segmentContoller.selectedSegmentIndex = 1
        viewModal.setUpCreateJob()
    }
    
    override func setUp() {
        datepickerController = mainStoryboard.instantiateViewController(withIdentifier: "datePickerViewController") as? DatePcikerViewController
               datepickerController.view.layoutIfNeeded()
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
