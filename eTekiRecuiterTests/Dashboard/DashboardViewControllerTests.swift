//
//  DashboardViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 27/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class DashboardViewControllerTests: XCTestCase {
    
    var dashboardViewController: DashboardViewController!
    var dashboardNavigationController: UINavigationController!
    var cell : DashBoardTableViewCell! = nil
    var cell1: MyInterviewsTableViewCell! = nil
    var menuTableViewController : MenuTableViewController!
    var createJobModal = CreateJobViewModel()
    
    override func setUp() {
        dashboardViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
        dashboardNavigationController = UINavigationController(rootViewController: dashboardViewController)
        dashboardViewController.view.layoutIfNeeded()
        dashboardNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = dashboardNavigationController
        cell = self.dashboardViewController.dashboardTableView.cellForRow(at: IndexPath(row: 0, section:0)) as? DashBoardTableViewCell
        cell1 = self.dashboardViewController.dashboardTableView.cellForRow(at: IndexPath(row: 0, section:0)) as? MyInterviewsTableViewCell
        menuTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        menuTableViewController?.view.layoutIfNeeded()
    }
    
    func testcallBackToParent(){
        dashboardViewController.loadItems()
        dashboardViewController.callBackToParent()
    }
    
    func testcustomAlertToParent(){
        dashboardViewController.loadItems()
        dashboardViewController.customAlertToParent()
    }
    
    override func tearDown() {
        dashboardViewController = nil
        dashboardNavigationController = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(dashboardViewController, "Not able to create DashboardViewController Instance.")
        XCTAssertNotNil(dashboardViewController.segmentControl, "Not able to create DashboardViewController segmentControl Instance.")
        XCTAssertNotNil(dashboardViewController.segmentControl, "Not able to create DashboardViewController segmentControl Instance.")
        XCTAssertNotNil(dashboardViewController.filterButton, "Not able to create DashboardViewController filterButton Instance.")
        XCTAssertNotNil(dashboardViewController.createJob, "Not able to create DashboardViewController createJob Instance.")
    }
    
    func testNavigationBar() {
        XCTAssertFalse(dashboardViewController.navigationController?.isNavigationBarHidden ?? true, "NavigationBar is hidden by default")
        XCTAssertEqual(dashboardViewController.navigationItem.title, "DASHBOARD".localized, "Navigation item title mismatch")
        XCTAssertNotEqual(dashboardViewController.navigationItem.title, "DASHBOARD", "DASHBOARD localized key not found in .strings file.")
    }
    
    func testNavigationBarMenuItem() {
        if let leftButton = dashboardViewController.navigationItem.leftBarButtonItem {
            XCTAssertNotNil(leftButton, "Left Bar Button item instance is nil.")
            XCTAssertTrue(leftButton.isEnabled , "Menu Button is diasabled")
            _ = UIImage(named: "menu")
            //        XCTAssertEqual(leftButton.image, menuIcon, "Image Mismatch")
        } else {
            XCTFail("Left Bar Button item instance is nil.")
        }
    }
    
    func testPefromSegue() {
        let result = dashboardViewController.shouldPerformSegue(withIdentifier: "MenuSegue", sender: self.dashboardViewController)
        XCTAssertTrue(result, "Should Perform Segue returns false")
        let result1 = dashboardViewController.shouldPerformSegue(withIdentifier: "MenuSegue1", sender: self.dashboardViewController)
        XCTAssertTrue(result1, "Should Perform Segue returns true")
    }
    
    
    func testLoadItems(){
        dashboardViewController.jobsArray = [["job": "job1"], ["job": "job2"], ["job": "job3"]]
        dashboardViewController.loadDefaultJobs()
        //        XCTAssertEqual(dashboardViewController.jobTypes, ["MyJobs"])
        XCTAssertEqual(dashboardViewController.dashboardTableView.isHidden, true)
    }
    
    
    
    //    func testsetDefaultFilters(){
    //       dashboardViewController.setDefaultFilters()
    //       XCTAssertEqual(dashboardViewController.statusFilters , ["Active"])
    //    }
    
    func testScrollViewDidEnding(){
        dashboardViewController.scrollViewDidEndDragging(dashboardViewController.dashboardTableView, willDecelerate: true)
        dashboardViewController.totalCount = 3
        dashboardViewController.scrollViewDidEndDragging(dashboardViewController.dashboardTableView, willDecelerate: true)
        
        dashboardViewController.scrollViewDidEndDragging(dashboardViewController.interViewsTableView, willDecelerate: true)
        dashboardViewController.tableViewData = [interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
        dashboardViewController.scrollViewDidEndDragging(dashboardViewController.interViewsTableView, willDecelerate: true)
    }
    
    func testreactivateJob(){
        dashboardViewController.jobsArray = [["id" : 3968, "name": "afreen"],["id" : 3965, "name": "afreen"]]
        dashboardViewController.reactivateJob(UIButton())
        XCTAssertEqual(dashboardViewController.selectedJobId, "3968")
    }
    
    func testSearchByAction(){
        dashboardViewController.jobsArray = [["id" : 3968, "name": "afreen"],["id" : 3965, "name": "afreen"]]
        dashboardViewController.searchByAction(0)
        dashboardViewController.segmentControl.selectedSegmentIndex = 1
        dashboardViewController.searchByAction(0)
    }
    
    func testflagIconOnClick(){
        dashboardViewController.jobsArray = [["id" : 3968, "owner_name": "Harik K"],["id" : 3965, "owner_name": "Afreen sk"]]
        dashboardViewController.flagIconOnClick(UIButton())
    }
    
    func testSegmentedControlAction(){
        let typeAnyObject =  NSObject()
        dashboardViewController.segmentedControlAction(sender: typeAnyObject)
        XCTAssertEqual(dashboardViewController.createJob.isHidden, false)
        let typeAnyObject1 =  NSObject()
        dashboardViewController.segmentControl.selectedSegmentIndex = 1
        dashboardViewController.segmentedControlAction(sender: typeAnyObject1)
        XCTAssertEqual(dashboardViewController.createJob.isHidden, true)
    }
    
    func testSearchAction(){
        dashboardViewController.searchAction(0)
        dashboardViewController.keyWordsTextField.text = "s"
        dashboardViewController.jobsArray = [["id" : 3968, "name": "afreen"],["id" : 3965, "name": "afreen"]]
        dashboardViewController.searchAction(0)
    
        dashboardViewController.searchByButton.setTitle("Job Title", for: .normal)
        dashboardViewController.searchAction(0)
        dashboardViewController.searchByButton.setTitle("Hiring Company Name", for: .normal)
        dashboardViewController.searchAction(0)
        dashboardViewController.searchByButton.setTitle("Recruiter Name", for: .normal)
        dashboardViewController.searchAction(0)
        dashboardViewController.searchByButton.setTitle("Candidate Name", for: .normal)
        dashboardViewController.searchAction(0)
        dashboardViewController.segmentControl.selectedSegmentIndex = 1
        dashboardViewController.searchByButton.setTitle("Interviewer Name", for: .normal)
        dashboardViewController.searchAction(0)
        
    }
    
    func testSearchValueUpdate(){
        dashboardViewController.keyWordsTextField.text = "s"
        dashboardViewController.searchValueUpdate(0)
    }
    
    func testFilterButton() {
        XCTAssertNotNil(dashboardViewController.filterButton, "filterButton instance is nil.")
        XCTAssertFalse(dashboardViewController.filterButton.isHidden , "filterButton is hidden")
        XCTAssertTrue(dashboardViewController.filterButton.isEnabled , "filterButton is disabled")
        XCTAssertEqual(dashboardViewController.filterButton.frame.size.height, 40.0, "filterButton  height Mismatch")
    }
    
    func testCloseJObAction(){
        dashboardViewController.jobsArray = [["id" : 3968, "name": "afreen"],["id" : 3965, "name": "afreen"]]
        dashboardViewController.closeJobAction(UIButton())
        XCTAssertEqual(dashboardViewController.selectedJobId, "3968")
    }
    
    func testPrepareForSegue(){
        let segue = UIStoryboardSegue(identifier: "DashboardToCustomMessage", source: DashboardViewController(), destination: CustomAlertViewController())
        dashboardViewController.prepare(for: segue, sender: nil)
    }
    
    func testheightForRow(){
        dashboardViewController.jobsArray = [["id" : 3968, "name": "afreen"],["id" : 3965, "name": "afreen"]]
        for i in 0...dashboardViewController.jobsArray.count-1 {
            let height = dashboardViewController.tableView(dashboardViewController.dashboardTableView, heightForRowAt: IndexPath(row: i, section: 0))
            XCTAssertEqual(height, UITableView.automaticDimension)
        }
        
    }
    
    func testCellforRowat(){
        dashboardViewController.jobsArray = [["id" : 3968, "title": "Sr.Developer", "skillset": "c", "due_at": "2019-12-09", "candidates_count": ["completed": 1, "pending": 0, "total": 1], "status": "Active","pending_candidate_availabilities": 0, "collaborated_job": true, "job_permissions" : [
                                                                "Candidate Edit" : 1 ,
                                                                "Candidate Notify" : 1,
                                                                "Candidate View" : 1,
                                                                "Interview Edit" : 1,
                                                                "Interview Notify" : 1,
                                                                "Interview View" : 1,
                                                                "Job Edit" : 1,
                                                                "Job Notify" : 1,
                                                                "Job View" : 1
        ]]]
        for i in 0...dashboardViewController.jobsArray.count-1 {
            _ = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: i, section: 0)) as! DashBoardTableViewCell
            //row.closeJob.stopBlink()
        }
        dashboardViewController.jobsArray = [["id" : 3968, "title": "Sr.Developer", "skillset": "c", "candidates_count": ["completed": 1, "pending": 0, "total": 1], "status": "Inactive", "collaborated_job": false, "pending_candidate_availabilities": 2, "job_permissions" : [
                                                                "Candidate Edit" : 1 ,
                                                                "Candidate Notify" : 1,
                                                                "Candidate View" : 1,
                                                                "Interview Edit" : 1,
                                                                "Interview Notify" : 1,
                                                                "Interview View" : 1,
                                                                "Job Edit" : 1,
                                                                "Job Notify" : 1,
                                                                "Job View" : 1
        ]]]
        for i in 0...dashboardViewController.jobsArray.count-1 {
            _ = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: i, section: 0)) as! DashBoardTableViewCell
            //row.closeJob.startBlink()
        }
        
    }
    
    
    
    func testMoreActions(){
        dashboardViewController.jobsArray = [["id" : 3968, "title": "Sr.Developer", "skillset": "c", "due_at": "2019-12-09", "candidates_count": ["completed": 1, "pending": 0, "total": 1], "status": "Active", "collaborated_job": true]]
        dashboardViewController.moreActions(UIButton())
        dashboardViewController.jobsArray = [["id" : "3968", "title": "Sr.Developer", "skillset": "c", "due_at": "2019-12-09", "candidates_count": ["completed": 1, "pending": 0, "total": 1], "status": "Inactive", "collaborated_job": true]]
        dashboardViewController.moreActions(UIButton())
        dashboardViewController.jobsArray = [["id" : "3968", "title": "Sr.Developer", "skillset": "c", "due_at": "2019-12-09", "candidates_count": ["completed": 1, "pending": 0, "total": 1], "collaborated_job": true]]
        dashboardViewController.moreActions(UIButton())
    }
    
    func testloadItems(){
        let response = ["success": 1, "next_page": 2, "jobs": [["candidates_count" : [ "completed" : 0 ,"pending" : 0, "total" : 0], "collaborated_job" : 0, "created_at" : "2019-10-18T04:28:47.000Z", "due_at" : "2019-11-18", "expertise_category" : "Enterprise & Off Shelf Applications (ERP, CRM, SCM, PLM)", "id" : 3209, "interview_access" : 0,
                                                                "job_permissions" : [
                                                                    "Candidate Edit" : 1 ,
                                                                    "Candidate Notify" : 1,
                                                                    "Candidate View" : 1,
                                                                    "Interview Edit" : 1,
                                                                    "Interview Notify" : 1,
                                                                    "Interview View" : 1,
                                                                    "Job Edit" : 1,
                                                                    "Job Notify" : 1,
                                                                    "Job View" : 1
            ], "matched_interviewers_count" : 0, "owner_name" : "dada", "pending_candidate_availabilities" : 0,
               "skillset" : "ISDN",
               "status" : "Active",
               "title" : "NewJob18October",
            ]]
            ] as [String : Any]
        dashboardViewController.currentPage = 1
        dashboardViewController.statusFilters = ["Active"]
        dashboardViewController.jobTypes = ["MyJobs"]
//        dashboardViewController.dueAts = []
        dashboardViewController.filterDueDate = "2019-11-18"
        let _ = JobsManager(page: "1", perPage: "10", status: dashboardViewController.statusFilters, currentTypes: dashboardViewController.jobTypes, searchBy: ["title": "s"], closingDate: "2019-11-18")
        DashboardStubApi.getJobsCall = response
        //        self.createJobModal.jobListingAPI = DashboardStubApi.self
        dashboardViewController.showBanner(title: "", withMessage:  "Unable to reach Server Error", style: .danger)
        dashboardViewController.removeSpinner()
        dashboardViewController.loadItems()
        dashboardViewController.statusFilters = []
        dashboardViewController.jobTypes = []
//        dashboardViewController.dueAts = []
        dashboardViewController.loadItems()
    }
    
    func testshowFiltersAction(){
        dashboardViewController.showFiltersAction(0)
        dashboardViewController.statusFilters = ["Inactive"]
        dashboardViewController.jobTypes = ["My Collaboration"]
        dashboardViewController.filterDueDate = "2019-11-18"
//        dashboardViewController.dueAts = ["2019-11-18"]
        dashboardViewController.showFiltersAction(0)
        dashboardViewController.statusFilters = ["Active"]
        dashboardViewController.jobTypes = ["My Collaboration"]
        dashboardViewController.filterDueDate = "2019-11-18"
//        dashboardViewController.dueAts = ["2019-11-18"]
        dashboardViewController.showFiltersAction(0)
        
    }
    
    func testgetDefaultFilters(){
        
        let response = CreateJobResponse(message: "filters saved", categoryName: "My jobs", categoryID: "3098", categories: ["My jobs", "My Contributors"], autoSkills: ["c", "swift"], success: true, clientCompanyName: "Facebook", codingRequired: true, jobDescription: "description", dueDate: "2019-12-18", experirenceRequired: 3, expertiseCategory: "Development", idRequired: true, interViewMode: "Audio", interviewMinimumPricing: "123", interviewMaximuPrice: "4556", interViewLanguagePreference: "English", interViewLocationPreference: "India", jobCode: "12", numberOfProspects: 2, specialInstructions: "nothing", preferedSkillSet: "c", skillset: "database", interViewersCount: 4, whiteboradRequired: true, companyLogo: "sdfjh.png", jobDescriptionAwsurl: "dsfgdfg", jobTitle: "developer", skillsAutoCompleteText: "complere", autoSource: true, agent: "self", skill: "c", skillType: "required", jobId: "3098", status: "Active", recordingEnabled: true, statusFilters: ["Active"], filterDueDate: "2019-10-12", jobTypes: ["My Jobs"], interViewTypes: ["Audio"], isIndependentRecruiter: false)
        let manager = JobsManager(currentTab: .myJobs)
        dashboardViewController.showSpinner()
        DashboardStubApi.defaultfilters = response
        //        self.createJobModal.jobListingAPI = DashboardStubApi.self
        JobListingAPI.getDefaultFilters(jobDetails: manager) { (response, error) in
            
        }
       // dashboardViewController.getDefaultFilters(currentTab: .myJobs)
    }
    
    
    func testUpdateFilters(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["filters":[["job_type[]": .myJobs, "status[]": "true", "due_date[]" : "12-09-2019"],["job_type": "My Contributor Jobs", "status": "true", "due_date" :"17-09-2019"]]])
        
        dashboardViewController.jobsArray = [["job": "job1"], ["job": "job2"], ["job": "job3"]]
        self.dashboardViewController.currentPage = 0
        self.dashboardViewController.noDataView.isHidden = false
        self.dashboardViewController.dashboardTableView.reloadData()
        
        dashboardViewController.jobsArray = [["job": "job1"], ["job": "job2"], ["job": "job3"]]
        dashboardViewController.showSpinner()
        dashboardViewController.updateFilters(notfication: notification)
        dashboardViewController.showFiltersAction(0)
        
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["filters":["job_type[]": "MyJobs", "status[]": "true", "due_date[]": "12-09-2019"]])
        dashboardViewController.updateFilters(notfication: notification1)
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil)
        dashboardViewController.updateFilters(notfication: notification2)
        let notification3 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["filters":[["job_type[]": "MyJobs", "status[]": "true", "due_date[]" : "12-09-2019"],["job_type[]": "My Contributor Jobs", "status[]": "true", "due_date[]" : "17-09-2019"]]])
        dashboardViewController.jobsArray = [["job": "job1"], ["job": "job2"], ["job": "job3"]]
        dashboardViewController.showSpinner()
        dashboardViewController.segmentControl.selectedSegmentIndex = 1
        _ = JobsManager(currentTab: "My Jobs", status: ["Active","Inactive"], currentTypes: ["My Jobs", "My Contributors"], closingDate: "12-09-2015")
        dashboardViewController.updateFilters(notfication: notification3)
        dashboardViewController.showFiltersAction(0)
        
    }
    
    func testUpdateInterviewsFilters(){
        dashboardViewController.interviewsArray = [["Scheduling": MyinterviewsStatus.waitingOnInterviewer]]
        dashboardViewController.tableViewData = [interViewData(opened: false, isColloborate: true, title: "", jobId: "23444", owner: "Anusha", sectionData: [], permissions: [:])]
        _ = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["interviewFilters":[["interview_type": [MyinterviewsStatus.myInterviews], "status_filters": [["Scheduling": [MyinterviewsStatus.waitingOnCandidate]]]],["interview_type": [MyinterviewsStatus.contributorInterviews], "status_filters": [["Scheduling": [MyinterviewsStatus.waitingOnCandidate, MyinterviewsStatus.waitingOnInterviewer]]]]], "interviewData": [interViewData(opened: false, isColloborate: true, title: "", jobId: "23444", owner: "Anusha", sectionData: [], permissions: [:])]])
