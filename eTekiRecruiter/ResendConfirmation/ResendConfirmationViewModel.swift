//
//  ResendConfirmationViewModel.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 05/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol ResendResendConfirmationViewModelDelegate {
    func onResendConfirmationResponse(response : ForgotPasswordResponse?)
    func onAPIException(errorResponse : ErrorResponse?)
}

struct ResendConfirmationViewModel  {
    
    var emailTextField = UITextField()
    var backToLogin = UIButton()
    var resetButton = UIButton()
    
    var delegate : ResendResendConfirmationViewModelDelegate?
    var authenticaionAPI: AuthenticationAPIProtocol.Type = AuthenticationApi.self

    func addImagesToTextFields() {
        emailTextField.withImage(direction: .left, image: UIImage(named: "email") ?? UIImage(), colorSeparator: .clear, colorBorder:  .clear)
        emailTextField.layer.borderWidth = 1
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        
        backToLogin.layer.borderWidth = 1
        backToLogin.clipsToBounds = true
        backToLogin.layer.cornerRadius = 5
        
    }
    
    var isValidEmail: Bool {
        guard let email = emailTextField.text else { return false}
        let isValid = emailTextField.isValidEmail(emailStr: email)
        return isValid
    }
    
    func shouldValidateCredentials() -> (Bool,String) {
        if isValidEmail {
            
            BaseViewModel.shared.setUpReachabilty()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                // Put your code which should be executed with a delay here
                
                if BaseViewModel.shared.isNetworkAvailable {
                    
                    //call API Here
                    let credentialsManager = CredentialsManager(username: self.emailTextField.text ?? "" , password: "", applicationId: "")
                    self.callResendConfirmationAPI(credentialsManager: credentialsManager)
                    
                } else {
                    let errorResponse = ErrorResponse(responseCode: false.intValue, message: .checkYourNetwork, tittle: .checkYourNetwork)
                    self.delegate?.onAPIException(errorResponse: errorResponse)
                }
                
            })
            return (true,"")
            
        } else {
            var messageString = ""
            if emailTextField.text == ""{
                messageString = validationMessages.emailCantBeBlank
            } else if !isValidEmail {
                messageString = validationMessages.enterValidEmail
            }
            return (false,messageString)
        }
    }
    
}

extension ResendConfirmationViewModel {
    func callResendConfirmationAPI(credentialsManager : CredentialsManager) {
        authenticaionAPI.resendConfirmation(credentials: credentialsManager) { (forgotPasswordResponse, error) in
            if error == nil {
                self.delegate?.onResendConfirmationResponse(response: forgotPasswordResponse)
            } else {
                self.delegate?.onAPIException(errorResponse: error)
            }
        }
    }
}

