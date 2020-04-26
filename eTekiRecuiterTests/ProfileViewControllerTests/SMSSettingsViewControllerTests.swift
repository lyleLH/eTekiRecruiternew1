//
//  SMSSettingsViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 23/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class SMSSettingsViewControllerTests: XCTestCase {
    var smsSettingsController: SMSSettingViewController!
    var smsSettingNavigationController: UINavigationController!
    
    func testBackAction(){
        smsSettingsController.dismiss(animated: true, completion: nil)
        smsSettingsController.backAction(0)
    }
    
    func testSubscribeSmsAction(){
        smsSettingsController.emailButton.iconColor = UIColor(red: 183.0/255.0, green: 196.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        smsSettingsController.contactField.text = "+91 9949643302"
        smsSettingsController.contactView.isHidden = false
        smsSettingsController.activateSMS = true
        smsSettingsController.subscribeSMSAction(0)
    }
    
    func testSubscribeEmailAction(){
        smsSettingsController.smsButton.iconColor = UIColor(red: 183.0/255.0, green: 196.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        smsSettingsController.contactField.text = ""
        smsSettingsController.contactView.isHidden = true
        smsSettingsController.subscribeEmailAction(0)
    }
    
    func testUpdateContactAction(){
        smsSettingsController.dropDown.dataSource = ["+ 91 8077382134", "+ 1 345589433"]
        smsSettingsController.dropDown.selectRow(at: 0)
        self.smsSettingsController.contactField.text = "+ 91 8077382134"
        smsSettingsController.updateContactAction(0)
    }
    
    func testUpdateAction(){
      smsSettingsController.currentSelectedContact = "+ 91 8077382134"
      smsSettingsController.updateAction(0)
      smsSettingsController.currentSelectedContact = "+ 91 8077382134"
      smsSettingsController.smsButton.isSelected = true
      smsSettingsController.updateAction(0)
      smsSettingsController.contactField.text = "+ 91 8077382134"
      smsSettingsController.updateAction(0)
    }
    
    func testStripContactandUpdateUI(){
        smsSettingsController.stripContactAndUpdateAPI(contact: "+ 91 8077382134")
        smsSettingsController.stripContactAndUpdateAPI(contact: "")
    }
    
    func testOnGetProfileResponseforGetsmsSettings(){
        let response = ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: nil, address2: nil, city: nil, country: nil, state: nil, timeZone: nil, zip: nil, companyName: nil, website: nil, sameAsBillingAddress: nil, contact1: "8077382134", contact2: "857766784", areaCode1: "IN", areaCode2: "US", countryCode1: "91", countryCode2: "1", success: true, smsservice: true, usSMSService: true, otpRequired: true, smsContact: "8077382134", smsAreaCode: "IN", smsCountrycode: "91", idRequired: true)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
            self.smsSettingsController.dropDown.reloadAllComponents()
        }
        wait(for: [expectation], timeout: 2.5)
        smsSettingsController.onGetProfileResponse(response:response , requestType: "GetSMSSetting")
        
    }
    
    func testOnGetProfileResponseforUpdatesmsSettings(){
        let response = ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: nil, address2: nil, city: nil, country: nil, state: nil, timeZone: nil, zip: nil, companyName: nil, website: nil, sameAsBillingAddress: nil, contact1: "8077382134", contact2: "857766784", areaCode1: "IN", areaCode2: "US", countryCode1: "91", countryCode2: "1", success: true, smsservice: true, usSMSService: true, otpRequired: false, smsContact: "8077382134", smsAreaCode: "IN", smsCountrycode: "91", idRequired: false)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
            self.smsSettingsController.smsButton.isSelected = true
        }
        wait(for: [expectation], timeout: 2.5)
        smsSettingsController.onGetProfileResponse(response:response , requestType: "UpdateSMSSettings")
    }
    func testonGetProfileIsSmSButtonNotSelected(){
        let response1 = ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: nil, address2: nil, city: nil, country: nil, state: nil, timeZone: nil, zip: nil, companyName: nil, website: nil, sameAsBillingAddress: nil, contact1: "8077382134", contact2: "857766784", areaCode1: "IN", areaCode2: "US", countryCode1: "91", countryCode2: "1", success: true, smsservice: true, usSMSService: true, otpRequired: false, smsContact: "8077382134", smsAreaCode: "IN", smsCountrycode: "91", idRequired: false)
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation1.fulfill()
            self.smsSettingsController.smsButton.isSelected = false
        }
        wait(for: [expectation1], timeout: 2.5)
        smsSettingsController.onGetProfileResponse(response:response1 , requestType: "UpdateSMSSettings")
    }
    
    func testoGetProfileOTPRequired(){
        let response1 = ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: nil, address2: nil, city: nil, country: nil, state: nil, timeZone: nil, zip: nil, companyName: nil, website: nil, sameAsBillingAddress: nil, contact1: "8077382134", contact2: "857766784", areaCode1: "IN", areaCode2: "US", countryCode1: "91", countryCode2: "1", success: true, smsservice: true, usSMSService: true, otpRequired: true, smsContact: "8077382134", smsAreaCode: "IN", smsCountrycode: "91", idRequired: false)
        let expectation1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 2.5)
        smsSettingsController.onGetProfileResponse(response:response1 , requestType: "UpdateSMSSettings")
    }
    override func setUp() {
        smsSettingsController = mainStoryboard.instantiateViewController(withIdentifier: "SMSSettingViewController") as? SMSSettingViewController
        smsSettingNavigationController = UINavigationController(rootViewController: smsSettingsController)
        smsSettingsController.view.layoutIfNeeded()
        smsSettingNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = smsSettingNavigationController
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
