//
//  SearchViewcControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 13/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class SearchViewcControllerTests: XCTestCase {
     
    var searchController: SearchViewController!
    var searchNavigationController: UINavigationController!
    
    override func setUp() {
        searchController = mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
                searchNavigationController = UINavigationController(rootViewController: searchController)
                searchController.createJobAPI = CreateJobStubApi.self
                searchController.selectedString = "Development"
                searchController.selectedCandidate = ["0": "candidate"]
                searchController.selectDictionary = ["name": "Afreen"]
                searchController.view.layoutIfNeeded()
                searchNavigationController.view.layoutIfNeeded()
                UIApplication.shared.keyWindow?.rootViewController = searchNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testLangugageSearch(){
        searchController.currentSearch = StoryboardSegueIdentifiers.createJobToLangaugeSearch
        searchController.viewDidLoad()
    }
    
    func testStateToSearch(){
        searchController.currentSearch = "StateToSearch"
        searchController.viewDidLoad()
    }
    
    func testCandidateToSearch(){
        searchController.currentSearch = StoryboardSegueIdentifiers.candidateToSearch
           searchController.viewDidLoad()
    }
    
    func testAreaExpertiseSearch(){
        searchController.currentSearch = StoryboardSegueIdentifiers.createJobToAreaExpertise
        searchController.viewDidLoad()
    }
    
    func testDoneActionOfCandidateToSearch(){
        searchController.currentSearch = StoryboardSegueIdentifiers.candidateToSearch
    }
    
    
    func testDoneActionOfTimeZones(){
        searchController.currentSearch = "SearchTimeZones"
        searchController.currentSearch = "search"
    }
    
    func testTableViewCellForRowAt(){
//        searchController.menuList = ["data1", "data2", "data3"]
//        searchController.tableView(searchController.searchTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! SearchCell
        
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
