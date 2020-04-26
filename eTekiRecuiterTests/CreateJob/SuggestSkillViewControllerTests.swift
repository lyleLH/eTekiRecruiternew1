//
//  SuggestSkillViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 03/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class SuggestSkillViewControllerTests: XCTestCase {
    var suggestSkillController: SuggestSkillViewController!
//    var sugggestSkillModal = SuggestSkillViewModel()
    var suggestSkillNavigationController: UINavigationController!
    
    func testselectRequiredction(){
        suggestSkillController.selectRequiredction(0)
        XCTAssertEqual(suggestSkillController.optionalButton.isSelected, false)
    }
    
    func testselectOptionalction(){
        suggestSkillController.selectOptionalction(0)
        XCTAssertEqual(suggestSkillController.requiredButton.isSelected, false)
    }
    
    func testsuggestSkillAction(){
      suggestSkillController.showBanner(title: "", withMessage: "Skill can't be blank", style: .warning)
      suggestSkillController.suggestSkillAction(0)
        suggestSkillController.suggestSkillTextField.text = "Database"
        suggestSkillController.showBanner(title: "", withMessage: "Skill type can't be blank", style: .warning)
        suggestSkillController.suggestSkillAction(0)
    }
    
    func testSuggestAction(){
        suggestSkillController.suggestSkillTextField.text = "Database"
        suggestSkillController.requiredButton.isSelected = true
        suggestSkillController.showSpinner()
        suggestSkillController.suggestSkillTextField.text = "Database"
        let response = CreateJobResponse(json: ["autoSkills": ["scripting Language"]], success: true, message: "skill added")
         CreateJobStubApi.skillsAutoComplete = response
               let manager = CreateJobManager(skillsAutoCompleteText: "c")
               suggestSkillController.createJobAPI.getSkillsAutoComplete(createJobManager: manager) {(response, Error) in
                   print(response)
               }
        suggestSkillController.suggestSkillAction(0)
    }
    
//    func testFilterSuggestSkills(){
//     suggestSkillController.showBanner(title: "", withMessage: "Skill type can't be blank", style: .warning)
//      suggestSkillController.filterSuggestSkills()
//        suggestSkillController.requiredButton.isSelected = true
//        suggestSkillController.suggestSkillTextField.text = "c"
//        let manager = CreateJobManager(skill: "c", skillType: "required")
//         suggestSkillController.viewModel.suggestSkill(createJobManager: manager, requestType: ServerAttributes.suggestSkills)
//     suggestSkillController.filterSuggestSkills()
//    }
    
    func testFilterSuggestOPtional(){
        suggestSkillController.requiredButton.isSelected = false
        suggestSkillController.optionalButton.isSelected = true
        suggestSkillController.suggestSkillTextField.text = "c"
        let manager1 = CreateJobManager(skill: "c", skillType: "optional")
        //suggestSkillController.viewModel.suggestSkill(createJobManager: manager1, requestType: ServerAttributes.suggestSkills)
        suggestSkillController.filterSuggestSkills()
        suggestSkillController.suggestSkillTextField.text = "scripting language"
        suggestSkillController.searchSuggestSkills = ["scripting language"]
        suggestSkillController.removeSpinner()
        suggestSkillController.showBanner(title: "", withMessage: "You are trying to suggest already existed skill.", style: .warning)
        suggestSkillController.filterSuggestSkills()
    }
    
    func testBackAction(){
      suggestSkillController.dismiss(animated: true, completion: nil)
      suggestSkillController.backAction(0)
    }
    
    func testOnGetApiResponse(){
        suggestSkillController.suggestSkillTextField.text = "scripting Language"
        let response = CreateJobResponse(json: ["autoSkills": ["scripting Language"]], success: true, message: "skill added")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.suggestSkillController.filterSuggestSkills()
        }
        wait(for: [exp1], timeout: 2.5)
        CreateJobStubApi.skillsAutoComplete = response
        let manager = CreateJobManager(skillsAutoCompleteText: "c")
        suggestSkillController.createJobAPI.getSkillsAutoComplete(createJobManager: manager) {(response, Error) in
            print(response)
        }
        XCTAssertEqual(suggestSkillController.searchSuggestSkills, response.autoSkills)
    }

    func testOnGetApiResponseofsuggestSkills(){
        suggestSkillController.suggestSkillTextField.text = "scripting Language"
        let response = CreateJobResponse(json: ["autoSkills": ["scripting Language"]], success: true, message: "skill added")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.suggestSkillController.showBanner(title: "", withMessage: "Suggestion Updated.", style: .success)
        }
        wait(for: [exp1], timeout: 2.5)
        CreateJobStubApi.skillsAutoComplete = response
        let manager = CreateJobManager(skillsAutoCompleteText: "c")
        suggestSkillController.createJobAPI.getSkillsAutoComplete(createJobManager: manager) {(response, Error) in
            print(response)
        }
        XCTAssertEqual(suggestSkillController.requiredButton.isSelected, false)
        XCTAssertEqual(suggestSkillController.optionalButton.isSelected, false)
    }
    
//    func testOnApiException(){
//        let response = ErrorResponse(responseCode: 500, message: "Server Error", tittle: "")
//        let exp1 = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            exp1.fulfill()
//            self.suggestSkillController.removeSpinner()
//            self.suggestSkillController.showBanner(title: "", withMessage: "Server Error", style: .danger)
//        }
//        wait(for: [exp1], timeout: 2.5)
//        suggestSkillController.onAPIException(errorResponse: response, requestType: "exception")
//        XCTAssertEqual(suggestSkillController.requiredButton.isSelected, false)
//        XCTAssertEqual(suggestSkillController.optionalButton.isSelected, false)
//    }
    override func setUp() {
        suggestSkillController = mainStoryboard.instantiateViewController(withIdentifier: "SuggestSkillViewController") as? SuggestSkillViewController
        suggestSkillNavigationController = UINavigationController(rootViewController: suggestSkillController)
        suggestSkillController.view.layoutIfNeeded()
        suggestSkillNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = suggestSkillNavigationController
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
