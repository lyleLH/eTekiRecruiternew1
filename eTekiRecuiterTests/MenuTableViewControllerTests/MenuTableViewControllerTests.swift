//
//  MenuViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 27/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
import SideMenu
@testable import eTekiRecruiter

class MenuViewControllerTests: XCTestCase {
    
    var menuTableViewController: MenuTableViewController!
    var menuNavigationController: UISideMenuNavigationController!
    var cell : MenuTableViewCell! = nil

    override func setUp() {
        menuTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        menuNavigationController = UISideMenuNavigationController(rootViewController: menuTableViewController)
        menuTableViewController.view.layoutIfNeeded()
        menuNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = menuNavigationController
        
        cell = self.menuTableViewController.menuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTableViewCell

    }
    override func tearDown() {
        menuTableViewController = nil
        menuNavigationController = nil
        cell = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(menuTableViewController, "Not able to create MenuTableViewController Instance.")
        XCTAssertNotNil(cell, "Not able to create MenuTableViewCell Instance.")
        XCTAssertNotNil(menuTableViewController.menuTableView, "Not able to create menuTableView Instance.")
        XCTAssertNotNil(menuTableViewController.menuList, "Not able to create menuList Instance.")
        XCTAssertNotNil(menuNavigationController, "Not able to create UISideMenuNavigationController Instance.")
    }
    
    func testMenuListParameters(){
        let menuList = ["Dashboard","Profile","Logout"]
        XCTAssertEqual(menuList, menuTableViewController.menuList, "Parameters Mismatch")
    }
    
    func testMenuTableView(){
        XCTAssertFalse(menuTableViewController.menuTableView.isHidden, "Menu Table View is hidden by default")
        let menuList = ["Dashboard","Profile","Logout"]
        XCTAssertEqual(menuList, menuTableViewController.menuList, "Parameters Mismatch")
    }
    
    
    func testThatTableViewLoads() {
        XCTAssertNotNil(self.menuTableViewController?.menuTableView, "Menu TableView not initiated")
    }
    
    func testThatTableViewHasDataSource() {
        XCTAssertNotNil(self.menuTableViewController?.menuTableView.dataSource, "Menu Table datasource cannot be nil")
    }
    
    func testTableViewIsConnectedToDelegate() {
        XCTAssertNotNil(self.menuTableViewController?.menuTableView.delegate, "Menu Table delegate cannot be nil")
    }
    
    func testTableViewHeightForRowAtIndexPath() {
        let expectedHeight : CGFloat = 50.0
        let actualHeight = cell.contentView.frame.size.height
        XCTAssertEqual(expectedHeight, actualHeight, "Expected and Actual Height is different. Did you change it")
    }
        
    func testDidSelectRowMenuToProfile() {
        let testRow = IndexPath(row: 1, section: 0)
        menuTableViewController.menuTableView.delegate?.tableView!(menuTableViewController.menuTableView, didSelectRowAt: testRow)
        guard let profileViewController = UIApplication.topMostViewController() as? ProfileViewController else {
        XCTFail("ProfileViewController is not Top most view controller.")
        return
        }
        XCTAssertNotNil(profileViewController, "Not able to Navigate ProfileViewController, instance is nil.")
        profileViewController.view.layoutIfNeeded()
        XCTAssertFalse(profileViewController.navigationController!.isNavigationBarHidden, "Navigation Bar is Hidden in ProfileViewController")
        XCTAssertEqual(profileViewController.navigationItem.title, "Profile", "profileViewController not loaded")

    }
    
    func testDidSelectRowMenuToPayments() {
        let testRow = IndexPath(row: 2, section: 0)
        menuTableViewController.menuTableView.delegate?.tableView!(menuTableViewController.menuTableView, didSelectRowAt: testRow)
       
    }
    
