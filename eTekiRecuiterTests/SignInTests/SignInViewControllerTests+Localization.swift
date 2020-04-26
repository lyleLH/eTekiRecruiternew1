//
//  SignInViewControllerTests+ Localization.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 31/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//


import XCTest
@testable import eTekiRecruiter

extension SignInViewControllerTests {
    

    func testIsEmailTextFieldLocalized() {
        XCTAssertEqual(signInViewController.emailTextField.placeholder, "ENTER_EMAIL".localized, "Email text-field localized value mismatched.")
        XCTAssertNotEqual(signInViewController.emailTextField.placeholder, "ENTER_EMAIL", "Email text-field localized key not found in .strings file.")
    }
    
    func testIsPasswordTextFieldLocalized() {
        XCTAssertEqual(signInViewController.passwordField.placeholder, "ENTER_PASSWORD".localized, "Password localized value mismatched.")
        XCTAssertNotEqual(signInViewController.passwordField.placeholder, "ENTER_PASSWORD", "Password localized key not found in .strings file.")
    }
    
    func testIsLoginButtonLocalized() {
        XCTAssertEqual(signInViewController.signInButton.title(for: .normal), "SIGN_IN".localized, "Sign In button localized value mismatched.")
        XCTAssertNotEqual(signInViewController.signInButton.title(for: .normal), "SIGN_IN", "Sign In button localized key not found in .strings file.")
    }
    
    func testIsForgorPasswordButtonLocalized() {
        XCTAssertEqual(signInViewController.forgotPasswordButton.title(for: .normal), "FORGET_PASSWORD".localized, "Forgot-Password button localized value mismatched.")
        XCTAssertNotEqual(signInViewController.forgotPasswordButton.title(for: .normal), "FORGET_PASSWORD", "Forgot-Password button localized key not found in .strings file.")
    }
 
    func testIsOrLabelLocalized() {
        XCTAssertEqual(signInViewController.orLabel.text, "OR".localized, "OR label localized value mismatched.")
        XCTAssertNotEqual(signInViewController.orLabel.text, "OR", "OR Labelb localized key not found in .strings file.")
    }
    
    func testIsResendConfirmationButtonLocalized() {
        XCTAssertEqual(signInViewController.resendEmailConfirmationButton.title(for: .normal), "RESEND_CONFIRMATION_LINK".localized, "resendEmailConfirmationButton localized value mismatched.")
        XCTAssertNotEqual(signInViewController.resendEmailConfirmationButton.title(for: .normal), "RESEND_CONFIRMATION_LINK", "resendEmailConfirmationButton button localized key not found in .strings file.")
    }
    
    
}
