//
//  CandidateDetailsViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 06/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [[String : Any]]()
    var sectionData1 = [Any]()
}

class CandidateDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var detailsTableView: UITableView!
    let documentInteractionController = UIDocumentInteractionController()
    var fileURL = URL(string: "")
    var candidateDetailsResponse = [String:Any]()
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var candidateName: String = ""
    var availibilityStatus = false
    var interviewsStatus = false
    var tableViewData = [cellData]()
    var mainCell: DetailsTableViewCell!
    var id = Int()
    var detailsArray = Dictionary<String, Any>()
    var availbilitiesData = [Any]()
    var interViewersData = [[String : Any]]()
    var jobTitle = ""
    var detailsCount = 6
    var jobPermissions: Dictionary<String, Any> = [:]
    var candidateTimeZone = ""
    
    lazy var  editCandidateItem: Array = { () -> [UIBarButtonItem] in
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let imageView = UIImageView(frame: CGRect(x: 17.0, y: 12.5, width: 16.0, height: 19.0))
        imageView.image = UIImage(named: "edit")
        imageView.contentMode = .scaleAspectFit
        let editCandidate = UIButton(type: .custom)
        editCandidate.frame.size.width = 50.0
        editCandidate.frame.size.height = 44.0
        editCandidate.isEnabled = true
        editCandidate.addTarget(self, action: #selector(editCandidateAction(_:)), for: .touchUpInside)
        customView.addSubview(imageView)
        customView.addSubview(editCandidate)
        let item = UIBarButtonItem(customView: customView)
        return [item]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Candidate Details"
        tableViewData = [cellData(opened: true, title: "", sectionData: [],  sectionData1 : []),
                         cellData(opened: false, title: "Candidate Availability", sectionData: [],  sectionData1 : availbilitiesData),
                         cellData(opened: false, title: "Interviews (0)", sectionData: interViewersData, sectionData1 : [])]
        
        getCandidateDetails()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(tableViewData[section].opened == true){

            if(section == 0){
                return detailsCount
            } else if(section == 1) {
                if(tableViewData[section].sectionData1.count == 0) {
                    return tableViewData[section].sectionData1.count+2
                }else {
                    print(tableViewData[section].sectionData1.count+1)
                    return tableViewData[section].sectionData1.count+1
                }
            }
            else {
                if(tableViewData[section].sectionData.count == 0) {
                    return tableViewData[section].sectionData.count+2
                }else {
                    return  tableViewData[section].sectionData.count+1
                }
            }
        }
        else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            if(indexPath.section == 0){
                let cell = detailsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateDetailsCell) as? DetailsTableViewCell ?? DetailsTableViewCell()

                if let name = detailsArray["full_name"] as? String {
                    cell.candidateNameLabel.text = name
                    cell.candidateNameLabel.bold(size: 18.0)
                }
                if let contact = detailsArray["contact"] as? String {
                    cell.contactLabel.text = contact
                    cell.contactLabel.light(size: 16.0)

                }
                if let email = detailsArray["email"] as? String {
                    cell.mailLabel.text = email
                    cell.mailLabel.light(size: 16.0)
                }

                if let profilePic = detailsArray["profile_pics"] as? Dictionary <String, String> {
                    if let profileStr = profilePic["profile_thumb_url"] {
                        cell.profileImageView.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: "NoImage"))
                        cell.profileImageView.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
                        //                        cell.profileImageView.backgroundColor = AppTheme.appBackgroundColor
                    }
                } 
                if let fileURLString = detailsArray["resume"] as? String {
                    cell.documentButton.isHidden = false
                    cell.documentImageView.isHidden = false
                    let fileurl =  URL(string: fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                    if fileurl?.pathExtension == "pdf" {
                        cell.documentImageView.image = UIImage(named: "pdf_icon")
                    } else {
                        cell.documentImageView.image = UIImage(named: "document_icon")
                    }
                } else {
                    cell.documentButton.isHidden = true
                    cell.documentImageView.isHidden = true
                }
                return cell
            } else {
                let cell  = detailsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateHeader) as? DetailsTableViewCell ?? DetailsTableViewCell()
                cell.title.text = tableViewData[indexPath.section].title
                cell.title.bold(size: 18.0)
                return cell
            }
        } else {
            
            if indexPath.section == 0 {
                let cell = detailsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateAvailibilities) as? DetailsTableViewCell ?? DetailsTableViewCell()
                cell.availibilityLabel.light(size: 18.0)
                cell.availibilityLabel.textColor = AppTheme.textColor

                switch indexPath.row {
                case 1:
                    if let createdAt = detailsArray["created_at"] as? String {

                        let formatedDate = self.updateFeedBackDate(reportDueDate: createdAt)

                        cell.availibilityLabel.text = "Created At:" + " " + formatedDate
                    }

                case 2:
                    if let report_due = self.detailsArray["feedback_due_by"] as? String {

                        print(report_due)
                        let formatedDate = self.updateFeedBackDate(reportDueDate: report_due)
                        print(formatedDate)
                        cell.availibilityLabel.text = "CANDIDATE_REPORT_DUE_By".localized + " " + formatedDate
                    }
                case 3:
                    if let owner = detailsArray["owner_name"] as? String {
                        cell.availibilityLabel.text = "Candidate Owner:" + " " + owner
                    }

                case 4:
                    if let status = detailsArray["status"] as? String {
                        cell.availibilityLabel.text = "Status:" + " " + status
                    }
                case 5:

                    print("==========Details===========")
                    print(detailsArray)

                    cell.availibilityLabel.text = "Timezone:" + " " + candidateTimeZone
                case 6:
                    if(detailsCount == 6){
                        if let reason = detailsArray["withdraw_reason"] as? String {
                            cell.availibilityLabel.text = "Withdrawn Reason:" + " " + reason
                        }
                    }

                default:
                    fatalError("Unhandled case")
                }

                return cell
            }
            else if(indexPath.section == 1) {
                let cell = detailsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateAvailibilities) as? DetailsTableViewCell ?? DetailsTableViewCell()
                cell.availibilityLabel.light(size: 18.0)
                if(indexPath.row == tableViewData[indexPath.section].sectionData1.count+1) {
                    cell.availibilityLabel.text = "NO_SLOTS".localized
                    cell.availibilityLabel.textAlignment = .center
                    cell.availibilityLabel.textColor = AppTheme.placeHolderColor
                }else {
                    let availibilityDate = tableViewData[indexPath.section].sectionData1[indexPath.row-1]
                    cell.availibilityLabel.text = getfullDate(reportDueBy: availibilityDate as! String)
                    cell.availibilityLabel.textAlignment = .left
                    cell.availibilityLabel.textColor = AppTheme.textColor
                }
                return cell
            } else {
                if(indexPath.row == tableViewData[indexPath.section].sectionData.count+1) {
                    let cell = detailsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateAvailibilities) as? DetailsTableViewCell ?? DetailsTableViewCell()
                    cell.availibilityLabel.text = "NO_INTERVIEWS".localized
                    cell.availibilityLabel.textAlignment = .center
                    cell.availibilityLabel.light(size: 18.0)
                    cell.availibilityLabel.textColor = AppTheme.placeHolderColor
                    return cell
                } else {
                    let cell = detailsTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateInterViews) as? DetailsTableViewCell ?? DetailsTableViewCell()
                    
                    let interviewsData = tableViewData[indexPath.section].sectionData[indexPath.row-1]
                    
                    if let name = interviewsData["interviewers"] as? [String] {
                        if (name != []) {
                            cell.interViewerName.text = name[0]
                        } else {
                            cell.interViewerName.text = None
                        }
                    }

                    cell.interViewerName.roman(size: 14.0)
                    cell.interviewerDesignation.light(size: 18.0)
                    if let date = tableViewData[indexPath.section].sectionData[indexPath.row-1]["start_time"] as? String {
                        if (date != "<null>") {
                            cell.interviewerDesignation.text = jobTitle + " " + "(\(getfullDate(reportDueBy: date)))"
                        } else {
                            cell.interviewerDesignation.text = jobTitle
                        }
                    } else {
                        cell.interviewerDesignation.text = jobTitle
                    }
                    
                    if let status =  tableViewData[indexPath.section].sectionData[indexPath.row-1]["status"] as? String {
                        
                        cell.statusButton.setTitle("  " + status + "  " , for: .normal)
                        cell.statusButton.roman(size: 11.0)
                        if status != .completed {
                            cell.statusButton.layer.borderWidth = 1
                            cell.statusButton.layer.borderColor = AppTheme.interViewerCancelledColor.cgColor
                            cell.statusButton.setTitleColor(AppTheme.interViewerCancelledColor, for: .normal)
                        }else {
                            cell.statusButton.layer.borderWidth = 1
                            cell.statusButton.layer.borderColor = AppTheme.interViewCompletedColor.cgColor
                            cell.statusButton.setTitleColor(AppTheme.interViewCompletedColor, for: .normal)
                        }
                    }
                    
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0 && indexPath.section != 0) {
            if(tableViewData[indexPath.section].opened == true){
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0 && indexPath.row == 0){
            return 108
        }
        else {
            return UITableView.automaticDimension
        }
    }
    override func viewDidLayoutSubviews() {
        bgScrollView.contentSize = CGSize(width: view.frame.size.width, height: contentView.frame.size.height)
    }
    
    func getCandidateDetails() {
        self.showSpinner()
        let manager = CandidatesManager(candidateID: "\(id)")
        self.candidatesAPI.getCandidateDetails(candidatesManager: manager) {(response , error) in
            if(response != nil){
                
                if let detailsReponse = response {
                    self.candidateDetailsResponse =  detailsReponse
                    print(self.candidateDetailsResponse)
                }
                
                let success = response?["success"] as? Bool ?? false
                
                if success {
                    
                    if let recruitertTimeZone = response?["recruiter_time_zone"]  as? String {
                        
                        for dict in LocalCountry.timezoneList {
                            for (key,value) in dict {
                                if key == recruitertTimeZone {
                                    print("=====TIME ZONE UPDATED=======\(value)")
                                    let dict:[String:String] = [key:value]
                                    UserDefaults.standard.set(dict, forKey: "RecruiterTimeZone")
                                }
                            }
                        }
                    }
                    
                    if let details = response?["candidate"] as? Dictionary<String,Any> {
                        self.detailsArray = details
                        DispatchQueue.main.async {
                            if let title = details["job_title"] as? String {
                                self.jobTitle = title
                            }

                            if let canidateTimeZone = details["time_zone"]  as? String {

                                for dict in LocalCountry.timezoneList {
                                    for (key,value) in dict {
                                        if key == canidateTimeZone {
                                            self.candidateTimeZone = value
                                        }
                                    }
                                }
                            }
                            
                            let candidateEdit = self.jobPermissions[ContributorKeys.candidateEdit] as? Int ?? 0

                            if let jobStatus = details["job_status"] as? String {
                                if jobStatus == .active && candidateEdit.boolValue {                                    self.navigationItem.setRightBarButtonItems(self.editCandidateItem, animated: true)
                                    
                                } else {
                                    self.navigationItem.setRightBarButtonItems(self.notificationItem, animated: true)
                                }
                            }
                            
                            if let status = details["status"] as? String {
                                if(status == "Withdrawn"){
                                    self.detailsCount = 7
                                }
                            }
                            
                            if let availabilities = details["availabilities"] as? [Any] {
                                self.availbilitiesData = availabilities

                                self.tableViewData = [cellData(opened: true, title: "", sectionData: [],  sectionData1 : []),cellData(opened: false, title: "Candidate Availability", sectionData: [],  sectionData1 : self.availbilitiesData),
                                                      cellData(opened: false, title: "Interviews (0)", sectionData: [], sectionData1 : self.availbilitiesData)]
                            }
                            
                            if let interViews = details["interviews"] as? [[String : Any]] {
                                self.interViewersData = interViews
                                if let count = details["interviews_count"] as? Int {
                                    self.tableViewData = [cellData(opened: true, title: "", sectionData: [],  sectionData1 : []),
                                                          cellData(opened: false, title: "Candidate Availability", sectionData: [],  sectionData1 : self.availbilitiesData),
                                                          cellData(opened: false, title: "Interviews (\(count))", sectionData: self.interViewersData, sectionData1 : [])]
                                }
                            }
                            self.detailsTableView.reloadData()
                            self.removeSpinner()
                        }
                    }
                }
            } else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardSegueIdentifiers.candidateDetailsToEditCandidate {
            let navVC = segue.destination as? UINavigationController
            let addCandidateViewController = navVC?.viewControllers.first as? AddCandidateViewController
            addCandidateViewController?.isNavigatingFrom = .editCandidate
            addCandidateViewController?.candidateID =  "\(self.id)"
        }
    }
    
    
}

