//
//  AddressViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 11/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class AddressViewController: BaseViewController {
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var downArrowState: UIImageView!
    @IBOutlet weak var stateDropDown: UIButton!
    @IBOutlet weak var timezoneField: PaddingTextField!
    @IBOutlet weak var address1TextField: PaddingTextField!
    @IBOutlet weak var cityTextField: PaddingTextField!
    @IBOutlet weak var zipcodeTextField: PaddingTextField!
    
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
    
    @IBOutlet weak var stateTextField: PaddingTextField!
    
    // let ACCEPTABLE_CHARACTERS = "0123456789"
    let ACCEPTABLECHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let AVOIDSPACE = " "
    
    
    var viewModel = AddressViewModel()
    
    var selectedTimeZoneCode = ""
    
    @IBOutlet weak var countryTextField: PaddingTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeZone(notfication:)), name: Notification.Name("SearchTimeZones"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStates(notfication:)), name: Notification.Name("StateSearch"), object: nil)
        
        
        downArrowState.isHidden = true
        stateDropDown.isHidden = true
        
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: false)
        
        self.bindViewModel()
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateStates(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            
            if let selectedState = info["selectedState"] as? String {
                self.stateTextField.text = selectedState
            }else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
    }
    
    @objc func updateTimeZone(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let searchData = info["timezone"] as? Dictionary<String,String> {
                print(searchData)
                for (key,value) in searchData {
                    self.timezoneField.text = value
                    self.selectedTimeZoneCode = key
                }
                
            }else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
    }
    
    func bindViewModel() {
        
        viewModel.countryTextField = self.countryTextField
        viewModel.address1TextField = self.address1TextField
        viewModel.timezoneField = self.timezoneField
        viewModel.cityTextField = self.cityTextField
        viewModel.zipcodeTextField = self.zipcodeTextField
        viewModel.stateTextField = self.stateTextField
        viewModel.setFontsForTextFields()
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        self.profileAPI.getProfileDetails(profileManager: ProfileManager(type: Profile.addressDetails)) { (response, errorResponse) in
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else  {
                DispatchQueue.main.async {
                    self.countryTextField.text = response?.country
                    if self.countryTextField.text == "United States of America" {
                        self.stateDropDown.isHidden = false
                        self.downArrowState.isHidden = false
                        self.stateView.bringSubviewToFront(self.stateDropDown)
                        self.stateView.bringSubviewToFront(self.downArrowState)
                    } else {
                        self.stateDropDown.isHidden = true
                        self.stateView.bringSubviewToFront(self.stateTextField)
                        self.downArrowState.isHidden = true
                    }
                    self.address1TextField.text = response?.address1
                    self.stateTextField.text = response?.state
                    self.cityTextField.text = response?.city
                    self.zipcodeTextField.text = response?.zip
                    self.timezoneField.text = response?.timeZone
                    self.removeSpinner()
                }
            }
        }
    }
    
    
    @IBAction func selectCountry(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCountry(notfication:)), name: Notification.Name("CountriesSearch"), object: nil)
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.addressToCountriesSearch, sender: self)
    }
    
    @objc func updateCountry(notfication: NSNotification) {
        
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            DispatchQueue.main.async {
            if let selectedCountry = info["selectedCountry"] as? String {
                
                self.stateTextField.text = ""
                self.countryTextField.text = selectedCountry
                if selectedCountry == "United States of America" {
                    self.stateDropDown.isHidden = false
                    self.stateView.bringSubviewToFront(self.stateDropDown)
                    self.stateView.bringSubviewToFront(self.downArrowState)
                    self.downArrowState.isHidden = false
                } else {
                    self.stateDropDown.isHidden = true
                    self.stateView.bringSubviewToFront(self.stateTextField)
                    self.downArrowState.isHidden = true
                }
                
            }else {
                print("no value for key\n")
            }
            
        }
        }
        else {
            print("wrong userInfo type")
        }
        
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CountriesSearch"), object: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let navVC = segue.destination as? UINavigationController
        
        let searchVc = navVC?.viewControllers.first as? SearchViewController
        
        if segue.identifier == "StateToSearch" {
            searchVc?.currentSearch = "StateToSearch"
        }else if segue.identifier == StoryboardSegueIdentifiers.addressToCountriesSearch {
            searchVc?.currentSearch = StoryboardSegueIdentifiers.createJobToCountrySearch
        }  else if segue.identifier == "TimeZoneToSearch" {
            searchVc?.currentSearch = "SearchTimeZones"
            searchVc?.selectedItem = self.timezoneField.text ?? ""
        }
    }
    
    @IBAction func updateAction(_ sender: Any) {
                
        if timezoneField.text?.trimSpace(str: timezoneField.text ?? "") == "" {
            showValidation(textField: timezoneField, currentField: "Time Zone")
        } else if countryTextField.text?.trimSpace(str: countryTextField.text ?? "") == "" {
            showValidation(textField: countryTextField, currentField: "Country")
        } else {
            
            self.showSpinner()
            let timezonekeys = LocalCountry.timezoneList
            for timezoneDict in timezonekeys {
                for (key,value) in timezoneDict {
                    
                    if value == self.timezoneField.text {
                        print("==========key============\(key)")
                        print("==========value============\(value)")
                        self.selectedTimeZoneCode = key
                    }
                }
            }
            
            print("")
            
            var countryText = countryTextField.text ?? ""
            if countryText == "Andorra" {
                countryText = "Andorre"
            }
            
            let profileManager = ProfileManager(address: address1TextField.text ?? "", city: cityTextField.text ?? "", country: countryText, state: stateTextField.text ?? "", timeZone: self.selectedTimeZoneCode, zip: zipcodeTextField.text ?? "")
            
            self.profileAPI.updateAddress(profileManager: profileManager) { (response, errorResponse) in
                if errorResponse != nil {
                    self.generateEventLogToAnalytics(eventName: "Update Address Event", status: "False")
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    self.generateEventLogToAnalytics(eventName: "Update Address Event", status: "True")

                    DispatchQueue.main.async {
                        self.showBanner(title: "", withMessage: .addressUpdated, style: .success)
                        self.removeSpinner()
                    }
                }
            }
        }
        
    }
    
    func showValidation(textField : UITextField,currentField : String) {
        self.showBanner(title: "", withMessage: "\(currentField) is mandatory.", style: .warning)
        textField.text = ""
        textField.becomeFirstResponder()
        
    }
    
}

extension AddressViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == zipcodeTextField {
            let invertedSet = CharacterSet(charactersIn: ACCEPTABLECHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: invertedSet) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        } else {
            textField.text = textField.text?.replacingOccurrences(of: " ", with: "")
            return true
        }
        
    }
}
