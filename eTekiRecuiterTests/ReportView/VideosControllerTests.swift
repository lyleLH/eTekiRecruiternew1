//
//  VideosControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 12/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class VideosControllerTests: XCTestCase {
    
    var videosViewController: ShowVideosViewController!
    var videosNavigationController: UINavigationController!
    
    override func setUp() {
        videosViewController = mainStoryboard.instantiateViewController(withIdentifier: "ShowVideosViewController") as? ShowVideosViewController
        videosNavigationController = UINavigationController(rootViewController: videosViewController)
        videosViewController.candidatesAPI = CandidateStubApi.self
        videosViewController.interviewCode = "xhjdf"
        videosViewController.view.layoutIfNeeded()
        videosNavigationController.view.layoutIfNeeded()
        videosNavigationController.setPresentation()
        UIApplication.shared.keyWindow?.rootViewController = videosNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

     //Get Interview videos
    func testGetVideos(){
        videosViewController.interviewCode = "h8k5z"
        videosViewController.videosArray = ["archive_url"]
        let stubData : [String : Any] = ["videos": [["archive_url":"archive_url/archive_url"]], "success" : true]
        CandidateStubApi.getCancellationReason = stubData
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        videosViewController.getVideos()
    }
    
    // when touch on video it should present video player
    func testVideoDidSelect(){
        videosViewController.videosArray = ["archive_url"]
        videosViewController.tableView(videosViewController.videosTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? VideosTableViewCell
        
         videosViewController.tableView(UITableView(), heightForRowAt: IndexPath(row: 0, section: 0)) as? VideosTableViewCell
    
        videosViewController.tableView(UITableView(), numberOfRowsInSection: 1) as? VideosTableViewCell
        
        videosViewController.backAction(0)
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
