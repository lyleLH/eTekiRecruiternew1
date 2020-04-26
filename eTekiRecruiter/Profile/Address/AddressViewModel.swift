//
//  AddressViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 13/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//


import Foundation
import UIKit

struct AddressViewModel  {
    
    var countryTextField: PaddingTextField!
    var timezoneField: PaddingTextField!
    var address1TextField: PaddingTextField!
    var address2TextField: PaddingTextField!
    var cityTextField: PaddingTextField!
    var zipcodeTextField: PaddingTextField!
    var stateTextField: PaddingTextField!
    
    
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
    
    func setFontsForTextFields() {
        let customfont = UIFont.appLightFontWith(size: 18.0)
        countryTextField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "Select Country*" , color: AppTheme.placeHolderColor)
        timezoneField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "Time Zone*" , color: AppTheme.placeHolderColor)
        address1TextField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "Address" , color: AppTheme.placeHolderColor)
        cityTextField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "City" , color: AppTheme.placeHolderColor)
        zipcodeTextField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "ZIP Code" , color: AppTheme.placeHolderColor)
        stateTextField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "State" , color: AppTheme.placeHolderColor)
    }
}
