//
//  PrimaryInfoViewController.swift
//  eTekiTrainingApp
//  Created by Lavanya on 22/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import FlagPhoneNumber

enum SocialLinks {
    static var facebook = "facebook.com"
    static var twitter = "twitter.com"
    static var googleplus = "plus.google.com"
    static var linkedIn = "linkedin.com"
}

enum SocialLinkValidationMessages : String {
    case facebook = "Use the following format URL https://www.facebook.com/user"
    case twitter = "Use the following format URL https://www.twitter.com/user"
    case googleplus = "Use the following format URL https://www.google.com/user"
    case Linkedin = "Use the following format URL https://www.linked.com/user"
}

class PrimaryInfoViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,PrimaryInfoViewModelDelegate {
    
    @IBOutlet weak var generalInfoTableView: UITableView!
    @IBOutlet weak var socialLinkTableView: UITableView!
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    let field = FPNTextField()
    var viewModel = PrimaryInfoViewModel()
    
    var responseArray = [ProfileResponse?]()
    @IBOutlet weak var updateButton: UIButton!

    override func viewDidLoad() {
        bindViewModel()
        self.navigationController?.modalPresentationStyle = .fullScreen
        //Params: {type: “Primary Details”/"Address Details"/"Company Details"/"Passcode"/”SMS Settings”}
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
        self.navigationItem.setRightBarButtonItems(self.notificationItem, animated: true)
        self.updateButton.bold(size: 18.0)
    
    }
    
    override func viewDidLayoutSubviews() {
        
        if ScreenSize.height <= DeviceHeight.Inches_4_7 {
            bgScrollView.contentSize = CGSize(width: view.frame.size.width, height: contentView.frame.size.height)
        }
    }
    