    func testDidSelectRowMenuToLogOut() {
        let testRow = IndexPath(row: 2, section: 0)
        menuTableViewController.menuTableView.delegate?.tableView!(menuTableViewController.menuTableView, didSelectRowAt: testRow)
            guard let signInViewController = UIApplication.topMostViewController() as? SignInViewController else {
               // XCTFail("SignInViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(signInViewController, "Not able to Navigate SignInViewController, instance is nil.")
            signInViewController.view.layoutIfNeeded()
    }
    
    func testDashBoardCell() {
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       menuTableViewController.menuTableView.dataSource?.tableView(menuTableViewController.menuTableView, cellForRowAt: testRow) as! MenuTableViewCell
        XCTAssertEqual(cell.iConView.image, UIImage(named: "dashboard-white"), "Dasboard iCon Mismatch")
        XCTAssertEqual(cell.menuTitleLabel.font, UIFont (name: "HelveticaLTStd-Light", size: 18.0), "LOGOUT cell font value mismatched.")

        XCTAssertEqual(cell.menuTitleLabel.text, "DASHBOARD".localized, "Dasboard Cell localized value mismatched.")
        XCTAssertNotEqual(cell.menuTitleLabel.text, "DASHBOARD", "Dasboard localized key not found in .strings file.")
    }
    
    func testProfileCell() {
        let testRow = IndexPath(row: 1, section: 0)
        let cell =       menuTableViewController.menuTableView.dataSource?.tableView(menuTableViewController.menuTableView, cellForRowAt: testRow) as! MenuTableViewCell
        XCTAssertEqual(cell.iConView.image, UIImage(named: "profile-white"), "profile iCon Mismatch")
        XCTAssertEqual(cell.menuTitleLabel.font, UIFont (name: "HelveticaLTStd-Light", size: 18.0), "LOGOUT cell font value mismatched.")
        XCTAssertEqual(cell.menuTitleLabel.text, "PROFILE".localized, "Profile Cell localized value mismatched.")
        XCTAssertNotEqual(cell.menuTitleLabel.text, "PROFILE", "Profile localized key not found in .strings file.")
    }
    
    func testPaymentCell() {
        let testRow = IndexPath(row: 2, section: 0)
        let cell =       menuTableViewController.menuTableView.dataSource?.tableView(menuTableViewController.menuTableView, cellForRowAt: testRow) as! MenuTableViewCell
        XCTAssertEqual(cell.iConView.image, UIImage(named: "payment-white"), "Payment iCon Mismatch")
        XCTAssertEqual(cell.menuTitleLabel.font, UIFont (name: "HelveticaLTStd-Light", size: 18.0), "LOGOUT cell font value mismatched.")
        XCTAssertEqual(cell.menuTitleLabel.text, "LOGOUT".localized, "LOGOUT Cell localized value mismatched.")
        XCTAssertNotEqual(cell.menuTitleLabel.text, "LOGOUT", "LOGOUT localized key not found in .strings file.")
    }
    
    func testLogoutCell() {
        let testRow = IndexPath(row: 2, section: 0)
        let cell =       menuTableViewController.menuTableView.dataSource?.tableView(menuTableViewController.menuTableView, cellForRowAt: testRow) as! MenuTableViewCell
        XCTAssertEqual(cell.menuTitleLabel.font, UIFont (name: "HelveticaLTStd-Light", size: 18.0), "LOGOUT cell font value mismatched.")
        XCTAssertEqual(cell.menuTitleLabel.text, "LOGOUT".localized, "LOGOUT Cell localized value mismatched.")
        XCTAssertNotEqual(cell.menuTitleLabel.text, "LOGOUT", "LOGOUT localized key not found in .strings file.")
    }
    
    func testShowSpinner(){
        menuTableViewController.showSpinner()
    }
    
    func testShowBanner(){
        menuTableViewController.showBanner(title: "", withMessage: "", style: .success)
        menuTableViewController.showBanner(title: "", withMessage: "Updated", style: .success)
    }
    
    func testRemoveSpinner(){
        menuTableViewController.removeSpinner()
    }
    
    func testApiSuceesResponse(){
        let response = SignInResponse(json: ["messgae" : "Successfully updated", "success": true], success: true)
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        menuTableViewController.onAPISuccessResponse(response: response)
    }
    
    func testApiErrorResponse(){
        let errorResponse = ErrorResponse(responseCode: 404, message: "Not found", tittle: "")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        menuTableViewController.onAPIException(errorResponse: errorResponse)
    }
}
