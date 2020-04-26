//
//  SignInViewModelTest.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 01/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class SignInViewModelTest: XCTestCase {

    var signInViewModel: SignInViewModel!
    
    override func setUp() {
        super.setUp()
        signInViewModel = SignInViewModel()
    }
    
    override func tearDown() {
        signInViewModel = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(signInViewModel, "ViewModel Instance is Nil.")
    }
    
    func testCallAuthenticationApi() {
        let credentialsManager = CredentialsManager(username: "siva@mail.com" , password: "Secret@16",applicationId: "")
        signInViewModel.callAuthenticationAPI(credentialsManager: credentialsManager)
    }
    
    func testCallOAuthLoginApi(){
        let response = SocialSignInResponse(json: ["name": "anusha", "id": "3345", "email": "anusha.u@mailinator.com"], success: true)
        signInViewModel.callOathLogingAPI(socialSignInResponse: response)
    }
}
