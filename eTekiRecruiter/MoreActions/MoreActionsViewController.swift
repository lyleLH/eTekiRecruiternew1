//
//  MoreActionsViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 22/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class MoreActionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moreActions = [String]()
    var jobID: String = ""
    var jobDueDate: String = ""
    var candidateID: String = ""
    var currentSelection = ""
    var activeStatus : String = ""
    var matchedInteviewsCount = 0
    var withDrawStatus : Bool = false
    var isCollaborateJob: Bool = false
    var isNotAdmin: Bool = false
    var isIndependantRecruiter : Bool = false
    var jobPermissions: Dictionary<String, Any> = [:]
    var jobTitle = ""
    var interviewsCount = 0
    var owner_name = ""
    @IBOutlet weak var actionsTableView: UITableView!
    
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //                                    if status != .withdrawn && status != .completed {
       setupMoreActions()
        
    }
    
    func setupMoreActions() {
        var ActionsWidth = 190
      if currentSelection == StoryboardIdentifiers.candidatesViewController {
        
        if activeStatus == .completed {
            moreActions = [.analytics,.editCandidate,.availability]
            
        } else if activeStatus == .scheduled {
            moreActions = [.editCandidate,.availability]
        }else if(activeStatus == .withdrawn) {
            withDrawStatus = false
            moreActions = [.revertWithdraw,.editCandidate, .availability]
        }else {
            withDrawStatus = true
            moreActions = [.withdraw,.editCandidate,.availability]
        }
        let actions = checkPermissions(moreActions: moreActions, from: "candidates")
        moreActions = actions
       } else {
        
        if activeStatus == .active {
          if(isIndependantRecruiter){
                moreActions = [.jobDetails,.editJob,.matchedInterviewers,.copyJob,.interviews]
          }else if(isCollaborateJob && isNotAdmin){
             moreActions = [.jobDetails,.contributorPermissions,.editJob,.matchedInterviewers,.copyJob,.interviews]
            ActionsWidth = 210
            let actions = checkPermissions(moreActions: moreActions, from: "dashboard")
            moreActions = actions
          }else {
                moreActions = [.jobDetails,.editContributors,.editJob,.matchedInterviewers,.copyJob,.interviews]
          }
        } else {
            if(isCollaborateJob && isNotAdmin){
                moreActions = [.jobDetails,.copyJob,.contributorPermissions,.interviews]
                 ActionsWidth = 210
                let actions = checkPermissions(moreActions: moreActions, from: "dashboard")
                moreActions = actions
            }else {
                moreActions = [.jobDetails,.copyJob,.interviews]
            }
         }
        
      }
      self.preferredContentSize = CGSize(width: ActionsWidth, height: moreActions.count * 48)
    }
    
    func checkPermissions(moreActions: Array<String>, from: String) -> Array<String>{
        let jobEdit = jobPermissions[ContributorKeys.jobEdit] as? Int ?? 0
//        let jobNotify = jobPermissions[ContributorKeys.jobNotify] as? Int ?? 0
//        let jobView = jobPermissions[ContributorKeys.jobView] as? Int ?? 0

        let candidateEdit = jobPermissions[ContributorKeys.candidateEdit] as? Int ?? 0
//        let candidateNotify = jobPermissions[ContributorKeys.candidateNotify] as? Int ?? 0
        let candidateView = jobPermissions[ContributorKeys.candidateView] as? Int ?? 0
//
        let interviewEdit = jobPermissions[ContributorKeys.interviewEdit] as? Int ?? 0
//        let interviewNotify = jobPermissions[ContributorKeys.interViewNotify] as? Int ?? 0
        let interviewView = jobPermissions[ContributorKeys.interviewView] as? Int ?? 0
        
        var actions = moreActions
        if(from == "dashboard") {
           
            if !jobEdit.boolValue{
              if(actions.contains(.copyJob)){
                 actions.remove(object: .copyJob)
              }
              if(actions.contains(.editJob)){
                 actions.remove(object: .editJob)
              }
           }
            
            if !candidateView.boolValue && !candidateEdit.boolValue && !interviewView.boolValue && !interviewEdit.boolValue  {
                if(actions.contains(.interviews)) {
                    actions.remove(object: .interviews)
                }
            }
        }else {
            if  !candidateEdit.boolValue {
               if(actions.contains(.editCandidate)){
                  actions.remove(object: .editCandidate)
               }
               if(actions.contains(.withdraw)){
                  actions.remove(object: .withdraw)
               }
               if(actions.contains(.revertWithdraw)){
                  actions.remove(object: .revertWithdraw)
               }
            }
        }
        return actions
    }
    
    func setUpView() {
        actionsTableView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        actionsTableView.clipsToBounds = true
        actionsTableView.layer.borderWidth = 1
        actionsTableView.layer.cornerRadius = 10
        actionsTableView.layer.borderWidth = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue.destination.view.translatesAutoresizingMaskIntoConstraints = false //Temporary Fix
        let navigation = segue.destination as? UINavigationController
        navigation?.presentingViewController?.modalPresentationStyle = .fullScreen
        
        if segue.identifier == StoryboardSegueIdentifiers.moreToJobDetails {
            let navVC = segue.destination as? UINavigationController
            let jobDetailsViewController = navVC?.viewControllers.first as? JobDetailsViewController
            jobDetailsViewController?.jobID = self.jobID
        } else if segue.identifier == StoryboardSegueIdentifiers.moreToCreateJob {
            let navVC = segue.destination as? UINavigationController
            let createJobViewController = navVC?.viewControllers.first as? CreateJobViewController
            createJobViewController?.isNavigatingFrom = self.currentSelection
            createJobViewController?.jobID =  self.jobID
        } else if segue.identifier == StoryboardSegueIdentifiers.moreToEditCandidate {
            let navVC = segue.destination as? UINavigationController
            let addCandidateViewController = navVC?.viewControllers.first as? AddCandidateViewController
            addCandidateViewController?.isNavigatingFrom = self.currentSelection
            addCandidateViewController?.candidateID =  self.candidateID
        } else if segue.identifier == StoryboardSegueIdentifiers.moreToWithdrawn {
            let navVC = segue.destination as? WithDrawnViewController
            navVC?.candidateId = candidateID
            navVC?.status = withDrawStatus
            navVC?.isNavigatingFrom = "moreActions"
            //let analyticsViewController = navVC?.viewControllers.first as? WithDrawnViewController
        }  else if segue.identifier == StoryboardSegueIdentifiers.moreToAnalytics {
            let navVC = segue.destination as? UINavigationController
            let analyticsViewController = navVC?.viewControllers.first as? AnalyticsViewController
            analyticsViewController?.candidateID =  self.candidateID
            analyticsViewController?.isNavigatingFrom = "moreActions"
        }else if segue.identifier == StoryboardSegueIdentifiers.moreToCandidateAvailabilty {
            let navVC = segue.destination as? UINavigationController
            let provideAvailabilty = navVC?.viewControllers.first as? ProvideAvailabiltyViewController
            provideAvailabilty?.jobID = "\(jobID)"
            provideAvailabilty?.candidateID = "\(candidateID)"
            provideAvailabilty?.isNavigatingFrom = StoryboardSegueIdentifiers.moreToCandidateAvailabilty
        }else if segue.identifier == StoryboardSegueIdentifiers.moreToMatchedInterviews {
            let navVC = segue.destination as? UINavigationController
            let matchedInterviews = navVC?.viewControllers.first as? MatchedInterviewsViewController
            matchedInterviews?.jobID = "\(jobID)"
        }else if segue.identifier == StoryboardSegueIdentifiers.moreToEditContributors {
            let navVC = segue.destination as? UINavigationController
            let contributorSettings = navVC?.viewControllers.first as? ContributorSettingsViewController
            contributorSettings?.jobID = "\(jobID)"
            contributorSettings?.isNavigatingFrom = StoryboardSegueIdentifiers.moreToEditContributors
        }else if segue.identifier == StoryboardSegueIdentifiers.dashboardToContributorPermissions {
            let navVC = segue.destination as? ContributorPermissionsViewController
            navVC?.jobPermissions = self.jobPermissions
        }
    }
    
}