//        let expectation = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 3.0)
//        dashboardViewController.updateInterviewFilters(notfication: notification)
        
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["interviewFilters":[["interview_type": [MyinterviewsStatus.myInterviews], "status_filters": [["Scheduling": [MyinterviewsStatus.waitingOnCandidate]]]],["interview_type": [MyinterviewsStatus.contributorInterviews], "status_filters": [["Scheduling": [MyinterviewsStatus.waitingOnCandidate]]]]]])
//        let expectation1 = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
//            expectation1.fulfill()
//        }
//        wait(for: [expectation1], timeout: 3.0)
        dashboardViewController.updateInterviewFilters(notfication: notification1)
        
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil)
//        let expectation2 = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
//            expectation2.fulfill()
//        }
//        wait(for: [expectation2], timeout: 3.0)
        dashboardViewController.updateInterviewFilters(notfication: notification2)
        
        let notification3 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["interviewFilters":[["interview_type": [MyinterviewsStatus.myInterviews], "status_filters": [["Scheduling": [MyinterviewsStatus.waitingOnCandidate]]]],["interview_type": [MyinterviewsStatus.contributorInterviews], "status_filters": [["Scheduling": [MyinterviewsStatus.waitingOnCandidate]]]]]])
        dashboardViewController.responseArray = [["status": MyinterviewsStatus.pendingReport],["status": MyinterviewsStatus.inProgress]]
