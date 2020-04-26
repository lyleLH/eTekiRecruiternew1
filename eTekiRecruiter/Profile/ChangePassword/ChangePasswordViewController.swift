//
//  ChangePasswordViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 11/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController, ChangePasswordViewModelDelegate {

    @IBOutlet weak var oldpwdIcon: UIImageView!
    @IBOutlet weak var newpwdIcon: UIImageView!

    @IBOutlet weak var confirmpwdIcon: UIImageView!

    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    var viewModel = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateEventLogToAnalytics(eventName: "Reset Password Event", status: "True")
        let customfont = UIFont.appLightFontWith(size: 18.0)
        oldPassword.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "OLD_PASSWORD".localized , color: AppTheme.placeHolderColor)
        newPassword.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "NEW_PASSWORD".localized , color: AppTheme.placeHolderColor)
        confirmPassword.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: "CONFIRM_PASSWORD".localized , color: AppTheme.placeHolderColor)
        bindViewModel()
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
    }
    
    func bindViewModel() {
        viewModel.delegate = self
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateAPI(_ sender: Any) {
        
        if oldPassword.text == "" {
            oldPassword.text = ""
            oldPassword.becomeFirstResponder()
            self.showValidationMesssage(message: "OLD_PASSWORD_VALIDATION".localized)
            return
        } else  if newPassword.text == "" {
            newPassword.text = ""
            newPassword.becomeFirstResponder()
            self.showValidationMesssage(message: "NEW_PASSWORD_VALIDATION".localized)
            return
        } else  if confirmPassword.text == "" {
            confirmPassword.text = ""
            confirmPassword.becomeFirstResponder()
            self.showValidationMesssage(message: "CONFIRM_PASSWORD_VALIDATION".localized)
            return
        }
        
        
        if !oldPassword.isValidPassword(passwordStr: oldPassword.text ?? "") {
            oldPassword.text = ""
            oldPassword.becomeFirstResponder()
            self.showValidationMesssage(message: "OLD_PASSWORD_8CHAR".localized)
            
        } else if !newPassword.isValidPassword(passwordStr: newPassword.text ?? "") {
            newPassword.text = ""
            newPassword.becomeFirstResponder()
            self.showValidationMesssage(message: "NEW_PASSWORD_8CHAR".localized)

        } else  if !confirmPassword.isValidPassword(passwordStr: confirmPassword.text ?? "") {
            confirmPassword.text = ""
            confirmPassword.becomeFirstResponder()
            self.showValidationMesssage(message: "CONFIRM_PASSWORD_8CHAR".localized)

        } else {

            
            if newPassword.text != confirmPassword.text {
                self.showValidationMesssage(message: "NEW_CONFIRM_NOTSAME".localized)

                confirmPassword.text = ""
                confirmPassword.becomeFirstResponder()
                return
            } else if newPassword.text == oldPassword.text {
                self.showValidationMesssage(message: "OLD_CONFIRM_NOTSAME".localized)
                newPassword.text = ""
                newPassword.becomeFirstResponder()
                return
            } else {
                
                if newPassword.isValidPassword(passwordStr: newPassword.text ?? "") && confirmPassword.isValidPassword(passwordStr: confirmPassword.text ?? ""){
                    DispatchQueue.main.async {
                        self.showSpinner()
                    }
                    
                    let profileManger = ProfileManager(currentPassword: self.oldPassword.text ?? "", newPassword: self.newPassword.text ?? "", confirmPassword: self.confirmPassword.text ?? "")
                    self.viewModel.updatePassword(profileManager: profileManger)
                    
                } else {
                    DispatchQueue.main.async {
                        if !self.oldPassword.isValidPassword(passwordStr: self.oldPassword.text ?? "") {
                            self.showValidationMesssage(message: "OLD_PASSWORD_8CHAR".localized)
                        } else if (!self.newPassword.isValidPassword(passwordStr: self.newPassword.text ?? "")) {
                            self.showValidationMesssage(message: "NEW_PASSWORD_8CHAR".localized)
                        }else {
                            self.showValidationMesssage(message: "CONFIRM_PASSWORD_8CHAR".localized)
                        }

                    }
                    newPassword.text = ""
                    newPassword.becomeFirstResponder()
                    return

                }
            }
            
        }

    }
    
    func showValidationMesssage(message : String) {
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: message, style: .danger)
        }
    }

    @IBAction func oldPasswordToggleAction(_ sender: Any) {

        self.oldPassword.isSecureTextEntry = !self.oldPassword.isSecureTextEntry
        if self.oldPassword.isSecureTextEntry {
            self.oldpwdIcon.image = UIImage(named: "password_show")
        } else {
            self.oldpwdIcon.image = UIImage(named: "password_hide")
        }
    }

    @IBAction func newPasswordToggleAction(_ sender: Any) {

        self.newPassword.isSecureTextEntry = !self.newPassword.isSecureTextEntry
        if self.newPassword.isSecureTextEntry {
            self.newpwdIcon.image = UIImage(named: "password_show")
        } else {
            self.newpwdIcon.image = UIImage(named: "password_hide")
        }
    }

    @IBAction func confirmPasswordToggleAction(_ sender: Any) {

        self.confirmPassword.isSecureTextEntry = !self.confirmPassword.isSecureTextEntry
        if self.confirmPassword.isSecureTextEntry {
            self.confirmpwdIcon.image = UIImage(named: "password_show")
        } else {
            self.confirmpwdIcon.image = UIImage(named: "password_hide")
        }
    }



}

extension ChangePasswordViewController {
    
    func onGetProfileResponse(response: ProfileResponse?) {
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: response?.message ?? "PROFILE_UPDATED".localized, style: .success)
            self.removeSpinner()
            self.resetValues()
        }
    }
    
    func onAPIException(errorResponse: ErrorResponse?) {
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: errorResponse?.message ?? "UNKOWN_SERVER_ERROR".localized, style: .danger)

            self.removeSpinner()
            self.resetValues()
            self.oldPassword.becomeFirstResponder()

        }
    }
    
    func resetValues() {
        self.oldPassword.text = ""
        self.newPassword.text = ""
        self.confirmPassword.text = ""

    }
    
}
