//
//  PictureIdViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 05/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class PictureIdViewControllerTests: XCTestCase {
    
    var pictureIDViewController: PictureIdViewController!
    var pictureIDNavigationController: UINavigationController!
    
    override func setUp() {
        pictureIDViewController = mainStoryboard.instantiateViewController(withIdentifier: "PictureIdViewController") as! PictureIdViewController
        pictureIDNavigationController = UINavigationController(rootViewController: pictureIDViewController)
        pictureIDViewController.view.layoutIfNeeded()
        pictureIDNavigationController.view.layoutIfNeeded()
        pictureIDNavigationController.setPresentation()
        UIApplication.shared.keyWindow?.rootViewController = pictureIDNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testViewDidLoad(){
        pictureIDViewController.imageUrl = "https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/images/1580462009735.png"
        pictureIDViewController.viewDidLoad()
    }
    
    func testBackAction(){
        pictureIDViewController.backAction(0)
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