//        let expectation3 = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
//            expectation3.fulfill()
//        }
//        wait(for: [expectation3], timeout: 3.0)
        dashboardViewController.updateInterviewFilters(notfication: notification3)
        
        let notification4 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["interviewFilters": [:]])
//        let expectation4 = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
//            expectation4.fulfill()
//        }
//        wait(for: [expectation4], timeout: 3.0)
        dashboardViewController.updateInterviewFilters(notfication: notification4)
    }
    
    func testUpdateSaveFilters(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["filters":[["job_type[]": .myJobs, "status[]": "true", "due_date" : "12-09-2019"],["job_type": "My Contributor Jobs", "status[]": "true", "due_date" :"17-09-2019"]]])
        let expectation = XCTestExpectation(description: "test")
        dashboardViewController.jobsArray = [["job": "job1"], ["job": "job2"], ["job": "job3"]]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            expectation.fulfill()
            self.dashboardViewController.noDataView.isHidden = false
            //self.dashboardViewController.viewModel.callSaveFiltersAPI()
        }
        wait(for: [expectation], timeout: 2.5)
        dashboardViewController.segmentControl.selectedSegmentIndex = 1
        dashboardViewController.showSpinner()
        dashboardViewController.updateSavedFilters(notfication: notification)
        dashboardViewController.showFiltersAction(0)
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["filters":["job_type[]": "MyJobs", "status[]": "true", "due_date[]": "12-09-2019"]])
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 2.5)
        dashboardViewController.updateSavedFilters(notfication: notification1)
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil)
        dashboardViewController.updateSavedFilters(notfication: notification2)
        let notification3 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["filters":[["job_type[]": "MyJobs", "status[]": "true", "due_date[]" : "12-09-2019"],["job_type[]": "My Contributor Jobs", "status[]": "true", "due_date" : "17-09-2019"]]])
        dashboardViewController.jobsArray = [["job": "job1"], ["job": "job2"], ["job": "job3"]]
        dashboardViewController.showSpinner()
        let expectation2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 2.5)
        dashboardViewController.segmentControl.selectedSegmentIndex = 1
        let manager = JobsManager(currentTab: "My Jobs", status: ["Active","Inactive"], currentTypes: ["My Jobs", "My Contributors"], closingDate: "12-09-2015")
        JobListingAPI.saveFilters(jobDetails: manager) { (response,error) in
           
        }
        dashboardViewController.updateSavedFilters(notfication: notification3)
        dashboardViewController.showFiltersAction(0)
    }
    
    func testcallSaveFiltersApi() {
        dashboardViewController.statusFilters = ["Active"]
        dashboardViewController.jobTypes = ["My Jobs"]
        let manager = JobsManager(currentTab: .myJobs, status: dashboardViewController.statusFilters, currentTypes: dashboardViewController.jobTypes, closingDate: "12-09-2019")
        let response = CreateJobResponse(json: ["data":["message": "Filters saved successfully"]], success: true, message: "job status move to active")
        DashboardStubApi.statusFilters = response
        JobListingAPI.saveFilters(jobDetails: manager){ (response, Error ) in
         
        }
        //dashboardViewController.callSaveFiltersAPI()
    }
    
    func testCandidatesDetails(){
        dashboardViewController.jobsArray = [["id" : 3968, "name": "afreen"],["id" : 3965, "name": "afreen"]]
        dashboardViewController.candidatesDetail(UIButton())
    }
    
    func testAddCandidateAction(){
        dashboardViewController.jobsArray = [["id" : 3968, "due_at": "2028-10-27"],["id" : 3965, "due_at": "2019-10-25"]]
        dashboardViewController.addCandiateAction(UIButton())
        dashboardViewController.jobsArray = [["id" : 3968, "due_at": "2019-12-12"],["id" : 3965, "due_at": "2019-12-12"]]
        dashboardViewController.addCandiateAction(UIButton())
    }
    
}


