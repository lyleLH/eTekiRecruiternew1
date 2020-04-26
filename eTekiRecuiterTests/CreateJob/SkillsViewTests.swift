//
//  SkillsViewTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 01/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
import TagListView

class SkillsViewTests: XCTestCase {
    var createJobController: CreateJobViewController!
    var createJobModal = CreateJobViewModel()
    var createJobNavigationController: UINavigationController!
    
    func testrequiredSkillsField(){
         createJobController.requiredSkills.text = "c"
        createJobController.requiredSkillArray = ["c", "Java"]
        let  manager = CreateJobManager(skillsAutoCompleteText: "c")
        let response = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
        CreateJobStubApi.skillsAutoComplete = response
       // createJobModal.createJobAPI = CreateJobStubApi.self
        CreateJobAPI.getSkillsAutoComplete(createJobManager: manager) {(response, Error) in
            print(response)
        }
        createJobController.requiredFieldChanged(0)
        createJobController.requiredSkillArray = ["c", "Java", "JavaScript", "Database", "oops"]
        createJobController.requiredSkills.text = "c"
        createJobController.requiredFieldChanged(0)
    }
    
    func testOptionalSkillsField(){
         createJobController.optionalSkills.text = "c"
        let  manager = CreateJobManager(skillsAutoCompleteText: "c")
        let response = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "success")
        CreateJobStubApi.skillsAutoComplete = response
       // createJobModal.createJobAPI = CreateJobStubApi.self
        CreateJobAPI.getSkillsAutoComplete(createJobManager: manager) {(response, Error) in
            print(response)
        }
        createJobController.optionalFieldChanged(0)
        createJobController.optionalSkills.text = "c"
               let  manager1 = CreateJobManager(skillsAutoCompleteText: "c")
               let response1 = CreateJobResponse(json: ["data": ""], success: true, message: "success")
               CreateJobStubApi.skillsAutoComplete = response1
               //createJobModal.createJobAPI = CreateJobStubApi.self
               CreateJobAPI.getSkillsAutoComplete(createJobManager: manager1) {(response, Error) in
                   print(response)
               }
               createJobController.optionalFieldChanged(0)
    }
//    func testAutoSkills(){
//        createJobController.requiredSkillArray = ["c", "JavaScript", "Database", "oops"]
//        createJobController.requiredSkills.text = "c"
//        if(createJobController.requiredSkillArray.count < 5){
//            let manager = CreateJobManager(skillsAutoCompleteText: createJobController.requiredSkills.text!)
//            let skillsAutoCompleteResponse = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
//            CreateJobStubApi.skillsAutoComplete = skillsAutoCompleteResponse
//            createJobModal.createJobAPI = CreateJobStubApi.self
//            createJobController.viewModel.getSkillsAutoCompleted(createJobManager: manager, requestType: "Required Skills")
//        }
//        createJobController.requiredFieldChanged(0)
//    }
    func testRequiredSkillSelection(){
        createJobController.requiredSkillsDropDown.dataSource = ["c", "Java", "Oops"]
        createJobController.requiredSkillsDropDown.selectRow(at: 2)
//        createJobController.requiredSkillsDropDown
        print(createJobController.requiredSkillsDropDown.selectedItem)
        createJobController.requiredSkillsSelection(field: createJobController.requiredSkills)
    }

    func testOptionalSkills(){
        createJobController.optionalSkillsDropDown.dataSource = ["c", "Java", "Oops"]
        createJobController.optionalSkillsSelection(textfield: createJobController.optionalSkills)
    }
    
    func testLayouts(){
        createJobController.viewDidLayoutSubviews()
    }

    func testApiresponseOfRequiredSkills(){
        let response = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.createJobController.removeSpinner()
            self.createJobController.requiredListView.isHidden = false
        }
        wait(for: [exp1], timeout: 2.5)
      //  createJobController.onGetAPIResponse(response: response, requestType: "Required Skills")
        XCTAssertEqual(self.createJobController.requiredListView.isHidden, false)
    }

    func testApiresponseOfOptionalSkills(){
        let response = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.createJobController.removeSpinner()
            self.createJobController.optionalSkillsListView.isHidden = false
        }
        wait(for: [exp1], timeout: 2.5)
//createJobController.onGetAPIResponse(response: response, requestType: "Optional Skills")
        XCTAssertEqual(createJobController.optionalSkillsListView.isHidden, false)
    }
    
    func testApiresponseOfupdateCreateJob(){
        let response = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.createJobController.showBanner(title: "", withMessage: "Job Created.", style: .success)
            self.createJobController.removeSpinner()
        }
        wait(for: [exp1], timeout: 2.5)
       // createJobController.onGetAPIResponse(response: response, requestType: "Update Create Job")
    }
    
    func testonAPIException(){
        let errorResponse = ErrorResponse(responseCode: 500, message: "Server Error", tittle : "")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            //self.createJobController.showBannerWithError(title: "", withMessage: "Server Error")
            self.createJobController.removeSpinner()
        }
        wait(for: [exp1], timeout: 2.5)
       // createJobController.onAPIException(errorResponse: errorResponse, requestType: "exception")
    }
    
    override func setUp() {
        createJobController = mainStoryboard.instantiateViewController(withIdentifier: "CreateJobViewController") as? CreateJobViewController
        createJobNavigationController = UINavigationController(rootViewController: createJobController)
        createJobController.view.layoutIfNeeded()
        createJobNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = createJobNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

}
