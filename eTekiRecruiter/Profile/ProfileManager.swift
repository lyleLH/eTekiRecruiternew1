//
//  ProfileManager.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct ProfileManager : Codable {

    public var type: String?
    
    public var currentPassword: String?
    public var newPassword: String?
    public var confirmPassword: String?
    public var sameAsBillingAddress: Bool?

    public var socialLinks: Array<Dictionary<String,String>>?
    
    //Params: {"address": "usa", "city": " ","country": "United States of America", "state": "Florida","time_zone": "US/Michigan","zip": "530013"}

    public var address : String?
    public var city : String?
    public var country : String?
    public var state : String?
    public var timeZone : String?
    public var zip : String?
    
    public var activateSMS : Bool?
    public var smsContact : String?
    public var smsCountryCode : String?
    public var smsAreaCode : String?
    
    public var otp : String?


    public init(address: String,city: String,country: String,state: String,timeZone: String,zip: String) {
        
        self.address = address
        self.city = city
        self.country = country
        self.state = state
        self.timeZone = timeZone
        self.zip = zip
    
    }
    
    public init(activateSMS: Bool,smsContact: String,smsCountryCode: String,smsAreaCode: String) {
        self.activateSMS = activateSMS
        self.smsContact = smsContact
        self.smsCountryCode = smsCountryCode
        self.smsAreaCode = smsAreaCode
    }

    public init(type: String) {
        self.type = type
    }
    
    public init(otp: String) {
        self.otp = otp
    }
    
    public init(sameAsbilling : Bool) {
        self.sameAsBillingAddress = sameAsbilling
    }
    
    public init(socialLinks : Array<Dictionary<String,String>>) {
        self.socialLinks = socialLinks
    }
    
    public init(currentPassword : String, newPassword : String, confirmPassword : String) {
        self.currentPassword = currentPassword
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
    }
    
    
}

extension ProfileManager: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "\nProfileManager"
        description += "\n\ttype: \(String(describing: type))"
        return description
    }
}
