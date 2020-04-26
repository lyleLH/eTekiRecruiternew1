//
//  CompanyViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 20/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class CompanyViewControllerTests: XCTestCase {
    var companyController: CompanyViewController!
    var companyNavigationController: UINavigationController!
     var companyViewModal = CompanyViewModel()
    
    func testBackAction(){
        companyController.backAction(0)
    }
    
    func testInstance(){
        XCTAssertNotNil(companyController.addressTextField, "should not empty")
    }
    func testUpdateAction(){
        let manager = ProfileManager(sameAsbilling: true)
//        let response = ProfileResponse(json: [:], success: true, message: "company")
//        ProfileAuthenticationApi.updateCompanyResponse = response
//        companyViewModal.profileAPI = ProfileAuthenticationApi.self
//        companyController.viewModel.updateCompanyDetails(profileManager: manager)
        companyController.updateButton.sendActions(for: .touchUpInside)
    }
    
    func testGetProfileResponse(){
        
        let profileResponse =  ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: "address1", address2: "address2", city: "city", country: "country", state: "state", timeZone: nil, zip: "531116",companyName: "Company1", website: "", sameAsBillingAddress: true,contact1: nil, contact2: nil, areaCode1: nil, areaCode2: nil, countryCode1: nil, countryCode2: nil, success: true, smsservice: nil, usSMSService: nil, otpRequired: nil, smsContact: nil, smsAreaCode: nil, smsCountrycode: nil, idRequired: false)
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
           // self.companyController.removeSpinner()
        }
        wait(for: [exp], timeout: 2.5)
        companyController.onGetProfileResponse(response: profileResponse)
                let profileResponse1 =  ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: "address1", address2: "address2", city: "city", country: "country", state: "state", timeZone: nil, zip: "531116",companyName: "Company1", website: "", sameAsBillingAddress: false,contact1: nil, contact2: nil, areaCode1: nil, areaCode2: nil, countryCode1: nil, countryCode2: nil, success: true, smsservice: nil, usSMSService: nil, otpRequired: nil, smsContact: nil, smsAreaCode: nil, smsCountrycode: nil, idRequired: false)
                let exp1 = XCTestExpectation(description: "test")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    exp1.fulfill()
                    //self.companyController.removeSpinner()
                }
                wait(for: [exp1], timeout: 2.5)
                companyController.onGetProfileResponse(response: profileResponse1)
    }
    func testGetProfile(){
        
        let profileResponse =  ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: "address1", address2: "address2", city: "city", country: "country", state: "state", timeZone: nil, zip: "531116",companyName: "", website: "", sameAsBillingAddress: true,contact1: nil, contact2: nil, areaCode1: nil, areaCode2: nil, countryCode1: nil, countryCode2: nil, success: true, smsservice: nil, usSMSService: nil, otpRequired: nil, smsContact: nil, smsAreaCode: nil, smsCountrycode: nil, idRequired: false)
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
            //self.companyController.removeSpinner()
        }
        wait(for: [exp], timeout: 2.5)
        companyController.onGetProfileResponse(response: profileResponse)

    }
    func testtTableViewHeight(){
        for index in 0...5 {
            let tableViewRowHeight = companyController.tableView(companyController.companyTableView, heightForRowAt: IndexPath(row: index, section: 0))
            XCTAssertEqual(tableViewRowHeight, 45)
        }
    }
    
    func testViewforFooterInSection(){
        let v = companyController.tableView(companyController.companyTableView, viewForFooterInSection: 0)
        XCTAssertTrue((v != nil))
    }
    
    override func setUp() {
        companyController = mainStoryboard.instantiateViewController(withIdentifier: "CompanyViewController") as? CompanyViewController
        companyNavigationController = UINavigationController(rootViewController: companyController)
        companyController.view.layoutIfNeeded()
        companyNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = companyController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
