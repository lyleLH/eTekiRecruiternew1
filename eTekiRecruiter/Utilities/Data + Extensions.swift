//
//  Data + Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 24/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import Foundation

extension Data {

    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }

}
