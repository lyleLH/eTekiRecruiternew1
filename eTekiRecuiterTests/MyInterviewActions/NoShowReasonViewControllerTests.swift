//
//  NoShowReasonViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class NoShowReasonViewControllerTests: XCTestCase {
     
    var noShowReasonController: NoshowReasonViewController!
    
    override func setUp() {
        noShowReasonController = mainStoryboard.instantiateViewController(withIdentifier: "NoshowReasonViewController") as? NoshowReasonViewController
        noShowReasonController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = noShowReasonController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInstance(){
        XCTAssertNotNil(noShowReasonController.reasonLabel)
        XCTAssertNotNil(noShowReasonController.reasonTitle)
    }
    
    func testNavigatingFromReport() {
        noShowReasonController.isNavigatingFrom = RevertReport.revert
        noShowReasonController.report_status = RevertReport.requestEditsRecruiter
        noShowReasonController.viewDidLoad()
    }
    
    func testNavigatingfromReport() {
        noShowReasonController.isNavigatingFrom = RevertReport.revert
        noShowReasonController.report_status = RevertReport.requestEditsAdmin
        noShowReasonController.viewDidLoad()
    }
    
    func testNavigatingFromreport() {
        noShowReasonController.isNavigatingFrom = RevertReport.revert
        noShowReasonController.report_status = RevertReport.pendingAdminApproval
        noShowReasonController.viewDidLoad()
    }
    
    func testCloseAction(){
        noShowReasonController.cancelAction(0)
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
