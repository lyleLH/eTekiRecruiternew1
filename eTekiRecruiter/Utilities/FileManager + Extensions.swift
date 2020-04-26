//
//  FileManager + Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 25/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                print("Clear Temporary file at \(fileUrl.absoluteString)")
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
}
