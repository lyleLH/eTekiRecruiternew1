//
//  ResendConfirmation.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 20/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

extension ResendConfirmationViewControllerTests {
    
    func testIsEmailTextFieldLocalized() {
        XCTAssertEqual(resendConfirmationLinkViewController.emailTextField.placeholder, "ENTER_EMAIL".localized, "Email text-field localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.emailTextField.placeholder, "ENTER_EMAIL", "Email text-field localized key not found in .strings file.")
    }
    
    func testIsResetButtonLocalized() {
        XCTAssertEqual(resendConfirmationLinkViewController.resetButton.title(for: .normal), "RESEND".localized, "Resend button localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.resetButton.title(for: .normal), "RESEND", "Resend button localized key not found in .strings file.")
    }
    
    func testIsBackToLoginLocalized() {
        XCTAssertEqual(resendConfirmationLinkViewController.backToLogin.title(for: .normal), "BACK_TO_LOGIN".localized, "Back to Login localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.backToLogin.title(for: .normal), "BACK_TO_LOGIN", "Back to Login button localized key not found in .strings file.")
    }
    
    func testIsTitleLabelLocalized() {
        XCTAssertEqual(resendConfirmationLinkViewController.resendConfirmationTitle.text, "RESEND_CONFIRMATION".localized, "Resend Confirmation localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.resendConfirmationTitle.text, "RESEND_CONFIRMATION", "Resend Confirmation  localized key not found in .strings file.")
    }
    
    func testIsTitleDescLabelLocalized() {
        XCTAssertEqual(resendConfirmationLinkViewController.resendConfirmationDescription.text, "RESEND_CONFIRMATION_DESC".localized, "Resend confirmation Description localized value mismatched.")
        XCTAssertNotEqual(resendConfirmationLinkViewController.resendConfirmationDescription.text, "RESEND_CONFIRMATION_DESC", "Resend confirmation mail Description localized key not found in .strings file.")
    }
}
