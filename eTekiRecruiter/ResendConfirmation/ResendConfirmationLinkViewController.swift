//
//  ResendConfirmationLinkViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 18/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class ResendConfirmationLinkViewController: BaseViewController,ResendResendConfirmationViewModelDelegate {
  
    @IBOutlet weak var resendConfirmationDescription: UILabel!
    @IBOutlet weak var resendConfirmationTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var backToLogin: UIButton!
    
    var viewModel = ResendConfirmationViewModel()
    
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
        self.resendConfirmationTitle.bold(size: 20.0)
        self.resendConfirmationDescription.light(size: 16.0)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == StoryboardSegueIdentifiers.resendConfirmationToCustomMessage {
            DispatchQueue.main.async {
                self.showSpinner()
            }
            let result = viewModel.shouldValidateCredentials()
            if result.0 {
                return false
            } else {
                showBanner(title: "", withMessage: result.1, style: .warning)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.removeSpinner()
                })
                return result.0
            }
        }
        return false
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}

extension ResendConfirmationLinkViewController {
    
    func onResendConfirmationResponse(response: ForgotPasswordResponse?) {
        self.removeSpinner()
        DispatchQueue.main.async {
            guard let message = response?.message else {return}
            self.showBanner(title: "", withMessage: message, style: .success)
        }
    }
    
    func onAPIException(errorResponse: ErrorResponse?) {
        self.removeSpinner()
        guard let message = errorResponse?.message else {return}
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: message, style: .warning)
        }
        
        if message == ErrorHandler.tokenExpired {
                  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                      RequestBuilder.shared.resetToSignInOnTokenExpire()
            })
        }
    }
    
}
