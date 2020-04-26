//
//  FeedbackViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 10/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController {
     
    @IBOutlet weak var commentsTableView: UITableView!
    var interviewCode = ""
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var comments = [Dictionary<String,Any>]()
    var interviewReportId = ""
    var grievancePeriodValue = Bool()
    var reportStatus = ""
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var addCommentButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsTableView.backgroundColor = AppTheme.appBackgroundColor
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: true)
        noCommentsLabel.light(size: 18)
        self.noCommentsLabel.isHidden = false
        self.commentsTableView.isHidden = true
        self.noCommentsLabel.backgroundColor = AppTheme.appBackgroundColor
        addCommentButton.bold(size: 18)
        self.getComments()
        setUpNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    // Listing all comments api call
    func getComments() {
      self.showSpinner()
      let manager = CandidatesManager(interviewCode: self.interviewCode)
      candidatesAPI.getReportViewDetails(candidateManger: manager) {(response , error) in

                 if(response != nil) {
                     let success = response?["success"] as? Bool ?? false
                     if(success) {
                         DispatchQueue.main.async {
                            if let comments = response?["comments"] as? [Dictionary<String, Any>] {
                                self.comments = comments
                            }
                            if let reportID = response?["report_id"] as? Int {
                                self.interviewReportId = "\(reportID)"
                            }
                            if !self.grievancePeriodValue {
                                self.addCommentButton.isHidden = true
                                self.addCommentButton.isEnabled = false
                            }
                            
                            if self.comments.isEmpty {
                                self.commentsTableView.isHidden = true
                                self.noCommentsLabel.isHidden = false
//                                if !self.grievancePeriodValue {
//                                    self.noCommentsLabel.text = "Contact support as the 3 day window for clarifications has passed."
//                                }
                            } else {
                                self.noCommentsLabel.isHidden = true
                                self.commentsTableView.isHidden = false
                               self.commentsTableView.reloadData()
                            }
                            
                            if let status = response?["report_status"] as? String {
                                self.reportStatus = status
                            }
                            
                            self.removeSpinner()
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
    
    
    
    // Click on add comment Button action
    @IBAction func addCommentAction(_ sender: Any) {
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.feedbackToWithdrawn, sender: nil)
    }
    
    //Navigating from Feedback Controller to Withdrawn controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.feedbackToWithdrawn {
            NotificationCenter.default.addObserver(self, selector: #selector(reloadComments(notfication:)), name: Notification.Name("reloadComments"), object: nil)
            if let navVc = segue.destination as? AddCommentViewController {
                navVc.isNavigatingFrom = RevertReport.addComment
                navVc.interviewReportId = self.interviewReportId
                navVc.report_status = self.reportStatus
            }
        }
    }
    
    @objc func reloadComments(notfication: NSNotification) {
        self.getComments()
       NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadComments"), object: nil)
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

// MARK: - Comments list Datasource and Delegates
extension FeedbackViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // loading comments and its data into table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.feedbackTableViewCell) as? FeedbackTableViewCell ?? FeedbackTableViewCell()
        cell.layer.borderWidth = 1
        cell.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        cell.layer.cornerRadius = 5
        let data = self.comments[indexPath.section]
        cell.candidateName.text = data["commented_by"] as? String ?? None
        cell.designation.text = data["default_role"] as? String ?? None
        cell.dueDate.text = self.convertUTCToLocalTimeZoneOfComments(date: data["created_at"] as? String ?? "N/A")
        cell.comment.text = data["content"] as? String ?? None
        if let profilePic = data["profile_urls"] as? Dictionary<String,String> {
            
            if let profileStr = profilePic["profile_thumb_url"] {
                cell.profileImage.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: "NoImage"))
                cell.profileImage.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
                cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
                cell.profileImage.clipsToBounds = true
            }
        }
        
        cell.candidateName.bold(size: 16)
        cell.designation.light(size: 14)
        cell.comment.light(size: 14)
        cell.dueDate.light(size: 12)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 8))
        view.backgroundColor = AppTheme.appBackgroundColor

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}

extension FeedbackViewController {
    func convertUTCToLocalTimeZoneOfComments(date: String) -> String {
              let dateformatter = DateFormatter()
              dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
              let convertedDate = self.convertUTCToLocalTimeZone(date: date)
              guard let formattedDueDate = dateformatter.date(from: convertedDate) else {return "N/A"}
              dateformatter.dateFormat =  "dd MMM, yyyy hh:mm a"
              let date = dateformatter.string(from: formattedDueDate)
              return date
    }
}
