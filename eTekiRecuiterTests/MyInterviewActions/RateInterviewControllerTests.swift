//
//  RateInterviewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class RateInterviewControllerTests: XCTestCase {
    
       var rateInteviewViewController: RateInterviewerViewController!
       var rateInteviewNavigationController: UINavigationController!
    
    override func setUp() {
        rateInteviewViewController = mainStoryboard.instantiateViewController(withIdentifier: "RateInterviewerViewController") as? RateInterviewerViewController
        rateInteviewNavigationController = UINavigationController(rootViewController: rateInteviewViewController)
        rateInteviewViewController.candidatesAPI = CandidateStubApi.self
        rateInteviewViewController.view.layoutIfNeeded()
        rateInteviewNavigationController.view.layoutIfNeeded()
        rateInteviewNavigationController.setPresentation()
        UIApplication.shared.keyWindow?.rootViewController = rateInteviewNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    // GET Submitted Rating details
    func testgetInterviewerRatingDetails(){
        let stubData : [String : Any] = ["interviewer_rating": ["interview_member_id": 3233, "name": "eTeki", "title": "title", "note": "notes", "rating": 3.00, "rating_present": true, "profile_urls": ["profile_thumb_url": "url"]], "job": ["title": "eTeki"], "success": true]
        CandidateStubApi.getInterviewerRatingDetails = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        rateInteviewViewController.getViewInterviewerRatingDetails()
    }
    
    // Press on Submit rating button checking validations
    func testSubmitRating(){
        
        // when rating is 0
        rateInteviewViewController.submitAction(0)
        XCTAssertEqual(rateInteviewViewController.ratingView.rating, 0.0)
        
        // when rating title is Empty
        rateInteviewViewController.ratingView.rating = 3.0
        rateInteviewViewController.submitAction(0)
        XCTAssertEqual(rateInteviewViewController.reviewTitleField.text, "")
        XCTAssertEqual(rateInteviewViewController.ratingView.rating, 3.0)
        
        //when commentTextView is Empty
        rateInteviewViewController.ratingView.rating = 2.0
        rateInteviewViewController.reviewTitleField.text = "Title"
        rateInteviewViewController.submitAction(0)
        XCTAssertEqual(rateInteviewViewController.ratingView.rating, 2.0)
        XCTAssertEqual(rateInteviewViewController.reviewTitleField.text , "Title")
        
        // All mandatory fields filled
        rateInteviewViewController.ratingView.rating = 2.0
        rateInteviewViewController.reviewTitleField.text = "Title"
        rateInteviewViewController.commentTextView.text = "Comments"
        
        let stubData : [String : Any] = ["message":["Rating is Submitted"] , "success": false]
        CandidateStubApi.postInterviewerRating = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        rateInteviewViewController.submitAction(0)
    }
    
    //while Submitting rating when it fails
    func testSubmitAction(){
        rateInteviewViewController.ratingView.rating = 2.0
        rateInteviewViewController.reviewTitleField.text = "Title"
        rateInteviewViewController.commentTextView.text = "Comments"
        let stubData : [String : Any] = ["message":["Rating is Submitted"] , "success": true]
        CandidateStubApi.postInterviewerRating = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        rateInteviewViewController.submitAction(0)
    }
    
    //when press on back Navigation button
    func testBackAction(){
        rateInteviewViewController.backAction(0)
    }
    
    //when textView starts Editing
    func testTextviewEditing(){
        rateInteviewViewController.textViewDidBeginEditing(rateInteviewViewController.commentTextView)
        XCTAssertEqual(rateInteviewViewController.commentTextView.text, "")
    }
    
    //When textView ends editing
    func testTextViewEndsEditing(){
        rateInteviewViewController.commentTextView.text = ""
        rateInteviewViewController.textViewDidEndEditing(rateInteviewViewController.commentTextView)
        XCTAssertEqual(rateInteviewViewController.commentTextView.text, "Enter Comment*")
    }
    
    //when textView field returns
    func testTextViewShouldChangeTextIn(){
        rateInteviewViewController.textView(rateInteviewViewController.commentTextView, shouldChangeTextIn: NSRange(), replacementText: "\n")
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
