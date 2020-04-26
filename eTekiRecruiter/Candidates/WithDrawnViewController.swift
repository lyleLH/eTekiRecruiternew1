//
//  WithDrawnViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 05/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class WithDrawnViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var reasonTextView: UITextView!
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var candidateId : String = ""
    var status : Bool = false
    var isNavigatingFrom = ""
    var placeholder = ""
    var interviewReportId = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var withdrawnButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonTextView.layer.borderWidth = 1
        reasonTextView.layer.cornerRadius = 3
        reasonTextView.layer.borderColor = AppTheme.containerBorderColor.cgColor
        titleLabel.roman(size: 18)
        reasonTextView.light(size: 18)
        cancelButton.bold(size: 18)
        withdrawnButton.bold(size: 18)
        if(isNavigatingFrom != "cancelConfirmed"){
          view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
          view.isOpaque = true
        } else {
            view.backgroundColor = .clear
        }
        reasonTextView.contentInset = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        reasonTextView.delegate = self
        reasonTextView.textColor = AppTheme.placeHolderColor
        if(isNavigatingFrom == "myInterviews" || isNavigatingFrom == "cancelConfirmed") {
            reasonTextView.text = "WITHDRAW_PLACEHOLDER".localized
        }else if(isNavigatingFrom == RevertReport.addComment) {
            reasonTextView.text = "Comment"
        } else {
            reasonTextView.text = "TYPE_REASON".localized
        }
        
        if(isNavigatingFrom == MyinterviewsStatus.report){
            self.withdrawnButton.setTitle("Submit", for: .normal)
            self.titleLabel.text = "Reason for Revert*"
            self.status = true
            hideSubmitButton(status: false)
        }else if(isNavigatingFrom == RevertReport.addComment){
            self.withdrawnButton.setTitle("Submit", for: .normal)
            self.titleLabel.text = RevertReport.addComment
            self.status = false
            hideSubmitButton(status: false)
        }
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 3
        containerView.layer.borderColor = AppTheme.containerBorderColor.cgColor
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelAction(_ sender: Any) {
        if(self.isNavigatingFrom == "cancelConfirmed"){
            NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }else if(self.isNavigatingFrom == StoryboardSegueIdentifiers.customAlertToCancelInterview){
            NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }else if(self.isNavigatingFrom == MyinterviewsStatus.report || self.isNavigatingFrom == RevertReport.addComment){
            self.dismiss(animated: false, completion: nil)
        } else {
           self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func withDrawnAction(_ sender: Any) {
        if(isNavigatingFrom != MyinterviewsStatus.report && isNavigatingFrom != RevertReport.addComment) {
          withdrawnJobAction()
        } else {
            revertReportAction()
        }
    }
    
    func withdrawnJobAction(){
        if(self.reasonTextView.text == "TYPE_REASON".localized || self.reasonTextView.text == "WITHDRAW_PLACEHOLDER".localized ||  self.reasonTextView.text.trimSpace(str: self.reasonTextView.text) == "") {
            self.showBanner(title: "", withMessage: "Reason can't be blank" , style: .warning)
        } else {
            print(candidateId)
            let manager = CandidatesManager(withdrawReason: reasonTextView.text, candidateID: candidateId, withdrawStatus: true)
            self.showSpinner()
            self.candidatesAPI.withdrawCandidate(candidatesManager: manager) {(response , error) in
             if(response != nil) {
               let success = response?["success"] as? Bool ?? false
                if(success){
                    let successMessage = response?["message"] as? [String] ?? ["Success"]
                    DispatchQueue.main.async {
                        self.showBanner(title: "", withMessage: successMessage[0] , style: .success)
                        self.removeSpinner()
                        if(self.isNavigatingFrom == "myInterviews"){
                             NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
                        }else if(self.isNavigatingFrom == "cancelConfirmed"){
                            NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
                            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                        }else if(self.isNavigatingFrom == StoryboardSegueIdentifiers.customAlertToCancelInterview){
                                NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
                                self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                        }else {
                            NotificationCenter.default.post(name: Notification.Name("updateCandidates"), object: nil, userInfo:["requestType": "withdrawn"])
                        }
                     self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                     }
                }else {
                   DispatchQueue.main.async {
                      self.removeSpinner()
                      self.showBanner(title: "", withMessage: error?.message ?? "Server error", style: .danger)
                   }
                }
             }else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
            }
        }
    }
    
    func revertReportAction(){
        if(self.reasonTextView.text == "TYPE_REASON".localized ||  self.reasonTextView.text == "Comment" || self.reasonTextView.text.trimSpace(str: self.reasonTextView.text) == "") {
            if(self.reasonTextView.text == "Comment"){
                self.showBanner(title: "", withMessage: "Comment can't be blank" , style: .warning)
            } else {
              self.showBanner(title: "", withMessage: "Reason can't be blank" , style: .warning)
            }
        } else {
          self.showSpinner()
            let manager = CandidatesManager(interviewReportId: self.interviewReportId, content: self.reasonTextView.text, revertStatus: self.status)
          candidatesAPI.revertReport(candidateManger: manager){(response , error) in
           if(response != nil) {
             let success = response?["success"] as? Bool ?? false
              if(success){
                  let successMessage = response?["message"] as? [String] ?? ["Success"]
                  DispatchQueue.main.async {
                      self.showBanner(title: "", withMessage: successMessage[0] , style: .success)
                       
                    if self.isNavigatingFrom == RevertReport.addComment {
                        NotificationCenter.default.post(name: Notification.Name("reloadComments"), object: nil, userInfo: nil)
                    } else {
                        if let status = response?["interview_report_status"] as? String {
                          NotificationCenter.default.post(name: Notification.Name("revertedStatus"), object: nil, userInfo: ["status": status])
                        }
                    }
                      self.removeSpinner()
                      self.dismiss(animated: false, completion: nil)
                   }
              }else {
                 DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showBanner(title: "", withMessage: error?.message ?? "Server error", style: .danger)
                 }
              }
           }else {
              guard let message = error?.message else {return}
              self.handleErrorResponse(message: message)
          }
          }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WithDrawnViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == reasonTextView{
            if textView.textColor == AppTheme.placeHolderColor {
                textView.text = ""
                textView.textColor = AppTheme.textColor
            }
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(isNavigatingFrom == MyinterviewsStatus.report || isNavigatingFrom == RevertReport.addComment){
           if(textView.text == "TYPE_REASON".localized || textView.text == "Comment" || textView.text.trimSpace(str: textView.text) == ""){
              hideSubmitButton(status: false)
           } else {
              hideSubmitButton(status: true)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == reasonTextView{
            if textView.text.isEmpty {
                if(isNavigatingFrom == "myInterviews" || isNavigatingFrom == "cancelConfirmed") {
                    textView.text = "WITHDRAW_PLACEHOLDER".localized
                } else if(isNavigatingFrom == RevertReport.addComment) {
                    textView.text = "Comment"
                } else {
                    textView.text = "TYPE_REASON".localized
                }
                textView.textColor = AppTheme.placeHolderColor
            }
        }
    }
    
    func hideSubmitButton(status: Bool) {
        self.withdrawnButton.isEnabled = status
        if status {
          self.withdrawnButton.alpha = 1.0
        } else {
            self.withdrawnButton.alpha = 0.5
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
