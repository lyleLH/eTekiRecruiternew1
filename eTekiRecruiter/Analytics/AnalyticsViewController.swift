//
//  AnalyticsViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 06/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class AnalyticsViewController: BaseViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenedButton: UIButton!
    @IBOutlet weak var submittedButton: UIButton!
    @IBOutlet weak var interviewedButton: UIButton!
    @IBOutlet weak var offeredButton: UIButton!
    @IBOutlet weak var hiredbutton: UIButton!
    @IBOutlet weak var proxyImageView: UIImageView!
    
    @IBOutlet weak var screenProgressImage: UIImageView!
    @IBOutlet weak var submittedProgressImage: UIImageView!
    @IBOutlet weak var interviewedProgressImage: UIImageView!
    @IBOutlet weak var offeredProgressImage: UIImageView!
    @IBOutlet weak var barContainterView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var candidateID = ""
    var currentAnalyticStatus = ""
    var analyticfinalStatus = false
    var candidateProxied = false
    var isNavigatingFrom = ""
    
    let dataSource : [String] = [.screened,.submitted,.interviewed,.offered,.hired]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
        getCandidatesROI()
        self.currentAnalyticStatus = .screened
        self.enableScreenButton()
        self.nameLabel.roman(size: 16.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       bgScrollView.contentSize = CGSize(width: bgScrollView.frame.size.width, height: barContainterView.frame.size.height-100)
    }

    func enableScreenButton() {
        screenedButton.borderColor = AnalyticsScreenFonts.progressButtonColor
        screenedButton.backgroundColor = AnalyticsScreenFonts.progressStatusColor
        screenedButton.backgroundColor = AnalyticsScreenFonts.progressStatusColor
        screenedButton.imageView?.isHidden = false
        screenedButton.setImage(UIImage(named: "whitetick"), for: .normal)
        screenedButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @objc func updateAnalytics(notfication: NSNotification) {
        
        self.showSpinner()
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let analyticResponse = info["Analytics"] as? Dictionary<String,Any> {
                
                DispatchQueue.main.async {
                    
                    if let analyticResponse = analyticResponse["analytics_response"] as? Dictionary<String,Any> {
                        
                        if let analyticStatus = analyticResponse["analytic_status"] as? String {
                            switch analyticStatus {
                            case .screened:
                                self.screenedStatusAction(self.screenedButton)
                            case .offered:
                                self.offeredStatusAction(self.offeredButton)
                            case .hired:
                                self.hiredStatusAction(self.hiredbutton)
                            case .submitted:
                                self.submittedStatusAction(self.submittedButton)
                            case .interviewed:
                                self.interviewedStatusAction(self.interviewedButton)
                            default:
                                print("Default")
                            }
                        }
                        
                        if let analyticCompleted = analyticResponse["analytics_completed"] as? Bool {
                            print("\(analyticCompleted)")
                            if analyticCompleted {
                                self.submitButton.isHidden = true
                                self.barContainterView.isUserInteractionEnabled = false
                            } else {
                                self.submitButton.isHidden = false
                                self.barContainterView.isUserInteractionEnabled = true
                            }
                        }
                        
                        if let proxiedCandidate = analyticResponse["proxied"] as? Bool {
                            print("\(proxiedCandidate)")
                            if proxiedCandidate {
                                self.showBanner(title: "", withMessage: "SUSPECTED_PROXY".localized, style: .warning)
                            } else {}
                        }
                        
                        if let candiateID = analyticResponse["id"] as? Int {
                            print("\(candiateID)")
                        }
                        
                        if let candiateName = analyticResponse["full_name"] as? String {
                            self.navigationItem.title = candiateName
                        }
                    }
                    
                    self.removeSpinner()
                    
                }
                
            } else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateAnalytics"), object: nil)
        
    }
    
    func getCandidatesROI() {
        
        self.showSpinner()
        candidatesAPI.getCandidateROIDetails(candidatesManager: CandidatesManager(candidateID: candidateID)) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                DispatchQueue.main.async {
                    guard let apiResponse = response else {return}
                    
                    if let analyticResponse = apiResponse["analytics_response"] as? Dictionary<String,Any> {
                        
                        if let analyticStatus = analyticResponse["analytic_status"] as? String {
                            switch analyticStatus {
                            case .screened:
                                self.screenedStatusAction(self.screenedButton)
                            case .offered:
                                self.offeredStatusAction(self.offeredButton)
                            case .hired:
                                self.hiredStatusAction(self.hiredbutton)
                            case .submitted:
                                self.submittedStatusAction(self.submittedButton)
                            case .interviewed:
                                self.interviewedStatusAction(self.interviewedButton)
                            default:
                                print("Default")
                            }
                        }
                        
                        
                        
                        if let isProxied = analyticResponse["proxied"] as? Bool {
                            if isProxied {
                                self.proxyImageView.isHidden = false
                            } else {
                                self.proxyImageView.isHidden = true
                            }
                        }
                        
                        if let analyticCompleted = analyticResponse["analytics_completed"] as? Bool {
                            print("\(analyticCompleted)")
                            if analyticCompleted {
                                self.submitButton.isHidden = true
                                self.barContainterView.isUserInteractionEnabled = false
                            } else {
                                self.submitButton.isHidden = false
                                self.barContainterView.isUserInteractionEnabled = true
                            }
                        }
                        
                        if let candiateID = analyticResponse["id"] as? Int {
                            print("\(candiateID)")
                        }
                        
                        if let candiateName = analyticResponse["full_name"] as? String {
                            self.nameLabel.text = candiateName.uppercased()
                            //self.proxyImageView.isHidden = false
                            if !self.proxyImageView.isHidden {
                                self.nameLabel.text = (self.nameLabel.text ?? "") + " " + "Suspected of Proxy"
                            } else {
                                
                                self.nameLabel.text =  "Name: " + (self.nameLabel.text ?? "")
                               // self.nameLabel.textColor = AppTheme.brandColor
                            }

                            //self.navigationItem.title = candiateName
                        }
                    }
                    self.removeSpinner()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.analyticsToCustomMessage {
            if let navVC = segue.destination as? CustomAlertViewController {
                let parameters: [String: Any] = ["candidate_id" : candidateID,"analytic_status": currentAnalyticStatus ,"is_final" : analyticfinalStatus,"proxied" : candidateProxied]
                print(currentAnalyticStatus)
                navVC.isNavigatingFrom = StoryboardSegueIdentifiers.analyticsToCustomMessage
                navVC.infoData = parameters
                NotificationCenter.default.addObserver(self, selector: #selector(updateAnalytics(notfication:)), name: Notification.Name("updateAnalytics"), object: nil)
                
            }
        }
    }
    
    /*! @brief This function Customize the SignIn Fields Stack View*/
    func setUpView() {
        barContainterView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        barContainterView.clipsToBounds = true
        barContainterView.layer.borderWidth = 1
        barContainterView.layer.cornerRadius = 10
    }
    
    @IBAction func screenedStatusAction(_ sender: UIButton) {
        self.currentAnalyticStatus = .screened
        //self.statusDescriptionLabel.text = .screenedDescription
        self.updateViewToEnableFields()
    }
    
    @IBAction func submittedStatusAction(_ sender: UIButton) {
        generateEventLogToAnalytics(eventName: "Analytics Submit Event", status: "True")
        if currentAnalyticStatus == .submitted {return}
        self.currentAnalyticStatus = .submitted
        //self.statusDescriptionLabel.text = .submittedDescription
        self.enableDisableButton(sender: sender)
    }
    
    @IBAction func interviewedStatusAction(_ sender: UIButton) {
        if currentAnalyticStatus == .interviewed {return}
        self.currentAnalyticStatus = .interviewed
        
        //self.statusDescriptionLabel.text = .interviewedDescription
        self.enableDisableButton(sender: sender)
    }
    
    func enableDisableButton(sender : UIButton) {
        self.updateViewToEnableFields()
    }
    
    func updateViewToEnableFields() {
        
        let revereseIndex : Int = dataSource.firstIndex(of: self.currentAnalyticStatus) ?? 1
        for index in (1 ..< dataSource.count) {
            
            let status = dataSource[index]
            var  inputButton = UIButton()
            var  progressImageView = UIImageView()
            switch status {
            case .screened:
                inputButton = screenedButton
            case .submitted:
                progressImageView = screenProgressImage
                inputButton = submittedButton
            case .interviewed:
                progressImageView = submittedProgressImage
                inputButton = interviewedButton
            case .offered:
                progressImageView = interviewedProgressImage
                inputButton = offeredButton
            case .hired:
                progressImageView = offeredProgressImage
                inputButton = hiredbutton
            default:
                inputButton = screenedButton
            }
            
            if index <= revereseIndex {
                self.updateButtonForEnabled(progressButton: inputButton, screenedStatus: status,progressImage:progressImageView)
            } else {
                self.updateButtonForDisabled(progressButton: inputButton, screenedStatus: status, progressImage: progressImageView)
            }
        }
    }
    
    @IBAction func offeredStatusAction(_ sender: UIButton) {
        if self.currentAnalyticStatus == .offered {return}
        self.currentAnalyticStatus = .offered
        //self.statusDescriptionLabel.text = .offeredDescription
        self.enableDisableButton(sender: sender)
    }
    
    @IBAction func hiredStatusAction(_ sender: UIButton) {
        
        if self.currentAnalyticStatus == .hired {
            return
        }
        self.currentAnalyticStatus = .hired
        self.enableDisableButton(sender: sender)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if isNavigatingFrom == "Dashboard" {
           NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
          self.dismiss(animated: false, completion: nil)
        } else {
         self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func updateButtonForEnabled(progressButton : UIButton,screenedStatus : String,progressImage : UIImageView) {
        self.updateEnabledProgress(progressButton: progressButton, progressImage: progressImage)
    }
    
    func updateEnabledProgress(progressButton : UIButton, progressImage : UIImageView) {
        progressButton.borderColor = AnalyticsScreenFonts.progressButtonColor
        progressButton.backgroundColor = AnalyticsScreenFonts.progressStatusColor
        progressImage.backgroundColor = AnalyticsScreenFonts.progressStatusColor
        progressButton.imageView?.isHidden = false
        progressButton.setImage(UIImage(named: "whitetick"), for: .normal)
        progressButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func updateButtonForDisabled(progressButton : UIButton,screenedStatus : String,progressImage : UIImageView) {
        if screenedStatus == .screened {return}
        progressButton.borderColor = AppTheme.contributorPermissionsUncheckColor
        progressButton.backgroundColor = AppTheme.appBackgroundColor
        progressImage.backgroundColor = AppTheme.contributorPermissionsUncheckColor
        progressButton.setImage(UIImage(), for: .normal)
        // self.currentAnalyticStatus = .screened
    }
    
    @IBAction func backAction(_ sender: Any) {
         NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
        self.dismiss(animated: false, completion: nil)
        if isNavigatingFrom == "moreActions" {
         self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
