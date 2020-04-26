//
//  CancelConfirmedControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class CancelConfirmedControllerTests: XCTestCase {
     
    var cancelConfirmedController: CancellationConfirmedViewController!
    
    override func setUp() {
        cancelConfirmedController = mainStoryboard.instantiateViewController(withIdentifier: "CancellationConfirmedViewController") as? CancellationConfirmedViewController
        cancelConfirmedController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = cancelConfirmedController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // Click on Withdrawn action
    func testWithdrawnAction(){
        cancelConfirmedController.infoData = ["candidate_id": 1233]
        cancelConfirmedController.withdrawAction(0)
        
        cancelConfirmedController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
        cancelConfirmedController.withdrawAction(0)
    }
    
    // Close PopupAlert action
    func testClosePopupAction(){
        cancelConfirmedController.closeAction(0)
        
        cancelConfirmedController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
        cancelConfirmedController.closeAction(0)
    }
    
    //Reschedule Action
    func testRescheduleAction(){
        cancelConfirmedController.rescheduleAction(0)
    }
    
    func testViewDidLoad(){
        cancelConfirmedController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
        cancelConfirmedController.viewDidLoad()
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
