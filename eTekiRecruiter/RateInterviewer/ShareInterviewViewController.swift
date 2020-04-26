//
//  ShareInterviewViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 10/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class ShareInterviewViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var interviewersTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var shareInterviewButton: UIButton!
    @IBOutlet weak var noteLabel: PaddingLabel!
    var jobListingAPI: JobListingAPIProtocol.Type = JobListingAPI.self
    var jobID = ""
    var inteviewStatus = ""
    var interviewCode = ""
    var currentIndex = 0
    var currentPage = 0
    var totalCount = 0
    var dataArray = [Dictionary<String,Any>]()
    var responseArray = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(inteviewStatus)
        
        shareInterviewButton.isHidden = true

        if currentIndex == 1 && inteviewStatus == .completed {
            shareInterviewButton.isHidden = false
            shareInterviewButton.isEnabled = false
        }
        
        self.getEmailList(jobID: self.jobID)
        self.emailTextField.light(size: 18.0)
        self.addButton.light(size: 16.0)
        self.shareInterviewButton.bold(size: 18.0)
        self.noteLabel.roman(size: 11)
        self.setUpNavigationBar()
        generateEventLogToAnalytics(eventName: "Share Add Email Event", status: "True")
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
    }
    
    @IBAction func removeMailAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.shareInterviewToCustomAlert, sender: sender.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == StoryboardSegueIdentifiers.shareInterviewToCustomAlert){
            let navVC = segue.destination as? CustomAlertViewController
            navVC?.isNavigatingFrom = StoryboardSegueIdentifiers.shareInterviewToCustomAlert
            navVC?.index = sender as? Int ?? 0
            NotificationCenter.default.addObserver(self, selector: #selector(removeMail(notification:)), name: NSNotification.Name(rawValue: StoryboardSegueIdentifiers.shareInterviewToCustomAlert),object: sender as? Int)
        }
    }
    
    @objc func removeMail(notification: NSNotification){
        let index = notification.object as? Int ?? 0
        let dict = dataArray[index]
        let email = dict["email"] as? String ?? ""
        self.deleteEmailFromShare(email: email, jobID: jobID)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: StoryboardSegueIdentifiers.shareInterviewToCustomAlert), object: nil)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        var status = false
        if(emailTextField.text?.trimSpace(str: emailTextField.text ?? "") != ""){
            let validEmail = self.emailTextField.isValidEmail(emailStr: emailTextField.text ?? "")
            if validEmail {
                for i in 0..<dataArray.count{
                    let mail = dataArray[i]["email"] as? String
                    if(mail?.uppercased() == emailTextField.text?.uppercased()){
                        status = true
                    }
                }
                if status {
                    self.showBanner(title: "", withMessage: "Email is already added", style: .warning)
                }else {
                  self.showSpinner()
                  self.addEmailToShare(email: emailTextField.text ?? "", jobID: jobID)
                }
            } else{
                self.showBanner(title: "", withMessage: validationMessages.enterValidEmail, style: .warning)
            }
        } else {
            self.showBanner(title: "", withMessage: validationMessages.emailCantBeBlank, style: .warning)
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == interviewersTableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if totalCount > dataArray.count { // more items to fetch
                    self.getEmailList(jobID: jobID)
                } else {
                    print("No More Items to load.")
                }
            }
            
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = interviewersTableView.dequeueReusableCell(withIdentifier: "shareInterview") as! ShareInterviewTableViewCell
        let dict = dataArray[indexPath.row]
        cell.emailId.light(size: 18.0)
        if let email = dict["email"] as? String {
            cell.emailId.text = email
        }
        cell.deleteButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    @IBAction func shareInterviewAction(_ sender: Any) {
        generateEventLogToAnalytics(eventName: "Share Interview Event", status: "True")
        self.notifyRecruiter(interviewCode: interviewCode)
    }
    
}

extension ShareInterviewViewController {
    
