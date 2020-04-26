//
//  XCTest+Async.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 31/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest

extension XCTestCase {
    /**
     * Helper function for setting up a single expectation; call expectation.fulfill() to complete expectation.
     *
     * Default timeout value => 5 seconds
     */
    func wait(description: String = #function, timeout: TimeInterval = 5.0, testingClosure: @escaping (XCTestExpectation) -> Void) {
        let newExpectation = expectation(description: description)
        testingClosure(newExpectation)
//        waitForExpectations(timeout: timeout, handler: nil)
    }
}
