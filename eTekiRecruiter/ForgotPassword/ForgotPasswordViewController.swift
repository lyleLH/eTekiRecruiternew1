//
//  ForgotPasswordViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 18/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController,ForgotPasswordViewModelDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var backToLogin: UIButton!
    @IBOutlet weak var resetPasswordTitleLabel: UILabel!
    @IBOutlet weak var resetPasswordDescription: UILabel!
    
    var responseMessage = ""
    var viewModel = ForgotPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.emailTextField = self.emailTextField
        viewModel.backToLogin = self.backToLogin
        viewModel.resetButton = self.resetButton
        self.viewModel.addImagesToTextFields()
        viewModel.delegate = self

        self.emailTextField.light(size: 18.0)
        self.resetButton.bold(size: 20.0)
        self.backToLogin.bold(size: 20.0)
        self.resetPasswordTitleLabel.bold(size: 20.0)
        self.resetPasswordDescription.light(size: 16.0)

    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == StoryboardSegueIdentifiers.forgotPasswordToCustomMessage {
            DispatchQueue.main.async {
                self.showSpinner()
            }
            let result = viewModel.shouldValidateCredentials()
            if result.0 {
                return false
            } else {
                showBanner(title: "", withMessage: result.1, style: .warning)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.removeSpinner()
                })
                return result.0
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue.destination.view.translatesAutoresizingMaskIntoConstraints = false //Temporary Fix
        
        if segue.identifier == StoryboardSegueIdentifiers.forgotPasswordToCustomMessage {
            let vc = segue.destination as? CustomTickViewController
            
            if responseMessage != "" {
                vc?.message = responseMessage
            }
        }
    }
}

extension ForgotPasswordViewController {
    
    func onForgotPasswordResponse(response: ForgotPasswordResponse?) {
        self.removeSpinner()
        DispatchQueue.main.async {
            guard let message = response?.message else {return}
            self.responseMessage = message
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.forgotPasswordToCustomMessage, sender: self)
         }
    }
    
    func onAPIException(errorResponse: ErrorResponse?) {
        guard let message = errorResponse?.message else {return}

        DispatchQueue.main.async {
            self.removeSpinner()
            self.showBanner(title: "", withMessage: message, style: .danger)
        }
        if message == ErrorHandler.tokenExpired {
                         DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                             RequestBuilder.shared.resetToSignInOnTokenExpire()
            })
        }
    }
    
}