    func addEmailToShare(email : String,jobID : String) {
        
        var emails = [String]()
        
        if email != "" {
            emails.append(email)
        }
        
        if emails.count > 0 {
            
            self.jobListingAPI.addEmailToShare(jobDetails: JobsManager(emails: emails, jobID: jobID)) { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    if let response = response {
                        let successMessage = response["message"] as? [String] ?? [""]
                        DispatchQueue.main.async {
                            
                            self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                            
                            let dict = ["email" : email]
                            self.dataArray.append(dict)
                            
                            if self.dataArray.count == 0 {
                                self.noDataView.isHidden = false
                                self.interviewersTableView.isHidden = true
                                if self.currentIndex == 1 && self.inteviewStatus == .completed {
                                    self.shareInterviewButton.isEnabled = false
                                    self.shareInterviewButton.alpha = 0.5
                                }
                            } else {
                                if self.currentIndex == 1 && self.inteviewStatus == .completed {
                                  self.shareInterviewButton.isEnabled = true
                                    self.shareInterviewButton.alpha = 1.0
                                }
                                self.interviewersTableView.isHidden = false
                                self.noDataView.isHidden = true
                            }
                            self.emailTextField.text = ""
                            self.interviewersTableView.reloadData()
                            self.removeSpinner()
                        }
                    }
                    
                }
            }
        }
    }
    
    func getEmailList(jobID : String) {
        
        currentPage = currentPage+1

        self.showSpinner()
        self.jobListingAPI.getShareDetails(jobDetails: JobsManager(page: "\(currentPage)", perPage: "10", jobID: jobID)) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                self.totalCount = response?["total_count"] as? Int ?? 0
                
                if let inteviewAccess = response?["interview_accesses"] as? [Dictionary<String,Any>] {
                    
                    if self.responseArray.count > 0 {
                        self.responseArray.removeAll()
                    }
                    self.responseArray.append(contentsOf: inteviewAccess)
                }
                
                if self.responseArray.count > 0 {
                    self.dataArray.append(contentsOf: self.responseArray)
                }
                
                DispatchQueue.main.async {
                    
                    if self.responseArray.count == 0 {
                        self.noDataView.isHidden = false
                        self.interviewersTableView.isHidden = true
                        if self.currentIndex == 1 && self.inteviewStatus == .completed {
                            self.shareInterviewButton.isEnabled = false
                            self.shareInterviewButton.alpha = 0.5
                        }
                    } else {
                        
                        if self.currentIndex == 1 && self.inteviewStatus == .completed {
                            self.shareInterviewButton.isEnabled = true
                            self.shareInterviewButton.alpha = 1.0
                        }

                        self.interviewersTableView.isHidden = false
                        self.noDataView.isHidden = true
                    }
                    self.interviewersTableView.reloadData()
                    self.removeSpinner()
                }
                
            }
            
        }
    }
    
    func deleteEmailFromShare(email : String, jobID : String) {
        
        if email != "" {
            
            print(email)
            self.showSpinner()
            self.jobListingAPI.deleteEmailFromShare(jobDetails: JobsManager(email: email, jobID: jobID)) { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    if let response = response {
                        let successMessage = response["message"] as? [String] ?? [""]
                        DispatchQueue.main.async {
                            
                            self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                            
                            for i in 0..<self.dataArray.count {
                                let dict = self.dataArray[i]
                                
                                let currentMail  = dict["email"] as? String
                                if currentMail == email {
                                    self.dataArray.remove(at: i)
                                    self.emailTextField.text = ""
                                    
                                    if self.dataArray.count == 0 {
                                        self.noDataView.isHidden = false
                                        self.interviewersTableView.isHidden = true
                                        if self.currentIndex == 1 && self.inteviewStatus == .completed {
                                            self.shareInterviewButton.isEnabled = false
                                            self.shareInterviewButton.alpha = 0.5
                                        }
                                    } else {
                                        if self.currentIndex == 1 && self.inteviewStatus == .completed {
                                            self.shareInterviewButton.isEnabled = true
                                            self.shareInterviewButton.alpha = 1.0
                                        }
                                        self.interviewersTableView.isHidden = false
                                        self.noDataView.isHidden = true
                                    }
                                    
                                    self.interviewersTableView.reloadData()
                                    self.removeSpinner()
                                    return
                                }
                            }
                            self.removeSpinner()
                        }
                    }
                    
                }
            }
        }
    }
    
    func notifyRecruiter(interviewCode : String) {
        
        if interviewCode != "" {
            self.showSpinner()
            self.jobListingAPI.notifyRecruiter(jobDetails: JobsManager(interviewCode: interviewCode)) { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    if let response = response {
                        let successMessage = response["message"] as? [String] ?? [""]
                        DispatchQueue.main.async {
                            
                            self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                            self.removeSpinner()
                        }
                    }
                    
                }
            }
        }
    }
}
