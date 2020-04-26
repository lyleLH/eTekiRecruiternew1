//
//  Optional+NullifyString.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 05/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}
