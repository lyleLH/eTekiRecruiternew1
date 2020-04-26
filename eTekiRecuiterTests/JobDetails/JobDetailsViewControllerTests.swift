//
//  JobDetailsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 04/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class JobDetailsViewControllerTests: XCTestCase {
    var jobDetailsController : JobDetailsViewController!
    var jobDetailsNavigationController : UINavigationController!
    let response = CreateJobResponse(message: "", categoryName: "", categoryID: "", categories: [], autoSkills: [], success: true, clientCompanyName: "company1", codingRequired: true, jobDescription: "desc", dueDate: "2019-12-09T13:59:38+0530", experirenceRequired: 4, expertiseCategory: "java", idRequired: true, interViewMode: "audio", interviewMinimumPricing: "", interviewMaximuPrice: "", interViewLanguagePreference: "English", interViewLocationPreference: "India", jobCode: "5465", numberOfProspects: 4, specialInstructions: "", preferedSkillSet: "database", skillset: "c, Java", interViewersCount: 3, whiteboradRequired: true, companyLogo: "", jobDescriptionAwsurl: "", jobTitle: "dfg", skillsAutoCompleteText: "", autoSource: true, agent: "self", skill: "c", skillType: "c", jobId: "34535", status: "active", recordingEnabled: true, statusFilters: [], filterDueDate: "", jobTypes: [], interViewTypes: [], isIndependentRecruiter: true, myInterviewsFilters: [])
    
   
    
    override func setUp() {
        jobDetailsController = mainStoryboard.instantiateViewController(withIdentifier: "JobDetailsViewController") as? JobDetailsViewController
        jobDetailsNavigationController = UINavigationController(rootViewController: jobDetailsController)
       
       jobDetailsController.jobResponse = response
        jobDetailsController.view.layoutIfNeeded()
        jobDetailsNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = jobDetailsNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    
    
    func testDocumentAction(){
        let _ = jobDetailsController.documentInteractionControllerViewControllerForPreview(UIDocumentInteractionController())

        jobDetailsController.fileURL = URL(string: "https://demo-api.eteki.com/jobs/get_details?job_id=")
        let _ = jobDetailsController.fileURL?.typeIdentifier
        let _ = jobDetailsController.fileURL?.localizedName

        let _ = jobDetailsController.textView(jobDetailsController.jobDescriptionTextView, shouldChangeTextIn: NSRange(), replacementText: "\n")
        let _ = jobDetailsController.textView(jobDetailsController.jobDescriptionTextView, shouldChangeTextIn: NSRange(), replacementText: "desc")
    }
    
    func testOnApiException(){
        let response = ErrorResponse(responseCode: 500, message: "Server Error", tittle: "")
        jobDetailsController.onAPIException(errorResponse: response, requestType: "")
    }
    
    func testonGetApiResponse(){
//         let response = CreateJobResponse(message: "", categoryName: "", categoryID: "", categories: [], autoSkills: [], success: true, clientCompanyName: "company1", codingRequired: true, jobDescription: "desc", dueDate: "2019-12-09T13:59:38+0530", experirenceRequired: 4, expertiseCategory: "java", idRequired: true, interViewMode: "audio", interviewMinimumPricing: "", interviewMaximuPrice: "", interViewLanguagePreference: "English", interViewLocationPreference: "India", jobCode: "5465", numberOfProspects: 4, specialInstructions: "", preferedSkillSet: "database", skillset: "c, Java", interViewersCount: 3, whiteboradRequired: true, companyLogo: "", jobDescriptionAwsurl: "", jobTitle: "dfg", skillsAutoCompleteText: "", autoSource: true, agent: "self", skill: "c", skillType: "c", jobId: "34535", status: "active", recordingEnabled: true, statusFilters: [], filterDueDate: "", jobTypes: [], interViewTypes: [], isIndependentRecruiter: true, myInterviewsFilters: [])
//        jobDetailsController.jobResponse = response
//        jobDetailsController.jobDescriptionTextView.text = ""
//        let expectation = XCTestExpectation(description: "test")
//               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.jobDetailsController.jobDetailstableView.reloadData()
//                   expectation.fulfill()
//               }
//               wait(for: [expectation], timeout: 3.0)
        jobDetailsController.jobDescriptionTextView.text = ""
        jobDetailsController.onGetAPIResponse(response: response, requestType: "")
        self.jobDetailsController.jobDetailstableView.reloadData()
    }

    func testonGetApiResponse2(){

        let response = CreateJobResponse(message: "", categoryName: "", categoryID: "", categories: [], autoSkills: [], success: true, clientCompanyName: "company1", codingRequired: false, jobDescription: "", dueDate: "2019-12-09T13:59:38+0530", experirenceRequired: 4, expertiseCategory: "java", idRequired: false, interViewMode: "audio", interviewMinimumPricing: "", interviewMaximuPrice: "", interViewLanguagePreference: "English", interViewLocationPreference: "India", jobCode: "5465", numberOfProspects: 4, specialInstructions: "", preferedSkillSet: "database", skillset: "c, Java", interViewersCount: 3, whiteboradRequired: false, companyLogo: "", jobDescriptionAwsurl: "", jobTitle: "dfg", skillsAutoCompleteText: "", autoSource: true, agent: "self", skill: "c", skillType: "c", jobId: "34535", status: "active", recordingEnabled: true, statusFilters: [], filterDueDate: "", jobTypes: [], interViewTypes: [], isIndependentRecruiter: true, myInterviewsFilters: [])
        jobDetailsController.jobResponse = response
        jobDetailsController.jobDescriptionTextView.text = ""
        jobDetailsController.onGetAPIResponse(response: response, requestType: "")
        self.jobDetailsController.jobDetailstableView.reloadData()

    }

    func testDocumentDownload(){
        let response = CreateJobResponse(message: "", categoryName: "", categoryID: "", categories: [], autoSkills: [], success: true, clientCompanyName: "company1", codingRequired: true, jobDescription: "desc", dueDate: "2019-12-09T13:59:38+0530", experirenceRequired: 4, expertiseCategory: "java", idRequired: true, interViewMode: "audio", interviewMinimumPricing: "", interviewMaximuPrice: "", interViewLanguagePreference: "English", interViewLocationPreference: "India", jobCode: "5465", numberOfProspects: 4, specialInstructions: "", preferedSkillSet: "database", skillset: "c, Java", interViewersCount: 3, whiteboradRequired: true, companyLogo: "", jobDescriptionAwsurl: "15831393810871574599161422 (1).docx", jobTitle: "dfg", skillsAutoCompleteText: "", autoSource: true, agent: "self", skill: "c", skillType: "c", jobId: "34535", status: "active", recordingEnabled: true, statusFilters: [], filterDueDate: "", jobTypes: [], interViewTypes: [], isIndependentRecruiter: true, myInterviewsFilters: [])
        jobDetailsController.jobResponse = response
//        let expectation = XCTestExpectation(description: "test")
//                       DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
//                        //self.jobDetailsController.jobDetailstableView.reloadData()
//                           expectation.fulfill()
//                       }
//                       wait(for: [expectation], timeout: 4.0)
        jobDetailsController.documentDowloadAction(0)
    }
    
    
    
    
//    func testBackAction(){
//      let _ = jobDetailsController.backAction(0)
//    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
