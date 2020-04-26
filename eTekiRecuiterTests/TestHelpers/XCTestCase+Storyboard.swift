//
//  XCTestCase+Storyboard.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 31/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

extension XCTestCase {
    /**
     * Get mainStoryboard inside XCTestCase.
     */
    var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle(for: SignInViewController.self))
    }
}
