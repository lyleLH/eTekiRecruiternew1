//
//  CompanyViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//
import UIKit
import SimpleCheckbox

class CompanyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,CompanyViewModelDelegate {
    
    @IBOutlet weak var addressTextField: UILabel!
    @IBOutlet var noCompanyView: UIView!
    @IBOutlet var companyDetailsView: UIView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var seperatorLine: UIView!
    @IBOutlet var companyTableView: UITableView!
    @IBOutlet var checkBoxView: Checkbox!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    var responseArray = [ProfileResponse?]()
    var viewModel = CompanyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyDetailsView.layer.borderWidth = 1
        companyDetailsView.layer.cornerRadius = 5
        companyDetailsView.layer.borderColor = UIColor.init(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1).cgColor
             
        self.updateButton.isHidden = true
        checkBoxView.borderLineWidth = 1
        checkBoxView.layer.cornerRadius = 5
        checkBoxView.checkmarkStyle = .tick
        checkBoxView.checkmarkColor = AppTheme.brandColor
        checkBoxView.uncheckedBorderColor = UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1)
        checkBoxView.checkedBorderColor = UIColor(red: 183.0/255, green: 196.0/255, blue: 204.0/255, alpha: 1)
      
        self.companyDetailsView.isHidden = true
        self.updateButton.isHidden = true
        self.checkBoxView.isHidden = true
        
        self.bindViewModel()
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)

    }
    
    func bindViewModel() {
        viewModel.delegate = self
        self.showSpinner()
        let profileManager = ProfileManager(type: Profile.companyDetails)
        viewModel.getCompanyDetails(profileManager: profileManager)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = companyTableView.dequeueReusableCell(withIdentifier: "CompanyDetailsCell") as! CompanyDetailsCell
        
        cell.layer.borderColor =  AppTheme.containerBorderColor.cgColor
        
        let profileData = responseArray.first as? ProfileResponse ?? ProfileResponse()
        
        
    switch indexPath.row {
            
        case 0:
            cell.iconImage.image = UIImage(named: "earth")
            cell.titleTextField.placeholder = "www.company.com"
            cell.titleTextField.text = profileData.website
            
        case 1:
            cell.iconImage.image = UIImage(named: "mobileIcon")
            cell.titleTextField.placeholder = "+91 99999 91234"
            cell.titleTextField.text = profileData.contact1


        case 2:
            cell.iconImage.image = UIImage(named: "telephone")
            cell.titleTextField.placeholder = "+91 99999 91234"
            cell.titleTextField.text = profileData.contact2

        case 3:
            cell.iconImage.image = UIImage(named: "mail_light")
            cell.titleTextField.placeholder = "contact@company.com"
            cell.titleTextField.text = profileData.email
  
         default: fatalError("Unhandled section \(indexPath.section)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return view
    }
    
    @IBAction func updateAction(_ sender: Any) {
     
        generateEventLogToAnalytics(eventName: "Update Company Event", status: "True")
        self.showSpinner()
        let profileManager = ProfileManager(sameAsbilling: checkBoxView.isChecked)
        self.viewModel.updateCompanyDetails(profileManager: profileManager)
 
    }
    
}

extension CompanyViewController {
    
    func onGetProfileResponse(response: ProfileResponse?) {
          
        if self.responseArray.count > 0 {
            self.responseArray.removeAll()
            
        }
        
        self.responseArray.append(response)
        

        guard let companyName = response?.companyName else {return}

        guard let address1 = response?.address1 else {return}
        guard let address2 = response?.address2 else {return}
        guard let city = response?.city else {return}
        guard let state = response?.state else {return}
        guard let country = response?.country else {return}
        guard let zip = response?.zip else {return}
        
        var formatedAddress = ""
        
        if address1 != "" {
        formatedAddress = "\(address1),"
        }

        if address2 != "" {
        formatedAddress = formatedAddress + "\(address2),"
        }

        if city != "" {
        formatedAddress = formatedAddress + "\(city),"
        }

        if state != "" {
        formatedAddress = formatedAddress + "\(state),"
        }

        if country != "" {
        formatedAddress = formatedAddress + "\(country),"
        }

        if zip != "" {
        formatedAddress = formatedAddress + "\(zip)"
        }

        
        if companyName != "" {
            
            DispatchQueue.main.async {
                
              self.companyDetailsView.isHidden = false
             // self.updateButton.isHidden = false
                self.noCompanyView.isHidden = true

                self.removeSpinner()
                if response?.message != "" {
                    self.showBanner(title: "", withMessage: .profileUpdated, style: .success)
                }
                
                self.checkBoxView.isChecked = response?.sameAsBillingAddress ?? false
                
                if response?.sameAsBillingAddress ?? false {
                   // self.updateButton.isHidden = true
                    self.checkBoxView.isEnabled = false
                } else {
                   // self.updateButton.isHidden = false
                    self.checkBoxView.isEnabled = true
                }
                self.companyLabel.text = companyName

                if formatedAddress.last == "," {
                   let removedLastChar = formatedAddress.dropLast()
                   formatedAddress = "\(removedLastChar)"
                }
                
                self.addressTextField.text = formatedAddress

                self.companyTableView.reloadData()
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.companyDetailsView.isHidden = true
                self.updateButton.isHidden = true
                self.noCompanyView.isHidden = false
                self.removeSpinner()
            }
                
        }
        
}
    
    func onAPIException(errorResponse: ErrorResponse?) {
        DispatchQueue.main.async {
            self.removeSpinner()
            self.showBanner(title: "", withMessage: errorResponse?.message ?? "Server Error", style: .danger)
        }
    }
    
}