extension DashboardViewControllerTests {
    
    //Scenario  ---- Dashboard to Candidates with Completed Status
    func testNaviagtionToCandidatesWithCompletedStatus() {
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       dashboardViewController.dashboardTableView.dataSource?.tableView(dashboardViewController.dashboardTableView, cellForRowAt: testRow) as! DashBoardTableViewCell
        dashboardViewController.jobsArray = [["candidates_count" : ["pending": 3, "completed": 1, "total": 4]]]
        cell.completedButton.tag = 0
        cell.completedButton.sendActions(for: .touchUpInside)
        
        guard let candidatesViewController = UIApplication.topMostViewController() as? CandidatesViewController else {
        XCTFail("candidatesViewController is not Top most view controller.")
        return
        }
        XCTAssertNotNil(candidatesViewController, "Not able to Navigate CandidatesViewController, instance is nil.")
        candidatesViewController.view.layoutIfNeeded()
        XCTAssertEqual(candidatesViewController.navigationItem.title, "Candidates", "candidatesViewController not loaded")
        XCTAssertEqual(candidatesViewController.selectStatusButton.titleLabel?.text, "Completed", "Current Selected Status Label not matching")
    }
    
    //Scenario  ---- Dashboard to Candidates with Completed Status Zero
    func testNaviagtionToCandidatesWithCompletedStatusZero() {
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       dashboardViewController.dashboardTableView.dataSource?.tableView(dashboardViewController.dashboardTableView, cellForRowAt: testRow) as! DashBoardTableViewCell
        dashboardViewController.jobsArray = [["candidates_count" : ["pending": 3, "completed": 0, "total": 4]]]
        cell.completedButton.tag = 0
        cell.completedButton.sendActions(for: .touchUpInside)
        guard let dashboardViewController = UIApplication.topMostViewController() as? DashboardViewController else {
        XCTFail("DashboardViewController is not Top most view controller.")
        return
        }
        XCTAssertNotNil(dashboardViewController, "Not able to Navigate dashboardViewController, instance is nil.")
        dashboardViewController.view.layoutIfNeeded()


        XCTAssertEqual(dashboardViewController.navigationItem.title, "Dashboard", "candidatesViewController not loaded")

    }
    
