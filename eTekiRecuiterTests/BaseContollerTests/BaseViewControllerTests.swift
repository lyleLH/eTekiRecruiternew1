//
//  BaseViewControllerTests.swift
//  eTekiRecuiterTests
//
//  Created by Siva Sagar Palakurthy on 22/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class BaseViewControllerTests: XCTestCase {
    
    var navigationController: UINavigationController!
    var baseViewController: BaseViewController {
        return self.navigationController.viewControllers[0] as! BaseViewController
    }
    
    override func setUp() {
        super.setUp()
        let baseViewController = BaseViewController(nibName: nil, bundle: nil)
        self.navigationController = UINavigationController(rootViewController: baseViewController)
    }
    
    func testViewSetup(){
        baseViewController.hideKeyboardWhenTappedAround()
        baseViewController.viewSetup()
        XCTAssertEqual(baseViewController.view.backgroundColor, AppTheme.appBackgroundColor)
    }
    
    func testtextFieldShouldReturn(){
        let  _ = baseViewController.textFieldShouldReturn(UITextField())
    }
    
    func testisValidSocialLink(){
        let _ = baseViewController.isValidSocialLink(socialLink : "https://eteki.com")
    }
    
    func testshowSpinner(){
        baseViewController.showSpinner()
    }
    
    func testremoveSpinner(){
        baseViewController.removeSpinner()
    }
    
    
    func testshowBanner(){
        baseViewController.showBanner(title:"", withMessage :"successfully created", style : .success)
        baseViewController.showBanner(title:"", withMessage :"", style : .success)
    }
    
    func revealMenuAction(){
            baseViewController.revealMenuAction(UIBarButtonItem())
            //XCTAssertEqual(baseViewController.leftMenuNavigationController.presentationStyle, .viewSlideOutMenuPartialIn)
    }
    
    func testUserLogout() {
        let notification = NSNotification(name: NSNotification.Name(rawValue: "UserShouldLoggedOut"), object: nil)
        baseViewController.userLogout(notfication: notification)
    }

    override func tearDown() {
        navigationController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(baseViewController, "Not able to create BaseViewController Instance.")
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

    

}
