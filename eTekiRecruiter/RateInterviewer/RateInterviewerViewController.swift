//
//  RateInterviewerViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 08/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import Cosmos

class RateInterviewerViewController: BaseViewController {
    @IBOutlet weak var interviewerTitle: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var ratingInterviewerView: UIView!
    @IBOutlet weak var feedBackView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var reviewTitleField: PaddingTextField!
    @IBOutlet weak var interviewerName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var jobTitleHeader: UILabel!
    @IBOutlet weak var rateInterviewerHeader: UILabel!
    @IBOutlet weak var feedbackHeader: UILabel!

    
    var interviewMemberID = ""
    var interviewID = ""
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView(viewName: detailsView)
        setUpView(viewName: ratingInterviewerView)
        setUpView(viewName: feedBackView)
        self.profileImage.makeRounded()
        self.jobTitle.text = None
        self.ratingView.text = ""
        reviewTitleField.setFontforTextFieldPlaceHolder(customfont: UIFont(name: APPFonts.lightFont, size: 17) ?? UIFont(), placeholderString: "Review Title*", color: AppTheme.placeHolderColor)
        reviewTitleField.textColor = AppTheme.textColor
        commentTextView.textColor = AppTheme.placeHolderColor
        commentTextView.delegate = self
        commentTextView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.setUpNavigationBar()
        setUpViewFonts()
        
        self.getViewInterviewerRatingDetails()
    }
    
    func setUpViewFonts() {
        self.interviewerName.bold(size: 18)
        self.jobTitle.roman(size: 18)
        self.reviewTitleField.light(size: 16)
        self.commentTextView.light(size: 16)
        self.jobTitleHeader.roman(size: 12)
        self.rateInterviewerHeader.bold(size: 16)
        self.feedbackHeader.bold(size: 16)
        self.submitButton.bold(size: 18)
    }
    
    func getViewInterviewerRatingDetails() {
        
        self.showSpinner()
        
        self.candidatesAPI.getViewInterviewerRating(candidateManger: CandidatesManager(interviewID: self.interviewID))  {(response , error) in
            if(response != nil) {
                let success = response?["success"] as? Bool ?? false
                if(success){
                    DispatchQueue.main.async {
                        
                        if let interviewRating = response?["interviewer_rating"] as? Dictionary<String, Any> {
                            if let memberID = interviewRating["interview_member_id"] as? Int{
                                self.interviewMemberID = "\(memberID)"
                            }
                            if let interviewerName = interviewRating["name"] as? String{
                                self.interviewerName.text = interviewerName
                            }
                            
                            self.interviewerTitle.text = ""
                            
                            if let reviewTitle = interviewRating["title"] as? String{
                                // Set Interview Title here
                                self.reviewTitleField.text = reviewTitle
                            }
                            
                            if let feedBackNote = interviewRating["note"] as? String{
                                                         // Set Interview Title here
                                  self.commentTextView.text = feedBackNote
                                
                            }
                            
                            if let rating =  interviewRating["rating"] as? Double {
                                self.ratingView.rating = rating
                                self.ratingView.text = "\(rating)"
                            }
                            
                            if let ratingPresent =  interviewRating["rating_present"] as? Bool {
                                    
                                if ratingPresent {
                                    self.enableFields(value: false)
                                    self.commentTextView.textColor = AppTheme.textColor
                                    self.submitButton.alpha = 0.5

                                } else {
                                    self.enableFields(value: true)
                                    self.submitButton.alpha = 1.0
                                }
                            }
                            
                            
                            if let profilePic = interviewRating["profile_urls"] as? Dictionary<String,String> {
                                if let profileStr = profilePic["profile_thumb_url"] {
                                    self.profileImage.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: "NoImage"))
                                    self.profileImage.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
                                }
                            }
                        }
                        
                        if let job = response?["job"] as? Dictionary<String, Any> {

                            if let jobTitle = job["title"] as? String {
                                    self.jobTitle.text = jobTitle
                                                         
                            }
                            
                        }
                        
                        self.removeSpinner()
                        
                    }
                } else {
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
    
    
    
    func setUpView(viewName: UIView){
        viewName.layer.borderWidth = 1
        viewName.layer.cornerRadius = 3
        viewName.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if(ratingView.rating == 0) {
            showValidationMessage(message: "Rating can't be blank")
        } else if(self.reviewTitleField.text?.trimSpace(str: self.reviewTitleField.text ?? "") == "") {
            showValidationMessage(message: "Review Title can't be blank")
        } else if(self.commentTextView.text.trimSpace(str: self.commentTextView.text) == "" || commentTextView.text == "Enter Comment*"){
            showValidationMessage(message: "Comments can't be blank")
        } else {
            submitRating()
            //            showBanner(title: "", withMessage: "Rating submitted", style: .success)
            //            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func submitRating(){
        let manager = CandidatesManager(rating: self.ratingView?.rating ?? 0, title: self.reviewTitleField.text ?? "", note: self.commentTextView.text, interviewMemberId: self.interviewMemberID)
        
        candidatesAPI.postInterviewerRating(candidateManger: manager) {(response , error) in
            
            if(response != nil) {
                let success = response?["success"] as? Bool ?? false
                if(success){
                    DispatchQueue.main.async {
                        let successMessage = response?["message"] as? [String] ?? ["Success"]
                        self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                        self.removeSpinner()
                        NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
                        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func showValidationMessage(message: String){
        showBanner(title: "", withMessage: message, style: .warning)
    }
}

extension RateInterviewerViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == AppTheme.placeHolderColor {
            textView.text = ""
            textView.textColor = AppTheme.textColor
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Comment*"
            textView.textColor = AppTheme.placeHolderColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func enableFields(value : Bool) {
        commentTextView.isEditable = value
        reviewTitleField.isUserInteractionEnabled = value
        ratingView.isUserInteractionEnabled = value
        submitButton.isUserInteractionEnabled = value
        submitButton.isEnabled = value
    }
    
}

