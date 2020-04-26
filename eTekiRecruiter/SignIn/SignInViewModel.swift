//
//  SignInViewModel.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 23/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation
import UIKit

protocol SignInModelDelegate {
    func onSignInResponse(response : SignInResponse?)
    func onOAuthLoginResponse(response : OAuthLoginResponse?)
    func onAPIException(errorResponse : ErrorResponse?)
}

struct SignInViewModel  {

    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var delegate : SignInModelDelegate?
    var authenticaionAPI: AuthenticationAPIProtocol.Type = AuthenticationApi.self


    func addImagesToTextFields() {

        emailTextField.setPlaceholderText(color: AppTheme.fieldsBorderColor)
        passwordTextField.setPlaceholderText(color: AppTheme.fieldsBorderColor)
        emailTextField.light(size: 18.0)
        passwordTextField.light(size: 18.0)
        emailTextField.placeholder = .enterEmail
        passwordTextField.placeholder = .enterPassword

    }
    
    var isValidEmail: Bool {
        guard let email = emailTextField.text else { return false}
        let isValid = emailTextField.isValidEmail(emailStr: email)
        return isValid
    }
    
    var isValidPassword: Bool {
        guard let password = passwordTextField.text else { return false}
        let isValid = passwordTextField.isValidPassword(passwordStr: password)
        return isValid
    }

    func shouldValidateCredentials() -> (Bool,String) {
        
        if isValidEmail &&  isValidPassword {
            let credentialsManager = CredentialsManager(username: self.emailTextField.text ?? "" , password: self.passwordTextField.text ?? "", applicationId: "")
                self.callAuthenticationAPI(credentialsManager: credentialsManager)

            /*
            BaseViewModel.shared.setUpReachabilty()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                // Put your code which should be executed with a delay here
                if BaseViewModel.shared.isNetworkAvailable {
                    let credentialsManager = CredentialsManager(username: self.emailTextField.text ?? "" , password: self.passwordTextField.text ?? "", applicationId: "")
                    self.callAuthenticationAPI(credentialsManager: credentialsManager)
                } else {
                    let errorResponse = ErrorResponse(responseCode: false.intValue, message: .checkYourNetwork, tittle: .checkYourNetwork)
                    self.delegate?.onAPIException(errorResponse: errorResponse)
                }
            })*/
            return (true,"")

        } else {
            var messageString = ""
            if emailTextField.text == "" {
                messageString = validationMessages.emailCantBeBlank
            } else if !isValidEmail {
                messageString = validationMessages.enterValidEmail
            } else if !isValidPassword {
                messageString = .passwordRangeMismatch
            }
            return (false,messageString)
        }
    }
}

extension SignInViewModel {
    func callAuthenticationAPI(credentialsManager : CredentialsManager) {
        authenticaionAPI.login(credentials: credentialsManager) { (signInResponse, error) in
            if error == nil {
                self.delegate?.onSignInResponse(response: signInResponse)
            } else {
                self.delegate?.onAPIException(errorResponse: error)
            }
        }
    }
    
    func callOathLogingAPI(socialSignInResponse : SocialSignInResponse) {
        authenticaionAPI.OAthLogin(credentials: socialSignInResponse) { (oathResponse, error) in
            if error == nil {
                self.delegate?.onOAuthLoginResponse(response: oathResponse)
            } else {
                self.delegate?.onAPIException(errorResponse: error)
            }
        }
    }

}
