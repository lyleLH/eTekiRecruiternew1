//
//  MatchedInterviewersProfileViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 10/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class MatchedInterviewersProfileViewController: BaseViewController {

    @IBOutlet weak var interViewertableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    var details = [String]()
    var interViewerId = ""
    var interviewsAPI : InterviewsAPIProtocol.Type =  InterviewsAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        details = [MatchedInterviewers.summary,None,MatchedInterviewers.yearsofExperience,None, MatchedInterviewers.priorInterviewingExperience,None,MatchedInterviewers.skills,None,MatchedInterviewers.languages,None,""]
        setUpNavigationBar()
        getInterViewerProfileDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Get Matched Interviewers Profile Details
extension MatchedInterviewersProfileViewController {
    
   func getInterViewerProfileDetails(){
       self.showSpinner()
       self.interviewsAPI.getInterviewerProfile(jobDetails: JobsManager(interViewerID: self.interViewerId)) { (response, errorResponse) in
           if errorResponse != nil {
               guard let message = errorResponse?.message else {return}
               self.handleErrorResponse(message: message)
           } else {
               if let interViews = response?["interviewer_details"] as? [String : Any] {
                   DispatchQueue.main.async {
                       let cell = self.interViewertableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InterviewerProfileTableViewCell
                       if let name = interViews["name"] as? String {
                           cell?.nameLabel.text = name
                       }
                    cell?.nameLabel.bold(size: 18)
                       if let title = interViews["title"] as? String {
                           cell?.designationLabel.text = title
                       }
                    cell?.designationLabel.light(size: 16)
                       if let level = interViews["level"] as? String{
                        if(level == MatchedInterviewers.certified) {
                            cell?.badgeImage.image = UIImage(named: Assets.blueBadge)
                        }else if(level == MatchedInterviewers.trained){
                            cell?.badgeImage.image = UIImage(named: Assets.orangeBadge)
                           }
                       }
                       if let profilePic = interViews["profile_pics"] as? Dictionary<String,String> {
                                  if let profileStr = profilePic["profile_thumb_url"] {
                                    cell?.profileImage.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: Assets.noImage))
                                   cell?.profileImage.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
                                  }
                       }
                       if let starRating = interViews["candidate_rating"] as? Double {
                          DispatchQueue.main.async {
                             cell?.ratingView.rating = starRating
                             cell?.ratingView.text = "\(Float(round(starRating*10)/10))"
                           }
                       }
                       let cell1 = self.interViewertableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? InterviewerProfileTableViewCell
                       if let noOfInterviews = interViews["interviews_count"] as? Int{
                           cell1?.noOfInterviews.text = "\(noOfInterviews)"
                       }
                    cell1?.interviewsHeader.light(size: 11)
                    cell1?.noOfInterviews.roman(size: 18)
                    
                       if let completedInterviews = interViews["completed_interviews"] as? Int{
                           cell1?.completedInterviews.text = "\(completedInterviews)"
                       }
                    cell1?.completedHeader.light(size: 11)
                    cell1?.completedInterviews.roman(size: 18)
                    
                       if let cancelledInterviews = interViews["cancelled_interviews"] as? Int{
                           cell1?.cancelledInterviews.text = "\(cancelledInterviews)"
                       }
                    cell1?.cancelledHeader.light(size: 11)
                    cell1?.cancelledInterviews.roman(size: 18)
                    
                       if let noShowCount = interViews["no_shows_count"] as? Int{
                           cell1?.noShowsCount.text = "\(noShowCount)"
                       }
                    cell1?.noshowsHeader.light(size: 11)
                    cell1?.noShowsCount.roman(size: 18)
                    
                       if let summary = interViews["bio"] as? String {
                           self.details[1] = summary
                       }
                       if let experience = interViews["years_of_experience"] as? Int{
                           self.details[3] = "\(experience) " + "Years"
                       }
                       
                       if let priorExperience = interViews["prior_interviews"] as? Int{
                           if(priorExperience > 0){
                             self.details[5] = Yes
                           } else {
                               self.details[5] = No
                           }
                       }
                       if let skills = interViews["skillset"] as? Array<String>  {
                           var skillSet = ""
                           for i in 0..<skills.count {
                               skillSet = skillSet + ", " + skills[i]
                           }
                           skillSet.remove(at: skillSet.startIndex)
                           skillSet.remove(at: skillSet.startIndex)
                            self.details[7] = skillSet
                       }
                       if let languageSet = interViews["language_proficiencies"] as? [[String: Any]] {
                           var languages = ""
                           for i in 0..<languageSet.count{
                               if let languageObject = languageSet[i] as? [String: Any]{
                                   if let language = languageObject["language"] as? String {
                                       languages = languages + ", " + language
                                   }
                                   if let proficiency = languageObject["proficiency"] as? String {
                                       languages = languages  + "(\(proficiency))"
                                   }
                               }
                           }
                            languages.remove(at: languages.startIndex)
                            languages.remove(at: languages.startIndex)
                           self.details[9] = languages
                       }
                   }
               }
               DispatchQueue.main.async {
                   self.interViewertableView.reloadData()
                   self.removeSpinner()
               }
           }
       }
   }

}

//MARK: - Setup Matched Interviewers Profile Table view
extension MatchedInterviewersProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = interViewertableView.dequeueReusableCell(withIdentifier: CellIdentifiers.profile) as? InterviewerProfileTableViewCell
            return cell!
        }
        else if(indexPath.row == 1){
            let cell = interViewertableView.dequeueReusableCell(withIdentifier: CellIdentifiers.interviewers) as? InterviewerProfileTableViewCell
            return cell!
        }else {
            if(indexPath.row%2 == 0){
                if(indexPath.row != 12){
                    let cell = interViewertableView.dequeueReusableCell(withIdentifier: CellIdentifiers.details) as? InterviewerProfileTableViewCell
                    cell?.titleLabel.text = details[indexPath.row-2]
                    cell?.titleLabel.bold(size: 16)
                  return cell!
                } else {
                    let cell = interViewertableView.dequeueReusableCell(withIdentifier: CellIdentifiers.borderlabel) as? InterviewerProfileTableViewCell
                    return cell!
                }
            } else {
                let cell = interViewertableView.dequeueReusableCell(withIdentifier: CellIdentifiers.content) as? InterviewerProfileTableViewCell
                cell?.detailsLabel.text = details[indexPath.row-2]
                cell?.detailsLabel.light(size: 16)
                return cell!
            }
       }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 93
        }else if(indexPath.row == 1){
            return 78
        } else {
            if(indexPath.row != 12){
              return UITableView.automaticDimension
            }else {
                return 18
            }
        }
    }
    
}
