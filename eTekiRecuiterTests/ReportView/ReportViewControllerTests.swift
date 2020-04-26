//
//  ReportViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 05/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import XCTest
import JJFloatingActionButton
import AVKit
@testable import eTekiRecruiter

class ReportViewControllerTests: XCTestCase {
    
    var reportViewController: ReportViewController!
    var reportViewNavigationController: UINavigationController!
    
    override func setUp() {
        reportViewController = mainStoryboard.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController
        reportViewNavigationController = UINavigationController(rootViewController: reportViewController)
        self.addStubData()
        reportViewController.images = ["https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/images/1580462009735.png"]
        reportViewController.audiosArray = ["https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3"]
        reportViewController.videosArray = ["https://www.radiantmediaplayer.com/media/bbb-360p.mp4"]
        
        
        reportViewNavigationController.view.layoutIfNeeded()
        
        reportViewNavigationController.setPresentation()
        UIApplication.shared.keyWindow?.rootViewController = reportViewNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func addStubData() {
        let stubData : [String : Any] = ["report_skills" : [["skill_competency": "Required", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
                                                                    "experience_score": "4.0 - Good", "skill_rating": "3.0 - Satisfactory"]],
                                                "videos" :[["url": "https://s3.amazonaws.com/sample/jamun.mp4"]] ,
                                                "audios" :[["url": "https://s3.amazonaws.com/sample/jamun.mp4"]] ,
                                                "image_urls": ["https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/images/1580462009735.png"],
                                                "report_id": 4857,
                                                "job": ["id": 3943],
                                                "candidate": ["capture_id_url": "https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/images/1580462009735.png", "first_name": "lkn"],
                                                "grievance_period": true,
                                                "code": [["code":"https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/code_snippets/1580462097943.txt"]],
                                                "professional_background": "Professional background summary should reflect how the candidate's qualifications align with job requirements without making a hire/no-hire recommendation",
//                                                "average_ratings": ["preferred_skill_avg_rating": "2.33", "required_skill_avg_rating": "4.2"],
                                                "average_ratings": [
                                                    "preferred_skill_avg_rating" : "",
                                                       "qumilative_skill_avg_rating" : "2.00",
                                                       "required_skill_avg_rating" : "3.00"
                                                       ],
                                                "average_experience_ratings": ["required_experience_score_rating": "3.2", "preferred_experience_score_rating": "4.1"],
                                                "success" : true,"total_count" : 1]
        
        
        CandidateStubApi.getReportViewDetails = stubData
        reportViewController.viewModel.candidateAPI = CandidateStubApi.self
    }
            
    /*
    - Test Scenario when Audios loaded in tableView
    */
    func testAudioCellForRowAt(){
        //Audio Array Initialized in Setup Method
        let cell = reportViewController.tableView(reportViewController.audioTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? AudioTableViewCell
        XCTAssertEqual(cell?.audioLabel.text, "Audio 1")
    }
    
    /*
    - Test Scenario when Videos loaded in tableView
    */
    func testVideoCellForRowAt(){
        //Video Array Initialized in Setup Method
        let cell = reportViewController.videosTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? VideosTableViewCell
        XCTAssertEqual(cell?.videoLabel.text , "Video 1")
    }
    
    func testSkillsCellForRowAt() {
        
        reportViewController.viewModel.skillstableViewData[0].opened = true
        let cell1 = reportViewController.skillsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SkillsTableViewCell
        XCTAssertEqual(cell1?.skillsDropdownImage.image, UIImage(named: "downArrow"))
        
        reportViewController.viewModel.skillstableViewData[0].opened = true
        let cell = reportViewController.tableView(reportViewController.skillsTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? SkillsTableViewCell
        XCTAssertFalse(cell?.noDataLabel.isHidden ?? true, "Label is not hidden")
        XCTAssertEqual(cell?.noDataLabel.text, "There are no required skills to display.", "No Data label text mismatch")
        
        reportViewController.viewModel.skillstableViewData[1].opened = true
        
        let cellOne = reportViewController.tableView(reportViewController.skillsTableView, cellForRowAt: IndexPath(row: 1, section: 1)) as? SkillsTableViewCell
        XCTAssertFalse(cellOne?.noDataLabel.isHidden ?? true, "Label is not hidden")
        XCTAssertEqual(cellOne?.noDataLabel.text, "There are no optional skills to display.", "No Data label text mismatch")
    }
    
//    func testSkills() {
//      reportViewController.skillstableViewData[0].opened = true
//        reportViewController.skillstableViewData[0].sectionData = [["skill_competency": "Required", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
//        "experience_score": "4.0 - Good", "skill_rating": "3.0 - Satisfactory"],]
//        
//         reportViewController.skillstableViewData[1].opened = true
//        reportViewController.skillstableViewData[0].sectionData = [["skill_competency": "Preferred", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
//        "experience_score": "4.0 - Good", "skill_rating": "3.0 - Satisfactory"],]
//        
//        
//        
//        reportViewController.tableView(reportViewController.skillsTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? SkillsTableViewCell
//        
//        reportViewController.skillstableViewData[0].sectionData = [["skill_competency": "Required", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
//        "experience_score": 3, "skill_rating": 2],]
//         reportViewController.skillstableViewData[1].opened = true
//        reportViewController.skillstableViewData[0].sectionData = [["skill_competency": "Preferred", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
//        "experience_score": 4, "skill_rating": 5],]
//        reportViewController.tableView(reportViewController.skillsTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? SkillsTableViewCell
//    }
    
    func testCodeCellForRowAt(){
        let url = "https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/code_snippets/1580462097943.txt"
        reportViewController.viewModel.codeTableViewData = [CodeData(opened: false, title: "", sectionData: [url])]
        _ = reportViewController.tableView(reportViewController.codeTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CodeTableViewCell
        
        reportViewController.viewModel.codeTableViewData = [CodeData(opened: true, title: "", sectionData: ["https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/code_snippets/1580462097943.txt"])]
        _ = reportViewController.tableView(reportViewController.codeTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CodeTableViewCell
        
        reportViewController.viewModel.codeTableViewData = [CodeData(opened: true, title: "", sectionData: ["https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/code_snippets/1580462097943.txt"])]
        let cell2 = reportViewController.tableView(reportViewController.codeTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? CodeTableViewCell
        XCTAssertNotNil(cell2?.codeLabel.text)
    }
    
    func testDidSelectRow() {
        //step1
        _ = reportViewController.tableView(reportViewController.audioTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? AudioTableViewCell
        
        //step2
        reportViewController.videosArray = ["https://s3.amazonaws.com/sample/jamun.mp4"]
        _ = reportViewController.tableView(reportViewController.videosTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? VideosTableViewCell
        
        //step3
        reportViewController.viewModel.skillstableViewData = [SkillsData(opened: false, title: Skills.requiredSkills, sectionData: [["skill_competency": "Required", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
        "experience_score": "4.0 - Good", "skill_rating": "3.0 - Satisfactory"]])]
        _ = reportViewController.tableView(reportViewController.skillsTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? SkillsTableViewCell
        
        //step4
        reportViewController.viewModel.skillstableViewData = [SkillsData(opened: true, title: Skills.requiredSkills, sectionData: [["skill_competency": "Required", "skill": "Java", "skill_assessment": "Job Closed Without Filling",
                "experience_score": "4.0 - Good", "skill_rating": "3.0 - Satisfactory"]])]
        _ = reportViewController.tableView(reportViewController.skillsTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? SkillsTableViewCell
        
        //step5
        reportViewController.viewModel.codeTableViewData = [CodeData(opened: false, title: "", sectionData: [ "https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/code_snippets/1580462097943.txt"])]
        _ = reportViewController.tableView(reportViewController.codeTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? CodeTableViewCell
        
        //step6
        reportViewController.viewModel.codeTableViewData = [CodeData(opened: true, title: "", sectionData: [ "https://s3-us-west-2.amazonaws.com/iconf-documents/interviews/rhe40/code_snippets/1580462097943.txt"])]
        _ = reportViewController.tableView(reportViewController.codeTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) as? CodeTableViewCell
    }
    
    func testImagesCellForRowat(){
        _ = reportViewController.collectionView(reportViewController.imagesCollectionView, numberOfItemsInSection: 0) as? ImagesCollectionViewCell
        
        let cell = reportViewController.collectionView(reportViewController.imagesCollectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? ImagesCollectionViewCell
        XCTAssertNotNil(cell?.imagesView.image)
        
        reportViewController.collectionView(reportViewController.imagesCollectionView, layout: UICollectionViewLayout(), sizeForItemAt: IndexPath(row: 0, section: 0)) as? ImagesCollectionViewCell
        
    }
    
    func testPrepareForSegue(){
        let segue = UIStoryboardSegue(identifier: StoryboardSegueIdentifiers.reportViewToWithdrawn, source: reportViewController, destination: WithDrawnViewController())
        reportViewController.prepare(for: segue, sender: nil)
        
        reportViewController.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportViewToShare, sender: nil)
       
        reportViewController.performSegue(withIdentifier: StoryboardSegueIdentifiers.reportViewToPictureId, sender: nil)
    }
    
    func testChartValueSelected(){
       // reportViewController.chartValueSelected(reportViewController.skillsBarchartView., entry: ChartDataEntry, highlight: Highlight)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.'
        reportViewController = nil
        reportViewNavigationController = nil
        
    }
    
    //MARK: Test visible report view on segment selection
    func testScenarioWhenSegmentIndexIsZero() {
        XCTAssertNotNil(reportViewController.scrollableSegment, "Scrollable Segment Controller is nil")
        XCTAssertFalse(reportViewController.scrollableSegment.isHidden, "Scrollable Segment controller is hidden")
        //Score View must be visible when selectedSegmentIndex is 0
        reportViewController.scrollableSegment.selectedSegmentIndex = 0
        XCTAssertNotNil(reportViewController.scoreView, "Scorview is nil")
        XCTAssertFalse(reportViewController.scoreView.isHidden, "scoreView is hidden")
        
        XCTAssertTrue(reportViewController.audioView.isHidden, "audioView is not hidden")
        XCTAssertTrue(reportViewController.videoView.isHidden, "videoView is not hidden")
        XCTAssertTrue(reportViewController.skillsView.isHidden, "skillsView is not hidden")
        XCTAssertTrue(reportViewController.codeView.isHidden, "Code View is not hidden")
        XCTAssertTrue(reportViewController.imagesView.isHidden, "white board Imagesview is not hidden")
    }
    
    
    func testScenarioWhenSegmentIndexIsOne() {
        //Audio View must be visible when selectedSegmentIndex is 1
        reportViewController.scrollableSegment.selectedSegmentIndex = 1
        XCTAssertNotNil(reportViewController.audioView, "audioView is nil")
        XCTAssertTrue(reportViewController.audioView.isHidden, "audioView is hidden")
        
        XCTAssertTrue(reportViewController.scoreView.isHidden, "scoreView is not hidden")
        XCTAssertFalse(reportViewController.videoView.isHidden, "videoView is not hidden")
        XCTAssertTrue(reportViewController.skillsView.isHidden, "skillsView is not hidden")
        XCTAssertTrue(reportViewController.codeView.isHidden, "Code View is not hidden")
        XCTAssertTrue(reportViewController.imagesView.isHidden, "white board Imagesview is not hidden")
    }
    
    func testScenarioWhenSegmentIndexIsTwo() {
        //Video View must be visible when selectedSegmentIndex is 2
           reportViewController.scrollableSegment.selectedSegmentIndex = 2
           XCTAssertNotNil(reportViewController.videoView, "videoView is nil")
           XCTAssertTrue(reportViewController.videoView.isHidden, "videoView is hidden")
           
           XCTAssertTrue(reportViewController.scoreView.isHidden, "scoreView is not hidden")
           XCTAssertFalse(reportViewController.audioView.isHidden, "audioView is not hidden")
           XCTAssertTrue(reportViewController.skillsView.isHidden, "skillsView is not hidden")
           XCTAssertTrue(reportViewController.codeView.isHidden, "Code View is not hidden")
           XCTAssertTrue(reportViewController.imagesView.isHidden, "white board Imagesview is not hidden")
    }
    
    func testScenarioWhenSegmentIndexIsThree() {
             //Skills View must be visible when selectedSegmentIndex is 3
             reportViewController.scrollableSegment.selectedSegmentIndex = 3
             XCTAssertNotNil(reportViewController.skillsView, "skillsView is nil")
             XCTAssertFalse(reportViewController.skillsView.isHidden, "skillsView is hidden")
             
             XCTAssertTrue(reportViewController.audioView.isHidden, "audioView is not hidden")
             XCTAssertTrue(reportViewController.videoView.isHidden, "videoView is not hidden")
             XCTAssertTrue(reportViewController.scoreView.isHidden, "scoreView is not hidden")
             XCTAssertTrue(reportViewController.codeView.isHidden, "Code View is not hidden")
             XCTAssertTrue(reportViewController.imagesView.isHidden, "white board Imagesview is not hidden")
    }
    
    func testScenarioWhenSegmentIndexIsFour() {
       //Code View must be visible when selectedSegmentIndex is 4
        reportViewController.scrollableSegment.selectedSegmentIndex = 4
        XCTAssertNotNil(reportViewController.codeView, "codeView is nil")
        XCTAssertFalse(reportViewController.codeView.isHidden, "codeView is hidden")
        
        XCTAssertTrue(reportViewController.audioView.isHidden, "audioView is not hidden")
        XCTAssertTrue(reportViewController.videoView.isHidden, "videoView is not hidden")
        XCTAssertTrue(reportViewController.scoreView.isHidden, "scoreView is not hidden")
        XCTAssertTrue(reportViewController.skillsView.isHidden, "skillsView is not hidden")
        XCTAssertTrue(reportViewController.imagesView.isHidden, "white board Imagesview is not hidden")
    }
    
    func testScenarioWhenSegmentIndexIsFive() {
        //White board View must be visible when selectedSegmentIndex is 5
        reportViewController.scrollableSegment.selectedSegmentIndex = 5
        XCTAssertNotNil(reportViewController.imagesView, "white board imagesView is nil")
        XCTAssertFalse(reportViewController.imagesView.isHidden, "white board Imagesview is hidden")
        
        XCTAssertTrue(reportViewController.audioView.isHidden, "audioView is not hidden")
        XCTAssertTrue(reportViewController.videoView.isHidden, "videoView is not hidden")
        XCTAssertTrue(reportViewController.scoreView.isHidden, "scoreView is not hidden")
        XCTAssertTrue(reportViewController.skillsView.isHidden, "skillsView is not hidden")
        XCTAssertTrue(reportViewController.codeView.isHidden, "Code View is not hidden")
    }
}

extension ReportViewControllerTests {
    
    /*
     - Test if user able to see candidate firstname in navigation title
    */
    func testScenearioIsUserAbleToSeeCandiateNameInNavigationTitle() {
        self.reportViewController.viewModel.getReportViewDetails(interviewCode: reportViewController.interviewCode)
    }
    
    /*
    - Test Scenario when user is on report view score
    */
    func testScenarionSummaryWhenUserIsOnReportScoreView() {
        self.reportViewController.scrollableSegment.selectedSegmentIndex = 0
        self.reportViewController.viewModel.getReportViewDetails(interviewCode: reportViewController.interviewCode)
    }
    
}

extension ReportViewControllerTests {
    
    //MARK: Test Auido and Video Player Controller
    func testScenarioWhenUserClicksOnAudioFile() {
        
        let testRow = IndexPath(row: 0, section: 0)
        reportViewController.audioTableView.delegate?.tableView!(reportViewController.audioTableView, didSelectRowAt: testRow)
                
//        let expectation = XCTestExpectation(description: "test")
//
//           DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
//               guard let avplayerController = UIApplication.topMostViewController() as? AVPlayerViewController else {
//                   XCTFail("AVPlayerViewController is not Top most view controller.")
//                   return
//               }
//               XCTAssertNotNil(avplayerController, "Not able to Navigate avplayerController, instance is nil.")
//              avplayerController.view.layoutIfNeeded()
//              XCTAssertEqual(avplayerController.player?.status, AVPlayer.Status.readyToPlay,"Stub Auido file is not ready to play")
//               expectation.fulfill()
//           }
//
//           wait(for: [expectation], timeout: 15.5)
    }
    
    //Test when user clicks on video file
    func testScenarioWhenUserClicksOnVideoFile() {
        
        let testRow = IndexPath(row: 0, section: 0)
        reportViewController.videosTableView.delegate?.tableView!(reportViewController.videosTableView, didSelectRowAt: testRow)
                
//        let expectation = XCTestExpectation(description: "test")
//
//           DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
//               guard let avplayerController = UIApplication.topMostViewController() as? AVPlayerViewController else {
//                   XCTFail("AVPlayerViewController is not Top most view controller.")
//                   return
//               }
//               XCTAssertNotNil(avplayerController, "Not able to Navigate avplayerController, instance is nil.")
//              avplayerController.view.layoutIfNeeded()
//              XCTAssertEqual(avplayerController.player?.status, AVPlayer.Status.readyToPlay,"Stub Auido file is not ready to play")
//               expectation.fulfill()
//           }
//
//           wait(for: [expectation], timeout: 15.5)
    }
}


