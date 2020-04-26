//
//  UserDetails.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 05/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import NotificationBannerSwift

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
    case profileIncomplete(String)
}

public struct UserDetails: Codable {
    
    public var areaCode: String?
    public var countryCode: String?
    public var displayName: String?
    public var profileCreated : String?
    public var profileId : String?
    public var phoneNumber : String?
    public var profilePics : Dictionary<String,String>?
    public var email: String?
    public var role : String?
    public var termsOfService : String?
    public var provider : String?
}

extension UserDetails: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "\nUserDetails"
        description += "\n\tresponseCode: \(String(describing: profileCreated))"
        return description
    }
}


extension UserDetails {
    init(json: [String: Any]) {
        self.areaCode = json["area_code"] as? String ?? ""
        self.countryCode = json["country_code"] as? String ?? ""
        self.displayName = json["display_name"] as? String ?? ""
        
        if let displayName = json["display_name"] {
            UserDefaults.standard.set(displayName, forKey: "displayName")
        }
        
        self.email = json["email"] as? String ?? ""
        self.profileId = json["id"] as? String ?? ""
        self.phoneNumber = json["phone"] as? String ?? ""
        self.profileCreated = json["profile_created"] as? String ?? ""
        self.profilePics = json["profile_pics"] as? Dictionary<String,String> ?? Dictionary()
        
        let profileThumb = self.profilePics?["profile_thumb_url"] ?? ""
        print(profileThumb)
        
        self.provider = json["provider"] as? String ?? ""
        self.role = json["role"] as? String ?? ""
        self.termsOfService = json["terms_of_service"] as? String ?? ""
        UserDefaults.standard.set(profileThumb, forKey: "ProfilePic")
        UserDefaults.standard.set(self.role, forKey: "Role")
        
        //Update recruiter time zone in Defaults.
        if let recruitertTimeZone = json["time_zone"]  as? String {
            
            for dict in LocalCountry.timezoneList {
                for (key,value) in dict {
                    if key == recruitertTimeZone {
                        let dict:[String:String] = [key:value]
                        UserDefaults.standard.set(dict, forKey: "RecruiterTimeZone")
                    }
                }
            }
        }
        
        
    }
}

