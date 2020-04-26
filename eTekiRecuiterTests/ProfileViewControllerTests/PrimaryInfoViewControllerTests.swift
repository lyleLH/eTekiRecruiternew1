//
//  PrimaryInfoViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 18/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class PrimaryInfoViewControllerTests: XCTestCase {
    var primaryInfoViewController: PrimaryInfoViewController!
    var primaryNavigationController: UINavigationController!
    var cell : SocialLinksTableViewCell! = nil
    func testBackAction(){
        primaryInfoViewController.backAction(0)
    }
    func testUpdateAction(){
        for index in 0..<3 {
            cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SocialLinksTableViewCell
            switch index {
            case 0:
                self.cell.socialLinkField.text = "https://www.linkedin.com/afreen"
                XCTAssertTrue(self.primaryInfoViewController.isValidSocialLink(socialLink: "https://www.linkedin.com/afreen"))
            case 1:
                cell.socialLinkField.text = "https://www.twitter.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.twitter.com/afreen"))
            case 2:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.facebook.com/afreen"))
            default:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
            }
        }
      primaryInfoViewController.updatePrimaryInformation(0)
    }
    func testUpdateActionlinkedinDomainisnil(){
            cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SocialLinksTableViewCell
                self.cell.socialLinkField.text = "https://www.linkedin.com/afreen"
                XCTAssertTrue(self.primaryInfoViewController.isValidSocialLink(socialLink: "https://www.linkedin.com/afreen"))
                SocialLinks.linkedIn = ""
         primaryInfoViewController.updatePrimaryInformation(0)
    }
    func testUpdateActiontwitterDomainisnil(){
        for index in 0..<3 {
            cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SocialLinksTableViewCell
            switch index {
            case 0:
                self.cell.socialLinkField.text = "https://www.linkedin.com/afreen"
                XCTAssertTrue(self.primaryInfoViewController.isValidSocialLink(socialLink: "https://www.linkedin.com/afreen"))
            case 1:
                cell.socialLinkField.text = "https://www.twitter.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.twitter.com/afreen"))
                 SocialLinks.twitter = ""
            default:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
            }
        }
        primaryInfoViewController.updatePrimaryInformation(0)
    }
    func testUpdateActiongooglePlusDomainisnil(){
        for index in 0..<3 {
            cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SocialLinksTableViewCell
            switch index {
            case 0:
                self.cell.socialLinkField.text = "https://www.linkedin.com/afreen"
                XCTAssertTrue(self.primaryInfoViewController.isValidSocialLink(socialLink: "https://www.linkedin.com/afreen"))
            case 1:
                cell.socialLinkField.text = "https://www.twitter.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.twitter.com/afreen"))
            case 2:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.facebook.com/afreen"))
            default:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
            }
        }
        primaryInfoViewController.updatePrimaryInformation(0)
    }
    func testUpdateActionfacebookDomainisnil(){
        for index in 0..<3 {
            cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SocialLinksTableViewCell
            switch index {
            case 0:
                self.cell.socialLinkField.text = "https://www.linkedin.com/afreen"
                XCTAssertTrue(self.primaryInfoViewController.isValidSocialLink(socialLink: "https://www.linkedin.com/afreen"))
            case 1:
                cell.socialLinkField.text = "https://www.twitter.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.twitter.com/afreen"))
            case 2:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
                XCTAssertTrue(primaryInfoViewController.isValidSocialLink(socialLink: "https://www.facebook.com/afreen"))
                SocialLinks.facebook = ""
            default:
                cell.socialLinkField.text = "https://www.facebook.com/afreen"
            }
        }
        primaryInfoViewController.updatePrimaryInformation(0)
    }
    func testUpdateActionforInvvalidLink(){
            for index in 0..<3 {
                cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SocialLinksTableViewCell
                    self.cell.socialLinkField.text = "https:www.linkedin.com/afreen"
                    XCTAssertTrue(self.primaryInfoViewController.isValidSocialLink(socialLink: "https://www.linkedin.com/afreen"))
                }
            primaryInfoViewController.updatePrimaryInformation(0)
    }
    
    func testOnGetProfileResponse(){
        var val = ProfileResponse()
        val.message = "success"
        // wait
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        primaryInfoViewController.onGetProfileResponse(response: val)
    }
    
    func testvalidateUrl(){
        "https://www.linkedIn.com/afreen".validateUrl()
    }
    
    override func setUp() {
        primaryInfoViewController = mainStoryboard.instantiateViewController(withIdentifier: "PrimaryInfoController") as? PrimaryInfoViewController
        primaryNavigationController = UINavigationController(rootViewController: primaryInfoViewController)
        primaryInfoViewController.view.layoutIfNeeded()
        primaryNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = primaryNavigationController
        let cell = primaryInfoViewController.socialLinkTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SocialLinksTableViewCell
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
