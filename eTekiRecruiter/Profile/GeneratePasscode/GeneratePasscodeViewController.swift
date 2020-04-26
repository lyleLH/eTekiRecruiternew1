//
//  GeneratePasscodeViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 11/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class GeneratePasscodeViewController: BaseViewController,GeneratePasscodeViewModelDelegate {
   
    @IBOutlet weak var passcodeLabel: UILabel!
    
    var viewModel = GeneratePasscodeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      self.bindViewModel()
      self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
      self.passcodeLabel.roman(size: 40.0)

    }
    
    func bindViewModel() {
        viewModel.delegate = self
        DispatchQueue.main.async {
            self.showSpinner()
        }
        viewModel.getPasscode(profileManager: ProfileManager(type: Profile.passcode),requestType: ServerAttributes.getProfileDetails)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func generateNewPasscode(_ sender: Any) {
        DispatchQueue.main.async {
            self.showSpinner()
        }
        viewModel.resetPasscode(requestType: ServerAttributes.resetPasscode)
        
    }
    
}

extension GeneratePasscodeViewController {
    
    func onGetProfileResponse(response: ProfileResponse?, requestType: String) {
        
        print("request type==============\(requestType)")
        DispatchQueue.main.async {
            self.removeSpinner()
            
            self.showBanner(title: "", withMessage: response?.message ?? "Success", style: .success)
            
            if let newCode = response?.currentPasscode {
                self.passcodeLabel.text = newCode
            } else {
                self.passcodeLabel.text = "-"
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
