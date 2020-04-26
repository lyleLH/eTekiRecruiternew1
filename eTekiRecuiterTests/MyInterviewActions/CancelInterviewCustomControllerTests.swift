//
//  CancelInterviewCustomControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 12/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class CancelInterviewCustomControllerTests: XCTestCase {
    
    var cancelInterviewCustomController: CancelInterviewCustomController!
    
    override func setUp() {
        cancelInterviewCustomController = mainStoryboard.instantiateViewController(withIdentifier: "CancelInterviewCustomController") as? CancelInterviewCustomController
        cancelInterviewCustomController.infoData = ["id": "2345"]
        cancelInterviewCustomController.noAction(0)
        cancelInterviewCustomController.yesAction(0)
        cancelInterviewCustomController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = cancelInterviewCustomController
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
