//
//  PreferencesViewTest.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 01/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class PreferencesViewTest: XCTestCase {
    var createJobController: CreateJobViewController!
    var createJobNavigationController: UINavigationController!
    
    func testdropdownSetup(){
        createJobController.setupDropDown()
        XCTAssertEqual(createJobController.areasDropdown.direction, .bottom)
        XCTAssertEqual(createJobController.areasDropdown.backgroundColor, AppTheme.appBackgroundColor)
        XCTAssertEqual(createJobController.areasDropdown.bottomOffset, CGPoint(x: 0, y: 45))
        XCTAssertEqual(createJobController.optionalSkillsDropDown.direction, .bottom)
        XCTAssertEqual(createJobController.optionalSkillsDropDown.backgroundColor, AppTheme.appBackgroundColor)
        XCTAssertEqual(createJobController.optionalSkillsDropDown.bottomOffset, CGPoint(x: 0, y: 45))
        XCTAssertEqual(createJobController.requiredSkillsDropDown.direction, .bottom)
        XCTAssertEqual(createJobController.requiredSkillsDropDown.backgroundColor, AppTheme.appBackgroundColor)
        XCTAssertEqual(createJobController.requiredSkillsDropDown.bottomOffset, CGPoint(x: 0, y: 45))
    }
    func testSetupCheckbox(){
      createJobController.setUpCheckBox()
      XCTAssertEqual(createJobController.codingSamples.borderWidth, 1)
      XCTAssertEqual(createJobController.codingSamples.checkmarkStyle, .tick)
      XCTAssertEqual(createJobController.codingSamples.checkmarkColor, AppTheme.brandColor)
      XCTAssertEqual(createJobController.codingSamples.uncheckedBorderColor, UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1))
      XCTAssertEqual(createJobController.codingSamples.checkedBorderColor, UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1))
      XCTAssertEqual(createJobController.whiteBoard.borderWidth, 1)
      XCTAssertEqual(createJobController.whiteBoard.checkmarkStyle, .tick)
      XCTAssertEqual(createJobController.whiteBoard.checkmarkColor, AppTheme.brandColor)
      XCTAssertEqual(createJobController.whiteBoard.uncheckedBorderColor, UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1))
      XCTAssertEqual(createJobController.whiteBoard.checkedBorderColor, UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1))
      XCTAssertEqual(createJobController.candidatePicture.borderWidth, 1)
      XCTAssertEqual(createJobController.candidatePicture.checkmarkStyle, .tick)
      XCTAssertEqual(createJobController.candidatePicture.checkmarkColor, AppTheme.brandColor)
      XCTAssertEqual(createJobController.candidatePicture.uncheckedBorderColor, UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1))
      XCTAssertEqual(createJobController.candidatePicture.checkedBorderColor, UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1))
    }
    
    func testUpdateLanguage(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedLangauge" : "English"])
        createJobController.updateLangauge(notfication: notification)
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedLangauge" : []])
        createJobController.updateLangauge(notfication: notification1)
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil)
        createJobController.updateLangauge(notfication: notification2)
    }
    
    func testcountrySelection(){
        createJobController.countryPickerView.showCountriesList(from: createJobController)
        createJobController.countrySelection(0)
        var country = createJobController.countryPickerView.selectedCountry
        createJobController.countryPickerView(createJobController.countryPickerView, didSelectCountry: country)
        XCTAssertEqual(createJobController.interviewLocationField.text, "United States of America")
//        createJobController.countryPickerView.selectedCountry = Country
        var country1 = createJobController.countryPickerView.selectedCountry
        country1.name = "India"
        createJobController.countryPickerView(createJobController.countryPickerView, didSelectCountry: country1)
        XCTAssertEqual(createJobController.interviewLocationField.text, "India")
    }
    
    func testSegue(){
        let segue = UIStoryboardSegue(identifier: "CreateJobToLangaugeSearch", source: CreateJobViewController(), destination: UINavigationController())
        let vc = segue.destination as? UINavigationController
        let nav = vc!.viewControllers.first as? SearchViewController
        nav?.currentSearch = StoryboardSegueIdentifiers.createJobToLangaugeSearch
       createJobController.prepare(for: segue, sender: nil)
        
        let segue1 = UIStoryboardSegue(identifier: "CreateJobToAreaExpertise", source: CreateJobViewController(), destination: UINavigationController())
        let vc1 = segue1.destination as? UINavigationController
        let nav1 = vc1!.viewControllers.first as? SearchViewController
        nav1?.currentSearch = StoryboardSegueIdentifiers.createJobToAreaExpertise
        createJobController.prepare(for: segue1, sender: nil)
    }
    
    func testLanguagePreferencesAction(){
      createJobController.interViewLanguageDropDown.show()
      createJobController.laguagePreferecesAction(0)
    }
    
    func testInterViewMode(){
        createJobController.interviewModeAction(0)
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
