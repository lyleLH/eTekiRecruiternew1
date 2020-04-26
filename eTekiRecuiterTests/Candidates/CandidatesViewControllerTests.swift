//
//  CandidatesViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 23/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class CandidatesViewControllerTests: XCTestCase {
    
    var candidatesViewController: CandidatesViewController!
    var candidatesNavigationController: UINavigationController!
    var cell : CandidateViewCell! = nil
    
    override func setUp() {
        super.setUp()
        candidatesViewController = mainStoryboard.instantiateViewController(withIdentifier: "CandidatesViewController") as? CandidatesViewController
        candidatesNavigationController = UINavigationController(rootViewController: candidatesViewController)
        let stubData : [String : Any] = ["candidates" : [["first_name" : "sivasagar","full_name" : "sivasagar candidates", "id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "completed", "time_zone" : "US/Alaska","profile_pics" :     [
           "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
           "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
           "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
           "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
        ]]],"success" : true,"total_count" : 1]
        CandidateStubApi.getCandidatesresponse = stubData
        candidatesViewController.candidatesAPI = CandidateStubApi.self
        candidatesViewController.view.layoutIfNeeded()
        candidatesNavigationController.view.layoutIfNeeded()
        candidatesNavigationController.setPresentation()
        cell = self.candidatesViewController.candidatesTableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? CandidateViewCell
        UIApplication.shared.keyWindow?.rootViewController = candidatesNavigationController
    }
    
    override func tearDown() {
        candidatesViewController = nil
        candidatesNavigationController = nil
        cell = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(candidatesViewController, "Not able to create candidatesViewController Instance.")
        XCTAssertNotNil(candidatesViewController.searchContatinerView, "Not able to create searchContatinerView Instance.")
        XCTAssertNotNil(candidatesViewController.candidatesTableView, "Not able to create candidatesTableView Instance.")
        XCTAssertNotNil(candidatesViewController.searchBar, "Not able to create searchBar Instance.")
        XCTAssertNotNil(candidatesViewController.anchorView, "Not able to create anchorView Instance.")
        XCTAssertNotNil(candidatesViewController.selectStatusButton, "Not able to create selectStatusButton Instance.")
        XCTAssertNotNil(candidatesViewController.listContainerView, "Not able to create selectStatusButton Instance.")
        XCTAssertNotNil(candidatesViewController.noDataView, "Not able to create selectStatusButton Instance.")
        XCTAssertNotNil(candidatesViewController.addCandidateButton, "Not able to create selectStatusButton Instance.")
    }
    
    /*! @brief Scenario when user taps on add candidate button with expired due date. */
    func testScenarioAddCandidateButtonWithExpiredDueDate() {


        candidatesViewController.jobClosingDate = CannedDataConstant.jobExpiredDate
        candidatesViewController.addCandidateButton?.sendActions(for: .touchUpInside)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            guard let candidatesViewController = UIApplication.topMostViewController() as? CandidatesViewController else {
                XCTFail("CandidatesViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(candidatesViewController, "Not able to Navigate CandidatesViewController, instance is nil.")
            candidatesViewController.view.layoutIfNeeded()
            XCTAssertEqual(candidatesViewController.navigationItem.title, "Candidates", "candidatesViewController not loaded")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 7.0)

    }
    
    /*! @brief Scenario when user taps on add candidate button with valid due date. */
    func testScenarioAddCandidateButtonWithValidDueDate() {
        candidatesViewController.jobClosingDate = CannedDataConstant.jobClosedDate
        candidatesViewController.addCandidateButton?.sendActions(for: .touchUpInside)

        let expectation = XCTestExpectation(description: "test")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let addCandidateViewController = UIApplication.topMostViewController() as? AddCandidateViewController else {
                XCTFail("AddCandidateViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(addCandidateViewController, "Not able to Navigate AddCandidateViewController, instance is nil.")
            addCandidateViewController.view.layoutIfNeeded()
            XCTAssertEqual(addCandidateViewController.navigationItem.title, "Add Candidate", "candidatesViewController not loaded")
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    /*! @brief Scenario when user loads the view with candidates data*/
    func testScenarioCandidatesTableViewWithData() {
        let stubData : [String : Any] = ["candidates" : [["id" : 3455,"first_name" : "sivasagar","full_name" : "sivasagar candidates", "job_id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "completed", "time_zone" : "US/Alaska"]],"success" : true,"total_count" : 1]
        CandidateStubApi.getCandidatesresponse = stubData
        candidatesViewController.loadCandidates()
        let expectation = XCTestExpectation(description: "test")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //XCTAssertNotNil(self.candidatesViewController.listContainerView, "list Container instance not created")
            XCTAssertFalse(self.candidatesViewController.listContainerView?.isHidden ?? true,"Candidate Table view is hidden")
            XCTAssertFalse(self.candidatesViewController.candidatesTableView?.isHidden ?? true, "Candidate Table view is hidden")
            XCTAssertTrue(self.candidatesViewController.noDataView?.isHidden ?? false, "No Data View is not Hidden")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)
    }
    
    /*! @brief Scenario when user loads the view with out candidates data */
    func testScenarioCandidatesTableViewWithOutData() {
        let stubData : [String : Any] = ["candidates" : [],"success" : true,"total_count" : 0]
        CandidateStubApi.getCandidatesresponse = stubData
        candidatesViewController.loadCandidates()
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
           // XCTAssertTrue(self.candidatesViewController.listContainerView?.isHidden ?? false, "Candidate Table view is hidden")
            XCTAssertNotNil(self.candidatesViewController.noDataView, "noDataView  is created")
            //XCTAssertFalse(self.candidatesViewController.noDataView?.isHidden ?? true, "noDataView Table view is hidden")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    /*! @brief Scenario when user taps on More action */
    func testScenarioWhenUsersTapsOnMoreActionWithCompletedStatus() {
        
        let stubData : [String : Any] = ["candidates" : [[ "first_name" : "sivasagar","full_name" : "sivasagar candidates", "id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "completed", "time_zone" : "US/Alaska"]],"success" : true,"total_count" : 1]
        CandidateStubApi.getCandidatesresponse = stubData
        candidatesViewController.loadCandidates()


        let expectation = XCTestExpectation(description: "test")

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

            let testRow = IndexPath(row: 0, section: 0)
            guard let cell =       self.candidatesViewController.candidatesTableView?.dataSource?.tableView(self.candidatesViewController.candidatesTableView ?? UITableView(), cellForRowAt: testRow) as? CandidateViewCell else {return}
            cell.moreButton.sendActions(for: .touchUpInside)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

                guard let moreActionsViewController = UIApplication.topMostViewController() as? MoreActionsViewController else {
                    //XCTFail("MoreActionsViewController is not Top most view controller.")
                    return
                }
                XCTAssertNotNil(moreActionsViewController, "Not able to Navigate moreActionsViewController, instance is nil.")
                moreActionsViewController.view.layoutIfNeeded()
                XCTAssertEqual(moreActionsViewController.currentSelection, "CandidatesViewController", "Not from CandidatesController")
                expectation.fulfill()

            }
        }

        wait(for: [expectation], timeout: 7.0)
    }
    
    /*! @brief Scenario when search bar text chages */
    func testSearchFieldDidChange(){
        candidatesViewController.searchBar(candidatesViewController.searchBar, textDidChange: "")
        XCTAssertEqual(candidatesViewController.searchText, "")
    }
    
    /*! @brief Scenario when user taps on search button */
    func testSearchButtonTapped(){
        candidatesViewController.searchBarSearchButtonClicked(candidatesViewController.searchBar)
    }
    
   /*! @brief Scenario when uset taps on status action */
    func testStatusButtonTapped(){
        candidatesViewController.selectStatusButton.sendActions(for: .touchUpInside)
    }
    
    /*! @brief Scenario when user taps on back navigation Button */
    func testBackNavigation(){
    }
    
    /*! @brief Scenario when user taps on revert withdrawn in more actions */
    func testUpdateCandidates(){
        let  notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["requestType": "revertWithdraw" , "withdrawStatus": false, "candidateId" : "3968"])
        let response = ["message" : ["Candidate has been withdrawn"], "success" : true] as? [String : Any]
        CandidateStubApi.withDrawnCandidate = response!
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        candidatesViewController.updateCandidates(notfication: notification)
        
        let  notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["requestType": "revertWithdraw" , "withdrawStatus": false, "candidateId" : "3968"])
        let response1 = ["message" : ["Candidate has been withdrawn"], "success" : false] as? [String : Any]
        CandidateStubApi.withDrawnCandidate = response1!
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        candidatesViewController.updateCandidates(notfication: notification1)
    }
    
    func testReload(){
        candidatesViewController.searchBar(UISearchBar(), textDidChange: "text")
        candidatesViewController.searchBar.setCustomBackgroundColor(color: .gray)
        let searchBar = UISearchBar()
        candidatesViewController.reload(searchBar)
        
        candidatesViewController.candidatesArray = [["candidates": ["text": "text", "id" : 23]]]
        candidatesViewController.searchBar(UISearchBar(), textDidChange: "text")
        let searchBar1 = UISearchBar()
        searchBar1.text = "text"
        candidatesViewController.reload(searchBar1)
    }
    
    func testAnimations(){
        candidatesViewController.searchContatinerView.zoomIn()
        candidatesViewController.searchContatinerView.zoomOut()
        candidatesViewController.searchContatinerView.zoomInWithEasing(duration: 0.2, easingOffset: 0.2)
        candidatesViewController.searchContatinerView.zoomOutWithEasing(duration: 0.2, easingOffset: 0.2)
    }
    
    
    func testSearchBarButtonClicked(){
        candidatesViewController.searchBarSearchButtonClicked(UISearchBar())
    }
    
    func testGetCandidates(){
        let stubData : [String : Any] = ["candidates" : [["first_name" : "sivasagar","full_name" : "sivasagar candidates", "id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "completed", "time_zone" : "US/Alaska"]],"success" : true,"total_count" : 1]
        CandidateStubApi.getCandidatesresponse = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        candidatesViewController.loadCandidates()
        
        let stubData1 : [String : Any] = ["candidates" : [["first_name" : "sivasagar","full_name" : "sivasagar candidates", "id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "Active", "time_zone" : "US/Alaska"]],"success" : true,"total_count" : 1]
        CandidateStubApi.getCandidatesresponse = stubData1
        candidatesViewController.candidatesArray = []
        candidatesViewController.jobStatus = .active
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        candidatesViewController.loadCandidates()
    }
    
    func testGetCandidatesWithSearch(){
        let stubData : [String : Any] = ["candidates" : [["first_name" : "sivasagar","full_name" : "sivasagar candidates", "id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "completed", "time_zone" : "US/Alaska"]],"success" : true,"total_count" : 1,"job_title": "title"]
        CandidateStubApi.getCandidatesresponse = stubData
        candidatesViewController.isFromSearch = true
        candidatesViewController.jobStatus = .inActive
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        candidatesViewController.loadCandidates()
        
        let stubData1 : [String : Any] = ["candidates" : [["first_name" : "sivasagar","full_name" : "sivasagar candidates", "id" : 3353, "last_name" : "lastname", "phone" : "9493801757", "status" : "Active", "time_zone" : "US/Alaska"]],"success" : true,"total_count" : 1,"job_title": "title"]
        CandidateStubApi.getCandidatesresponse = stubData1
         candidatesViewController.isFromSearch = true
        candidatesViewController.candidatesArray = []
        candidatesViewController.jobStatus = .active
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        candidatesViewController.loadCandidates()
    }
    
    func testUpdateCandidatesForWithdrawn(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["requestType": "Withdraw"])
        candidatesViewController.updateCandidates(notfication: notification)
    }
    
    
    func testDidSelectRowAt(){
        candidatesViewController.candidatesArray = [["full_name": "fullname", "id" : 23]]
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3.0)
        candidatesViewController.tableView(candidatesViewController.candidatesTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
    func testScrollViewDidEndDragging(){
        candidatesViewController.scrollViewDidEndDragging(candidatesViewController.candidatesTableView, willDecelerate: true)
    }
}
