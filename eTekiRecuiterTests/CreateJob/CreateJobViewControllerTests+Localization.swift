//
//  CreateJobViewControllerTests+Localization.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 23/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
extension CreateJobVewControllerTests {
    func testIsCreateJobButtonLocalized(){
        XCTAssertEqual(createJobController.saveButton.currentTitle, "SAVE_AND_CONTINUE".localized)
    }
//    func testIsJotitleFieldLocalized(){
//        XCTAssertEqual(createJobController.jobTitle.placeholder, "SAVE_AND_CONTINUE".localized)
//    }
}
