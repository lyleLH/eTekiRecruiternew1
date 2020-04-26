//
//  CandidateDetailsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 11/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class CandidateDetailsViewControllerTests: XCTestCase {
  var candidateDetailsViewController: CandidateDetailsViewController!
  var candidateDetailsNavigationController: UINavigationController!
  var cell : DetailsTableViewCell! = nil
  var addCandidateViewController: AddCandidateViewController!
    
    override func setUp() {
        candidateDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "CandidateDetailsViewController") as? CandidateDetailsViewController
        candidateDetailsNavigationController = UINavigationController(rootViewController: candidateDetailsViewController)
        candidateDetailsViewController.candidatesAPI = CandidateStubApi.self
        candidateDetailsViewController.view.layoutIfNeeded()
        candidateDetailsNavigationController.view.layoutIfNeeded()
        cell = self.candidateDetailsViewController.detailsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailsTableViewCell
        UIApplication.shared.keyWindow?.rootViewController = candidateDetailsNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        candidateDetailsViewController = nil
        candidateDetailsNavigationController = nil
        cell = nil
    }

    
    /*! @brief Scenario CandidateAvailibility tableView number of rows in section */
    func testNumberofRowsInSection(){
        let availbleData = ["13 Nov 2019, 7:00 AM", "13 Nov 2019, 7:00 AM", "13 Nov 2019, 7:00 AM"]
        candidateDetailsViewController.tableViewData = [cellData(opened: true, title: "", sectionData: [], sectionData1: []),
                                                        cellData(opened: true, title: "Candidate Availibility", sectionData: [], sectionData1: availbleData),
                                                        cellData(opened: true, title: "interView", sectionData: [], sectionData1: [])]
        let rows = candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, numberOfRowsInSection: 1)
        XCTAssertEqual(rows , availbleData.count+1)
    }
    
    /*! @brief Scenario CandidateAvailibility tableView number of rows in section with empty list */
    func testNumberofRowsInSectionWithEmpty(){
        candidateDetailsViewController.tableViewData = [cellData(opened: true, title: "", sectionData: [], sectionData1: []),
                                                        cellData(opened: true, title: "Candidate Availibility", sectionData: [], sectionData1: []),
                                                        cellData(opened: true, title: "interView", sectionData: [], sectionData1: [])]
        let rows = candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, numberOfRowsInSection: 1)
        XCTAssertEqual(rows, 2)
    }
    
    /*! @brief Scenario InterViews tableView number of rows in section */
    func testInterviewsNumberofRowsInSection(){
        let interViews = [["start_time" : "13 Nov 2019, 7:00 AM"], ["start_time" : "13 Nov 2019, 7:00 AM"], ["start_time" : "13 Nov 2019, 7:00 AM"]]
           candidateDetailsViewController.tableViewData = [cellData(opened: true, title: "", sectionData: [], sectionData1: []),
                                                           cellData(opened: true, title: "Candidate Availibility", sectionData: [], sectionData1: []),
                                                           cellData.init(opened: true, title: "Interviews", sectionData: interViews, sectionData1: [])]
           let rows = candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, numberOfRowsInSection: 2)
        XCTAssertEqual(rows, interViews.count+1)
    }
    
      /*! @brief Scenario InterViews tableView number of rows in section with empty data*/
    func testInterviewsNumberofRowsInSectionWithEmptyData(){
               candidateDetailsViewController.tableViewData = [cellData(opened: true, title: "", sectionData: [], sectionData1: []),  cellData(opened: true, title: "Candidate Availibility", sectionData: [], sectionData1: []), cellData(opened: true, title: "Interviews", sectionData: [], sectionData1: [])]
              let rows = candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, numberOfRowsInSection: 2)
               XCTAssertEqual(rows , 2)
    }
    
      /*! @brief Scenario when user taps on didSelect whether list is opened*/
    func testTableViewDidSelect(){
        candidateDetailsViewController.tableViewData[1].opened = true
        candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, didSelectRowAt: IndexPath(row: 0, section: 1))
        
    }
    
    /*! @brief Scenario when user taps on didSelect whether list is not opened*/
       func testTableViewDidSelectListisNotOpened(){
           candidateDetailsViewController.tableViewData[1].opened = false
           candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, didSelectRowAt: IndexPath(row: 0, section: 1))
           
       }
    
    /*! @brief Scenario When user taps on back navigation button*/
    func testBackAction(){
        candidateDetailsViewController.backAction(0)
    }
    
    /*! @brief Scenario Candidate details Api call*/
    func testGetCandidateDetails(){
        let stubData : [String : Any] = ["candidate" : [
          "availabilities" : ["2019-11-12T10:00:00.000Z",
            "2019-11-13T04:30:00.000Z",
            "2019-11-13T05:00:00.000Z",
            "2019-11-13T05:30:00.000Z"],
          "contact" : "+12015552639","created_at" : "2019-11-11T11:24:13.000Z",
          "email" : "kkk@gmail.com","feedback_due_by" : "2019-11-11T22:30:00.000Z","full_name" : "kkk",
            "interviews" :[ [
                "interviewers" :  [
                    "Raghavendra Radhakrishna",
                    "Sameena Eteki"
                ],
                "interviewers_count" : 2,
                "start_time" : "2020-12-19T18:15:00.000Z",
                "status" : "Waiting on Interviewer",
            ],[
                "interviewers" :  [],
                "interviewers_count" : 2,
                "start_time" : "<null>",
                "status" : "Completed",
            ],[
                "interviewers" :  [],
                "interviewers_count" : 2,
                "status" : "Completed",
            ]],
            "interviews_count" : 1,"job_status" : "Active","job_title" : "vv","owner_name" : "Ajay ",
            "profile_pics" :     [
                "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
            "resume" : "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3376/resumes/EV Web-Mobile App_BRD1_1.7V_17.10.2019.pdf",
            "status" : "Withdrawn", "withdraw_reason" : "Dfg.   ",
        ],"success" : true,"total_count" : 0]
        let data : [String : Any] = stubData["candidate"] as! [String : Any]
        candidateDetailsViewController.detailsArray = stubData
        CandidateStubApi.getCandidatesresponse = stubData
        candidateDetailsViewController.tableViewData[1].opened = true
        candidateDetailsViewController.tableViewData[2].opened = true
        candidateDetailsViewController.tableViewData[1].sectionData1 = data["availabilities"] as! [Any]
        candidateDetailsViewController.tableViewData[2].sectionData = data["interviews"] as! [[String : Any]]
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.candidateDetailsViewController.detailsTableView.reloadData()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateDetailsViewController.getCandidateDetails()
    }
    
    /*! @brief Scenario Candidate details with null data*/
    func testgetCandidateDetails(){
        candidateDetailsViewController.tableViewData[1].opened = true
        candidateDetailsViewController.tableViewData[2].opened = true
        candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, cellForRowAt: IndexPath(row: 0, section: 1))
        candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, cellForRowAt: IndexPath(row: 0, section: 2))
    }
    
    /*! @brief Scenario when candidate details response is nil */
    func testGetcandidateDetails(){
        CandidateStubApi.getCandidatesresponse = [:]
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.candidateDetailsViewController.detailsTableView.reloadData()
        }
        wait(for: [exp1], timeout: 2.5)
        candidateDetailsViewController.getCandidateDetails()
    }
    
    /*! @brief Scenario when user taps on document with invalid response */
    func testDownloadDocument(){
        candidateDetailsViewController.candidateDetailsResponse = ["candidate" : "cb v","resume": "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3060/resumes/1570180432459.odt"]
        candidateDetailsViewController.downloadDocument()
        candidateDetailsViewController.candidateDetailsResponse = ["candidate" : ["resume1": ""]]
        candidateDetailsViewController.downloadDocument()
    }
    
    /*! @brief Scenario when user taps on document for pdf valid format */
    func testDownloadPdfDocument(){
        candidateDetailsViewController.candidateDetailsResponse = ["candidate" : ["resume": "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3060/resumes/1570180432459.pdf"]]
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()

        }
        wait(for: [exp1], timeout: 2.5)
        candidateDetailsViewController.downloadDocument()
    }
    
    /*! @brief Scenario when user taps on document for pdf valid format */
    func testDownloadOdtDocuments(){
        candidateDetailsViewController.candidateDetailsResponse = ["candidate" : ["resume": "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3060/resumes/1570180432459.odt"]]
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()

        }
        wait(for: [exp1], timeout: 2.5)
        candidateDetailsViewController.downloadDocument()
    }
    
    /*! @brief Scenario when user taps on document */
    func testDownloadAction(){
        candidateDetailsViewController.candidateDetailsResponse = ["candidate" : ["resume": "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3060/resumes/1570180432459.pdf"]]
        candidateDetailsViewController.tableViewData[0].opened = true
        let cell = candidateDetailsViewController.tableView(candidateDetailsViewController.detailsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DetailsTableViewCell
        cell?.documentImageView.borderWidth
        cell?.documentImageView.cornerRadius
        cell?.documentImageView.borderColor
        cell?.documentButton.setImageWithText(image: (cell?.documentImageView.image)!, withTitle: "document")
        cell?.documentButton.borderColor
        cell?.documentImageView.dowloadFromServer(url: URL(fileURLWithPath: "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png"), contentMode: candidateDetailsViewController.contentView.contentMode)
        cell?.documentImageView.dowloadFromServer(link: "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png", contentMode: candidateDetailsViewController.contentView.contentMode)
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()

        }
        wait(for: [exp1], timeout: 2.5)
        cell?.documentButton.sendActions(for: .touchUpInside)
    }

}
