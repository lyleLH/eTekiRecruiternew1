//
//  ProfileResponse.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

public struct ProfileResponse: Codable {
    public var alternateEmail : String? = .alternateEmail
    public var firstName : String? = .firstName
    public var lastName : String? = .lastName
    public var displayName : String? = .displayName
    
    public var email : String? = .email
    public var phoneNumber : String? = .phoneNumber
    public var alternatePhoneNumber : String? = .alternatePhoneNumber
    
    public var twitter : String? = ""
    public var googlePlus : String? = ""
    public var facebook : String? = ""
    public var linkedIn : String? = ""
    
    public var message: String?
    public var currentPasscode : String?
    
    //Address Details Response identifiers
    public var address1 : String? = ""
    public var address2 : String? = ""
    public var city : String? = ""
    public var country : String? = ""
    public var state : String? = ""
    public var timeZone : String? = ""
    public var zip : String? = ""
    
    
    
    public var companyName : String? = ""
    public var website : String? = ""
    public var sameAsBillingAddress : Bool? = false

    
    public var contact1 : String? = ""
    public var contact2 : String? = ""
    
    public var areaCode1 : String? = ""
    public var areaCode2 : String? = ""
    
    public var countryCode1 : String? = ""
    public var countryCode2 : String? = ""

    public var success : Bool?
    public var smsservice : Bool?
    public var usSMSService : Bool?

    public var otpRequired : Bool?
    
    public var smsContact : String?
    public var smsAreaCode : String?
    public var smsCountrycode : String?
    
    public var idRequired : Bool?

}

extension ProfileResponse {
    
