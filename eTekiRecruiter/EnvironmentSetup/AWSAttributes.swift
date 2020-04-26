//
//  AWSAttributes.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 02/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import AWSCore

enum S3Configuration : String {
    case IDENTITYPOOLID   = "us-east-1:7f968a1c-d81e-4af4-a379-5be45990eace"
//    case BUCKET_NAME        = "eteki-profile-upload"
//    case BUCKET_NAME_DOCUMENTS     = "eteki-documents"
//
    case BUCKETNAME        = "iconf-profile-upload"
    case BUCKETNAMEDOCUMENTS     = "iconf-documents"
    
   // case BUCKET_NAME_QA       = "iconf-profile-upload"
    case CALLBACKKEY       = "IOS_MOBILE_RECRUITERS"
    case CONTENTTYPEIMAGE = "image/png"
    case CONTENTTYPEVIDEO = "video/mp4"
    case CONITOREGIONTYPE  = "AWSRegionUSEast1"
    case DEFAULTSERVICEREGIONTYPE = "AWSRegionUSWest2"
}




//NSString *const S3BucketName = @"iconf-profile-upload";
//NSString *const S3BucketName_for_documents = @"iconf-documents";

