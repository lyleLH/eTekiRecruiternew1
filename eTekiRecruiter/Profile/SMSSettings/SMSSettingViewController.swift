//
//  SMSSettingViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 11/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import DLRadioButton
import DropDown
import NotificationBannerSwift

class SMSSettingViewController: BaseViewController,SMSViewModelDelegate {
    
    @IBOutlet weak var smsButton: DLRadioButton!
    @IBOutlet weak var emailButton: DLRadioButton!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var contactView: UIView!
    
    
    var activateSMS = false
    
    var currentSelectedContact = ""
    var previouseSelectedContact = ""
    
    var contactsArray = Array<String>()
    
  
    var isSMSSelected: Bool = false
    var isEmailSelected: Bool = false
    
    @IBOutlet weak var contactField: UITextField!

    let dropDown = DropDown()
    let appearance = DropDown.appearance()
    
    var viewModel = SMSViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownsetUp()

        self.smsButton.layer.borderWidth = 0.5
        self.smsButton.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        self.smsButton.layer.cornerRadius = 10
        self.emailButton.layer.borderWidth = 0.5
        self.emailButton.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        self.emailButton.layer.cornerRadius = 10
        contactView.isHidden = true
        bindViewModel()
        setupDropdown()
        self.emailLabel.light(size: 18.0)
        self.smsLabel.light(size: 18.0)
        self.emailButton.isSelected = true
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
    }
    
    func bindViewModel() {
        viewModel.delegate = self
        self.showSpinner()
        let profileManager = ProfileManager(type: Profile.smsSettings)
        viewModel.getSMSSettings(profileManager: profileManager, requestType: "GetSMSSetting")
        
    }
    
    func dropDownsetUp(){
        
        dropDown.direction = .bottom
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
    }
    
    func setupDropdown() {
       // dropDown.dataSource = ["Primary Contact (+91) 9999991234", "Secondary Contact (+91) 9999991234"]
        dropDown.anchorView = contactView
        dropDown.bottomOffset = CGPoint(x: 0, y: 45)
        dropDown.topOffset = CGPoint(x: 45 ,y: 0)
        dropDown.customCellConfiguration = {(index, text, cell) in
                cell.backgroundColor = AppTheme.appBackgroundColor
                cell.optionLabel.font = UIFont.appLightFontWith(size: 18.0)
            }
    }
    
    @IBAction func subscribeSMSAction(_ sender: Any) {
        self.emailButton.iconColor = AppTheme.fieldsBorderColor
        self.smsButton.iconColor = AppTheme.appBackgroundColor
        self.contactField.text = previouseSelectedContact // Known Issue
        contactView.isHidden = false
        self.activateSMS = true
    }
    
    @IBAction func subscribeEmailAction(_ sender: Any) {
        self.smsButton.iconColor = AppTheme.fieldsBorderColor
        self.emailButton.iconColor = AppTheme.appBackgroundColor
        self.contactField.text = ""
        contactView.isHidden = true
        self.activateSMS = false
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateContactAction(_ sender: Any) {
                
        dropDown.show()
        dropDown.selectionAction = { (index , item ) in
            let selectedItem = item
            self.contactField.text = selectedItem
        }

    }
    
    @IBAction func updateAction(_ sender: Any) {
                
        currentSelectedContact = contactField.text ?? ""
        
        if currentSelectedContact != "" {
            
            stripContactAndUpdateAPI(contact: currentSelectedContact)
            
        } else {
            
            if smsButton.isSelected {
                self.showBanner(title: "", withMessage: "Please select the contact before subscribing the SMS.", style: .warning)
            } else {
                
                self.showSpinner()
                let profileManager = ProfileManager(activateSMS: activateSMS, smsContact: "", smsCountryCode: "", smsAreaCode: "")
                viewModel.updateSMSSettings(profileManager: profileManager, requestType: "UpdateSMSSettings")
                
            }
        }

    }
    
    func stripContactAndUpdateAPI(contact : String) {
        
        if contact != "" {
            let contactArray = contact.components(separatedBy: " ")
            let areaCode = contactArray[0].stripped.lowercased()
            let countryCode = contactArray[1].stripped.lowercased()
            let smsContact = contactArray[2].stripped.lowercased()
            self.showSpinner()
            let profileManager = ProfileManager(activateSMS: activateSMS, smsContact: smsContact, smsCountryCode: countryCode, smsAreaCode: areaCode)
            viewModel.updateSMSSettings(profileManager: profileManager, requestType: "UpdateSMSSettings")

        } else {
            print("Contact not selected.")
        }
        
    }
    
}

