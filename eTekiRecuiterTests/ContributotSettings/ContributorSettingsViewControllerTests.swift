//
//  ContributorSettingsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 18/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
import SimpleCheckbox

class ContributorSettingsViewControllerTests: XCTestCase {

    var contributorSettingsController: ContributorSettingsViewController!
    var contributorSettingsNavigationController: UINavigationController!
    var cell : ContributorsCell! = nil
    
    override func setUp() {
        contributorSettingsController = mainStoryboard.instantiateViewController(withIdentifier: "ContributorSettingsViewController") as? ContributorSettingsViewController
        contributorSettingsNavigationController = UINavigationController(rootViewController: contributorSettingsController)
        contributorSettingsController.contributorSettingsAPI = ContributorsStubApi.self
        contributorSettingsController.view.layoutIfNeeded()
        contributorSettingsController.contributorsArray = [
        [
            "collaborated" : 0,
            "full_name" : "jeshya kedarisetty",
            "id" : 1250,
            "job_permissions" :  [
                "Candidate Edit" : 1,
                "Candidate Notify" : 1,
                "Candidate View" : 1,
                "Interview Edit" : 1,
                "Interview Notify" : 1,
                "Interview View" : 1,
                "Job Edit" : 1,
                "Job Notify" : 1,
                "Job View" : 1,
            ],
            "profile_pics" :     [
                "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
        ],[
            "collaborated" : 0,
            "full_name" : "jeshya kedarisetty",
            "id" : 1250,
            "job_permissions" :  [
                "Candidate Edit" : 1,
                "Candidate Notify" : 1,
                "Candidate View" : 1,
                "Interview Edit" : 1,
                "Interview Notify" : 1,
                "Interview View" : 1,
                "Job Edit" : 1,
                "Job Notify" : 1,
                "Job View" : 1,
            ],
            "profile_pics" :     [
                "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
        ]]
        contributorSettingsController.searchArray = contributorSettingsController.contributorsArray
        contributorSettingsController.permissionsArray =   [[
            "Candidate Edit" : 1,
            "Candidate Notify" : 1,
            "Candidate View" : 1,
            "Interview Edit" : 1,
            "Interview Notify" : 1,
            "Interview View" : 1,
            "Job Edit" : 1,
            "Job Notify" : 1,
            "Job View" : 1,
        ],[
            "Candidate Edit" : 1,
            "Candidate Notify" : 1,
            "Candidate View" : 1,
            "Interview Edit" : 1,
            "Interview Notify" : 1,
            "Interview View" : 1,
            "Job Edit" : 1,
            "Job Notify" : 1,
            "Job View" : 1,
        ]]
        contributorSettingsNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = contributorSettingsNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

     /*! @brief Scenario when user taps on update View Checkbox of job  */
    func testUpdateCheckBox(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 0
        contributorSettingsController.updateViewBox(notfication: notification)
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: [:])
        contributorSettingsController.updateViewBox(notfication: notification1)
    }
    
    /*! @brief Scenario when user taps on update View Checkbox of candidate  */
    func testUpdateCheckBoxOfCandidate(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 1
        contributorSettingsController.updateViewBox(notfication: notification)
    }
    
    /*! @brief Scenario when user taps on update View Checkbox of interview  */
    func testUpdateCheckBoxOfInterview(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 2
        contributorSettingsController.updateViewBox(notfication: notification)
    }
    
    /*! @brief Scenario when user taps on Update Edit Checkbox of job  */
    func testEditCheckBox(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 0
        contributorSettingsController.updateEditBox(notfication: notification)
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: [:])
        contributorSettingsController.updateEditBox(notfication: notification1)
    }
    
    /*! @brief Scenario when user taps on Update Edit Checkbox of candidate  */
    func testEditCheckBoxOfCandidate(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 1
        contributorSettingsController.updateEditBox(notfication: notification)
    }
    
    /*! @brief Scenario when user taps on Update Edit Checkbox of interview  */
    func testEditCheckBoxOfInterview(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 2
        contributorSettingsController.updateEditBox(notfication: notification)
    }
    
    /*! @brief Scenario when user taps on  Update Notify Checkbox of job  */
    func testNotifyCheckBox(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 0
        contributorSettingsController.updateNotifyBox(notfication: notification)
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: [:])
        contributorSettingsController.updateNotifyBox(notfication: notification1)
    }
    