extension MoreActionsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.moreActionsCell, for: indexPath) as! MoreActionsCell
        cell.actionLabel.text = moreActions[indexPath.row] as String
        cell.actionLabel.light(size: 18.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            let cell = tableView.cellForRow(at: indexPath) as? MoreActionsCell
            
            if let selectedString = cell?.actionLabel.text {
                
                switch selectedString {
                    
                case .editJob:
                    self.currentSelection = .editJob
                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToCreateJob, sender: self)
                    
                case .copyJob:
                    self.currentSelection = .copyJob
                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToCreateJob, sender: self)
                    
                case .myContributorJobs:
                    print("Edit contributors in progress")
                    
                case .editContributors:
                    
                    print("InProgress")

                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToEditContributors, sender: self)
                    
                case .jobDetails:
                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToJobDetails, sender: self)
                    
                case .availability:
                    
                    if self.activeStatus == "Withdrawn" || self.activeStatus == .completed {
                        self.showBanner(title: "", withMessage: "No Candidates to show, Candidates are either withdrawn or completed.", style: .warning)
                        return

                    }
                    
                    self.generateEventLogToAnalytics(eventName: "Availibility Remove Event", status: "True")
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = Formats.dateFormat
                    let date = self.jobDueDate.changeDate(self.jobDueDate)
                    if(date.toDate() >= formatter.string(from: Date()).toDate()) {
                        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToCandidateAvailabilty, sender: self)
                    }else {
                        self.showBanner(title: "", withMessage: .jobDueDateExpiredAvailibity, style: .warning)
                    }       
                    
                case .analytics:
                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToAnalytics, sender: self)
                    
                case .editCandidate:
                    
                    if self.candidateID != "" {
                        self.currentSelection = .editCandidate
                        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToEditCandidate, sender: self)
                    } else {
                        print("Invalid candidate id")
                    }
                case .withdraw:
                    self.currentSelection = .analytics
                    self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToWithdrawn, sender: self)
                case .revertWithdraw:
                    self.generateEventLogToAnalytics(eventName: "Revert Withdraw Event", status: "True")
                    NotificationCenter.default.post(name: Notification.Name("updateCandidates"), object: nil, userInfo:["candidateId": self.candidateID , "withdrawStatus" : self.withDrawStatus, "requestType" : "revertWithdraw"])
                    self.dismiss(animated: false, completion: nil)
                    
                case .matchedInterviewers:
                    
                    if self.matchedInteviewsCount == 0 {
                        self.showBanner(title: "", withMessage: .noMatchedInterviews, style: .warning)
                    } else {
                        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToMatchedInterviews, sender: self)
                    }
                    
                case .interviews :
                    
                    NotificationCenter.default.post(name: Notification.Name("MyInterviews"), object: nil, userInfo:["jobId": self.jobID , "title" : self.jobTitle, "isCollaborate" : self.isCollaborateJob, "permissions": self.jobPermissions, "interviewsCount": self.interviewsCount, "ownerName": self.owner_name])
                    self.dismiss(animated: false, completion: nil)
                
                case .contributorPermissions :
                     self.performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToContributorPermissions, sender: self)
                    
                default: self.performSegue(withIdentifier: StoryboardSegueIdentifiers.moreToJobDetails, sender: self)
                    
                }
                
            }
            
            
        }
        
    }
    
}