extension SMSSettingViewController {
    
    func onGetProfileResponse(response: ProfileResponse?, requestType: String) {
        
        if requestType == "GetSMSSetting" {
            
          
            DispatchQueue.main.async {
                
                guard let contact1 = response?.contact1 else {return}
                guard let contact2 = response?.contact2 else {return}
                
                guard let countryCode1 = response?.countryCode1 else {return}
                guard let countryCode2 = response?.countryCode2 else {return}
                
                guard let areaCode1 = response?.areaCode1 else {return}
                guard let areaCode2 = response?.areaCode2 else {return}
                
                var countryContact1 = ""
                var countryContact2 = ""

                if contact1 != "" && areaCode1 != "" && countryCode1 != "" {
                    countryContact1 = "\(areaCode1.uppercased()): " + "(+\(countryCode1)) " + contact1
                    self.dropDown.dataSource.append(countryContact1)
                    self.contactsArray.append(countryContact1)
                
                }
                
                if contact2 != "" && areaCode2 != "" && countryCode2 != "" {
                    countryContact2 = "\(areaCode2.uppercased()): " + "(+\(countryCode2)) " + contact2
                    //self.dropDown.dataSource.append(countryContact2)
                   // self.contactsArray.append(countryContact2)

                }
                print(self.contactsArray)
                
                if response?.smsservice ?? false {
                    self.smsButton.isSelected = true
                    self.contactView.isHidden = false
                    self.activateSMS = true
                }
                
                
                guard let smsContact = response?.smsContact else {return}
                guard let smsCountryCode = response?.smsCountrycode else {return}
                guard let smsAreaCode = response?.smsAreaCode else {return}
                
                if smsContact != "" && smsAreaCode != "" && smsCountryCode != "" {
                    
                    let selectedContact = "\(smsAreaCode.uppercased()): " + "(+\(smsCountryCode)) " + smsContact
                    self.previouseSelectedContact = selectedContact
                    self.contactField.text = selectedContact
                    
                    self.dropDown.dataSource.append(selectedContact)
                    self.contactsArray.append(selectedContact)
                
                    if response?.usSMSService ?? false {
                        let banner = GrowingNotificationBanner(title: "", subtitle: .usSMSAlertMessage, style: .warning)
                        banner.show()
                        banner.duration = 4.0
                       // banner.remove()
                    }
                }
                
                self.dropDown.reloadAllComponents()
                self.removeSpinner()
            }
            
        } else if requestType == "UpdateSMSSettings" {
            
            DispatchQueue.main.async {
                
                if response?.otpRequired ?? false {
                    self.performSegue(withIdentifier: "SMSSettingsToOTPScreen", sender: nil)
                    self.showBanner(title: "", withMessage: response?.message ?? "PROFILE_UPDATED".localized, style: .success)

                } else {
                    print("OTP Not required")
                    
                    if self.smsButton.isSelected {
                        let banner = GrowingNotificationBanner(title: "", subtitle: .usSMSAlertMessage, style: .warning)
                        banner.show()
                        banner.duration = 4.0

                    } else {
                        self.showBanner(title: "", withMessage: response?.message ?? "PROFILE_UPDATED".localized, style: .success)
                    }
                    
                }
                
                self.removeSpinner()
                
            }
        }
    }
    
    func onAPIException(errorResponse: ErrorResponse?, requestType: String) {
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: errorResponse?.message ?? "Server Error", style: .warning)
            self.removeSpinner()
            
        }
    }
    
}
