//
//  AWSManager.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 04/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
import AWSCore

class AWSManager {
    static let shared = AWSManager()
    private init() {}

    func regiesterUitilty() {
        
        let cognitoPoolID = S3Configuration.IDENTITYPOOLID.rawValue
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:cognitoPoolID)
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        //Setup the transfer utility configuration
        let tuConf = AWSS3TransferUtilityConfiguration()
        tuConf.isAccelerateModeEnabled = false
        tuConf.retryLimit = 5
        tuConf.timeoutIntervalForResource = 15*60 //15 minutes
        tuConf.bucket = S3Configuration.BUCKETNAME.rawValue
        //Register a transfer utility object asynchronously
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: "transfer-utility-with-advanced-options"
        ) { (error) in
            if let error = error {
                //Handle registration error.
                print(error)
            }
        }
    }
    
    func uploadS3(image: UIImage,
                  name: String,
                  progressHandler: @escaping (Progress) -> Void,s3UrlHandler: @escaping (URL?,String?) -> Void,
                  s3completionHandler: @escaping (Error?) -> Void) {
        
        let s3BucketName = S3Configuration.BUCKETNAME.rawValue
        let data: Data = image.pngData()!
        
       // let uuid = UUID().uuidString
        
        let remoteName =   generateRandomStringWithLength(length: 12) + "." + data.format

       // let remoteName =  uuid + "." + data.format

        print("REMOTE NAME : ",remoteName)
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        expression.progressBlock = { (task, progress) in
            
            DispatchQueue.main.async(execute: {
                progressHandler(progress)
                
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                    s3completionHandler(error)
                }
                
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data, bucket: s3BucketName, key: remoteName, contentType: "image/png", expression: expression, completionHandler: completionHandler).continueWith{ (task) -> Any? in
            
            if let error = task.error {
                print("Error : \(error.localizedDescription)")
                s3completionHandler(error)
                
            }
            
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(s3BucketName).appendingPathComponent(remoteName)
                
                if let absoluteString = publicURL?.absoluteString {
                    // Set image with URL
                    print("Image URL : ",absoluteString)
                    s3UrlHandler(publicURL, remoteName)
                    
                }
            }
            
            return nil
        }
        
    }
    
    func generateRandomStringWithLength(length: Int) -> String {
        let randomString: NSMutableString = NSMutableString(capacity: length)
        let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var index: Int = 0
        
        while index < length {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            index += 1
        }
        return String(randomString)
    }
    
    
    func downloadImageWithKey(key: String,
                              progressHandler: @escaping (Progress) -> Void,
                              downloadedImage: @escaping (UIImage) -> Void,
                              s3completionHandler: @escaping (Error?) -> Void) {
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                progressHandler(progress)
            })
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, location, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    
                    s3completionHandler(error)
                }
                
                if let imageData = data {
                    let image : UIImage = UIImage(data: imageData) ?? UIImage()
                    downloadedImage(image)
                } else {
                    
                    print("Data Image is NIL")
                }
                
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.downloadData(fromBucket: S3Configuration.BUCKETNAME.rawValue, key: key, expression: expression,completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
            if let error = task.error {
                NSLog("Error: %@",error.localizedDescription);
                DispatchQueue.main.async(execute: {
                    s3completionHandler(error)
                })
            }
            
            if let _ = task.result {
                DispatchQueue.main.async(execute: {
                })
                NSLog("Download Starting!")
                // Do something with uploadTask.
            }
            return nil;
        }
        
    }
    
    
    
    func multipartFileUpload(fileData: Data,
                             name: String,awsLocationKey : String,
                             progressHandler: @escaping (Progress) -> Void,s3UrlHandler: @escaping (URL?,String?) -> Void,
                             s3completionHandler: @escaping (Error?) -> Void) {
        
        // Resumes ----- jobs/3366/resumes/
        // Job Description ---------- jobs/
        
        let remoteFileName = awsLocationKey + generateRandomStringWithLength(length: 12) + "." + name
        let expression = AWSS3TransferUtilityMultiPartUploadExpression()
        expression.progressBlock = {(task, progress) in
            print(progress)
            progressHandler(progress)
        }
        
        var completionHandler: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock
        completionHandler = { (task, error) -> Void in
            if let error = error {
                s3completionHandler(error)
            }
        }
            print(name)
        let mimeType = AWSManager.mimeType(for: fileData)
        print("==========================\(mimeType)")
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadUsingMultiPart(data:fileData,
                                             bucket: S3Configuration.BUCKETNAMEDOCUMENTS.rawValue,
                                             key: remoteFileName,
                                             contentType: mimeType,
                                             expression: expression,
                                             completionHandler: completionHandler).continueWith {
                                                (task) -> AnyObject? in
                                                if let error = task.error {
                                                    print("Error: \(error.localizedDescription)")
                                                    s3completionHandler(error)
                                                }
                                                
                                                if task.result != nil {
                                                    let url = AWSS3.default().configuration.endpoint.url
                                                    let publicURL = url?.appendingPathComponent(S3Configuration.BUCKETNAMEDOCUMENTS.rawValue).appendingPathComponent(remoteFileName)
                                                    
                                                    if let absoluteString = publicURL?.absoluteString {
                                                        // Set image with URL
                                                        print("pdf URL : ",absoluteString)
                                                        s3UrlHandler(publicURL, remoteFileName)
                                                        
                                                    }
                                                }
                                                return nil
        }
    }
    
    
    func multipartFileUploadWithURL(fileURL: URL,
                                    name: String,
                                    progressHandler: @escaping (Progress) -> Void,s3UrlHandler: @escaping (URL?,String?) -> Void,
                                    s3completionHandler: @escaping (Error?) -> Void) {
        
        
        
        let remoteFileName = generateRandomStringWithLength(length: 12) + "." + fileURL.pathExtension
        
        let expression = AWSS3TransferUtilityMultiPartUploadExpression()
        expression.progressBlock = {(task, progress) in
            progressHandler(progress)
        }
        
        var completionHandler: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock
        completionHandler = { (task, error) -> Void in
            
            if let error = error {
                s3completionHandler(error)
            }
            
        }
        let transferUtility = AWSS3TransferUtility.default()
        

        
        print(fileURL)
        
        
        
        
        transferUtility.uploadUsingMultiPart(fileURL: fileURL, bucket: S3Configuration.BUCKETNAMEDOCUMENTS.rawValue, key: fileURL.lastPathComponent, contentType: fileURL.pathExtension, expression: expression, completionHandler: completionHandler).continueOnSuccessWith(block: { (task) -> Any? in
            
                if task.result != nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(S3Configuration.BUCKETNAMEDOCUMENTS.rawValue).appendingPathComponent(remoteFileName)

                    if let absoluteString = publicURL?.absoluteString {
                    // Set image with URL
                    print("Image URL : ",absoluteString)
                    s3UrlHandler(publicURL, remoteFileName)

                    }
                }
            return nil

            })
        

        
    }
    
    func downloadFileWithKey(key: String,
                             progressHandler: @escaping (Progress) -> Void,
                             fileData: @escaping (Data) -> Void,
                             s3completionHandler: @escaping (Error?) -> Void) {
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            progressHandler(progress)
        })
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            
            
            if let error = error {
                s3completionHandler(error)
            }
            
            if let data = data {
                fileData(data)
            } else {
                print("File Data is nil")
            }
            
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: S3Configuration.BUCKETNAME.rawValue,
            key: key,
            expression: expression,
            completionHandler: completionHandler
        ).continueWith {
            (task) -> AnyObject? in if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with downloadTask.
                
            }
            return nil
        }
    }
}

extension AWSManager {
    
    static func mimeType(for data: Data) -> String {

        var index: UInt8 = 0
        data.copyBytes(to: &index, count: 1)

        switch index {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return ""
        }
    }

    
}