    /*! @brief Scenario when user taps on Update Notify Checkbox of candidate  */
    func testNotifyCheckBoxOfCandidate(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 1
        contributorSettingsController.updateNotifyBox(notfication: notification)
    }
    
    /*! @brief Scenario when user taps on Update Notify Checkbox of interview  */
    func testNotifyCheckBoxOfInterview(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["Index": 0])
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 2
        contributorSettingsController.updateNotifyBox(notfication: notification)
    }
    
    /*! @brief Scenario when user taps on Any other segment then reloads the data  */
    func testReloadDateWhenSegmentSwitched(){
        contributorSettingsController.rolesSegmentAction(0)
    }
    
    /*! @brief Scenario when user taps on Apply default button  */
    func testApplyDefaultButton(){
        contributorSettingsController.applyDefaultButton.sendActions(for: .touchUpInside)
    }
    
    /*! @brief Scenario when user taps on Save default button  */
    func testSaveDefaultButton(){
        contributorSettingsController.saveDefaultButton.sendActions(for: .touchUpInside)
    }
    
    /*! @brief Scenario when user taps on Update default button  */
    func testUpdateDefaultButton(){
        let stubData = ["message": ["Permissions Successfully Updated"], "success": true] as [String : Any]
        contributorSettingsController.jobID = "3673"
        contributorSettingsController.defaultContributors = [["1250": ["Candidate Edit", "Candidate Notify", "Candidate View", "Interview View", "Interview Edit", "Interview Notify", "Job Edit", "Job Notify", "Job View"]]]
       ContributorsStubApi.saveDefaultSettings = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        contributorSettingsController.updateButton.sendActions(for: .touchUpInside)
        contributorSettingsController.isNavigatingFrom = StoryboardSegueIdentifiers.createJobToContributorSettings
        contributorSettingsController.updateButton.sendActions(for: .touchUpInside)
    }
    
    /*! @brief Scenario when user taps yes button in customAlert of ApplyButton  */
    func testSettingsAction(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: "Apply Default", userInfo: [:])
        let stubData = ["recruiters" :
        [[
            "collaborated" : 0,
            "full_name" : "jeshya kedarisetty",
            "id" : 1250,
            "job_permissions" :  [
                "Candidate Edit" : 1,
                "Candidate Notify" : 1,
                "Candidate View" : 1,
                "Interview Edit" : 1,
                "Interview Notify" : 1,
                "Interview View" : 1,
                "Job Edit" : 1,
                "Job Notify" : 1,
                "Job View" : 1,
            ],
            "profile_pics" :     [
                "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
        ]]]
        ContributorsStubApi.getContributors = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        contributorSettingsController.settingsAction(notfication: notification)
    }
    
    /*! @brief Scenario when user taps yes button in customAlert of SaveDefaultButton  */
    func testSettingsActionofSaveDefaulrt(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: "Save Default", userInfo: [:])
        let stubData = ["message": ["Permissions Successfully Updated"], "success": true] as [String : Any]
        ContributorsStubApi.saveDefaultSettings = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        contributorSettingsController.settingsAction(notfication: notification)
        contributorSettingsController.checkButtonViewAction(0)
    }
    
    /*! @brief Scenario when user taps on Clear All Button */
    func testClearAll(){
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        contributorSettingsController.clearButton.sendActions(for: .touchUpInside)
    }
    
    /*! @brief Scenario when user taps on back Button */
    func testBackAction(){
        contributorSettingsController.backAction(0)
        contributorSettingsController.isNavigatingFrom = StoryboardSegueIdentifiers.createJobToContributorSettings
        contributorSettingsController.backAction(0)
    }
    
    func testCellForRowAt(){
        contributorSettingsController.contributorsArray = [
        [
            "collaborated" : 0,
            "id" : 1250,
            "job_permissions" :  [
                "Candidate Edit" : "1",
                "Candidate Notify" : "1",
                "Candidate View" : "1",
                "Interview Edit" : "1",
                "Interview Notify" : "1",
                "Interview View" : "1",
                "Job Edit" : "1",
                "Job Notify" : "1",
                "Job View" : "1",
            ],
            "profile_pics" :     [
                "profile_large_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_medium_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
                "profile_small_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.svg",
                "profile_thumb_url" : "https://s3.amazonaws.com/eteki-assets/icons/new_default_user.png",
            ],
        ]]
        contributorSettingsController.contributorSegmentControl.selectedSegmentIndex = 0
        contributorSettingsController.updatePermissions()
    }
    
    /*! @brief Scenario when user taps on cell */
    func testTableViewCellDidSelect(){
        contributorSettingsController.tableView(contributorSettingsController.contributorTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        contributorSettingsController.tableView(contributorSettingsController.contributorTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
    /*! @brief Scenario when user taps on SearchButton */
    func testSearchBarClicked(){
        contributorSettingsController.searchBarSearchButtonClicked(UISearchBar())
    }
    
     /*! @brief Scenario when user taps on Cancel Button of SearchBar */
    func testSearchBarCancelClicked(){
        contributorSettingsController.searchBarCancelButtonClicked(UISearchBar())
    }
    
    /*! @brief Scenario when user enters a text in search bar is empty */
    func testSearchTextEntersEmpty(){
        contributorSettingsController.searchBar.text = "jesh"
        contributorSettingsController.searchBar(UISearchBar(), textDidChange: "jesh")
    }
    
    /*! @brief Scenario when user enters a text in search bar is empty */
    func testSearchTextEnters(){
        let searchBar = UISearchBar()
        searchBar.text = "jesh"
        contributorSettingsController.searchBar(searchBar, textDidChange: "jesh")
        searchBar.text = "jayi"
        contributorSettingsController.searchBar(searchBar, textDidChange: "jayi")
    }
    
//    func testViewBoxActionInCell(){
//        let cell = contributorSettingsController.tableView(contributorSettingsController.contributorTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ContributorsCell
//        cell?.viewBox.isChecked = false
//        cell?.viewBoxAction(cell?.viewBox ?? Checkbox())
//
//        let cell1 = contributorSettingsController.tableView(contributorSettingsController.contributorTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? ContributorsCell
//        cell1?.viewBox.isChecked = true
//        cell1?.viewBoxAction(cell1?.viewBox ?? Checkbox())
//    }
//    
//    func testEditBoxActionInCell(){
//        let cell = contributorSettingsController.tableView(contributorSettingsController.contributorTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ContributorsCell
//        cell?.editBox.isChecked = false
//        cell?.editBoxAction(cell?.editBox ?? Checkbox())
//        let cell1 = contributorSettingsController.tableView(contributorSettingsController.contributorTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ContributorsCell
//        cell?.editBox.isChecked = true
//        cell?.editBoxAction(cell?.editBox ?? Checkbox())
//    }
//    
//    func testNotifyBoxActionInCell(){
//        let cell = contributorSettingsController.tableView(contributorSettingsController.contributorTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ContributorsCell
//        cell?.notifyBox.isChecked = false
//        cell?.notifyBoxAction(cell?.notifyBox ?? Checkbox())
//        let cell1 = contributorSettingsController.tableView(contributorSettingsController.contributorTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ContributorsCell
//        cell?.notifyBox.isChecked = true
//        cell?.notifyBoxAction(cell?.notifyBox ?? Checkbox())
//    }
    
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
