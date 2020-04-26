//
//  VerificationViewController.swift
//  eTekiTrainingApp
//
//  Created by Afreen on 12/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import KWVerificationCodeView
class VerificationViewController: BaseViewController,VerificationViewModelDelegate {
    
    @IBOutlet var otpView: KWVerificationCodeView!
    @IBOutlet var resendOtpButton: UIButton!
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var verificationView: UIView!
    
    @IBOutlet weak var verificationLabel: UILabel!
    var profileResponse : ProfileResponse?
    var errorResponse : ErrorResponse?

    
    var viewModel = VerificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        verificationView.layer.borderWidth = 1
        verificationView.layer.cornerRadius = 5
        verificationView.layer.borderColor = UIColor.init(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1).cgColor
        
        otpView.underlineColor = AppTheme.fieldsBorderColor
        otpView.underlineSelectedColor = AppTheme.fieldsBorderColor
        
        otpView.keyboardType = .numberPad
        // Do any additional setup after loading the view.
        viewModel.delegate = self
        
        let attributedString = NSMutableAttributedString(string: .otpScreenDisplayMessage)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
           verificationLabel.attributedText = attributedString

        verifyButton.bold(size: 18.0)
        resendOtpButton.bold(size: 14.0)
        otpView.textFont = APPFonts.boldFont
        otpView.tintColor = AppTheme.textColor
        otpView.textSize = 20.0
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func verifyAction(_ sender: Any) {
        
        let isValid = otpView.hasValidCode()
        if isValid {
            let otp = otpView.getVerificationCode()
            self.showSpinner()
            let profileManager = ProfileManager(otp: otp)
            viewModel.verifyOTP(profileManager: profileManager, requestType: "VerifyOTP")
        } else {
            self.showBanner(title: "", withMessage: "OTP_CANT_BLANK".localized, style: .warning)
        }
    }
    
    @IBAction func resendOTPAction(_ sender: Any) {
            self.showSpinner()
            viewModel.resendOTP(requestType: "ResendOTP")
    }
}

extension VerificationViewController {
    
    func onGetProfileResponse(response: ProfileResponse?, requestType: String) {
        
        if requestType == "VerifyOTP" {
            
            DispatchQueue.main.async {
                if response?.success ?? false {
                    self.showBanner(title: "", withMessage: response?.message ?? "PROFILE_UPDATED".localized, style: .success)
                    self.otpView.clear()
                    self.dismiss(animated: false, completion: nil)
                }
                self.removeSpinner()
                
            }
            
        } else if requestType == "ResendOTP" {
            DispatchQueue.main.async {
                if response?.success ?? false {
                    self.showBanner(title: "", withMessage: response?.message ?? "PROFILE_UPDATED".localized, style: .success)
                    self.otpView.clear()
                }
                self.removeSpinner()
            }
            
        }
    }
    
    func onAPIException(errorResponse: ErrorResponse?, requestType: String) {
        
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: errorResponse?.message ?? "Server Error", style: .warning)
            self.removeSpinner()
            self.otpView.clear()
        }
    }
    
}

