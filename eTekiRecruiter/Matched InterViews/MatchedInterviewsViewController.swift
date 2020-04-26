//
//  MatchedInterviewsViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 05/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import Cosmos
class MatchedInterviewsViewController: BaseViewController {
    
    @IBOutlet weak var interviewsTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var noDataView: UIView!

    var interViewsDetails = [[String : Any]]()
    var interviewsAPI : InterviewsAPIProtocol.Type =  InterviewsAPI.self
    var jobID = ""
    var interViewId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        getMatchedInterviews()
        noDataView.isHidden = false
        interviewsTableView.isHidden = true
        //self.interviewsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

    }

    func setUpView() {
        interviewsTableView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        interviewsTableView.clipsToBounds = true
        interviewsTableView.layer.borderWidth = 1
        interviewsTableView.layer.cornerRadius = 10
        self.setUpNavigationBar()
        jobTitle.roman(size: 16)
    }
    
    @IBAction func backAction(_ sender: Any) {
    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.matchedInterviewsToInterViewerProfile {
            let navVC = segue.destination as? UINavigationController
            if let interviewerProfileController = navVC?.viewControllers.first as? MatchedInterviewersProfileViewController {
                interviewerProfileController.interViewerId = self.interViewId
            }
        }
    }

}

//MARK: - Get Matched Interviewers data
extension MatchedInterviewsViewController {
    func getMatchedInterviews() {
        generateEventLogToAnalytics(eventName: "Interviewers List Event", status: "True")
        self.showSpinner()
        self.interviewsAPI.getMatchedInterviews(jobDetails: JobsManager(jobID: self.jobID)) { (response, errorResponse) in
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                DispatchQueue.main.async {
                    
                    var totalCount = 0
                    if let interViews = response?["interviewers"] as? [[String : Any]] {
                        self.interViewsDetails = interViews
                        totalCount = interViews.count
                        if interViews.count == 0 {
                            self.noDataView.isHidden = false
                            self.interviewsTableView.isHidden = true
                        } else {
                            self.noDataView.isHidden = true
                            self.interviewsTableView.isHidden = false
                        }
                    }
                    
                    
                    if let jobTitle = response?["title"] as? String {
                        self.jobTitle.text = jobTitle
                        self.navigationItem.title =  MatchedInterviewers.MatchedInterviewers + "(\(totalCount))"
                    }
                    self.interviewsTableView.reloadData()
                    self.removeSpinner()
                }
            }
        }
    }
}

//MARK: - Setup Matched Interviewers Table view
extension MatchedInterviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return interViewsDetails.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = interviewsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.interviewers) as! MatchedInterviewsCell
         if interViewsDetails.count > 0 {
             let details = interViewsDetails[indexPath.row]
             if let name = details["name"] as? String{
                 cell.fullNameLabel.text = name
             }
             if let title = details["title"] as? String{
                 cell.designationLabel.text = title
             }
             if let skills = details["skillset"] as? String{
                 cell.skillsLabel.text = skills
             }
             
             if let bio = details["bio"] as? String{
                 cell.bioLabel.text = bio
             }

             if let level = details["level"] as? String{
                if level == MatchedInterviewers.certified  {
                    cell.badgeImageView.image = UIImage(named: Assets.blueBadge)
                } else if(level == MatchedInterviewers.trained){
                    cell.badgeImageView.image = UIImage(named: Assets.orangeBadge)
                 } else {
                     cell.badgeImageView.image = UIImage(named: "")
                 }
             }
             
             if let profilePic = details["profile_pics"] as? Dictionary<String,String> {
                 
                 if let profileStr = profilePic["profile_thumb_url"] {
                    cell.interviewerImage.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: Assets.noImage))
                     cell.interviewerImage.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
                 }
             }
             if let starRating = details["rating"] as? Double{
                 DispatchQueue.main.async {
                     cell.ratingView.rating = starRating
                     cell.ratingView.text = "\(Float(round(starRating*10)/10))"
                 }
             }
         }
        cell.fullNameLabel.bold(size: 18)
        cell.designationLabel.light(size: 16)
        cell.bioLabel.light(size: 14)
        cell.skillsLabel.light(size: 14)
         return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let details = interViewsDetails[indexPath.row]
         if let id = details["id"] as? Int {
             self.interViewId = "\(id)"
         }
         DispatchQueue.main.async {
             self.performSegue(withIdentifier: StoryboardSegueIdentifiers.matchedInterviewsToInterViewerProfile, sender: self)
         }
     }
}