    //Scenario  ---- Dashboard to Candidates with Pending Status
    func testNaviagtionToCandidatesWithPendingStatus() {
        
        guard let dashboardViewController = UIApplication.topMostViewController() as? DashboardViewController else {
                            XCTFail("dashboardViewController is not Top most view controller.")
                           return
        }
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       dashboardViewController.dashboardTableView.dataSource?.tableView(dashboardViewController.dashboardTableView, cellForRowAt: testRow) as! DashBoardTableViewCell
        dashboardViewController.jobsArray = [["candidates_count" : ["pending": 3, "completed": 1, "total": 4]]]
        cell.pendingButton.tag = 0
        cell.pendingButton.sendActions(for: .touchUpInside)
        guard let candidatesViewController = UIApplication.topMostViewController() as? CandidatesViewController else {
        XCTFail("candidatesViewController is not Top most view controller.")
        return
        }

        XCTAssertNotNil(candidatesViewController, "Not able to Navigate CandidatesViewController, instance is nil.")
        candidatesViewController.view.layoutIfNeeded()


        XCTAssertEqual(candidatesViewController.navigationItem.title, "Candidates", "candidatesViewController not loaded")
        XCTAssertEqual(candidatesViewController.selectStatusButton?.titleLabel?.text, "Pending Interview", "Current Selected Status Label not matching")
    }
    
