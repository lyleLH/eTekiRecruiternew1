//
//  MorreActionsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 04/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class MorreActionsViewControllerTests: XCTestCase {
    var moreActionController: MoreActionsViewController!
    var createJobNavigationController: UINavigationController!
    
    func testOverridePrepare(){
    let segue = UIStoryboardSegue(identifier: "MoreToJobDetails", source: moreActionController, destination: UINavigationController())
       moreActionController.prepare(for: segue, sender: nil)
        XCTAssertEqual(segue.destination.view.translatesAutoresizingMaskIntoConstraints, true)
    }
    
    func testTableviewCellforRowat(){
        let cell = moreActionController.actionsTableView.dequeueReusableCell(withIdentifier: "MoreActionsCell", for: IndexPath(row: 0, section: 0)) as! MoreActionsCell
      moreActionController.tableView(moreActionController.actionsTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        moreActionController.setUpView()
    }
    
    func testDidselectRowat(){
       moreActionController.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToJobDetails, sender: self)
        selectMoreOptions()
       
    }
    
    func selectMoreOptions(){
        moreActionController.tableView(moreActionController.actionsTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        moreActionController.tableView(moreActionController.actionsTableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        moreActionController.tableView(moreActionController.actionsTableView, didSelectRowAt: IndexPath(row: 2, section: 0))
        moreActionController.tableView(moreActionController.actionsTableView, didSelectRowAt: IndexPath(row: 3, section: 0))
        moreActionController.tableView(moreActionController.actionsTableView, didSelectRowAt: IndexPath(row: 4, section: 0))
        moreActionController.tableView(moreActionController.actionsTableView, didSelectRowAt: IndexPath(row: 5, section: 0))
    }
    func testMoreActions(){
        moreActionController.currentSelection =  StoryboardIdentifiers.candidatesViewController
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
    
    func testMoreActionsHaveCompleted() {
         moreActionController.currentSelection =  StoryboardIdentifiers.candidatesViewController
        moreActionController.activeStatus = .completed
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
     
    func testMoreActionsHaveScheduled(){
         moreActionController.currentSelection =  StoryboardIdentifiers.candidatesViewController
        moreActionController.activeStatus = .scheduled
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
    
    func testMoreActionsHaveWithdrawn(){
         moreActionController.currentSelection =  StoryboardIdentifiers.candidatesViewController
        moreActionController.activeStatus = .withdrawn
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
     
    func testMoreActionsinActive(){
        moreActionController.currentSelection =  StoryboardIdentifiers.dashboardViewController
        moreActionController.activeStatus = .active
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
    
    func testLoginAsIndependantRecruiter(){
        moreActionController.currentSelection =  StoryboardIdentifiers.dashboardViewController
        moreActionController.activeStatus = .active
        moreActionController.isIndependantRecruiter = true
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
    
    func testLoginAsNormalRecruiter(){
        moreActionController.currentSelection =  StoryboardIdentifiers.dashboardViewController
        moreActionController.activeStatus = .active
        moreActionController.isIndependantRecruiter = false
        moreActionController.isCollaborateJob = true
        moreActionController.isNotAdmin = true
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
    
    func testContributorJobActions(){
        moreActionController.currentSelection =  StoryboardIdentifiers.dashboardViewController
        moreActionController.activeStatus = .inActive
        moreActionController.isCollaborateJob = true
        moreActionController.isNotAdmin = true
        moreActionController.setupMoreActions()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
        moreActionController.actionsTableView.reloadData()
        selectMoreOptions()
    }
    
    override func setUp() {
        moreActionController = mainStoryboard.instantiateViewController(withIdentifier: "MoreActionsViewController") as? MoreActionsViewController
        createJobNavigationController = UINavigationController(rootViewController: moreActionController)
        moreActionController.view.layoutIfNeeded()
        createJobNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = createJobNavigationController
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