    func bindViewModel() {
        viewModel.delegate = self
        self.showSpinner()
        viewModel.getPrimaryInfoDetails()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updatePrimaryInformation(_ sender: Any) {
        
        generateEventLogToAnalytics(eventName: "Update Profile Event", status: "True")

        var domainArray = [] as Array<Dictionary<String,String>>
        var result = Bool()
        for index in 0..<3 {
            let cell = socialLinkTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SocialLinksTableViewCell
            
            if let socialLink = cell?.socialLinkField.text {
                
                if(index == 1 || index == 2 ) {
                    
                    if(socialLink == "") {
                        result = true
                    } else {
                        result = socialLink.validateUrl()
                        print(result)
                        result = self.isValidSocialLink(socialLink: socialLink)
                        print(result)
                        
                    }
                    
                } else {
                    result = self.isValidSocialLink(socialLink: socialLink)
                }
                
                if result {
                    
                    let urlString = socialLink
                    let url = URL(string: urlString)
                    let domain = url?.host
                    
                    switch index {
                    case 0:
                        
                        if let domain = domain {
                            if domain.range(of: SocialLinks.linkedIn) != nil {
                                
                                domainArray.append(["domain_name":"linkedin","url" : socialLink])
                            } else {
                                //cell?.socialLinkField.text = ""
                                cell?.socialLinkField.becomeFirstResponder()
                                
                                self.showBanner(title: "", withMessage: .linkedinErrorMessage, style: .warning)
                                return
                            }
                        }
                        
                    case 1:
                        
                        if let domain = domain {
                            if domain.range(of: SocialLinks.twitter) != nil {
                                domainArray.append(["domain_name":"twitter","url" : socialLink])
                            } else {
                                //cell?.socialLinkField.text = ""
                                cell?.socialLinkField.becomeFirstResponder()
                                self.showBanner(title: "", withMessage: .twitterErroMessage, style: .warning)
                                return
                            }
                        }
 
                    case 2:
                        
                        if let domain = domain {
                            if domain.range(of: SocialLinks.facebook) != nil {
                                domainArray.append(["domain_name":"facebook","url" : socialLink])
                            } else {
                                //cell?.socialLinkField.text = ""
                                cell?.socialLinkField.becomeFirstResponder()
                                self.showBanner(title: "", withMessage: .facebookErrorMessage, style: .warning)
                                return
                            }
                        }
                    default: print("Unhandled")
                    }
                    
                } else {
                    
                    switch index {
                    case 0:
                        if(cell?.socialLinkField.text == ""){
                            self.showBanner(title: "", withMessage: .linkedInCantBlank, style: .warning)
                        } else {
                            self.showBanner(title: "", withMessage: .linkedinErrorMessage, style: .warning)
                        }
                    case 1:
                        self.showBanner(title: "", withMessage: .twitterErroMessage, style: .warning)
                    case 2:
                        self.showBanner(title: "", withMessage: .facebookErrorMessage, style: .warning)
                    default: print("Unhandled")
                    }
                    //cell?.socialLinkField.text = ""
                    cell?.socialLinkField.becomeFirstResponder()
                    return
                }
            }
            
        }
        self.showSpinner()
        let profileManager = ProfileManager(socialLinks: domainArray)
        viewModel.updateSocialLinks(profileManager: profileManager)
    }
}

extension String {
    func validateUrl () -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
}

extension PrimaryInfoViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == socialLinkTableView {
            return 3
        }
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        
        let response = responseArray.first as? ProfileResponse ?? ProfileResponse()
        
        
        if tableView == socialLinkTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.socialLinksTableViewCell, for: indexPath) as! SocialLinksTableViewCell
            
            cell.socialLinkField.textColor =  AppTheme.textColor
            cell.socialLinkField.light(size: 18.0)
            
            var placeHolder = ""
            
            switch indexPath.row {
            case 0:
                placeHolder = "http(s)://www.linkedin.com *"
                cell.socialLinkIcon.image = UIImage(named: "linkedin_profile")
                cell.socialLinkField.text = response.linkedIn
                
            case 1:
                placeHolder = "http(s)://www.twitter.com"
                cell.socialLinkIcon.image = UIImage(named: "twitter_profile")
                cell.socialLinkField.text = response.twitter
                
                //                    case 2:
                //                        placeHolder = "http[s]://plus.google.com"
                //                        cell.socialLinkIcon.image = UIImage(named: "google-plus_profile")
                //                        cell.socialLinkField.text = response.googlePlus
                
            case 2:
                placeHolder = "http(s)://www.facebook.com"
                cell.socialLinkIcon.image = UIImage(named: "facebook_profile")
                cell.socialLinkField.text = response.facebook
                
            default: fatalError("Unhandled section \(indexPath.section)")
            }
            
            let customfont = UIFont.appLightFontWith(size: 18.0)
           cell.socialLinkField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: placeHolder, color: AppTheme.placeHolderColor)

            return cell
            
        } else {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.generalInfoTableViewCell, for: indexPath) as! GeneralInfoTableViewCell
            cell.primaryTextField.light(size: 18.0)
            cell.primaryTextField.textColor = AppTheme.textColor
            var placeHolder = ""
            
            switch indexPath.row {
            case 0:
                
                placeHolder = .firstName
                cell.primaryTextField.text = response.firstName
            case 1:
                placeHolder = .lastName
                cell.primaryTextField.text = response.lastName
            case 2:
                placeHolder = .displayName
                cell.primaryTextField.text = response.displayName
            case 3:
                placeHolder = .email
                cell.primaryTextField.text = response.email
            case 4:
                placeHolder = .alternateEmail
                cell.primaryTextField.text = response.alternateEmail
            case 5:
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "phoneNumberTableViewCell", for: indexPath) as! GeneralInfoTableViewCell
                placeHolder = .phoneNumber
                cell1.phoneNumberField.text = response.phoneNumber
                if response.areaCode1 != "" {
                    cell1.phoneNumberField.setFlag(countryCode: FPNCountryCode(rawValue: response.areaCode1?.uppercased() ?? "")!)
                }
                setupNumberField(button: cell1.phoneNumberField)
                let customfont = UIFont.appLightFontWith(size: 18.0)
            cell1.phoneNumberField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: placeHolder, color: AppTheme.placeHolderColor)
                return cell1
            case 6:
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "phoneNumberTableViewCell", for: indexPath) as! GeneralInfoTableViewCell
                placeHolder = .alternatePhoneNumber
                cell1.phoneNumberField.text = response.alternatePhoneNumber
                if response.areaCode2 != "" {
                    cell1.phoneNumberField.setFlag(countryCode: FPNCountryCode(rawValue: response.areaCode2?.uppercased() ?? "")!)
                }
                setupNumberField(button: cell1.phoneNumberField)
                let customfont = UIFont.appLightFontWith(size: 18.0)
                    cell1.phoneNumberField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: placeHolder, color: AppTheme.placeHolderColor)
                return cell1
            default: fatalError("Unhandled section \(indexPath.section)")
            }
            
            let customfont = UIFont.appLightFontWith(size: 18.0)
          cell.primaryTextField.setFontforTextFieldPlaceHolder(customfont: customfont, placeholderString: placeHolder, color: AppTheme.placeHolderColor)
            return cell
        }
    }
    
    func setupNumberField(button: FPNTextField){
        // button.parentViewController = self commented after pods update
        button.delegate = self
        button.textColor = AppTheme.textColor
        button.font = UIFont(name: "Roboto-Regular", size: 16)
        //button.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.hasPhoneNumberExample = true
        button.leftView?.translatesAutoresizingMaskIntoConstraints = true
        button.leftView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

extension PrimaryInfoViewController {
    
    func onGetProfileResponse(response: ProfileResponse?) {
        
        if self.responseArray.count > 0 {
            self.responseArray.removeAll()
        }
        self.responseArray.append(response)
        DispatchQueue.main.async {
            self.removeSpinner()
            if response?.message != "" {
                self.showBanner(title: "", withMessage: .primaryInfoUpdated, style: .success)
            }
            self.generalInfoTableView.reloadData()
            self.socialLinkTableView.reloadData()
        }
    }
    
    func onAPIException(errorResponse: ErrorResponse?) {
        DispatchQueue.main.async {
           guard let message = errorResponse?.message else {return}
           self.handleErrorResponse(message: message)
        }
    }
    
}
