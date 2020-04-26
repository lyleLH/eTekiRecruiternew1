//
//  CandidatesViewControllerTests + Localization.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 23/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

extension CandidatesViewControllerTests {
    
    func testIsAddCandidateButtonLocalized() {
        XCTAssertEqual(candidatesViewController.addCandidateButton?.title(for: .normal), "ADD_CANDIDATE".localized, "Add Can button localized value mismatched.")
        XCTAssertNotEqual(candidatesViewController.addCandidateButton?.title(for: .normal), "ADD_CANDIDATE", "Forgot-Password button localized key not found in .strings file.")
    }
    
}
