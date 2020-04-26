//
//  ResendConfirmationViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 06/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter


class ResendConfirmationViewControllerTests: XCTestCase {

    var resendConfirmationLinkViewController: ResendConfirmationLinkViewController!
    var resendConfirmationLinkNavigationController: UINavigationController!
    
    override func setUp() {
        resendConfirmationLinkViewController = mainStoryboard.instantiateViewController(withIdentifier: "ResendConfirmationLinkViewController") as? ResendConfirmationLinkViewController
        resendConfirmationLinkNavigationController = UINavigationController(rootViewController: resendConfirmationLinkViewController)
        resendConfirmationLinkViewController.view.layoutIfNeeded()
        resendConfirmationLinkNavigationController.view.layoutIfNeeded()
        
        UIApplication.shared.keyWindow?.rootViewController = resendConfirmationLinkNavigationController
        
    }
    
    override func tearDown() {
        resendConfirmationLinkViewController = nil
        resendConfirmationLinkNavigationController = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(resendConfirmationLinkViewController, "Not able to create ResendConfirmationLinkViewController Instance.")
        XCTAssertNotNil(resendConfirmationLinkViewController.backToLogin, "Not able to create backToLogin Instance.")
        
        XCTAssertNotNil(resendConfirmationLinkViewController.resetButton, "Not able to create resetButton Instance.")
        XCTAssertNotNil(resendConfirmationLinkViewController.resendConfirmationTitle, "Not able to create resendConfirmationTitle Instance.")
        XCTAssertNotNil(resendConfirmationLinkViewController.resendConfirmationDescription, "Not able to create resendConfirmationDescription Instance.")
        XCTAssertNotNil(resendConfirmationLinkViewController.emailTextField, "Not able to create emailTextField Instance.")
    }
    
    func testResendConfirmationTitleLabel() {
        
        XCTAssertFalse(resendConfirmationLinkViewController.resendConfirmationTitle.isHidden, "resendConfirmationTitle hidden")
        XCTAssertEqual(resendConfirmationLinkViewController.resendConfirmationTitle.text, "RESEND_CONFIRMATION".localized, "resendConfirmationTitle localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.resendConfirmationTitle.text, "RESEND_CONFIRMATION", "resendConfirmationTitle localized key not found in .strings file.")
    }
    
    func testResendConfirmationDescLabel() {
        XCTAssertFalse(resendConfirmationLinkViewController.resendConfirmationDescription.isHidden, "resendConfirmationDescription hidden")
        XCTAssertEqual(resendConfirmationLinkViewController.resendConfirmationDescription?.font, UIFont (name: "HelveticaLTStd-Light", size: 16.0), "resendConfirmationDescription font value mismatched.")
        XCTAssertEqual(resendConfirmationLinkViewController.resendConfirmationDescription.text, "RESEND_CONFIRMATION_DESC".localized, "resendConfirmationDescription localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.resendConfirmationDescription.text, "RESEND_CONFIRMATION_DESC", "resendConfirmationDescription localized key not found in .strings file.")
    }
    
    
    func testEmailTextField() {
        let leftView = resendConfirmationLinkViewController.emailTextField.leftView
        let imageContentView = leftView?.subviews[0]
        let imageView = imageContentView?.subviews[0] as? UIImageView
        XCTAssertNotNil(imageView, "imageView view is nil")
        XCTAssertEqual(imageView?.image, UIImage(named: "email"), "email icon is broken")
        
        XCTAssertEqual(resendConfirmationLinkViewController.emailTextField.frame.height, 60.0,"Email Field Height broken")
        XCTAssertFalse(resendConfirmationLinkViewController.emailTextField.isHidden, "Email Field is hidden")
    }
    
    func testResendButton() {
        XCTAssertEqual(resendConfirmationLinkViewController.resetButton.frame.height, 50.0,"resetButton Height broken")
        XCTAssertFalse(resendConfirmationLinkViewController.resetButton.isHidden, "resetButtonis hidden")
        XCTAssertTrue(resendConfirmationLinkViewController.resetButton.isUserInteractionEnabled, "resetButton user interaction is disabled")
        
        XCTAssertEqual(resendConfirmationLinkViewController.resetButton.titleLabel?.text, "RESEND".localized, "resetButton localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.resetButton.titleLabel?.text, "RESEND", "resetButton localized key not found in .strings file.")
    }
    
    
    func testBackToLoginButton() {
        XCTAssertEqual(resendConfirmationLinkViewController.backToLogin.frame.height, 50.0,"backToLogin Height broken")
        XCTAssertFalse(resendConfirmationLinkViewController.backToLogin.isHidden, "backToLogin is hidden")
        XCTAssertTrue(resendConfirmationLinkViewController.backToLogin.isUserInteractionEnabled, "backToLogin user interaction is disabled")
        
        XCTAssertEqual(resendConfirmationLinkViewController.backToLogin.titleLabel?.text, "BACK_TO_LOGIN".localized, "back to login localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.backToLogin.titleLabel?.text, "BACK_TO_LOGIN", "back to login localized key not found in .strings file.")
    }
    
    func testEmailValidationFailure() {
        resendConfirmationLinkViewController.emailTextField.insertText("email@")
        let result = resendConfirmationLinkViewController.viewModel.shouldValidateCredentials()
        XCTAssertFalse(result.0, "Email Validation broken")
        XCTAssertEqual(result.1, "Please enter valid email", "Email Validation Message String Broken")
    }
    
    func testEmailValidationSuccess() {
        resendConfirmationLinkViewController.emailTextField.insertText("email@test.com")
        let result = resendConfirmationLinkViewController.viewModel.shouldValidateCredentials()
        XCTAssertTrue(result.0, "Email Validation broken")
        XCTAssertEqual(result.1, "", "Email Validation Message String Broken")
    }
    
    func testResendWithInValidpPassword() {
        
        resendConfirmationLinkViewController.emailTextField.insertText("adadasdads")
        resendConfirmationLinkViewController.resetButton.sendActions(for: .touchUpInside)
        
        let expectation = XCTestExpectation(description: "test")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.5)

    }
    
    func testBackAction(){
        resendConfirmationLinkViewController.backToLogin(0)
    }
    
    func testForgotPasswordResponse(){
        let response = ForgotPasswordResponse(success: true, message: "success")
        resendConfirmationLinkViewController.onResendConfirmationResponse(response: response)
    }
    
    func testApiException(){
        let response = ErrorResponse(responseCode: 404, message: ErrorHandler.tokenExpired, tittle: "")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.5)
        resendConfirmationLinkViewController.onAPIException(errorResponse: response)
    }
}
