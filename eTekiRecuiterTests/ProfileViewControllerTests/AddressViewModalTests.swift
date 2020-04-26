//
//  AddressViewModalTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 03/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class AddressViewModalTests: XCTestCase {
  var addressViewModal = AddressViewModel()
    
    func testAddressViewModal(){
        let manager = ProfileManager(address: "Narsipatnam", city: "visakhapatnam", country: "India", state: "AndhraPradesh", timeZone: "(GMT+02:00) Athens, Harare, Jerusalem", zip: "531116")
       // addressViewModal.apiCall(profileManager: manager, requestType : "GetAddress")
       //addressViewModal.getAddressDetails(profileManager: manager, requestType: "GetAddress")
    }
    
    func testUpdateView(){
        let response = ProfileResponse(alternateEmail: nil, firstName: nil, lastName: nil, displayName: nil, email: nil, phoneNumber: nil, alternatePhoneNumber: nil, twitter: nil, googlePlus: nil, facebook: nil, linkedIn: nil, message: nil, currentPasscode: nil, address1: "address1", address2: nil, city: "city", country:"India", state: "ap", timeZone: "(GMT+02:00) Athens, Harare, Jerusalem", zip: "531116", companyName: nil, website: nil, sameAsBillingAddress: nil, contact1: nil, contact2: nil, areaCode1: nil, areaCode2: nil, countryCode1: "+91", countryCode2: "+91", success: true, smsservice: nil, usSMSService: nil, otpRequired: nil, smsContact: nil, smsAreaCode: nil, smsCountrycode: nil, idRequired: false)
//        addressViewModal.updateView(response: response)
    }
    
    func testApiCallofGetResponse(){
//        let manager = ProfileManager(address: "address1", city: "Narsipatnam", country: "India", state: "Visakhapatnam", timeZone: "(GMT+02:00) Athens, Harare, Jerusalem", zip: "531116")
//        let getProfileResponse = ProfileResponse(json: ["type": "address","city": "city", "country":"India", "state": "ap", "timeZone": "(GMT+02:00) Athens, Harare, Jerusalem", "zip": "531116",], success: true, message: "200")
//        ProfileAuthenticationApi.getProfileResponse = getProfileResponse
//        addressViewModal.profileAPI = ProfileAuthenticationApi.self
//      addressViewModal.apiCall(profileManager: manager, requestType: "address")
    }
    
    override func setUp() {
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
