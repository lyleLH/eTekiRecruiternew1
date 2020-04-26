//
//  SkillsViewTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 01/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class SkillsViewTests: XCTestCase {
    var createJobController: CreateJobViewController!
    var createJobModal = CreateJobViewModel()
    var createJobNavigationController: UINavigationController!
    
    func testrequiredSkillsField(){
        createJobController.requiredSkillArray = ["c", "Java", "JavaScript", "Database", "oops"]
        createJobController.requiredSkills.text = "c"
        createJobController.requiredFieldChanged(0)
    }
    
    func testAutoSkills(){
        createJobController.requiredSkillArray = ["c", "JavaScript", "Database", "oops"]
        createJobController.requiredSkills.text = "c"
        if(createJobController.requiredSkillArray.count < 5){
            let manager = CreateJobManager(skillsAutoCompleteText: createJobController.requiredSkills.text!)
            let skillsAutoCompleteResponse = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
            CreateJobStubApi.skillsAutoComplete = skillsAutoCompleteResponse
            createJobModal.createJobAPI = CreateJobStubApi.self
            createJobController.viewModel.getSkillsAutoCompleted(createJobManager: manager, requestType: "Required Skills")
        }
        createJobController.requiredFieldChanged(0)
    }
    func testRequiredSkillSelection(){
        createJobController.requiredSkillsDropDown.dataSource = ["c", "Java", "Oops"]
        createJobController.requiredSkillsSelection()
    }
    func testOptionalFieldChanged(){
        createJobController.optionalSkills.text = "c"
        let manager = CreateJobManager(skillsAutoCompleteText: createJobController.requiredSkills.text!)
        let skillsAutoCompleteResponse = CreateJobResponse(json: ["data": [["skill" : "c"]]], success: true, message: "200 ok")
        CreateJobStubApi.skillsAutoComplete = skillsAutoCompleteResponse
        createJobModal.createJobAPI = CreateJobStubApi.self
        createJobController.viewModel.getSkillsAutoCompleted(createJobManager: manager, requestType: "Required Skills")
        createJobController.optionalFieldChanged(0)
    }
    func testOptionalSkills(){
        createJobController.optionalSkillsDropDown.dataSource = ["c", "Java", "Oops"]
        createJobController.optionalSkillsSelection()
    }
    func testLayouts(){
        createJobController.viewDidLayoutSubviews()
    }
    func testsetUpTagView(){
       createJobController.setUpTagViews()
    }
    override func setUp() {
        createJobController = mainStoryboard.instantiateViewController(withIdentifier: "CreateJobViewController") as? CreateJobViewController
        createJobNavigationController = UINavigationController(rootViewController: createJobController)
        createJobController.view.layoutIfNeeded()
        createJobNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = createJobNavigationController
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