extension CandidateDetailsViewController{
    
    func getDate(reportDueBy : String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        guard let formattedDueDate = dateformatter.date(from: reportDueBy) else {return ""}
        dateformatter.dateFormat =  "dd MMM, yyyy"
        let date = dateformatter.string(from: formattedDueDate)
        return date
    }
    
    func getfullDate(reportDueBy : String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
        let convertedDate = self.convertUTCToLocalTimeZone(date: reportDueBy)
        guard let formattedDueDate = dateformatter.date(from: convertedDate) else {return ""}
        dateformatter.dateFormat =  "dd MMM yyyy, hh:mm a"
        let date = dateformatter.string(from: formattedDueDate)
        return date
    }
}


extension CandidateDetailsViewController {
    
    @IBAction func documentDowloadAction(_ sender: Any) {
        self.showSpinner()
        DispatchQueue.main.async {
            self.downloadDocument()
        }
    }
    
    func downloadDocument() {
        
        guard let candidateData = candidateDetailsResponse["candidate"] as? Dictionary<String,Any> else {
            self.removeSpinner()
            return
        }
        
        guard let fileURLString = candidateData["resume"] as? String else {
            self.removeSpinner()
            return
        }
        
        
        if let fileURL = URL(string: fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            
            self.loadFileAsync(url: fileURL) { (result,path) in
                
                if result {
                    print("File Saved at \(path)")
                    let appendString = "file://" + path
                    self.fileURL = URL(string: appendString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    DispatchQueue.main.async {
                        self.documentInteractionController.url = self.fileURL
                        self.documentInteractionController.uti = self.fileURL?.typeIdentifier ?? "public.data, public.content"
                        self.documentInteractionController.name = self.fileURL?.localizedName ?? self.fileURL?.lastPathComponent
                        self.documentInteractionController.delegate = self
                        self.documentInteractionController.presentPreview(animated: true)
                    }
                    
                    
                } else {
                    DispatchQueue.main.async {
                        self.showBanner(title: "", withMessage: "Unsupported file not saved.", style: .warning)
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeSpinner()
                }
                
            }
            
        }
    }
    
    func updateFeedBackDate(reportDueDate : String) -> String {
        let localDate = self.convertUTCToLocalTimeZone(date: reportDueDate)
        return localDate
    }
}

extension CandidateDetailsViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension CandidateDetailsViewController {
    
    @objc func editCandidateAction(_ sender: Any) {
        generateEventLogToAnalytics(eventName: "Update Candidate Event", status: "True")
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.candidateDetailsToEditCandidate, sender: self)
    }
}
