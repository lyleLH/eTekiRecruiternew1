//
//  AddressViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 26/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class AddressViewControllerTests: XCTestCase {
    var addressController: AddressViewController!
    var addressNavigationController: UINavigationController!
    
    func testBackAction(){
        addressController.dismiss(animated: true, completion: nil)
        addressController.backAction(0)
    }
    
    func testupdateStates(){
        let notitfication = NSNotification(name: .AccessTokenDidChange, object: {}, userInfo: [:])
        addressController.updateStates(notfication: notitfication)
        let notitfication1 = NSNotification(name: .AccessTokenDidChange, object: {}, userInfo: ["selectedState":"andhrapradesh"])
        addressController.updateStates(notfication: notitfication1)
        let notitfication2 = NSNotification(name: .AccessTokenDidChange, object: {}, userInfo: [0:0])
        addressController.updateStates(notfication: notitfication2)
    }
    
    func testUpdateTimezone(){
        let notitfication = NSNotification(name: .AccessTokenDidChange, object: {}, userInfo: [:])
        addressController.updateTimeZone(notfication: notitfication)
        let notitfication1 = NSNotification(name: .AccessTokenDidChange, object: {}, userInfo: ["timezone":["GMT +0.00":"Kolkata"]])
        addressController.updateTimeZone(notfication: notitfication1)
        let notitfication2 = NSNotification(name: .AccessTokenDidChange, object: {}, userInfo: [0:0])
        addressController.updateTimeZone(notfication: notitfication2)
    }
    
//    func testPlacehoderProperties(){
//        addressController.timezoneField.
//    }
    
    func testSelectCountry(){
        addressController.selectCountry(0)
    }
    
    func testCountryPickerView(){
//        let countryPicker = addressController.countryPickerView
//        let country = addressController.countryPickerView.selectedCountry
//       addressController.countryPickerView(countryPicker, didSelectCountry: country)
    }
    
    func testupdateAction(){
        addressController.updateAction(0)
        addressController.timezoneField.text = "(GMT+02:00) Athens, Harare, Jerusalem"
        XCTAssertEqual(addressController.timezoneField.text, "(GMT+02:00) Athens, Harare, Jerusalem")
        addressController.updateAction(0)
        addressController.countryTextField.text = "India"
        XCTAssertEqual(addressController.countryTextField.text, "India")
        addressController.updateAction(0)
        addressController.stateTextField.text = "Andhrapradesh"
        XCTAssertEqual(addressController.stateTextField.text, "Andhrapradesh")
        addressController.updateAction(0)
        addressController.address1TextField.text = "Narsipatnam"
        XCTAssertEqual(addressController.address1TextField.text, "Narsipatnam")
        addressController.updateAction(0)
        addressController.cityTextField.text = "Narsipatnam"
        XCTAssertEqual(addressController.cityTextField.text, "Narsipatnam")
        addressController.updateAction(0)
        addressController.zipcodeTextField.text = "531116"
        addressController.zipcodeTextField.text?.safelyLimitedTo(length: 4)
        addressController.zipcodeTextField.isValidZip(zipStr: addressController.zipcodeTextField.text ?? "531116")
        XCTAssertEqual(addressController.zipcodeTextField.text, "531116")
        addressController.updateAction(0)
    }
    
    func testZipField(){
        let range = NSRange()
        addressController.textField(addressController.zipcodeTextField, shouldChangeCharactersIn: range, replacementString: "")
        addressController.textField(addressController.cityTextField, shouldChangeCharactersIn: range, replacementString: "")
    }
    
    func testPrepareSegue(){
        let segue = UIStoryboardSegue(identifier: "StateToSearch", source: AddressViewController(), destination: SearchViewController())
       addressController.prepare(for: segue, sender: 0)
    }
    
    func testProfileResponse(){
        let json = ["address" : ["address" : "Narsipatnam" , "address2" : "address2", "city" : "Narsipatnam", "country" : "India", "state":"Andhrapradesh", "time_zone":"(GMT+02:00) Athens, Harare, Jerusalem"]]
      let profileResponse = ProfileResponse(json: json, success: true, message: "address updated")
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
//            self.addressController.showBannerWithError(title: "success", withMessage: "Updated")
            self.addressController.removeSpinner()
        }
        wait(for: [exp], timeout: 2.5)
      //addressController.onGetProfileResponse(response: profileResponse, requestType: "UpdateAddress")
    }
    
    func testApiException(){
        let errorResponse = ErrorResponse(responseCode: 500, message: "Fail", tittle: "Exception")
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
//            self.addressController.showBannerWithError(title: "Invalid details", withMessage: "Server Error")
            self.addressController.removeSpinner()
        }
        wait(for: [exp], timeout: 2.5)
        //addressController.onAPIException(errorResponse: errorResponse, requestType: "address")
    }
    
    func testUpdateCountry(){
        let notification = NSNotification(name: NSNotification.Name(rawValue: "CountriesSearch"), object: nil, userInfo: ["selectedCountry": "United States of America"])
        addressController.updateCountry(notfication: notification)
        
        let notification1 = NSNotification(name: NSNotification.Name(rawValue: "CountriesSearch"), object: nil, userInfo: ["selectedCountry": "India"])
        addressController.updateCountry(notfication: notification1)
        
        let notification2 = NSNotification(name: NSNotification.Name(rawValue: "CountriesSearch"), object: nil, userInfo: ["country": "India"])
        addressController.updateCountry(notfication: notification2)
        
        let notification3 = NSNotification(name: NSNotification.Name(rawValue: "CountriesSearch"), object: nil)
        addressController.updateCountry(notfication: notification3)
    }
    override func setUp() {
        addressController = mainStoryboard.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController
        addressNavigationController = UINavigationController(rootViewController: addressController)
        addressController.view.layoutIfNeeded()
        addressNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = addressController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