    init(json: [String: Any],success : Bool,message : String) {
        self.success = success
        self.message = message
        
        if let otpRequired : Bool = json["otp_required"] as? Bool{
            print("otpRequired: \(otpRequired)")
            self.otpRequired = otpRequired
        } else {
            self.otpRequired = false
        }
        
        
        if let smsDetails = json["sms_settings"] as? [String : Any] {
            
            if let smsService : Bool = smsDetails["sms_service"] as? Bool{
                print("smsService: \(smsService)")
                self.smsservice = smsService
            } else {
                self.smsservice = false
            }
            
            if let usSMSService : Bool = smsDetails["sms_alert_for_user"] as? Bool{
                print("usSMSService: \(usSMSService)")
                self.usSMSService = usSMSService
            } else {
                self.usSMSService = false
            }
            
            
            
            if let smsContact : String = smsDetails["sms_contact"] as? String{
                print("smsContact: \(smsContact)")
                self.smsContact = smsContact
            } else {
                self.smsContact = ""
            }
            
            
            if let smsAreaCode : String = smsDetails["sms_area_code"] as? String{
                print("smsAreaCode: \(smsAreaCode)")
                self.smsAreaCode = smsAreaCode
            } else {
                self.smsAreaCode = ""
            }
            
            if let smsCountrycode : String = smsDetails["sms_country_code"] as? String{
                print("smsCountrycode: \(smsCountrycode)")
                self.smsCountrycode = smsCountrycode
            } else {
                self.smsCountrycode = ""
            }
            
            
            if let contact2 : String = smsDetails["contact2"] as? String{
                print("contact2: \(contact2)")
                self.contact2 = contact2
            } else {
                self.contact2 = ""
            }
            
            if let contact1 : String = smsDetails["contact1"] as? String{
                print("contact1: \(contact1)")
                self.contact1 = contact1
            } else {
                self.contact1 = ""
            }
            
            
            if let areaCode1 : String = smsDetails["area_code1"] as? String{
                print("areaCode1: \(areaCode1)")
                self.areaCode1 = areaCode1
            } else {
                self.areaCode1 = ""
            }
            
            if let areaCode2 : String = smsDetails["area_code2"] as? String{
                print("areaCode2: \(areaCode2)")
                self.areaCode2 = areaCode2
            } else {
                self.areaCode2 = ""
            }
            
            
            if let countryCode1 : String = smsDetails["country_code1"] as? String{
                print("country_code1: \(countryCode1)")
                self.countryCode1 = countryCode1
            } else {
                self.countryCode1 = ""
            }
            
            if let countryCode2 : String = smsDetails["country_code2"] as? String{
                print("country_code2: \(countryCode2)")
                self.countryCode2 = countryCode2
            } else {
                self.countryCode2 = ""
            }
            
            
        } else {
            print("Parsing failed for SMS Setting")
            
        }
        
        
        if let companyDetails = json["company_details"] as? [String : Any] {
            
            if let email : String = companyDetails["email"] as? String {
                print("email: \(email)")
                self.email = email
            } else {
                self.email = .email
            }
            
            if let idRequired : Bool = companyDetails["id_required"] as? Bool {
                           print("idRequired: \(idRequired)")
                           self.idRequired = idRequired
                } else {
                           self.idRequired = false
                }

            
            
            if let contact2 : String = companyDetails["contact2"] as? String{
                print("contact2: \(contact2)")
                self.contact2 = contact2
            } else {
                self.contact2 = ""
            }
            
           if let sameAsBillingAddress = companyDetails["same_as_billing_address"] as? Bool {
              print("sameAsBillingAddress: \(sameAsBillingAddress)")
                self.sameAsBillingAddress = sameAsBillingAddress
            }

            if let contact1 : String = companyDetails["contact1"] as? String{
                print("contact1: \(contact1)")
                self.contact1 = contact1
            } else {
                self.contact1 = ""
            }
            
            
            if let website : String = companyDetails["website"] as? String{
                print("website: \(website)")
                self.website = website
            } else {
                self.website = ""
            }
            
            if let companyName : String = companyDetails["name"] as? String{
                print("companyName: \(companyName)")
                self.companyName = companyName.trimSpace(str: companyName)
            } else {
                self.companyName = ""
            }
            
            if let address1 : String = companyDetails["address1"] as? String{
                print("address1: \(address1)")
                self.address1 = address1.trimSpace(str: address1)
            } else {
                self.address1 = ""
            }
            
            
            if let address2 : String = companyDetails["address2"] as? String{
                print("address2: \(address2)")
                self.address2 = address2.trimSpace(str: address2)
            } else {
                self.address2 = ""
            }
            
            if let city : String = companyDetails["city"] as? String{
                print("city: \(city)")
                self.city = city.trimSpace(str: city)
            } else {
                self.city = ""
            }
            
            
            if let country : String = companyDetails["country"] as? String{
                print("country: \(country)")
                self.country = country
            } else {
                self.country = ""
            }
            
            if let state : String = companyDetails["state"] as? String{
                print("state: \(state)")
                self.state = state
            } else {
                self.state = ""
            }
            
            if let timeZone : String = companyDetails["time_zone"] as? String{
                print("time_zone: \(timeZone)")
                self.timeZone = timeZone
            } else {
                self.timeZone = ""
            }
            
            if let zip : String = companyDetails["zip"] as? String{
                print("zip: \(zip)")
                self.zip = zip
            } else {
                self.zip = ""
            }
            
        } else {
            print("Parsing failed for Company details")
            
        }

   
        if let addresss = json["address"] as? [String : Any] {
            
            if let address1 : String = addresss["address"] as? String{
                print("address: \(address1)")
                self.address1 = address1.trimSpace(str: address1)
            } else {
                self.address1 = ""
            }
            
            
            if let address2 : String = addresss["address2"] as? String{
                print("address2: \(address2)")
                self.address2 = address2.trimSpace(str: address2)
            } else {
                self.address2 = ""
            }
            
            if let city : String = addresss["city"] as? String{
                print("city: \(city)")
                self.city = city.trimSpace(str: city)
            } else {
                self.city = ""
            }
            
            
            if let country : String = addresss["country"] as? String{
                print("country: \(country)")
                self.country = country.trimSpace(str: country)
            } else {
                self.country = ""
            }
            
            if let state : String = addresss["state"] as? String{
                print("state: \(state)")
                self.state = state.trimSpace(str: state)
            } else {
                self.state = ""
            }
            
            if let timeZone : String = addresss["time_zone"] as? String{
                print("time_zone: \(timeZone)")
                
                
                let timezonekeys = LocalCountry.timezoneList
                
                for timezoneDict in timezonekeys {
                    for (key,value) in timezoneDict {
                        
                        if key == timeZone {
                            self.timeZone = value
//                            print("==========key============\(key)")
//                            print("==========value============\(value)")
                        }
                    }
                }
            } else {
                self.timeZone = ""
            }

            
            if let zip : String = addresss["zip"] as? String{
                print("zip: \(zip)")
                self.zip = zip.trimSpace(str: zip)
            } else {
                self.zip = ""
            }

        } else {
            print("Parsing failed for address")

        }
        
        if let currentCode = json["report_passcode"] as? String {
            self.currentPasscode = currentCode
        } else {
            print("Parsing failed for Passcode")

        }
        
        if let primaryInfo = json["primary_information"] as? [String : Any] {
            
            if let alternateEmail : String = primaryInfo["alternate_email"] as? String {
                print("alternateEmail: \(alternateEmail)")
                self.alternateEmail = alternateEmail
            } else {
                self.alternateEmail = ""

            }
            
            if let firstName : String = primaryInfo["first_name"] as? String {
                print("firstName: \(firstName)")
                self.firstName = firstName
            } else {
                self.firstName = ""
            }
            
            if let lastName : String = primaryInfo["last_name"] as? String {
                print("last_name: \(lastName)")
                self.lastName = lastName
            } else {
                self.lastName = ""

            }
            
            if let displayName : String = primaryInfo["display_name"] as? String {
                print("displayName: \(displayName)")
                self.displayName = displayName
            } else {
                self.displayName = ""
            }
            
            if let email : String = primaryInfo["email"] as? String {
                print("email: \(email)")
                self.email = email
            } else {
                self.email = ""
            }
            
            if let phoneNumber : String = primaryInfo["contact1"] as? String {
                print("phoneNumber: \(phoneNumber)")
                self.phoneNumber = phoneNumber
            } else {
                self.phoneNumber =  ""

            }
            
            if let alternatePhoneNumber : String = primaryInfo["contact2"] as? String {
                print("alternatePhoneNumber: \(alternatePhoneNumber)")
                self.alternatePhoneNumber = alternatePhoneNumber
            } else {
                self.alternatePhoneNumber = ""

            }
//
            if let areaCode1 : String = primaryInfo["area_code_one"] as? String {
                print("araeCode1: \(areaCode1)")
                self.areaCode1 = areaCode1
            } else {
                self.areaCode1 =  ""

            }
            
            if let areaCode2 : String = primaryInfo["area_code_two"] as? String {
                print("araeCode1: \(areaCode2)")
                self.areaCode2 = areaCode2
            } else {
                self.areaCode2 =  ""

            }
            
            if let linkedIn : String = primaryInfo["linkedin"] as? String {
                print("linkedIn: \(linkedIn)")
                self.linkedIn = linkedIn
            } else {
                self.linkedIn = ""

            }

            
            if let socialLinks = primaryInfo["social_links"] as? Array<Dictionary<String,Any>> {
                
                for socialLink in socialLinks {
                    
                    if let domainName = socialLink["domain_name"] as? String {
                        /*    if domainName == "linkedin" {
                                                
                                                self.linkedIn = socialLink["url"] as? String ?? ""
                                                
                                            } else*/
                     if domainName == "facebook" {
                            
                            self.facebook = socialLink["url"] as? String ?? ""
                            
                        } else if domainName == "googleplus" {
                            
                            self.googlePlus = socialLink["url"] as? String ?? ""
                            
                        } else if domainName == "twitter" {
                            self.twitter = socialLink["url"] as? String ?? ""
                        }
                    }
                }
                
            } else {
                print("Parsing failed for Social Links")

            }

        } else {
            print("Parsing failed for primary_information")
        }

    }
      
}

extension String {
    
    func trimSpace(str : String) -> String {
        let trimmedString = str.trimmingCharacters(in: .whitespaces)
        if trimmedString == "" {
            return ""
        } else {
            return str
        }
    }
    
}
