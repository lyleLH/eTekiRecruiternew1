//
//  FitlerViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 09/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
import SideMenu
@testable import eTekiRecruiter

class FitlerViewControllerTests: XCTestCase {
    
    var filterViewController: FilterViewController!
    var filterNavigationController: UISideMenuNavigationController!
    var cell : FilterViewCell! = nil
    
    override func setUp() {
        filterViewController = mainStoryboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController
        filterNavigationController = UISideMenuNavigationController(rootViewController: filterViewController)
        filterViewController.view.layoutIfNeeded()
        filterNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = filterNavigationController
        
        cell = filterViewController.filterTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FilterViewCell
        
    }
    
    override func tearDown() {
        
        filterViewController = nil
        filterNavigationController = nil
        cell = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
        
    }
    
    func testInstance() {
        XCTAssertNotNil(filterViewController, "Not able to create FilterViewController Instance.")
        //XCTAssertNotNil(cell, "Not able to create FilterViewCell Instance.")
        XCTAssertNotNil(filterViewController.filterTableView, "Not able to create filterTableView Instance.")
    }
    
    func testFilterTableView() {

        
        filterViewController.filterTableView.reloadData()
        
        let stubArray = ["My Jobs","My Contributor Jobs","Active","Inactive","Today","Week","Month"]
        
//        XCTAssertEqual(stubArray , filterViewController.filterArray,"Data mismatch")
        for index in 0..<filterViewController.filterArray.count {
            print("\(index) times 5 is \(index * 5)")
            cell = filterViewController.filterTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FilterViewCell
            //XCTAssertEqual(stubArray[index], cell.filterLabel.text,"filter view table view data mismatch mismatch")
        }
        
    }
    
    func testSaveFilters(){
        filterViewController.filterArray = [["MY_JOBS".localized : false],["MY_CONTRIBUTOR_JOBS".localized : true],["ACTIVE".localized : false],["INACTIVE".localized  : true]]
        filterViewController.dueByDateTextField.text = "TODAY".localized
         for index in 0..<4 {
                   let cell1 = filterViewController.filterTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FilterViewCell
              if(index == 1 || index == 2){
                cell1?.checkBoxView.isChecked = true
              }
         }
        filterViewController.filterTableView.reloadData()
        filterViewController.saveFilters(0)
        XCTAssertTrue(filterViewController.filterArray[1]["MY_CONTRIBUTOR_JOBS".localized] ?? false)
        XCTAssertTrue(filterViewController.filterArray[3]["INACTIVE".localized] ?? false)
        XCTAssertFalse(filterViewController.filterArray[0]["MY_JOBS".localized] ?? false)
        XCTAssertFalse(filterViewController.filterArray[2]["ACTIVE".localized] ?? false)
    }
    
    func testApplyFilters(){
        filterViewController.filterArray = [["MY_JOBS".localized : false],["MY_CONTRIBUTOR_JOBS".localized : true],["ACTIVE".localized : false],["INACTIVE".localized  : true]]
        filterViewController.dueByDateTextField.text = "WEEK".localized
         for index in 0..<4 {
                   let cell1 = filterViewController.filterTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FilterViewCell
              if(index == 1 || index == 2){
                cell1?.checkBoxView.isChecked = true
              }
         }
        filterViewController.filterTableView.reloadData()
        filterViewController.applyFilters(0)
        
        filterViewController.dueByDateTextField.text = "TWO_WEEKS".localized
        filterViewController.filterTableView.reloadData()
        filterViewController.applyFilters(0)
        
        filterViewController.dueByDateTextField.text = "MONTH".localized
        filterViewController.filterTableView.reloadData()
        filterViewController.applyFilters(0)
        
        filterViewController.dueByDateTextField.text = "QUARTER".localized
        filterViewController.filterTableView.reloadData()
        filterViewController.applyFilters(0)
        
        filterViewController.dueByDateTextField.text = "ANNUAL".localized
        filterViewController.filterTableView.reloadData()
        filterViewController.applyFilters(0)
        
        XCTAssertTrue(filterViewController.filterArray[1]["MY_CONTRIBUTOR_JOBS".localized] ?? false)
        XCTAssertTrue(filterViewController.filterArray[3]["INACTIVE".localized] ?? false)
        XCTAssertFalse(filterViewController.filterArray[0]["MY_JOBS".localized] ?? false)
        XCTAssertFalse(filterViewController.filterArray[2]["ACTIVE".localized] ?? false)
    }

    func testsetUpView(){
        filterViewController.segmentIndex = 0
        filterViewController.selecteddueDate =  DueDate.today.rawValue
        filterViewController.setUpView()
        XCTAssertEqual(filterViewController.selecteddueDate, "0")
        
        filterViewController.segmentIndex = 0
        filterViewController.selecteddueDate =  DueDate.week.rawValue
        filterViewController.setUpView()
        XCTAssertEqual(filterViewController.selecteddueDate, "7")
        
        filterViewController.segmentIndex = 0
        filterViewController.selecteddueDate =  DueDate.twoweeks.rawValue
        filterViewController.setUpView()
        XCTAssertEqual(filterViewController.selecteddueDate, "14")
        
        filterViewController.segmentIndex = 0
        filterViewController.selecteddueDate =  DueDate.month.rawValue
        filterViewController.setUpView()
        XCTAssertEqual(filterViewController.selecteddueDate, "30")
        
        filterViewController.segmentIndex = 0
        filterViewController.selecteddueDate =  DueDate.quater.rawValue
        filterViewController.setUpView()
        XCTAssertEqual(filterViewController.selecteddueDate, "90")
        
        filterViewController.segmentIndex = 0
        filterViewController.selecteddueDate =  DueDate.annual.rawValue
        filterViewController.setUpView()
        XCTAssertEqual(filterViewController.selecteddueDate, "365")
        
        filterViewController.segmentIndex = 1
        filterViewController.setUpView()
    }
    
    func testShowDropdown(){
        filterViewController.showDropDown(0)
    }
}
