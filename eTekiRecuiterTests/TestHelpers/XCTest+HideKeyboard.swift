//
//  XCTest+HideKeyboard.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 06/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

extension XCUIApplication {
    func hideKeyboard() {
        let firstKey = self.keys.element(boundBy: 0)
        if firstKey.exists {
            self.typeText("\n")
        }
    }
}
