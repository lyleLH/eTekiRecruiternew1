//
//  ForgotPasswordTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 06/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
import NotificationBannerSwift
@testable import eTekiRecruiter

class ForgotPasswordTests: XCTestCase {
    
    var forgotPasswordViewController: ForgotPasswordViewController!
    var forgotPasswordInNavigationController: UINavigationController!

    override func setUp() {
        forgotPasswordViewController = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        forgotPasswordInNavigationController = UINavigationController(rootViewController: forgotPasswordViewController)
        forgotPasswordViewController.view.layoutIfNeeded()
        forgotPasswordInNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = forgotPasswordInNavigationController
    }

    override func tearDown() {
        forgotPasswordViewController = nil
        forgotPasswordInNavigationController = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(forgotPasswordViewController, "Not able to create forgotPasswordViewController Instance.")
        XCTAssertNotNil(forgotPasswordViewController.backToLogin, "Not able to create backToLogin Instance.")
        XCTAssertNotNil(forgotPasswordViewController.resetButton, "Not able to create resetButton Instance.")
        XCTAssertNotNil(forgotPasswordViewController.resetPasswordTitleLabel, "Not able to create resetPasswordTitleLabel Instance.")
        XCTAssertNotNil(forgotPasswordViewController.resetPasswordDescription, "Not able to create resetPasswordDescription Instance.")
        XCTAssertNotNil(forgotPasswordViewController.emailTextField, "Not able to create emailTextField Instance.")
    }
    
    func testEmailTextField() {
        let leftView = forgotPasswordViewController.emailTextField.leftView
        let imageContentView = leftView?.subviews[0]
        let imageView = imageContentView?.subviews[0] as? UIImageView
        XCTAssertNotNil(imageView, "imageView view is nil")
        XCTAssertEqual(imageView?.image, UIImage(named: "email"), "email icon is broken")
        
        XCTAssertEqual(forgotPasswordViewController.emailTextField.frame.height, 60.0,"Email Field Height broken")
        XCTAssertFalse(forgotPasswordViewController.emailTextField.isHidden, "Email Field is hidden")
    }
    