    //Scenario  ---- Dashboard to Candidates with Pending Status Zero
    func testNaviagtionToCandidatesWithPendingStatusZero() {
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       dashboardViewController.dashboardTableView.dataSource?.tableView(dashboardViewController.dashboardTableView, cellForRowAt: testRow) as! DashBoardTableViewCell
        dashboardViewController.jobsArray = [["candidates_count" : ["pending": 0, "completed": 1, "total": 4]]]
        cell.pendingButton.tag = 0
        cell.pendingButton.sendActions(for: .touchUpInside)
        guard let dashboardViewController = UIApplication.topMostViewController() as? DashboardViewController else {
        XCTFail("DashboardViewController is not Top most view controller.")
        return
        }
        

        XCTAssertNotNil(dashboardViewController, "Not able to Navigate dashboardViewController, instance is nil.")
        dashboardViewController.view.layoutIfNeeded()


        XCTAssertEqual(dashboardViewController.navigationItem.title, "Dashboard", "candidatesViewController not loaded")
        dashboardViewController.view.layoutIfNeeded()
    }
    
    //Scenario  ---- Dashboard to Candidates with All Status
    func testNaviagtionToCandidatesWithAllStatus() {
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       dashboardViewController.dashboardTableView.dataSource?.tableView(dashboardViewController.dashboardTableView, cellForRowAt: testRow) as! DashBoardTableViewCell
        dashboardViewController.jobsArray = [["candidates_count" : ["pending": 3, "completed": 1, "total": 4]]]
        cell.candidateDetailsButton.tag = 0
        cell.candidateDetailsButton.sendActions(for: .touchUpInside)
        guard let candidatesViewController = UIApplication.topMostViewController() as? CandidatesViewController else {
        XCTFail("candidatesViewController is not Top most view controller.")
        return
        }
        
        candidatesViewController.view.layoutIfNeeded()
        XCTAssertNotNil(candidatesViewController, "Not able to Navigate CandidatesViewController, instance is nil.")

        XCTAssertEqual(candidatesViewController.navigationItem.title, "Candidates", "candidatesViewController not loaded")
        
        guard let buttonTitle = candidatesViewController.selectStatusButton.currentTitle else {
           XCTFail("Button title is Nil.")
            return}
        XCTAssertEqual(buttonTitle, "All", "Current Selected Status Label not matching")
        candidatesViewController.view.layoutIfNeeded()
    }
    
    //Scenario  ---- Dashboard to Candidates with All Status Zero
    func testNaviagtionToCandidatesWithAllStatusZero() {
        let testRow = IndexPath(row: 0, section: 0)
        let cell =       dashboardViewController.dashboardTableView.dataSource?.tableView(dashboardViewController.dashboardTableView, cellForRowAt: testRow) as! DashBoardTableViewCell
        dashboardViewController.jobsArray = [["candidates_count" : ["pending": 3, "completed": 1, "total": 0]]]
        cell.candidateDetailsButton.tag = 0
        cell.candidateDetailsButton.sendActions(for: .touchUpInside)
        guard let dashboardViewController = UIApplication.topMostViewController() as? DashboardViewController else {
        XCTFail("DashboardViewController is not Top most view controller.")
        return
        }
        XCTAssertNotNil(dashboardViewController, "Not able to Navigate dashboardViewController, instance is nil.")

        XCTAssertEqual(dashboardViewController.navigationItem.title, "Dashboard", "Dashboard view controller not loaded")
        dashboardViewController.view.layoutIfNeeded()
    }

