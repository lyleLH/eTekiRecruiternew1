//
//  CustomAlertViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 15/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import TagListView

protocol CustomAlertDelegate {
    func customAlertToParent()
}

class CustomAlertViewController: BaseViewController {

    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var listName = ""
    var delegate : CustomAlertDelegate?
    var infoData = [String:Any]()

    var finalStatus = false
    public var message = ""
    public var tittle = ""
    public var jobId : String = ""
    var currentTagList : TagListView?
    var isNavigatingFrom = ""
    var index = Int()
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        updateContainerView()

    }
    
    func updateView() {
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
        view.isOpaque = true

        titleLabel.bold(size: 20.0)
        messageLabel.light(size: 20.0)
        noButton.bold(size: 18.0)
        yesButton.bold(size: 18.0)

        if isNavigatingFrom == StoryboardSegueIdentifiers.analyticsToCustomMessage {
            messageLabel.text = "Is this the final status? \n This indicates the final ROI status of the candidate."
            titleLabel.text = "Analytics Submit"
        } else if isNavigatingFrom == StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage {
            if let date = infoData["selectedEvent"] as? Date {
                
                let dateformatter = DateFormatter()
               // dateformatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
                dateformatter.dateFormat =  "dd-MMMM-yyyy hh:mm a"
                print(date)

                let formatedDate = dateformatter.string(from: date)
                messageLabel.text = formatedDate
            }
            titleLabel.text = "Do you want to remove slot?"
        } else if isNavigatingFrom == StoryboardSegueIdentifiers.contributorsToCustomMessage {
            
            
            if let currentPermission = infoData["settingsName"] as? String {
                
                if currentPermission == "Apply Default" {
                    titleLabel.text = "Apply Default Settings"
                } else if currentPermission == "Save Default" {
                    titleLabel.text = "Save As Default Settings"

                }
            }
  
            messageLabel.text = "Are you sure?"

        }else if isNavigatingFrom == StoryboardSegueIdentifiers.shareInterviewToCustomAlert {
                  
                titleLabel.text = "Delete Email Confirmation"
                messageLabel.text = "Do you want to delete this email?"

        }else if isNavigatingFrom == "withdraw" {
             titleLabel.text = "Withdraw Candidate"
             messageLabel.text = "Withdrawing a candidate would incur late cancellation fee applicable if any confirmed interview for the candidate."
        }else if isNavigatingFrom == "myInterviewsCancelInterview" {
            messageLabel.text = "Do you want to cancel interview?"
        } else if isNavigatingFrom == "CreateJobToCustomMessage" {
            
            titleLabel.text = "Do you want to remove skill?"
            messageLabel.text = tittle
        }
    }
    
    func updateContainerView(){
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = CustomAlertFonts.alertBorderColor.cgColor
        containerView.layer.cornerRadius = 10;
        containerView.layer.masksToBounds = true;
    }
    
    @IBAction func yesAction(_ sender: Any) {
        
        if isNavigatingFrom == "CreateJobToCustomMessage" {
            
            NotificationCenter.default.post(name: Notification.Name("CreateJobToCustomMessage"), object: nil, userInfo: ["listview":currentTagList ?? TagListView(), "listViewName": self.listName])
            self.dismiss(animated: false, completion: nil)

                   
        } else  if isNavigatingFrom == StoryboardSegueIdentifiers.analyticsToCustomMessage {
            finalStatus = true
            self.updateCandidateHiredStatus()
        } else if isNavigatingFrom == StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage {
            
            if let date = infoData["selectedEvent"] as? Date {
                NotificationCenter.default.post(name: Notification.Name(StoryboardSegueIdentifiers.provideAvailibiltyToCustomMessage), object: nil, userInfo: ["selectedEvent":date])
                self.dismiss(animated: false, completion: nil)
            }            
        }else if isNavigatingFrom == StoryboardSegueIdentifiers.contributorsToCustomMessage {
            NotificationCenter.default.post(name: Notification.Name(StoryboardSegueIdentifiers.contributorsToCustomMessage), object: infoData["settingsName"] as? String)
                self.dismiss(animated: false, completion: nil)
        } else if isNavigatingFrom == StoryboardSegueIdentifiers.shareInterviewToCustomAlert {
            NotificationCenter.default.post(name: Notification.Name(StoryboardSegueIdentifiers.shareInterviewToCustomAlert), object: index as? Int)
            self.dismiss(animated: false, completion: nil)
        }else if isNavigatingFrom == "withdraw" {
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.CustomAlertToWithdrawn, sender: nil)
        } else if isNavigatingFrom == "myInterviewsCancelInterview"{
             cancelInterview()
        } else {
            self.showSpinner()
              JobListingAPI.closeJob(jobDetails: JobsManager(jobID: jobId)) { (response, error) in
                   if response != nil {
                      let message = response?.message ?? "Job Closed."
                      DispatchQueue.main.async {
                          self.delegate?.customAlertToParent()
                          self.dismiss(animated: false, completion: nil)
                          self.removeSpinner()
                          self.showBanner(title: "", withMessage: message, style: .success)
                      }
                  } else {
                       DispatchQueue.main.async{
                          self.dismiss(animated: false, completion: nil)
                         self.removeSpinner()
                           self.showBanner(title: "" , withMessage: error?.message ?? "Server Error", style: .danger)
                       }
                  }
              }
        }
    }
    
    func cancelInterview() {
        generateEventLogToAnalytics(eventName: "Cancel Interview Event", status: "True")
        let manager = CandidatesManager(interviewID: infoData["id"] as? String ?? "")
        self.showSpinner()
        candidatesAPI.cancelInterview(candidateManger: manager) {(response , error) in
            if(response != nil) {
               let success = response?["success"] as? Bool ?? false
                if(success){
                    DispatchQueue.main.async {
                        let successMessage = response?["message"] as? [String] ?? ["Success"]
                        if let id = response?["interview_id"] as? Int {
                            let data = ["id": "\(id)", "message": successMessage[0], "title": self.infoData["title"] as? String, "startTime": self.infoData["startTime"] as? String]
                            self.removeSpinner()
                            if(successMessage[0] != "No payment required for this cancellation"){
                              self.performSegue(withIdentifier: StoryboardSegueIdentifiers.customAlertToCancelCustomInterview, sender: data)
                            } else {
                                self.performSegue(withIdentifier: StoryboardSegueIdentifiers.customAlertToCancelInterview, sender: data)
                            }
                        }    
                    }
                } else {
                   DispatchQueue.main.async {
                      self.removeSpinner()
                      self.showBanner(title: "", withMessage: error?.message ?? "Server error", style: .danger)
                   }
                }
             } else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    @IBAction func noAction(_ sender: Any) {
        
        if isNavigatingFrom == StoryboardSegueIdentifiers.analyticsToCustomMessage {
            finalStatus = false
            self.updateCandidateHiredStatus()

        } else {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == StoryboardSegueIdentifiers.CustomAlertToWithdrawn){
            let navVc =  segue.destination as? WithDrawnViewController
            navVc?.candidateId = infoData["id"] as? String ?? ""
            navVc?.status = true
            navVc?.isNavigatingFrom = "myInterviews"
        }
        if(segue.identifier == StoryboardSegueIdentifiers.customAlertToCancelCustomInterview){
            if let navVc = segue.destination as? CancelInterviewCustomController{
                navVc.infoData = sender as? [String: Any] ?? [:]
            }
        }
        if(segue.identifier == StoryboardSegueIdentifiers.customAlertToCancelInterview){
             let navVC = segue.destination as? UINavigationController
             if let cancelInterviewViewController = navVC?.viewControllers.first as? CancelInterviewViewController {
                cancelInterviewViewController.infoData = sender as? [String: Any] ?? [:]
                if let data = sender as? [String: Any] {
                    cancelInterviewViewController.interviewID = data["id"] as? String ?? ""
                }
                cancelInterviewViewController.isNavigatingFrom = StoryboardSegueIdentifiers.customAlertToCancelInterview
            }
        }
    }
    @IBAction func closePopUpAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func updateCandidateHiredStatus() {
        
        self.showSpinner()
        guard let candidateID = infoData["candidate_id"] as? String else {return}
        guard let analyticStatus = infoData["analytic_status"] as? String else {return}
        guard let candidateProxied = infoData["proxied"] as? Bool else {return}
        
        self.candidatesAPI.postCandidateROIDetails(candidateManager: CandidatesManager(candidateID: candidateID, analyticStatus: analyticStatus, analyticfinalStatus: finalStatus, candidateProxied: candidateProxied)) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                DispatchQueue.main.async {
                    
                    guard let jsonResponse =  response else {return}
                    let successMessage = jsonResponse["message"] as? [String] ?? ["Success"]
                    self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                    self.removeSpinner()
                    NotificationCenter.default.post(name: Notification.Name("updateAnalytics"), object: nil, userInfo: ["Analytics":jsonResponse])
                    self.dismiss(animated: false, completion: nil)
                }
                
            }
        }
    }
}