    func testResetButton() {
        XCTAssertEqual(forgotPasswordViewController.resetButton.frame.height, 50.0,"resetButton Height broken")
        XCTAssertFalse(forgotPasswordViewController.resetButton.isHidden, "resetButtonis hidden")
        XCTAssertTrue(forgotPasswordViewController.resetButton.isUserInteractionEnabled, "resetButton user interaction is disabled")
        XCTAssertEqual(forgotPasswordViewController.resetButton.titleLabel?.text, "RESET_PASSWORD".localized, "resetButton localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.resetButton.titleLabel?.text, "RESET_PASSWORD", "resetButton localized key not found in .strings file.")
    }
    
    func testForgotPasswordTitleLabel() {
        XCTAssertFalse(forgotPasswordViewController.resetPasswordTitleLabel.isHidden, "resetPasswordTitleLabel hidden")
        XCTAssertEqual(forgotPasswordViewController.resetPasswordTitleLabel.text, "RESET_PASSWORD".localized, "resetPasswordTitleLabel localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.resetPasswordTitleLabel.text, "RESET_PASSWORD", "resetPasswordTitleLabel localized key not found in .strings file.")
    }
    
    func testForgotPasswordDescLabel() {
        XCTAssertFalse(forgotPasswordViewController.resetPasswordDescription.isHidden, "resetPasswordDescription hidden")

        XCTAssertEqual(forgotPasswordViewController.resetPasswordDescription.text, "RESET_PASSWORD_DESC".localized, "resetPasswordDescription localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.resetPasswordDescription.text, "RESET_PASSWORD_DESC", "resetPasswordDescription localized key not found in .strings file.")
    }
    
    func testBackToLoginButton() {
        XCTAssertEqual(forgotPasswordViewController.backToLogin.frame.height, 50.0,"backToLogin Height broken")
        XCTAssertFalse(forgotPasswordViewController.backToLogin.isHidden, "backToLogin is hidden")
        XCTAssertTrue(forgotPasswordViewController.backToLogin.isUserInteractionEnabled, "backToLogin user interaction is disabled")
        XCTAssertEqual(forgotPasswordViewController.backToLogin.titleLabel?.text, "BACK_TO_LOGIN".localized, "back to login localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.backToLogin.titleLabel?.text, "BACK_TO_LOGIN", "back to login localized key not found in .strings file.")
    }
    
    func testEmailValidationFailure() {
        forgotPasswordViewController.emailTextField.insertText("email@")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        let result = forgotPasswordViewController.viewModel.shouldValidateCredentials()
        XCTAssertFalse(result.0, "Email Validation broken")
        XCTAssertEqual(result.1, "Please enter valid email", "Email Validation Message String Broken")
    }
    
    func testEmailValidationSuccess() {
        forgotPasswordViewController.emailTextField.insertText("email@test.com")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        let result = forgotPasswordViewController.viewModel.shouldValidateCredentials()
        XCTAssertTrue(result.0, "Email Validation broken")
        XCTAssertEqual(result.1, "", "Email Validation Message String Broken")
    }
    
    func testBackAction(){
        forgotPasswordViewController.backToLogin(0)
        
        let segue = UIStoryboardSegue(identifier: StoryboardSegueIdentifiers.forgotPasswordToCustomMessage, source: forgotPasswordViewController, destination: CustomTickViewController())
        forgotPasswordViewController.responseMessage = "response"
        forgotPasswordViewController.prepare(for: segue, sender: nil)
    }
    
    func testForgotPasswordResponse(){
        let response = ForgotPasswordResponse(success: true, message: "success")
        forgotPasswordViewController.onForgotPasswordResponse(response: response)
    }
    
    func testApiException(){
        let response = ErrorResponse(responseCode: 404, message: ErrorHandler.tokenExpired, tittle: "")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.5)
        forgotPasswordViewController.onAPIException(errorResponse: response)
    }
    
    func testForgotPasswordActionWithValidEmail() {
        
        guard let forgotPasswordViewController = UIApplication.topMostViewController() as? ForgotPasswordViewController else {
                      XCTFail("ForgotPasswordViewController is not Top most view controller.")
                      return
        }
        
        forgotPasswordViewController.view.layoutIfNeeded()
        forgotPasswordViewController.emailTextField.text = "siva.palakurthy@amzurtech.com"
     
        let forgotPasswordResponse = ForgotPasswordResponse(json: ["message": "You will receive an email momentarily with instructions on how to reset your password.  If you do not see the email in  your Inbox, please check your Spam / Junk folder."], success: true)
        StubAuthenticationApi.forgotPasswordResponse = forgotPasswordResponse
        forgotPasswordViewController.viewModel.authenticaionAPI = StubAuthenticationApi.self
        forgotPasswordViewController.resetButton.sendActions(for: .touchUpInside)
        
        let expectation = XCTestExpectation(description: "test")

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            guard let customTickViewController = UIApplication.topMostViewController() as? CustomTickViewController else {
//                XCTFail("CustomTickViewController is not Top most view controller.")
//                return
//            }
//            expectation.fulfill()
//
//            XCTAssertNotNil(customTickViewController, "Not able to Navigate CustomTickViewController, instance is nil.")
//            customTickViewController.view.layoutIfNeeded()
//            XCTAssertEqual(customTickViewController.message, "FORGOT_PASSWORD_LINK_RESET_DESC".localized,"Message are not matching")
//        }
//        wait(for: [expectation], timeout: 3.0)

    }
    
    func testForgotPasswordActionWithInValidEmail() {
        forgotPasswordViewController.emailTextField.insertText("siva")
        
        let forgotPasswordResponse = ForgotPasswordResponse(json: [:], success: true)
        StubAuthenticationApi.forgotPasswordResponse = forgotPasswordResponse
        forgotPasswordViewController.viewModel.authenticaionAPI = StubAuthenticationApi.self
        
        forgotPasswordViewController.resetButton.sendActions(for: .touchUpInside)
        
        guard let forgotPasswordViewController = UIApplication.topMostViewController() as? ForgotPasswordViewController else {
            XCTFail("ForgotPasswordViewController is not Top most view controller.")
            return

        }
        forgotPasswordViewController.view.layoutIfNeeded()
    }
    

}