    func testCreateJobAction(){
        dashboardViewController.createJob.sendActions(for: .touchUpInside)
    }
    
    func testLoadDefaultInterviews(){
        dashboardViewController.interviewsArray = [["interview": "Scheduling"]]
        dashboardViewController.tableViewData = [interViewData(opened: false, isColloborate: true, title: "", jobId: "2333", owner: "Anusha", sectionData: [], permissions: [:])]
        dashboardViewController.loadDefaultInterviews()
    }
    
    func testShareJobActionFromMyJobs(){
        dashboardViewController.jobsArray = [["id": 1234], ["id": 3332], ["id": 5566]]
        let cell = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DashBoardTableViewCell
        dashboardViewController.shareJob(cell?.shareButton ?? UIButton())
        guard let shareInterviewViewController = UIApplication.topMostViewController() as? ShareInterviewViewController else {
        XCTFail("ShareInterviewViewController is not Top most view controller.")
        return
        }
        XCTAssertNotNil(shareInterviewViewController, "Not able to Navigate ShareInterviewViewController, instance is nil.")
    }

    func testScenarioWhenContributorJobIsTappedInMyInterviews(){
        dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "3344", owner: "Anusha", sectionData: [], permissions: [:])]
        let cell = dashboardViewController.interViewsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MyInterviewsTableViewCell
        dashboardViewController.contributorFlagOnClick(cell?.contributorFlagIcon ?? UIButton())
    }
    
    func testScenarioWhenUserTappedOnCalendarAvalibility(){
        dashboardViewController.jobsArray = [["due_at": "2028-12-02", "candidates_count": ["total": 7, "withdraw": 2, "completed": 1 ], "id": 1234], ["due_at": "2028-12-02", "candidates_count": ["total": 0, "withdraw": 0, "completed": 0 ], "id": 1234], ["due_at": "2028-12-02", "candidates_count": ["total": 2, "withdraw": 1, "completed": 1 ], "id": 1234], ["due_at": "2019-12-02", "candidates_count": ["total": 2, "withdraw": 1, "completed": 1 ], "id": 1234]]
        
        let cell1 = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? DashBoardTableViewCell
        dashboardViewController.candidateAvailabiltyAction(cell1?.candidateAvailabity ?? UIButton())
        
        let cell2 = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? DashBoardTableViewCell
        dashboardViewController.candidateAvailabiltyAction(cell2?.candidateAvailabity ?? UIButton())
        
        let cell3 = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? DashBoardTableViewCell
        dashboardViewController.candidateAvailabiltyAction(cell3?.candidateAvailabity ?? UIButton())
        
        let cell = dashboardViewController.tableView(dashboardViewController.dashboardTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DashBoardTableViewCell
        dashboardViewController.candidateAvailabiltyAction(cell?.candidateAvailabity ?? UIButton())
        guard let provideAvailabiltyViewController = UIApplication.topMostViewController() as? ProvideAvailabiltyViewController else {
               XCTFail("ProvideAvailabiltyViewController is not Top most view controller.")
               return
        }
        XCTAssertNotNil(provideAvailabiltyViewController, "Not able to Navigate ProvideAvailabiltyViewController, instance is nil.")
    }
    
    func testUpdateDashboardAfterNewCandidateAdded(){
        dashboardViewController.jobsArray = [["due_at": "2028-12-02", "candidates_count": ["total": 7, "withdraw": 2, "completed": 1 ], "id": 1234], ["due_at": "2028-12-02", "candidates_count": ["total": 0, "withdraw": 0, "completed": 0 ], "id": 1234], ["due_at": "2028-12-02", "candidates_count": ["total": 2, "withdraw": 1, "completed": 1 ], "id": 1234], ["due_at": "2019-12-02", "candidates_count": ["total": 2, "withdraw": 1, "completed": 1 ], "id": 1234]]
        let notification = NSNotification(name: NSNotification.Name(rawValue: "RefreshDashboard"), object: nil, userInfo: nil)
        dashboardViewController.updateDashboard(notfication: notification)
        XCTAssertEqual(dashboardViewController.noDataView.isHidden, false)
        XCTAssertEqual(dashboardViewController.dashboardTableView.isHidden, true)
    }
    
    
}

