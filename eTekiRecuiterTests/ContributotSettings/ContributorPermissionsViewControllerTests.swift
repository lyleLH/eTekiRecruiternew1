//
//  ContributorPermissionsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 24/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class ContributorPermissionsViewControllerTests: XCTestCase {
   
     var contributorPermissionsController: ContributorPermissionsViewController!
     var contributorPermissionsNavigationController: UINavigationController!
        
    override func setUp() {
        contributorPermissionsController = mainStoryboard.instantiateViewController(withIdentifier: "ContributorPermissions") as? ContributorPermissionsViewController
                contributorPermissionsNavigationController = UINavigationController(rootViewController: contributorPermissionsController)
                contributorPermissionsController.jobPermissions =   [
                    "Candidate Edit" : 1,
                    "Candidate Notify" : 1,
                    "Candidate View" : 1,
                    "Interview Edit" : 1,
                    "Interview Notify" : 1,
                    "Interview View" : 1,
                    "Job Edit" : 1,
                    "Job Notify" : 1,
                    "Job View" : 1,
                ]
                contributorPermissionsController.view.layoutIfNeeded()
                contributorPermissionsNavigationController.view.layoutIfNeeded()
                UIApplication.shared.keyWindow?.rootViewController = contributorPermissionsNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
   
    func testCloseAction(){
        contributorPermissionsController.closeAction(0)
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
