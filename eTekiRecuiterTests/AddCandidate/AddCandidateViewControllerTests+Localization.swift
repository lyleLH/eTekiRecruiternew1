//
//  AddCandidateViewControllerTests+Localization.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 23/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

extension AddCandidateViewControllerTests {
    
    func testIsFirstnameLocalized() {
        XCTAssertNotNil(addCandidateController.firstNameField.placeholder)
        XCTAssertEqual(addCandidateController.firstNameField.placeholder, "PROFILEINFO_FIRSTNAME".localized)
        XCTAssertNotEqual(addCandidateController.firstNameField.placeholder, "PROFILEINFO_FIRSTNAME", "Profile Info text-field localized key not found in .strings file.")
    }
    
    func testLastnameLocalized() {
        XCTAssertNotNil(addCandidateController.lastNameField.placeholder)
        XCTAssertEqual(addCandidateController.lastNameField.placeholder, "PROFILEINFO_LASTNAME".localized)
        XCTAssertNotEqual(addCandidateController.lastNameField.placeholder, "PROFILEINFO_LASTNAME", "Profile Info Last name localized key not found in .strings file.")

    }
    
    func testEmailLocalized(){
        XCTAssertNotNil(addCandidateController.emailField.placeholder)
        XCTAssertEqual(addCandidateController.emailField.placeholder, "EMAIL_ADDRESS".localized)
        XCTAssertNotEqual(addCandidateController.emailField.placeholder, "EMAIL_ADDRESS", "Email Address localized key not found in .strings file.")
    }
    
    func testCandidateOwnerLocalized() {
      XCTAssertNotNil(addCandidateController.candidateOwner.placeholder)
      XCTAssertEqual(addCandidateController.candidateOwner.placeholder, "CANDIDATE_OWNER".localized)
       XCTAssertNotEqual(addCandidateController.candidateOwner.placeholder, "CANDIDATE_OWNER", "Candidate Onwer localized key not found in .strings file.")

    }
    
    func testUploadButtonLocalized() {
        XCTAssertNotNil(addCandidateController.uploadFileButton.currentTitle)
        XCTAssertEqual(addCandidateController.uploadFileButton.currentTitle, "UPLOAD".localized)
        XCTAssertNotEqual(addCandidateController.uploadFileButton.currentTitle, "UPLOAD", "UPLOAD localized key not found in .strings file.")
    }
    
    func testTimezoneLocalized() {
        XCTAssertNotNil(addCandidateController.timeZoneField.placeholder)
        XCTAssertEqual(addCandidateController.timeZoneField.placeholder, "TIME_ZONE".localized)
        XCTAssertNotEqual(addCandidateController.timeZoneField.placeholder, "TIME_ZONE", "TIME ZONE localized key not found in .strings file.")

    }
    
    func testReportDueLocalized() {
        XCTAssertNotNil(addCandidateController.reportDuelabel.text)
        XCTAssertEqual(addCandidateController.reportDuelabel.text, "CANDIDATE_REPORT_DUE_By".localized)
        XCTAssertNotEqual(addCandidateController.reportDuelabel.text, "CANDIDATE_REPORT_DUE_By", "CANDIDATE report due by localized key not found in .strings file.")

    }
    
    func testIsDateFieldLocalized() {
        XCTAssertNotNil(addCandidateController.dateField.placeholder)
        XCTAssertEqual(addCandidateController.dateField.placeholder, "DATE_FIELD".localized)
        XCTAssertNotEqual(addCandidateController.dateField.placeholder, "DATE_FIELD", "Date field by localized key not found in .strings file.")

    }
    
    func testTimeFieldLocalized() {
        XCTAssertNotNil(addCandidateController.timeField.placeholder)
        XCTAssertEqual(addCandidateController.timeField.placeholder, "TIME_FIELD".localized)
        XCTAssertNotEqual(addCandidateController.timeField.placeholder, "TIME_FIELD", "Time field by localized key not found in .strings file.")
    }
    
    func testCandidateSmsLocalized() {
        XCTAssertNotNil(addCandidateController.smsOPTlabel.text)
        XCTAssertEqual(addCandidateController.smsOPTlabel.text, "CANDIDATE_SMS_OPT_IN".localized)
        XCTAssertNotEqual(addCandidateController.smsOPTlabel.text, "CANDIDATE_SMS_OPT_IN", "Candidates SMS OPT In by localized key not found in .strings file.")
    }
    
    func testnotifyOfInterviewLocalized() {
        XCTAssertNotNil(addCandidateController.notifyInterview.text)
        XCTAssertEqual(addCandidateController.notifyInterview.text, "NOTIFY_OF_INTERVIEW".localized)
        XCTAssertNotEqual(addCandidateController.notifyInterview.text, "NOTIFY_OF_INTERVIEW", "Notify Interview In by localized key not found in .strings file.")
    }
    
    func testDisclaimerLocalized() {
        XCTAssertNotNil(addCandidateController.disclaimer.text)
        XCTAssertEqual(addCandidateController.disclaimer.text, "DISCLAIMER".localized)
        XCTAssertNotEqual(addCandidateController.disclaimer.text, "DISCLAIMER", "Disclaimer In by localized key not found in .strings file.")
    }
    
    func testDisclaimerMessageLocalized() {
        XCTAssertNotNil(addCandidateController.disclaimerMessage.text)
        XCTAssertEqual(addCandidateController.disclaimerMessage.text, "DISCLAIMER_MESSAGE".localized)
        XCTAssertNotEqual(addCandidateController.disclaimerMessage.text, "DISCLAIMER_MESSAGE", "Disclaimer message In by localized key not found in .strings file.")
    }
    
}