//MARK: Test Myinterview Statuses Actions
extension DashboardViewControllerTests {
   func testMyInterviewsCloseButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "close"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let customAlertViewController = UIApplication.topMostViewController() as? CustomAlertViewController else {
              XCTFail("CustomAlertViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(customAlertViewController, "Not able to Navigate CustomAlertViewController, instance is nil.")
   }
   
   func testMyInterviewsnReportviewButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "notepad"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let reportViewController = UIApplication.topMostViewController() as? ReportViewController else {
              XCTFail("ReportViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(reportViewController, "Not able to Navigate ReportViewController, instance is nil.")
   }
   
   func testMyInterviewsnRatingButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "star"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let rateInterviewerViewController = UIApplication.topMostViewController() as? RateInterviewerViewController else {
              XCTFail("RateInterviewerViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(rateInterviewerViewController, "Not able to Navigate RateInterviewerViewController, instance is nil.")
   }
   
   func testMyInterviewsnShowVideosButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "eye"), for: .normal)
       dashboardViewController.clickIcon4Action(button)
       guard let showVideosViewController = UIApplication.topMostViewController() as? ShowVideosViewController else {
              XCTFail("ShowVideosViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(showVideosViewController, "Not able to Navigate ShowVideosViewController, instance is nil.")
   }
   
   func testMyInterviewsnShareButtonActionFromMyJobs(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "share"), for: .normal)
       dashboardViewController.clickIcon2Action(button)
       guard let shareInterviewViewController = UIApplication.topMostViewController() as? ShareInterviewViewController else {
              XCTFail("ShareInterviewViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(shareInterviewViewController, "Not able to Navigate ShareInterviewViewController, instance is nil.")
   }
   
   func testMyInterviewsnShareButtonActionFromMyInterviews(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "share"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let shareInterviewViewController = UIApplication.topMostViewController() as? ShareInterviewViewController else {
              XCTFail("ShareInterviewViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(shareInterviewViewController, "Not able to Navigate ShareInterviewViewController, instance is nil.")
   }
   
   func testMyInterviewsWithdrawButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "withdraw"), for: .normal)
       dashboardViewController.clickIcon2Action(button)
       guard let customAlertViewController = UIApplication.topMostViewController() as? CustomAlertViewController else {
              XCTFail("CustomAlertViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(customAlertViewController, "Not able to Navigate CustomAlertViewController, instance is nil.")
   }
   
   func testMyInterviewsNoShowReasonButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "No Show", "no_show_reason": "reason"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "edit"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let noshowReasonViewController = UIApplication.topMostViewController() as? NoshowReasonViewController else {
              XCTFail("NoshowReasonViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(noshowReasonViewController, "Not able to Navigate NoshowReasonViewController, instance is nil.")
   }
   
   func testMyInterviewsWithdrawnReasonButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "Withdrawn", "no_show_reason": "reason"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "edit"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let reasonViewController = UIApplication.topMostViewController() as? ReasonViewController else {
              XCTFail("ReasonViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(reasonViewController, "Not able to Navigate ReasonViewController, instance is nil.")
   }
   
   func testMyInterviewsAnalyticsButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "Withdrawn", "no_show_reason": "reason"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "analytics"), for: .normal)
       dashboardViewController.clickIcon1Action(button)
       guard let analyticsViewController = UIApplication.topMostViewController() as? AnalyticsViewController else {
              XCTFail("AnalyticsViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(analyticsViewController, "Not able to Navigate AnalyticsViewController, instance is nil.")
   }
   
   func testMyInterviewsCalendarAvailabilityButtonActionWhileCandidateIsWithdrawn(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Withdrawn"], "id": 5564, "interview_code": "dfd434", "status": "Withdrawn", "no_show_reason": "reason"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "calendarAvailability"), for: .normal)
       dashboardViewController.clickIcon3Action(button)
   }
   
   func testMyInterviewsCalendarAvailabilityButtonAction(){
       dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Scheduled"], "id": 5564, "interview_code": "dfd434", "status": "Scheduled", "no_show_reason": "reason"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
       dashboardViewController.jobsArray = [["id": 3233], ["id": 3233]]
       dashboardViewController.segmentControl.selectedSegmentIndex = 1
       let button = UIButton()
       button.tag = 1
       button.setImage(UIImage(named: "calendarAvailability"), for: .normal)
       dashboardViewController.clickIcon3Action(button)
       guard let calendarAvailabilityViewController = UIApplication.topMostViewController() as? ProvideAvailabiltyViewController else {
              XCTFail("CalendarAvailabilityViewController is not Top most view controller.")
              return
       }
       XCTAssertNotNil(calendarAvailabilityViewController, "Not able to Navigate CalendarAvailabilityViewController, instance is nil.")
   }
}

//MARK: Test Myinterviewes TableView data
extension DashboardViewControllerTests {
    
    func setTableViewData(){
      dashboardViewController.tableViewData = [interViewData(opened: true, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [["job_id": 2223, "candidate": ["id": 5655, "status": "Scheduled"], "id": 5564, "interview_code": "dfd434", "status": "Scheduled", "no_show_reason": "reason"]], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:]), interViewData(opened: false, isColloborate: true, title: "", jobId: "8987", owner: "", sectionData: [], permissions: [:])]
    }
    
    func testMyinterviewsTableViewNumbeerofSections(){
         setTableViewData()
        _ = dashboardViewController.tableView(dashboardViewController.interViewsTableView, numberOfRowsInSection: 0) as? MyInterviewsTableViewCell
    }
    
    func testMyinterviewsTableViewheightForRowat(){
         setTableViewData()
        _ = dashboardViewController.tableView(dashboardViewController.interViewsTableView, heightForRowAt: IndexPath(row: 0, section: 0)) as? MyInterviewsTableViewCell
        
        _ = dashboardViewController.tableView(dashboardViewController.interViewsTableView, heightForRowAt: IndexPath(row: 1, section: 0)) as? MyInterviewsTableViewCell
 
    }

}
