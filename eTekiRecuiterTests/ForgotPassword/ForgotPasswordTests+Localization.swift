//
//  ForgotPasswordTests+Localization.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 20/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

extension ForgotPasswordTests {
    
    func testIsEmailTextFieldLocalized() {
        XCTAssertEqual(forgotPasswordViewController.emailTextField.placeholder, "ENTER_EMAIL".localized, "Email text-field localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.emailTextField.placeholder, "ENTER_EMAIL", "Email text-field localized key not found in .strings file.")
    }
    
    func testIsResetButtonLocalized() {
        XCTAssertEqual(forgotPasswordViewController.resetButton.title(for: .normal), "RESET_PASSWORD".localized, "Reset Password button localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.resetButton.title(for: .normal), "RESET_PASSWORD", "Reset Password button localized key not found in .strings file.")
    }
    
    func testIsBackToLoginLocalized() {
        XCTAssertEqual(forgotPasswordViewController.backToLogin.title(for: .normal), "BACK_TO_LOGIN".localized, "Back to Login localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.backToLogin.title(for: .normal), "BACK_TO_LOGIN", "Back to Login button localized key not found in .strings file.")
    }
    
    func testIsTitleLabelLocalized() {
        XCTAssertEqual(forgotPasswordViewController.resetPasswordTitleLabel.text, "RESET_PASSWORD".localized, "Reset Password localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.resetPasswordTitleLabel.text, "RESET_PASSWORD", "Reset Password button localized key not found in .strings file.")
    }
    
    func testIsTitleDescLabelLocalized() {
        XCTAssertEqual(forgotPasswordViewController.resetPasswordDescription.text, "RESET_PASSWORD_DESC".localized, "Reset Password Description localized value mismatched.")
        XCTAssertNotEqual(forgotPasswordViewController.resetPasswordDescription.text, "RESET_PASSWORD_DESC", "Reset Password Description localized key not found in .strings file.")
    }    
}
