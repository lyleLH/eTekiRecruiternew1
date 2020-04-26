//
//  MatchedInterviewsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class MatchedInterviewsViewControllerTests: XCTestCase {

     var matchedInterviewersController: MatchedInterviewsViewController!
     var matchedInterviewersNavigationController: UINavigationController!
     var cell : MatchedInterviewsCell! = nil
    
    override func setUp() {
        matchedInterviewersController = mainStoryboard.instantiateViewController(withIdentifier: "MatchedInterviewers") as? MatchedInterviewsViewController
        matchedInterviewersNavigationController = UINavigationController(rootViewController: matchedInterviewersController)
        matchedInterviewersController.interviewsAPI = InterviewersStubApi.self
        matchedInterviewersController.view.layoutIfNeeded()
        matchedInterviewersNavigationController.view.layoutIfNeeded()
        matchedInterviewersController.interViewsDetails = [[
            "id" : 415,
            "level" : "Certified",
            "name" : "Balasubramanyam",
            "profile_pics" :  [
                "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
            "rating" : 3.3125,
            "skillset" : "Database Testing (C), Ruby on Rails (P), Core Java (P)",
            "title" : "Java",
            "bio" : "Planned and managed. implementation of software quality assurance activities and projects to implement defined benefit, group life insurance, deferred compensation; cash match plans and sickness and disability programs."
            ],["name": "John Doe", "title": "Technical Manager", "skillset": "Core Java, # Angular, #PHP, Node JS, JSP, Struts, Oracle, Mango D...", "level": "Trained", "profile_pics": ["profile_thumb_url": ""], "rating": 4.7888,"bio" : "Planned and managed. implementation of software quality assurance activities and projects to implement defined benefit, group life insurance, deferred compensation; cash match plans and sickness and disability programs.",],["name": "John Doe", "title": "Technical Manager", "skillset": "Core Java, # Angular, #PHP, Node JS, JSP, Struts, Oracle, Mango D...", "level": "Registered", "profile_pics": ["profile_thumb_url": ""], "rating": 2.690]]
        cell = self.matchedInterviewersController.interviewsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MatchedInterviewsCell
        UIApplication.shared.keyWindow?.rootViewController = matchedInterviewersNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInstance() {
        XCTAssertNotNil(matchedInterviewersController, "Not able to create matchedInterviewersController Instance.")
        XCTAssertNotNil(matchedInterviewersController.backButton, "Left Bar Button item instance is not nil.")
        XCTAssertNotNil(matchedInterviewersController.interviewsTableView, "Not able to create interviewsTableView Instance.")
    }
    
    func testBackAction(){
            XCTAssertTrue(matchedInterviewersController.backButton.isEnabled, "Left Bar Button is not enabled.")
            UIApplication.shared.sendAction(matchedInterviewersController.backButton.action!, to: matchedInterviewersController.backButton.target!, from: matchedInterviewersController, for: nil)

//            let expectation = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.5) {
//            print(UIApplication.topMostViewController())
//            guard let dashboard = UIApplication.topViewController() as? DashboardViewController else {
//                      XCTFail("DashboardViewController is not Top most view controller.")
//                      return
//                    }
//                    XCTAssertNotNil(dashboard, "Not able to Navigate DashboardNavigationController, instance is nil.")
//                    dashboard.view.layoutIfNeeded()
//                    XCTAssertEqual(dashboard.navigationItem.title, "Matched Interviewers(0)", "Navigation title not matching.")
//                    expectation.fulfill()
//               }
//               wait(for: [expectation], timeout: 5)
    }
    
    /*! @brief Scenario when user loads the table view data */
    func testTableViewCellForRowat(){
        let cell = matchedInterviewersController.tableView(matchedInterviewersController.interviewsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MatchedInterviewsCell
        matchedInterviewersController.tableView(matchedInterviewersController.interviewsTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? MatchedInterviewsCell
        matchedInterviewersController.tableView(matchedInterviewersController.interviewsTableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? MatchedInterviewsCell
        let expectation = XCTestExpectation(description: "test")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
                XCTAssertEqual(cell?.fullNameLabel.text, self.matchedInterviewersController.interViewsDetails[0]["name"] as? String)
                XCTAssertEqual(cell?.designationLabel.text, self.matchedInterviewersController.interViewsDetails[0]["title"] as? String)
                XCTAssertEqual(cell?.skillsLabel.text, self.matchedInterviewersController.interViewsDetails[0]["skillset"] as? String)
                XCTAssertEqual(cell?.badgeImageView.image, UIImage(named: "BlueBadge"))
                XCTAssertEqual(cell?.ratingView.rating, self.matchedInterviewersController.interViewsDetails[0]["rating"] as? Double)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 3)
    }
    
    /*! @brief Scenario when user selects the table view cell */
    func testTableViewDidselect(){
        matchedInterviewersController.tableView(matchedInterviewersController.interviewsTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? MatchedInterviewsCell
        let expectation = XCTestExpectation(description: "test")
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
                 guard let InterviewerProfile = UIApplication.topMostViewController() as? MatchedInterviewersProfileViewController else {
                         XCTFail("MatchedInterviewersProfileViewController is not Top most view controller.")
                         return
                 }
                 XCTAssertNotNil(InterviewerProfile, "Not able to Navigate MatchedInterviewersProfileViewController, instance is nil.")
                 InterviewerProfile.view.layoutIfNeeded()
                print(InterviewerProfile.interViewerId)
                 XCTAssertEqual(InterviewerProfile.navigationItem.title, "Interviewer Profile", "Navigation title not matching.")
                 expectation.fulfill()
            }
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(matchedInterviewersController.interViewId, "\(matchedInterviewersController.interViewsDetails[0]["id"] as! Int)")
    }
    
    /*! @brief Scenario Matched Interviews list getting */
    func testMatchedInterviews(){
        let stubData =  ["interviewers": [
                [
                "bio" : "Architect/Developer with 12 yrs of software implementation experience in Java/J2EE. I have advanced levels of technical knowledge combined with sound business vision. Specialized in Custom/Mobile/Web/IOT Application Design & Development. Experienced in enterprise content management, enterprise search solutions and IOT apps.Experience in Predix/MindSphere IOT platforms, AnjularJS, REST/Soap web services, Spring Extensive experience in design and architecture of web and IOT apps",
                "id" : 415,
                "level" : "Certified",
                "name" : "Balasubramanyam",
                "profile_pics" :     [
                    "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                    "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                    "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                    "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                 ],
                "rating" : 3.3125,
                "skillset" : "Database Testing (C), Ruby on Rails (P), Core Java (P)",
                "title" : "Java",
            ]], "title": "New Level 1", "success": true] as [String : Any]
        InterviewersStubApi.getMatchedInterviewers = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        matchedInterviewersController.getMatchedInterviews()
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
