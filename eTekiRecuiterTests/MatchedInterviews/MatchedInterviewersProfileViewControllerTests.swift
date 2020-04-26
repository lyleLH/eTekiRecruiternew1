//
//  MatchedInterviewersProfileViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class MatchedInterviewersProfileViewControllerTests: XCTestCase {
    
    var interviewerProfileController: MatchedInterviewersProfileViewController!
    var interviewerProfileNavigationController: UINavigationController!
    var cell : InterviewerProfileTableViewCell! = nil
    
    override func setUp() {
        interviewerProfileController = mainStoryboard.instantiateViewController(withIdentifier: "InterviewersProfile") as? MatchedInterviewersProfileViewController
        interviewerProfileNavigationController = UINavigationController(rootViewController: interviewerProfileController)
        interviewerProfileController.interviewsAPI = InterviewersStubApi.self
        interviewerProfileController.view.layoutIfNeeded()
        interviewerProfileNavigationController.view.layoutIfNeeded()
        cell = self.interviewerProfileController.interViewertableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InterviewerProfileTableViewCell
        UIApplication.shared.keyWindow?.rootViewController = interviewerProfileNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testBackAction(){
       XCTAssertTrue(interviewerProfileController.backButton.isEnabled, "Left Bar Button is not enabled.")
        UIApplication.shared.sendAction(interviewerProfileController.backButton.action!, to: interviewerProfileController.backButton.target!, from: interviewerProfileController, for: nil)
    }
    
    func testGetInterviewerProfileDetails(){
        let stubData =  ["success": true, "interviewer_details": [
            "bio" : "Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank.",
            "cancelled_interviews" : 3,
            "candidate_rating" : 4.85,
            "completed_interviews" : 51,
            "interviews_count" : 183,
            "language_proficiencies" : [
                        [
                            "created_at" : "2018-06-25T08:39:33.000Z",
                            "id" : 7341,
                            "interviewer_id" : 3035,
                            "language" : "English",
                            "proficiency" : "Fluent",
                            "updated_at" : "2018-06-25T08:39:33.000Z",
                ]
            ],
            "level" : "Certified",
            "name" : "Jan",
            "no_shows_count" : 0,
            "prior_interviews" : 0,
            "profile_pics" : [
                "profile_large_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/large_1529916047222.png",
                "profile_medium_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/medium_1529916047222.png",
                "profile_small_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/small_1529916047222.png",
                "profile_thumb_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/thumb_1529916047222.png",
            ],
            "recruiter_avg_rating" : 1,
            "skillset" :  [
                "Java (E)"
            ],
            "title" : "Core Java Developer",
            "years_of_experience" : 5,
        ]] as [String : Any]
        InterviewersStubApi.interviewerProfile = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        interviewerProfileController.getInterViewerProfileDetails()
    }
    
    func testGetInterviewerProfiledetails(){
        let stubData =  ["success": true, "interviewer_details": [
            "bio" : "Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank,Professional Summary can't be blank.",
            "cancelled_interviews" : 3,
            "candidate_rating" : 5,
            "completed_interviews" : 51,
            "interviews_count" : 183,
            "language_proficiencies" : [
                        [
                            "created_at" : "2018-06-25T08:39:33.000Z",
                            "id" : 7341,
                            "interviewer_id" : 3035,
                            "language" : "English",
                            "proficiency" : "Fluent",
                            "updated_at" : "2018-06-25T08:39:33.000Z",
                ]
            ],
            "level" : "Trained",
            "name" : "Jan",
            "no_shows_count" : 0,
            "prior_interviews" : 2,
            "profile_pics" : [
                "profile_large_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/large_1529916047222.png",
                "profile_medium_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/medium_1529916047222.png",
                "profile_small_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/small_1529916047222.png",
                "profile_thumb_url" : "https://s3-us-west-2.amazonaws.com/iconf-profile/thumb_1529916047222.png",
            ],
            "recruiter_avg_rating" : 1,
            "skillset" :  [
                "Java (E)"
            ],
            "title" : "Core Java Developer",
            "years_of_experience" : 5,
        ]] as [String : Any]
        InterviewersStubApi.interviewerProfile = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        interviewerProfileController.getInterViewerProfileDetails()
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
