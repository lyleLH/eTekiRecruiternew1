//
//  DashboardViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 11/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SideMenu
import DropDown
import Toast_Swift
import Amplitude
//import Toaster

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

struct interViewData {
    var opened = Bool()
    var isColloborate = Bool()
    var title = String()
    var jobId = String()
    var owner = String()
    var sectionData = [[String : Any]]()
    var permissions = [String : Any]()
}

class DashboardViewController: BaseViewController, UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource,callBackDelegate,CustomAlertDelegate {
    
    
    var jobsRefresh = UIRefreshControl()
    var interviewsRefresh = UIRefreshControl()

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var keywordsStackView: UIStackView!
    @IBOutlet weak var keyWordsTextField: UITextField!
    @IBOutlet weak var searchByButton: UIButton!
    @IBOutlet weak var anchorView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var createJob: UIButton!
    @IBOutlet weak var interViewsTableView: UITableView!
    var myInterviewData = interViewData()
    var moreActions = MoreActionsViewController()
    var selectedJobId = ""
    var currentPage = 0
    var totalCount = 0
    var searchKey = ""
    var searchText = ""
    let categoryDropDown = DropDown()
    var statusFilters = [String]()
    var filterDueDate = ""
    var jobTypes = [String]()
    var interviewTypes = [String]()
    var interviewStatusFilters = Array<Dictionary<String,Array<String>>>()
    
    var candidateStatus = ""
    var tableViewData = [interViewData]()
    var viewModel = DashBoardViewModel()
    var jobsArray = [Dictionary<String,Any>]()
    var interviewsArray = [Dictionary<String,Any>]()
    var candidatesArray = [Dictionary<String,Any>]()
    var responseArray = [Dictionary<String,Any>]()
    let datePicker  = UIDatePicker()
    var date : String = ""
    var selectedIndexPath: NSIndexPath?
    var permissions = [Dictionary<String,Any>]()
    var reloadIndexpath = IndexPath()
    var jobId = Int()
    var isNavigatingFrom = ""
    var perPage = 15
    
    @IBOutlet weak var dashboardTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupDropDowns()
        setupMyinterviewsTableView()
        self.createJob.isEnabled = true
        self.interViewsTableView.isHidden = true
        self.createJob.isUserInteractionEnabled = true

        self.loadMyJobs()

        //self.getDefaultFilters(currentTab: .myJobs)
        if UIDevice.current.userInterfaceIdiom == .pad {
            perPage = 20
        }
        self.searchButton.isEnabled = false
        self.searchButton.alpha = 0.5
        self.noDataLabel.text = "NO_JOBS_TO_DISPLAY".localized
        self.navigationItem.setLeftBarButtonItems(self.menuItem, animated: true)

        self.noDataLabel.light(size: 18.0)
        self.keyWordsTextField.light(size: 18.0)
        self.searchButton.light(size: 16.0)

        if self.appDelegate.onFirstLaunch {
            DispatchQueue.background(background: {
                //Update timezones from API.
                self.updateTimeZones()


            }, completion:{

                print("Updated Time zones")
                self.appDelegate.onFirstLaunch = false

                // when background job finished, do something in main thread
            })
        } else {
            print("Not first launch")

        }
        ToastManager.shared.isTapToDismissEnabled = true
        var style = ToastStyle()
        style.backgroundColor = AppTheme.flagColor
        style.messageFont = UIFont.appBoldFontWith(size: 16.0)
        ToastManager.shared.style = style

    }
    
    @IBAction func createJobButtonAction(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToCreateJob, sender: nil)
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        if moreActions.isBeingPresented {
            moreActions.dismiss(animated: true, completion: nil)
        }
        setNavigationBarColor(color: AppTheme.statusBarDefaultColor)
        viewModel.setUpCreateJob()
        self.navigationController?.isNavigationBarHidden = false
        self.addPullToRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updatefilters"), object: nil)
    }
    
    func setupMyinterviewsTableView() {
        let border = UIView(frame:CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 1))
        border.backgroundColor = AppTheme.fieldsBorderColor
        interViewsTableView.addSubview(border)
    }
    
    func callBackToParent() {
        self.loadDefaultJobs()
    }
    
    func customAlertToParent() {
        self.loadDefaultJobs()
    }
    
    func loadDefaultJobs() {
        currentPage = 0
        if self.jobsArray.count > 0 {
            self.jobsArray.removeAll()
            self.dashboardTableView.isHidden = true
            self.noDataView.isHidden = false
        }
        self.showSpinner()
        loadItems()
    }
    
    func loadDefaultInterviews() {
        currentPage = 0
        if self.tableViewData.count > 0 {
            self.tableViewData.removeAll()
        }
        
        if self.interviewsArray.count > 0 {
            self.interviewsArray.removeAll()
            self.interViewsTableView.isHidden = true
            self.noDataView.isHidden = false
        }
        
        self.interviewTypes.removeAll()
        self.interviewStatusFilters.removeAll()
        
        
        self.showSpinner()
        loadMyInterviews()
    }
    
    @objc func updateSavedFilters(notfication: NSNotification) {
        
        self.clearFilters()
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let filters = info["filters"] as? Array<Dictionary<String,String>>{
                
                for filter in filters {
                    if let jobtype = filter["job_type[]"] {
                        print(jobtype)
                        self.jobTypes.append(jobtype)
                    }
                    if let status = filter["status[]"] {
                        print(status)
                        self.statusFilters.append(status)
                    }
                    if let dueAt = filter["due_date[]"] {
                        print(dueAt)
                        self.filterDueDate = dueAt
                    }
                }
                //call api if we need to update UI on saved filters
                
                DispatchQueue.main.async {

                    //self.callSaveFiltersAPI()
                    self.loadMyJobs()

                }
                
            } else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("savedFilters"), object: nil)
        
    }
    
    @objc func updateInterviewFilters(notfication: NSNotification) {
        
        self.clearInterviewFilters(isFrom: "segment")
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let filters = info["interviewFilters"] as? Array<Dictionary<String,Any>>{
                for filter in filters {
                    print(filter["status_filters"])
                    if let jobtype = filter["interview_type"] as? Array<String> {
                        print(jobtype)
                        interviewTypes = jobtype
                    }
                    if let status = filter["status_filters"] as? Array<Dictionary<String,Array<String>>> {
                        print(status)
                        interviewStatusFilters = status
                    }
                }
                
                print("==================================")
                print(interviewStatusFilters)
                print(interviewTypes)
                if let data = info["interviewData"] as? [Any]{
                    if data.count != 0 {
                        self.tableViewData.removeAll()
                        self.interviewsArray.removeAll()
                        if let dataArray = data[0] as? interViewData {
                            self.myInterviewData = dataArray ?? interViewData()
                        }
                    }
                }
                self.showSpinner()
                currentPage = 0
                self.loadMyInterviews()
                
            } else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateInterviewFilters"), object: nil)
        
    }

    /*
     func callSaveFiltersAPI() {

     self.showSpinner()
     var currentTab = ""
     if self.segmentControl.selectedSegmentIndex == 0 {
     currentTab = .myJobs  //"My Jobs"
     } else if self.segmentControl.selectedSegmentIndex == 1 {
     currentTab = MyinterviewsStatus.myInterviews
     }

     JobListingAPI.saveFilters(jobDetails: JobsManager(currentTab: currentTab, status: statusFilters, currentTypes: jobTypes, closingDate: filterDueDate)) { (response, error) in

     if response?.success ?? false {
     DispatchQueue.main.async {
     self.showBanner(title: "", withMessage: response?.message ?? "Saved.", style: .success)
     self.removeSpinner()
     self.getDefaultFilters(currentTab: currentTab)
     }

     } else {
     guard let message = error?.message else {return}
     self.handleErrorResponse(message: message)
     }
     }
     }*/
    
    func clearFilters() {
        if self.jobTypes.count > 0 {
            self.jobTypes.removeAll()
        }
        
        if self.statusFilters.count > 0 {
            self.statusFilters.removeAll()
        }
        
        self.filterDueDate = ""
        
    }
    
    func clearInterviewFilters(isFrom: String) {
        if self.interviewsArray.count > 0 {
            self.interviewsArray.removeAll()
        }
        
        if self.tableViewData.count > 0 {
            self.tableViewData.removeAll()
        }
        if(isFrom != "search"){
            if self.interviewStatusFilters.count > 0 {
                self.interviewStatusFilters.removeAll()
            }
            
            if self.interviewTypes.count > 0 {
                self.interviewTypes.removeAll()
            }
        }
    }
    
    @objc func updateFilters(notfication: NSNotification) {
        
        self.showSpinner()
        self.clearFilters()
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let filters = info["filters"] as? Array<Dictionary<String,String>>{
                
                for filter in filters {
                    if let jobtype = filter["job_type[]"] {
                        print(jobtype)
                        self.jobTypes.append(jobtype)
                    }
                    if let status = filter["status[]"] {
                        print(status)
                        self.statusFilters.append(status)
                    }
                    if let dueAt = filter["due_date[]"] {
                        print(dueAt)
                        self.filterDueDate = dueAt
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.currentPage = 0
                    if self.jobsArray.count > 0 {
                        self.jobsArray.removeAll()
                        self.dashboardTableView.reloadData()
                        self.noDataView.isHidden = false
                        self.dashboardTableView.isHidden = true
                    }
                    
                    self.loadItems()
                    
                }
                
                
            } else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updatefilters"), object: nil)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == dashboardTableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if totalCount > jobsArray.count { // more items to fetch
                    self.showSpinner()
                    loadItems()
                } else {
                    self.showBanner(title: "", withMessage: "There are no more jobs to display.", style: .warning)
                }
            }
            
        } else if scrollView == interViewsTableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if totalCount > tableViewData.count { // more items to fetch
                    self.showSpinner()
                    self.loadMyInterviews()
                } else {
                    self.showBanner(title: "", withMessage: "No more Interviews to load.", style: .warning)
                }
            }
        }
    }
    
    func setupDropDowns() {
        
        // The view to which the drop down will appear on
        categoryDropDown.anchorView = self.anchorView // UIView or UIBarButtonItem
        categoryDropDown.backgroundColor = AppTheme.appBackgroundColor
        categoryDropDown.selectionBackgroundColor = AppTheme.brandColor
        
        self.keyWordsTextField.isUserInteractionEnabled = false
        
        categoryDropDown.customCellConfiguration = {(index, text, cell) in
            cell.backgroundColor = AppTheme.appBackgroundColor
            cell.optionLabel.font = UIFont.appLightFontWith(size: 18.0)
        }

        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.searchByButton.setTitle(item,for: .normal)
            self.keyWordsTextField.isUserInteractionEnabled = true
            self.keywordsStackView?.isHidden = false
            self.keyWordsTextField.text = ""
            
            switch index {
            case 0:
                self.searchKey = ""
                self.searchText = ""
                self.searchByButton.setTitle(.searchBy,for: .normal)
                self.keyWordsTextField.isUserInteractionEnabled = false
                self.keywordsStackView?.isHidden = true
                self.keyWordsTextField.text = ""
                if self.segmentControl.selectedSegmentIndex == 0 {
                    self.loadDefaultJobs()
                } else if self.segmentControl.selectedSegmentIndex == 1{
                }
            case 1:
                self.searchKey = "job_title"
                self.keywordsStackView?.isHidden = false
            case 2:
                self.searchKey = "client_company_name"
                self.keywordsStackView?.isHidden = false
                
            case 3:
                self.searchKey = "recruiter_name"
                self.keywordsStackView?.isHidden = false
                
            case 4:
                self.searchKey = "candidate_name"
                self.keywordsStackView?.isHidden = false
                
            case 5:
                self.searchKey = "interviewer_name"
                self.keywordsStackView?.isHidden = false
                
                
            default: fatalError("Unhandled section \(index)")
            }
        }
    }
    
    @IBAction func reactivateJob(_ sender: UIButton) {
        let jobDetail = jobsArray[sender.tag]
        if let jobId = jobDetail["id"] as? Int {
            selectedJobId = "\(jobId)"
        }
        performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToDatePicker, sender: self)
    }
    
    @IBAction func shareJob(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.myInterviewsToShare, sender: sender)
        
    }
    
    @IBAction func searchByAction(_ sender: Any) {
        if(segmentControl.selectedSegmentIndex == 0) {
            categoryDropDown.dataSource = ["All","Job Title", "Hiring Company Name", "Recruiter Name","Candidate Name"]
        } else if(segmentControl.selectedSegmentIndex == 1) {
            categoryDropDown.dataSource = ["All","Job Title", "Hiring Company Name", "Recruiter Name","Candidate Name","Interviewer Name"]
        }
        categoryDropDown.show()
    }
    
    @IBAction func flagIconOnClick(_ sender: UIButton) {
        self.view.hideAllToasts()
        let jobDetail = jobsArray[sender.tag]
        if let ownerName = jobDetail["owner_name"] as? String {
            self.view.makeToast(ownerName, duration: 3.0, position: .center)
        }
    }
    
    @IBAction func contributorFlagOnClick(_ sender: UIButton) {
        if(tableViewData[sender.tag].isColloborate){
            self.view.hideAllToasts()
            let interviewDetails = tableViewData[sender.tag]
            let ownerName = interviewDetails.owner
            self.view.makeToast(ownerName, duration: 3.0, position: .center)
        }
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        self.view.hideAllToasts()
        currentPage = 0
        self.isNavigatingFrom = "Jobs"
        self.searchText = ""
        self.searchKey = ""
        self.searchByButton.setTitle(.searchBy,for: .normal)
        self.keyWordsTextField.isUserInteractionEnabled = false
        self.keywordsStackView?.isHidden = true
        self.keyWordsTextField.text = ""
        self.loadDataOnViewUpdate(from: "segment")
        
    }
    
    func loadDataOnViewUpdate(from: String) {
        self.noDataView.isHidden = false
        if(segmentControl.selectedSegmentIndex == 0) {
            createJob.isHidden = false
            dashboardTableView.isHidden = true
            interViewsTableView.isHidden = true
            self.searchView.isHidden = false
            categoryDropDown.dataSource = ["All","Job Title", "Hiring Company Name", "Recruiter Name","Candidate Name"]
            self.loadMyJobs()
            generateEventLogToAnalytics(eventName: "My Jobs Event", status: "True")
            //self.getDefaultFilters(currentTab: .myJobs)
            self.noDataLabel.text = "NO_JOBS_TO_DISPLAY".localized
            self.createJob.isEnabled = true
        } else if(segmentControl.selectedSegmentIndex == 1) {
            createJob.isHidden = true
            dashboardTableView.isHidden = true
            interViewsTableView.isHidden = true
            self.createJob.isEnabled = false
            self.searchView.isHidden = true
            self.keywordsStackView?.isHidden = false
            self.keyWordsTextField.isUserInteractionEnabled = true
            self.noDataLabel.text = "NO_INTERVIEWS_TO_DISPLAY".localized
            categoryDropDown.dataSource = ["All","Job Title", "Hiring Company Name", "Recruiter Name","Candidate Name","Interviewer Name"]
            currentPage = 0
            self.clearInterviewFilters(isFrom: from)
            self.showSpinner()
            self.loadMyInterviews()
        }
        
    }
    
    @IBAction func candidateAvailabiltyAction(_ sender: UIButton) {
        let jobDetail = jobsArray[sender.tag]
        let formatter = DateFormatter()
        formatter.dateFormat = Formats.dateFormat
        if let jobCloseDate = jobDetail["due_at"] as? String {
            let date = jobCloseDate.changeDate(jobCloseDate)
            if(date.toDate() >= formatter.string(from: Date()).toDate()) {
                
                if  let candidatesCount = jobDetail["candidates_count"] as? Dictionary<String,Any> {
                    if let totalCount = candidatesCount["total"] as? Int {
                        
                        guard let withdrawCount = candidatesCount["withdraw"] as? Int else {return}
                        guard let completedCount = candidatesCount["completed"] as? Int else {return}
                        
                        if (withdrawCount+completedCount) != 0 {
                            if totalCount == (withdrawCount+completedCount) {
                                self.showBanner(title: "", withMessage: "No Candidates to show, Candidates are either withdrawn or completed.", style: .warning)
                                return
                            }
                        }
                        
                        
                        if totalCount != 0 {
                            NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
                            performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToCandidateAvailabilty, sender: sender)
                        } else {
                            self.showBanner(title: "", withMessage: "NO_CANDIDATES_TO_SHOW".localized, style: .warning)
                        }
                    }
                }
            }else {
                self.showBanner(title: "", withMessage: .jobDueDateExpiredAvailibity, style: .warning)
            }
        }
        
    }
    
    @IBAction func closeJobAction(_ sender: UIButton) {
        generateEventLogToAnalytics(eventName: "Close Job Event", status: "True")
        let jobDetail = jobsArray[sender.tag]
        if let jobID = jobDetail["id"] as? Int {
            selectedJobId = "\(jobID)"
        }
        let info = ["name": "closeJob"]
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyInterviewsDashboard(notification:)), name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
        performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToCustomMessage, sender: info)

    }
    
    @IBAction func candidatesDetail(_ sender: UIButton) {
        //sender.tag = 1
        generateEventLogToAnalytics(eventName: "Candidate List Event", status: "True")
        
        let jobDetail = jobsArray[sender.tag]
        if let candidateCount = jobDetail["candidates_count"] as? Dictionary<String,Any> {
            print(candidateCount)
            if let total  = candidateCount["total"] as? Int {
                print(total)
                if total == 0 {
                    self.showBanner(title: "", withMessage: "No candidates to show.", style: .warning)
                } else {
                    candidateStatus = .all
                    NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
                    
                    performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToCandidates, sender: sender)
                }
            }
        }
        
    }
    
    
    @IBAction func completedCandidatesAction(_ sender: UIButton) {
        // sender.tag = 2
        let jobDetail = jobsArray[sender.tag]
        if let candidateCount = jobDetail["candidates_count"] as? Dictionary<String,Any> {
            print(candidateCount)
            if let completed  = candidateCount["completed"] as? Int {
                print(completed)
                if completed == 0 {
                    self.showBanner(title: "", withMessage: "No candidates to show.", style: .warning)
                } else {
                    candidateStatus = .completed
                    NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
                    performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToCandidates, sender: sender)
                }
            }
        }
    }
    
    @IBAction func pendingCandidatesAction(_ sender: UIButton) {
        //  sender.tag = 3
        let jobDetail = jobsArray[sender.tag]
        if let candidateCount = jobDetail["candidates_count"] as? Dictionary<String,Any> {
            print(candidateCount)
            if let pending  = candidateCount["pending"] as? Int {
                print(pending)
                if pending == 0 {
                    self.showBanner(title: "", withMessage: "No candidates to show.", style: .warning)
                } else {
                    candidateStatus = .pendingInterview
                    NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
                    performSegue(withIdentifier: StoryboardSegueIdentifiers.dashboardToCandidates, sender: sender)
                }
            }
        }
    }
    
    @IBAction func addCandiateAction(_ sender: UIButton) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Formats.dateFormat
        let jobDetail = jobsArray[sender.tag]
        if let jobCloseDate = jobDetail["due_at"] as? String {
            let date = jobCloseDate.changeDate(jobCloseDate)
            if(date.toDate() >= formatter.string(from: Date()).toDate()) {
                NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
                performSegue(withIdentifier: StoryboardSegueIdentifiers.candidatesToAddCandidate, sender: sender)
            }else {
                self.showBanner(title: "", withMessage: Candidates.dateExpired, style: .warning)
            }
        }
        
    }
    
    @objc func updateDashboard(notfication: NSNotification) {
        
        self.loadDefaultJobs()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("RefreshDashboard"), object: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        if keyWordsTextField.text?.count == 0 {
            self.showBanner(title: "", withMessage: "Please enter keywords to search.", style: .warning)
        } else  {
            if self.jobsArray.count > 0 {
                self.jobsArray.removeAll()
            }
            
            let buttonTitle = self.searchByButton.titleLabel?.text ?? ""
            print(buttonTitle)
            
            switch buttonTitle {
            case "Job Title":
                self.searchKey = "job_title"
            case "Hiring Company Name":
                self.searchKey = "client_company_name"
                
            case "Recruiter Name":
                self.searchKey = "recruiter_name"
                
            case "Candidate Name":
                self.searchKey = "candidate_name"
                
            case "Interviewer Name":
                self.searchKey = "interviewer_name"
                
            default:
                searchKey = ""
            }
            
            searchText = keyWordsTextField.text ?? ""
            currentPage = 0
            self.showSpinner()
            
            if self.segmentControl.selectedSegmentIndex == 0 {
                if self.jobsArray.count > 0 {
                    self.jobsArray.removeAll()
                }
                self.loadItems()
            } else if self.segmentControl.selectedSegmentIndex == 1 {
                searchKey = "keyword"
                self.interviewsArray.removeAll()
                self.tableViewData.removeAll()
                self.loadMyInterviews()
            }
        }
    }

    @IBAction func searchValueUpdate(_ sender: Any) {
        self.searchText = self.keyWordsTextField.text ?? ""
        self.searchButton.isEnabled = true
        self.searchButton.alpha = 1.0
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        keyWordsTextField.resignFirstResponder()
        if identifier == "MenuSegue"{
            return true
        }
        return true
    }
    
}

extension DashboardViewController {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToCreateJob {
            let navVC = segue.destination as? UINavigationController
            let createJob = navVC?.viewControllers.first as? CreateJobViewController
            createJob?.isNavigatingFrom = .createJob
        }
        
        // All popover segues should be popovers even on iPhone.
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceRect = button.bounds
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToCustomMessage {
            if let navVC = segue.destination as? CustomAlertViewController {
                navVC.delegate = self
                if let details = sender as? [String: Any] {
                    let jobID = details["job_id"] as? String ?? ""
                    navVC.jobId = jobID
                    self.jobId = Int(jobID) ?? 0
                    navVC.infoData = details
                    navVC.isNavigatingFrom = details["name"] as? String ?? ""
                }
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToDatePicker{
            if let navVC = segue.destination as? DatePcikerViewController {
                navVC.delegate = self
                navVC.jobId = selectedJobId
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.candidatesToAddCandidate {
            let navVC = segue.destination as? UINavigationController
            if let addCandidateViewController = navVC?.viewControllers.first as? AddCandidateViewController {
                
                if let button = sender as? UIButton {
                    
                    let jobDetail = jobsArray[button.tag]
                    if let jobID = jobDetail["id"] as? Int {
                        addCandidateViewController.jobID = "\(jobID)"
                    }
                    
                    if let isIndependentRecruiter = jobDetail["independent_recruiter"] as? Bool {
                        addCandidateViewController.isIndependentRecruiter = isIndependentRecruiter
                    }
                    
                    if let ownerName = jobDetail["owner_name"] as? String {
                        addCandidateViewController.ownerName = ownerName
                    }
                    
                    if let duedate = jobDetail["due_at"] as? String {
                        addCandidateViewController.jobClosedDate = duedate
                    }
                }
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToCandidates {
            let navVC = segue.destination as? UINavigationController
            let candidatesViewController = navVC?.viewControllers.first as? CandidatesViewController
            
            if let button = sender as? UIButton {
                
                candidatesViewController?.filterKey = self.candidateStatus
                
                let jobDetail = jobsArray[button.tag]
                
                if let jobID = jobDetail["id"] as? Int {
                    selectedJobId = "\(jobID)"
                    candidatesViewController?.jobID = "\(jobID)"
                }
                
                if let duedate = jobDetail["due_at"] as? String {
                    candidatesViewController?.jobClosingDate = duedate
                }
                
                if let jobPermissions = jobDetail["job_permissions"] as? Dictionary<String, Any>{
                    candidatesViewController?.jobPermissions = jobPermissions
                }
            }
            
            // candidatesViewController?.jobID = self.selectedJobId
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToCandidateAvailabilty {
            let navVC = segue.destination as? UINavigationController
            let provideAvailabilty = navVC?.viewControllers.first as? ProvideAvailabiltyViewController
            if let name = sender as? [String: Any] {
                if let jobID = name["id"] as? Int {
                    provideAvailabilty?.jobID = "\(jobID)"
                }
                if let candidateId = name["candidateId"] as? Int {
                    provideAvailabilty?.candidateID = "\(candidateId)"
                }
                provideAvailabilty?.isNavigatingFrom = StoryboardSegueIdentifiers.moreToCandidateAvailabilty
            } else {
                if let button = sender as? UIButton {
                    
                    let jobDetail = jobsArray[button.tag]
                    if let jobID = jobDetail["id"] as? Int {
                        selectedJobId = "\(jobID)"
                        provideAvailabilty?.jobID = "\(jobID)"
                    }
                    
                    if let duedate = jobDetail["due_at"] as? String {
                        provideAvailabilty?.jobClosedDate = duedate
                    }
                }
                provideAvailabilty?.isNavigatingFrom = "Dashboard"
            }
        }
        
        if segue.identifier == "InterviewsToRating" {
            let navVC = segue.destination as? UINavigationController
            let ratingInterviewer = navVC?.viewControllers.first as? RateInterviewerViewController
            let data = sender as? [String: Any]
            if  let interviewID = data?["interviewId"] as? Int {
              ratingInterviewer?.interviewID = "\(interviewID)"
            }
        }
        
        
        if segue.identifier == StoryboardSegueIdentifiers.myInterviewsToShare {
            let navVC = segue.destination as? UINavigationController
            
            if let shareInterview = navVC?.viewControllers.first as? ShareInterviewViewController {
                
                shareInterview.currentIndex = self.segmentControl.selectedSegmentIndex

                
                if self.segmentControl.selectedSegmentIndex == 0 {

                    if let button = sender as? UIButton {
                        let jobDetail = jobsArray[button.tag]
                        if let jobID = jobDetail["id"] as? Int {
                            shareInterview.jobID = "\(jobID)"
                        }
                    }

                } else if self.segmentControl.selectedSegmentIndex == 1 {

                    if let info = sender as? [String : Any] {
                        let jobId = info["job_id"] as? Int
                        print(info)
                        shareInterview.inteviewStatus = info["status"] as? String ?? ""
                        shareInterview.interviewCode = info["interview_code"] as? String ?? ""
                        shareInterview.jobID = "\(jobId ?? 0)"
                    }
                }
            }
            
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToReason {
            let navVC = segue.destination as? ReasonViewController
            navVC?.interviewerID =  sender  as? String ?? ""
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToAnlaytics {
            let navVC = segue.destination as? UINavigationController
            let analyticsViewController = navVC?.viewControllers.first as? AnalyticsViewController
            let data = sender as? [String: Any]
            if let id = data?["candidateId"] as? Int{
                analyticsViewController?.candidateID = "\(id)"
            }
            analyticsViewController?.isNavigatingFrom = "Dashboard"
        }

        if segue.identifier == StoryboardSegueIdentifiers.dashboardToNoshow {
            if let navVc = segue.destination as? NoshowReasonViewController{
                navVc.reason = sender as? String ?? ""
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToReportView {
            let navVC = segue.destination as? UINavigationController
            if let reportViewController = navVC?.viewControllers.first as? ReportViewController{
                if let data = sender as? [String: Any] {
                    if let code = data["interview_code"] as? String {
                        reportViewController.interviewCode = code
                    }
                }
            }
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.dashboardToShowVideos {
            let navVC = segue.destination as? UINavigationController
            if let showVideos = navVC?.viewControllers.first as? ShowVideosViewController{
                showVideos.interviewCode = sender as? String ?? ""
            }
        }
        
    }
    
    @objc func updateMyInterviewsDashboard(notification: NSNotification) {
        self.showSpinner()
        self.currentPage = 0


        if self.jobId != 0  {
            self.loadCandiatesWithInterview(jobID: "\(self.jobId)", indexPath: self.reloadIndexpath)
        } else {
                        if self.interviewsArray.count > 0 {
                            self.interviewsArray.removeAll()
                        }
            
                        if self.tableViewData.count > 0 {
                            self.tableViewData.removeAll()
                        }
                    self.loadMyInterviews()
        }
            NotificationCenter.default.removeObserver(self, name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
    }
    
}

extension DashboardViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == interViewsTableView){
            return tableViewData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == interViewsTableView {
            if tableViewData[section].opened {
                return tableViewData[section].sectionData.count+1
            }
            return 1
        } else if tableView == dashboardTableView {
            return self.jobsArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == interViewsTableView){
            if(indexPath.row == 0){
                return 60
            }else {
                return 160
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == interViewsTableView) {
            if(indexPath.row == 0){
                let cell = interViewsTableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! MyInterviewsTableViewCell
                
                if(tableViewData[indexPath.section].opened == true) {
                    cell.cellBorderLabel.isHidden = true
                    cell.dropdownImageView.image = UIImage(named: "downArrow")
                }else {
                    cell.cellBorderLabel.isHidden = false
                    cell.dropdownImageView.image = UIImage(named: "dropdownarrow")
                }
                cell.contributorFlagIcon.tag = indexPath.section
                if tableViewData[indexPath.section].isColloborate {
                    cell.flagIcon.isHidden = false
                    cell.contributorFlagIcon.isHidden = false
                    cell.contributorFlagIcon.isEnabled = true
                } else {
                    cell.flagIcon.isHidden = true
                    cell.contributorFlagIcon.isHidden = true
                    cell.contributorFlagIcon.isEnabled = false

                }
                cell.jobName.text = tableViewData[indexPath.section].title
                cell.jobName.bold(size: 18.0)

                return cell
            }else {
                let cell = interViewsTableView.dequeueReusableCell(withIdentifier: "jobs", for: indexPath) as? MyInterviewsTableViewCell ?? MyInterviewsTableViewCell()

                cell.name.bold(size: 16.0)
                cell.reportDate.light(size: 14.0)
                cell.interviewerLabel.light(size: 14.0)
                cell.interviewerLabel.textColor =  AppTheme.textColor
                cell.reportDate.textColor = AppTheme.textColor
                cell.statusButton.roman(size: 11.0)

                var candidateStatus = ""
                print(tableViewData)
                let response = tableViewData[indexPath.section].sectionData[indexPath.row-1]
                cell.dataResponse = response
                cell.sectionTitle = tableViewData[indexPath.section].title
                cell.delegate = self

                self.setupInterviewCell(cell : cell)

                if let candidate = response["candidate"] as? Dictionary<String,Any> {
                    print(candidate)
                    cell.name.text = candidate["full_name"] as? String ?? ""
                    candidateStatus = candidate["status"] as? String ?? ""
                }
                let interviewerStatus = response["status"] as? String
                
                if(interviewerStatus == MyinterviewsStatus.noShow || interviewerStatus == MyinterviewsStatus.incomplete || interviewerStatus == MyinterviewsStatus.cancelled){
                    
                    cell.statusButton.layer.borderColor = AppTheme.interViewerCancelledColor.cgColor
                    cell.statusButton.setTitleColor(AppTheme.interViewerCancelledColor, for: .normal)
                    
                } else if (interviewerStatus == MyinterviewsStatus.completed || interviewerStatus == MyinterviewsStatus.scheduled){
                    
                    cell.statusButton.layer.borderColor = AppTheme.interViewCompletedColor.cgColor
                    cell.statusButton.setTitleColor(AppTheme.interViewCompletedColor, for: .normal)
                    
                }else {
                    
                    cell.statusButton.layer.borderColor = AppTheme.interViewPendingColor.cgColor
                    cell.statusButton.setTitleColor(AppTheme.interViewPendingColor, for: .normal)
                    
                }
                let proxyStatus = response["is_proxied"] as? Bool ?? false
                if proxyStatus {
                    cell.proxyImage.isHidden = false
                } else {
                    cell.proxyImage.isHidden = true
                }
                cell.reportDate.text =  self.convertUTCToLocalTimeZone(date: response["start_time"] as? String ?? "")
                cell.statusButton.setTitle(response["status"] as? String, for: .normal)
                cell.interviewerLabel.text = (response["interviewer_name"] as? String ?? None) +  " ( Interviewer )"
                let noShowReason = response["no_show_reason"] as? String ?? ""
                let currency1 = response["currency"] as? String ?? ""

                cell.setIconsBasedonStatus(status: response["status"] as? String ?? "", permissions: tableViewData[indexPath.section].permissions, isCollaborate: tableViewData[indexPath.section].isColloborate, reason: noShowReason, currency: currency1, candidateStatus: candidateStatus, proxyStatus: proxyStatus, tag: (indexPath.section*100)+indexPath.row)

                cell.cellBorderView.layer.borderWidth = 1
                cell.cellBorderView.layer.cornerRadius = 3
                cell.cellBorderView.layer.borderColor = AppTheme.containerBorderColor.cgColor
                
                if(tableViewData[tableViewData.count-1].sectionData.count == indexPath.row && indexPath.section == tableViewData.count-1) {
                    cell.bottomBorderView.isHidden = false
                }else {
                    cell.bottomBorderView.isHidden = true
                }


                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.dashBoardTableViewCell, for: indexPath) as? DashBoardTableViewCell ?? DashBoardTableViewCell()
            
            if jobsArray.count > 0 {
                let jobDetail = jobsArray[indexPath.row]
                cell.jobTitlelabel.text = jobDetail["title"] as? String ?? ""

                cell.jobTitlelabel.bold(size: 18.0)
                cell.skillsLabel.light(size: 14.0)
                cell.closingDateLabel.roman(size: 14.0)



                let textString = jobDetail["skillset"] as? String ?? ""
                cell.skillsLabel.attributedText = textString.getAttributedString(text: textString)
                
                if let closingDate  = jobDetail["due_at"]  as? String{
                    let formatedDate = closingDate.changeCurrentDate(closingDate)
                    cell.closingDateLabel.text = "Closing Date: \(String(describing: formatedDate))"
                } else {
                    cell.closingDateLabel.text = "Closing Date: \(String(describing: "-"))"
                }
                



                
                let permissions = jobDetail["job_permissions"] as? [String : Any] ?? [String : Any]()
                let jobEdit = permissions[ContributorKeys.jobEdit] as? Int ?? 0

                let candidateEdit = permissions[ContributorKeys.candidateEdit] as? Int ?? 0
                let candidateView = permissions[ContributorKeys.candidateView] as? Int ?? 0

                let interviewEdit = permissions[ContributorKeys.interviewEdit] as? Int ?? 0
                let interviewView = permissions[ContributorKeys.interviewView] as? Int ?? 0

                setEnableStatuses(button: cell.shareButton, status: false, imageView: cell.shareImageView)
                setEnableStatuses(button: cell.candidateAvailabity, status: false, imageView: cell.calendarImageView)
                setEnableStatuses(button: cell.closeJob, status: false, imageView: cell.closeImageView)
                setEnableStatuses(button: cell.reactivateButton, status: false, imageView: UIImageView())
                setEnableStatuses(button: cell.completedButton, status: false, imageView: UIImageView())
                setEnableStatuses(button: cell.pendingButton, status: false, imageView: UIImageView())
                setEnableStatuses(button: cell.candidateDetailsButton, status: false, imageView: UIImageView())
                setEnableStatuses(button: cell.addCandidateButton, status: false, imageView: cell.addCandidateImageView)

                cell.completedCountLabel.alpha = 0.5
                cell.pendingCountLabel.alpha = 0.5
                cell.totalCountLabel.alpha = 0.5

                if jobEdit.boolValue {

                    setEnableStatuses(button: cell.shareButton, status: true, imageView: cell.shareImageView)
                    setEnableStatuses(button: cell.closeJob, status: true, imageView: cell.closeImageView)
                    setEnableStatuses(button: cell.reactivateButton, status: true, imageView: UIImageView())

                }

                if candidateView.boolValue || candidateEdit.boolValue || interviewView.boolValue || interviewEdit.boolValue {

                    setEnableStatuses(button: cell.completedButton, status: true, imageView: UIImageView())
                    setEnableStatuses(button: cell.pendingButton, status: true, imageView: UIImageView())
                    setEnableStatuses(button: cell.candidateDetailsButton, status: true, imageView: UIImageView())
                    setEnableStatuses(button: cell.candidateAvailabity, status: true, imageView: cell.calendarImageView)
                    cell.completedCountLabel.alpha = 1.0
                    cell.pendingCountLabel.alpha = 1.0
                    cell.totalCountLabel.alpha = 1.0

                }

                if candidateEdit.boolValue {

                    setEnableStatuses(button: cell.addCandidateButton, status: true, imageView: cell.addCandidateImageView)

                }



                let candidatesCount = jobDetail["candidates_count"] as? [String : Any] ?? [String : Any]()

                let count = candidatesCount["completed"] as? Int ?? 0
                cell.completedCountLabel.text = "\(count)"

                if let count = candidatesCount["pending"] {
                    cell.pendingCountLabel.text = "\(count)"
                }

                if let count = candidatesCount["total"] as? Int {
                    cell.totalCountLabel.text = "\(count)"
                    if count == 0 {
                        cell.candidateAvailabity.isEnabled = false
                        cell.calendarImageView.alpha = 0.5
                        //cell.addCandidateImageView.alpha = 0.5
                        let image1 = UIImage(named: "adduseroutline") ?? UIImage()
                        let image2 = UIImage(named: "adduserfill") ?? UIImage()
                        cell.addCandidateImageView.animationDuration = 0.5
                        cell.addCandidateImageView.animationImages = [image1,image2]
                        cell.addCandidateImageView.startAnimating()

                    } else {
                        cell.calendarImageView.alpha = 1.0
                        cell.addCandidateImageView.image = UIImage(named: "adduser")
                        if cell.addCandidateImageView.isAnimating {
                            print("Still Animating")
                            cell.addCandidateImageView.stopAnimating()
                            cell.addCandidateImageView.image = UIImage(named: "adduser")
                        }

                    }
                } else {
                    print("Unable to parse total count")
                }



                //Animate share button
                self.animateShareInterviewInMyJobs(cell: cell, completedCount: count,jobDetail: jobDetail)

                //Animate Calendar icon
                self.animateAvailabiltyInMyJobs(cell: cell, completedCount: count,jobDetail: jobDetail)

                cell.moreButton.addTarget(self, action: #selector(moreActions(_:)), for: .touchUpInside)
                cell.moreButton.tag = indexPath.row
                cell.reactivateButton.tag = indexPath.row
                cell.closeJob.tag = indexPath.row
                cell.flagIconButton.tag = indexPath.row
                cell.candidateDetailsButton.tag = indexPath.row
                cell.pendingButton.tag = indexPath.row
                cell.completedButton.tag = indexPath.row
                cell.addCandidateButton.tag = indexPath.row
                cell.candidateAvailabity.tag = indexPath.row
                cell.shareButton.tag = indexPath.row

                if jobDetail["status"] as? String ?? "" == "Active" {
                    cell.jobActionStackView.isHidden = false
                    cell.reactivateStackView.isHidden = true
                } else {
                    cell.reactivateStackView.isHidden = false
                    cell.jobActionStackView.isHidden = true
                }
                if jobDetail["collaborated_job"] as? Bool ?? false {
                    cell.flagIcon.isHidden = false
                    cell.flagIconButton.isHidden = false
                    cell.flagIconButton.isEnabled = true
                } else {
                    cell.flagIcon.isHidden = true
                    cell.flagIconButton.isHidden = true
                    cell.flagIconButton.isEnabled = false
                }
            }
            return cell
        }
    }

    func animateShareInterviewInMyJobs(cell : DashBoardTableViewCell, completedCount : Int,jobDetail : [String : Any]) {

        let interviewAccess = jobDetail["interview_access"] as? Bool ?? false

        if completedCount > 0 && interviewAccess {

            if !cell.shareButton.isEnabled {
                cell.shareImageView.image = UIImage(named: "shareborder")
            } else {
                let image1 = UIImage(named: "shareborder") ?? UIImage()
                let image2 = UIImage(named: "sharefill") ?? UIImage()
                cell.shareImageView.animationDuration = 0.5
                cell.shareImageView.animationImages = [image1,image2]
                cell.shareImageView.startAnimating()
            }

        } else {

            cell.shareImageView.image = UIImage(named: "share")
            if cell.shareImageView.isAnimating {
                print("Still Animating")
                cell.shareImageView.stopAnimating()
                cell.shareImageView.image = UIImage(named: "share")
            }
        }
    }

    func animateAvailabiltyInMyJobs(cell : DashBoardTableViewCell, completedCount : Int,jobDetail : [String : Any]) {

        if let pendingAvailabilty = jobDetail["pending_candidate_availabilities"] as? Int {

            if pendingAvailabilty == 1 {

                let image1 = UIImage(named: "calendarborder") ?? UIImage()
                let image2 = UIImage(named: "calendarfill") ?? UIImage()//add fill icon here
                cell.calendarImageView.animationDuration = 0.5
                cell.calendarImageView.animationImages = [image1,image2]
                cell.calendarImageView.startAnimating()

            } else {
                if cell.calendarImageView.isAnimating {
                    cell.calendarImageView.stopAnimating()
                    cell.calendarImageView.image = UIImage(named: "calendarAvailability")
                }
            }
        }

    }

    //MARK: TABLE VIEW CELL ANIMATION
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func setEnableStatuses(button: UIButton, status: Bool, imageView : UIImageView?){
        button.isEnabled = status
        if status {
            imageView?.alpha = 1.0
            button.alpha = 1.0
        } else {
            imageView?.alpha = 0.5
            button.alpha = 0.5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == interViewsTableView){
            print(tableViewData.count)
            if(indexPath.row == 0){
                if(tableViewData[indexPath.section].opened == true) {
                    tableViewData[indexPath.section].opened = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    selectedIndexPath =  indexPath as NSIndexPath
                    tableView.reloadSections(sections, with: .none)
                }else {
                    generateEventLogToAnalytics(eventName: "Interview Details Event", status: "True")
                    self.showSpinner()
                    let jobID = "\(tableViewData[indexPath.section].jobId)"
                    //self.currentPage = 0
                    createAnalyticsEventLog( jobName: "\(tableViewData[indexPath.section].title)")
                   // generateEventLogToAnalytics(eventName: "Interview Details Event ", status: "True")
                    self.loadCandiatesWithInterview(jobID: jobID,indexPath: indexPath)
                }
            }
        }
    }
    
    func createAnalyticsEventLog(jobName : String )  {

         let amplitudeInstance = Amplitude()
                                  amplitudeInstance.initializeApiKey("e3b77be60e7267be70c74f7e26876569")
        var params = [String:String]()
                                  //user name,user type,status
                                   amplitudeInstance.setUserProperties(params)
                                   amplitudeInstance.logEvent("Interview Details Event")
                                   params["user name"] = UserDefaults.standard.string(forKey: "displayName") ?? ""
                                   params["user type"] = UserDefaults.standard.string(forKey: "Role") ?? ""
                                   params["status"] = "True"
                                   params["jobName"] = jobName
                                   amplitudeInstance.logEvent("Interview Details Event", withEventProperties: params)

                                   amplitudeInstance.uploadEvents()
    }

    func setupInterviewCell(cell : MyInterviewsTableViewCell) {
        cell.completedRatingIcon.image = UIImage(named: "star")
        cell.canceldShowVideosIcon.image = UIImage(named: "eye")
        cell.pendingApprovalShowVideosIcon.image = UIImage(named: "eye")
        cell.pendingPaymentShowVideosIcon.image = UIImage(named: "eye")
        cell.pendingApprovalShowVideosIcon.image = UIImage(named: "eye")
        cell.inProgressShowVideosIcon.image = UIImage(named: "eye")
        cell.noshowShowVideosIcon.image = UIImage(named: "eye")
        cell.incompleteShowVideosIcon.image = UIImage(named: "eye")
    }
    
    @objc func moreActions(_ sender : UIButton) {
        moreActions = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.moreActionsViewController) as!
        MoreActionsViewController
        moreActions.modalPresentationStyle = .popover
        
        let jobDetail = jobsArray[sender.tag]
        
        if let jobID = jobDetail["id"] as? Int {
            moreActions.jobID = "\(jobID)"
        }
        
        if let matchedInterviewsCount = jobDetail["matched_interviewers_count"] as? Int {
            moreActions.matchedInteviewsCount = matchedInterviewsCount
        }
        
        if let jobStatus = jobDetail["status"] as? String {
            moreActions.activeStatus = "\(jobStatus)"
            if(jobStatus == "Inactive"){
                moreActions.preferredContentSize = CGSize(width: 200, height: 88)
            } else {
                moreActions.preferredContentSize = CGSize(width: 200, height: 280)
            }
        } else {
            print("Job Status not parsed")
        }
        
        if let collaborated_job = jobDetail["collaborated_job"] as? Bool {
            moreActions.isCollaborateJob = collaborated_job
        }
        
        if let isNotAdmin = jobDetail["is_admin"] as? Bool{
            if(isNotAdmin == false){
                moreActions.isNotAdmin = true
            } else {
                moreActions.isNotAdmin = false
            }
        }
        
        if let jobPermissions = jobDetail["job_permissions"] as? Dictionary<String, Any>{
            moreActions.jobPermissions = jobPermissions
        }
        
        if let independantRecruiter = jobDetail["independent_recruiter"] as? Bool{
            moreActions.isIndependantRecruiter = independantRecruiter
        }
        
        if let title = jobDetail["title"] as? String{
            moreActions.jobTitle = title
        }
        
        if let InterviewsCount = jobDetail["interviews_count"] as? Int {
            moreActions.interviewsCount = InterviewsCount
        }
        
        if let owner = jobDetail["owner_name"] as? String{
            moreActions.owner_name = owner
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard(notfication:)), name: Notification.Name("RefreshDashboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkTomyInterviews(notification:)), name: Notification.Name("MyInterviews"), object: nil)
        
        let ppc = moreActions.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.delegate = self
        ppc?.sourceView = sender
        present(moreActions, animated: true, completion: nil)
    }
    
    @objc func checkTomyInterviews(notification: NSNotification) {
        
        if let dataArray = notification.userInfo as? Dictionary<String, Any> {
            let count = dataArray["interviewsCount"] as? Int
            if(count != 0){
                DispatchQueue.main.async {
                    self.segmentControl.selectedSegmentIndex = 1
                    self.createJob.isHidden = true
                    self.dashboardTableView.isHidden = true
                    self.interViewsTableView.isHidden = false
                    
                    self.isNavigatingFrom = "moreActions"
                    self.searchView.isHidden = true
                    self.keywordsStackView?.isHidden = false
                    self.keyWordsTextField.isUserInteractionEnabled = true
                    self.keyWordsTextField.text = ""
                    self.searchButton.isEnabled = false
                    self.searchButton.alpha = 0.5
                    self.noDataLabel.text = "NO_INTERVIEWS_TO_DISPLAY".localized
                    
                    self.tableViewData.removeAll()
                    self.interviewsArray.removeAll()
                    self.jobsArray.removeAll()
                    DispatchQueue.main.async {
                        let id = dataArray["jobId"] as? String ?? ""
                        let title = dataArray["title"] as? String ?? ""
                        let isCollaborate = dataArray["isCollaborate"] as? Bool ?? false
                        let permissions = dataArray["permissions"] as? Dictionary<String, Any> ?? [:]
                        let ownerName = dataArray["ownerName"] as? String ?? ""
                        if(isCollaborate){
                            self.interviewTypes = []
                        } else {
                            self.interviewTypes = [.myInterviews]
                        }
                        self.interviewStatusFilters = []
                        let data = interViewData(opened: false, isColloborate: isCollaborate, title: title, jobId: id, owner: ownerName, sectionData: [[:]], permissions: permissions)
                        self.myInterviewData = data
                        self.tableViewData.append(data)
                        self.interViewsTableView.reloadData()
                    }
                }
            } else {
                self.showBanner(title: "", withMessage: "There are no interviews for this job", style: .warning)
            }
        }
        
        //self.getDefaultFilters(currentTab: .myInterviews)
        //         self.loadDefaultInterviews()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MyInterviews"), object: nil)
    }
}

extension DashboardViewController {
    
    func bindViewModel() {
        hideKeyboardWhenTappedAround()
        viewModel.segmentContoller = self.segmentControl
        viewModel.filterButton = self.filterButton
        viewModel.createJob = self.createJob
        viewModel.searchView = self.searchView
        viewModel.dashboardTableView = self.dashboardTableView
        self.noDataView.isHidden = false
        viewModel.setUpView()
    }
}

extension DashboardViewController {
    
    func loadItems() {
        currentPage = currentPage+1
        JobListingAPI.getJobs(jobDetails: JobsManager(page: "\(currentPage)", perPage: "\(15)", status: statusFilters, currentTypes: jobTypes ,searchBy: [searchKey:searchText],closingDate: filterDueDate)) { (response, error) in

            if response != nil {
                
                
                DispatchQueue.main.async {
                    
                    self.totalCount = response?["total_count"] as? Int ?? 0
                    
                    //Update recruiter time zone in Defaults.
                    if let recruitertTimeZone = response?["user_time_zone"]  as? String {

                        for dict in LocalCountry.timezoneList {
                            for (key,value) in dict {
                                if key == recruitertTimeZone {
                                    let dict:[String:String] = [key:value]
                                    UserDefaults.standard.set(dict, forKey: "RecruiterTimeZone")
                                }
                            }
                        }
                    }
                    
                    if let jobs = response?["jobs"] as? [Dictionary<String,Any>] {
                        
                        if self.responseArray.count > 0 {
                            self.responseArray.removeAll()
                        }
                        self.responseArray.append(contentsOf: jobs)
                    }
                    
                    if self.responseArray.count > 0 {
                        self.jobsArray.append(contentsOf: self.responseArray)
                    }
                    
                    
                    if self.responseArray.count == 0 {
                        self.noDataView.isHidden = false
                        self.dashboardTableView.isHidden = true
                    } else {
                        self.dashboardTableView.isHidden = false
                        self.noDataView.isHidden = true
                    }
                    
                    if self.keyWordsTextField.text == "" {
                        self.searchButton.isEnabled = false
                        self.searchButton.alpha = 0.5
                    }
                    
                    self.dashboardTableView.reloadData()
                    if self.jobsRefresh.isRefreshing {
                        self.jobsRefresh.endRefreshing()
                    }
                    self.removeSpinner()
                }
                
            } else {
                
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)   
            }
        }
    }
    
    func loadMyInterviews() {
        currentPage = currentPage+1
        print("\(currentPage)")
        
        //        if interviewStatusFilters.count == 0 {
        //            interviewStatusFilters = [.all]
        //        }
        
        if interviewTypes.count == 0 {
            interviewTypes = [.myInterviews]
        }
        
        
        
        
        JobListingAPI.getMyInterviews(jobDetails: JobsManager(page: "\(currentPage)", perPage: "\(perPage)", statusFilter: interviewStatusFilters, currentTypes: interviewTypes ,searchBy: [searchKey:searchText],closingDate: filterDueDate)) { (response, error) in
            
            if response != nil {
                
                self.totalCount = response?["total_jobs"] as? Int ?? 0
                
                if let myInterviews = response?["jobs"] as? [Dictionary<String,Any>] {
                    
                    if self.responseArray.count > 0 {
                        self.responseArray.removeAll()
                    }
                    //if(self.isNavigatingFrom != "moreActions"){
                    self.responseArray.append(contentsOf: myInterviews)
                    //                    } else {
                    //                        if self.responseArray.count > 0 {
                    //                            self.responseArray.removeAll()
                    //                        }
                    //                      if myInterviews.count != 0 {
                    //                       for i in 0..<myInterviews.count {
                    //                            if let jodid = myInterviews[i]["job_id"] as? Int{
                    //                                print(self.myInterviewData.jobId)
                    //                                print(jodid)
                    //                                if(self.myInterviewData.jobId == "\(jodid)"){
                    //                                    self.responseArray.append(myInterviews[i])
                    //                                }
                    //                            }
                    //                       }
                    //                      }
                    //                    }
                }
                
                if self.responseArray.count > 0 {
                    
                    self.interviewsArray = self.responseArray
                    //self.interviewsArray.append(contentsOf: self.responseArray)
                }
                
                DispatchQueue.main.async {
                    
                    if self.responseArray.count == 0 {
                        self.noDataView.isHidden = false
                        self.interViewsTableView.isHidden = true
                    } else {
                        self.interViewsTableView.isHidden = false
                        self.noDataView.isHidden = true
                    }
                    
                    if self.keyWordsTextField.text == "" {
                        self.searchButton.isEnabled = false
                        self.searchButton.alpha = 0.5
                    }
                    
                    self.parseInterviewData()
                    self.interViewsTableView.reloadData()
                    self.removeSpinner()
                }
                
            } else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    func loadCandiatesWithInterview(jobID : String,indexPath : IndexPath) {
        
        //currentPage = currentPage+1
        JobListingAPI.getInterviewsWithJob(jobDetails: JobsManager(page: "\(0)", perPage: "\(0)", statusFilter: interviewStatusFilters, currentTypes: interviewTypes ,searchBy: [searchKey:searchText],closingDate: filterDueDate,jobID: jobID)) { (response, error) in
            
            if response != nil {
                
                // self.totalCount = response?["total_count"] as? Int ?? 0
                self.candidatesArray.removeAll()
                if let myInterviews = response?["interviews"] as? [Dictionary<String,Any>] {
                    self.candidatesArray.append(contentsOf: myInterviews)
                }
                
                if(self.candidatesArray.count == 0){
                    self.currentPage = 0
                    self.loadMyInterviews()
                } else {
                    DispatchQueue.main.async {
                        self.parseCandidateInterviews(jobID: jobID, indexPath: indexPath)
                    }
                }
                
            } else {
                guard let message = error?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    func parseInterviewData() {
        
        for i in 0..<interviewsArray.count {
            let dict = interviewsArray[i]
            guard let title = dict["job_title"] as? String else {return}
            guard let jobID = dict["job_id"] as? Int else {return}
            guard let colloborateJob = dict["collaborated_job"] as? Int else {return}
            guard let jobPermissions = dict["job_permissions"] as? Dictionary<String,Any> else {return}
            guard let ownerName = dict["owner_name"] as? String else{return}
            
            let newJobID = "\(jobID)"
            let data = interViewData(opened: false,isColloborate: colloborateJob.boolValue, title: title, jobId: newJobID, owner: ownerName,sectionData: [], permissions: jobPermissions)
            tableViewData.append(data)
        }
    }
    
    func parseCandidateInterviews(jobID : String,indexPath : IndexPath) {
        
        print(candidatesArray)
        print(candidatesArray.count)
        print(indexPath)
        DispatchQueue.main.async {
            for index in 0..<self.tableViewData.count {
                var interview = self.tableViewData[index]
                if interview.jobId == jobID {
                    interview.sectionData = self.candidatesArray
                }
                self.tableViewData[index] = interview
            }
            self.tableViewData[indexPath.section].opened = true
            self.selectedIndexPath = nil
            let sections = IndexSet.init(integer: indexPath.section)
            self.interViewsTableView.reloadSections(sections, with: .none)
            self.removeSpinner()
        }
    }
    
}



extension DashboardViewController {
    
    @IBAction func showFiltersAction(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFilters(notfication:)), name: Notification.Name("updatefilters"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSavedFilters(notfication:)), name: Notification.Name("savedFilters"), object: nil)
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let filterViewController = mainStoryBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
            
            
            filterViewController.segmentIndex = self.segmentControl.selectedSegmentIndex
            
            
            
            if jobTypes.contains("MY_JOBS".localized) {
                filterViewController.filterArray.append(["MY_JOBS".localized : true])
            } else {
                filterViewController.filterArray.append(["MY_JOBS".localized : false])
            }
            
            if jobTypes.contains("My Collaboration") {
                filterViewController.filterArray.append(["MY_CONTRIBUTOR_JOBS".localized : true])
            } else {
                filterViewController.filterArray.append(["MY_CONTRIBUTOR_JOBS".localized : false])
            }
            
            if statusFilters.contains("ACTIVE".localized) {
                filterViewController.filterArray.append(["ACTIVE".localized : true])
            } else {
                filterViewController.filterArray.append(["ACTIVE".localized : false])
            }
            
            if statusFilters.contains("INACTIVE".localized) {
                filterViewController.filterArray.append(["INACTIVE".localized : true])
            } else {
                filterViewController.filterArray.append(["INACTIVE".localized : false])
            }
            
            filterViewController.selecteddueDate = filterDueDate
            let leftMenuNavigationController = SideMenuNavigationController(rootViewController: filterViewController)
            SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
            leftMenuNavigationController.navigationBar.isHidden = true
            leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
            leftMenuNavigationController.presentationStyle = .viewSlideOutMenuPartialIn
            leftMenuNavigationController.statusBarEndAlpha = 0
            leftMenuNavigationController.leftSide = false
            self.present(leftMenuNavigationController, animated: true, completion: nil)
            
        } else {
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateInterviewFilters(notfication:)), name: Notification.Name("updateInterviewFilters"), object: nil)
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let filterViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MyInterviewsFiltersViewController") as! MyInterviewsFiltersViewController
            
            //interviewTypes.append(.myInterviews)
            
            for status in MyinterviewsStatus.interViewStatusTypes {
                
                if status == MyinterviewsStatus.contributorInterviews {
                    if(interviewTypes.contains("My Collaboration")){
                        filterViewController.selectedfilterArray.append(MyinterviewsStatus.contributorInterviews)
                    }
                }else if status == MyinterviewsStatus.myInterviews {
                    if(interviewTypes.contains(MyinterviewsStatus.myInterviews)){
                        filterViewController.selectedfilterArray.append(MyinterviewsStatus.myInterviews)
                    }
                    print(filterViewController.selectedfilterArray)
                } else {
                    for filters in interviewStatusFilters {
                        for filterStatus in filters {
                            if(filterStatus.value.contains(status)) {
                                filterViewController.selectedfilterArray.append(status)
                            }
                        }
                    }
                }
            }
            filterViewController.interviewData = tableViewData
            print(filterViewController.selectedfilterArray)
            let leftMenuNavigationController = SideMenuNavigationController(rootViewController: filterViewController)
            SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
            leftMenuNavigationController.navigationBar.isHidden = true
            leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
            leftMenuNavigationController.presentationStyle = .viewSlideOutMenuPartialIn
            leftMenuNavigationController.statusBarEndAlpha = 0
            leftMenuNavigationController.leftSide = false
            self.present(leftMenuNavigationController, animated: true, completion: nil) 
            
        }
        
    }

    func loadMyJobs() {
        self.currentPage = 0
        self.showSpinner()
        self.jobTypes = [.myJobs]
        self.filterDueDate =  ""
        self.statusFilters = [.active]

        if self.jobsArray.count > 0 {
            self.jobsArray.removeAll()
        }
        self.loadItems()
    }

    /* THIS FEATURE IS CURRENTLY DISABLED SO PLEASE DONT REMOVE THIS CODE
     func getDefaultFilters(currentTab : String) {

     DispatchQueue.main.async {
     self.showSpinner()
     }

     JobListingAPI.getDefaultFilters(jobDetails: JobsManager(currentTab: currentTab)) { (response, error) in

     if response?.success ?? false {

     self.currentPage = 0

     if currentTab == .myJobs {

     self.jobTypes = response?.jobTypes ?? [String]()
     self.filterDueDate = response?.filterDueDate ?? ""
     self.statusFilters = response?.statusFilters ?? [String]()

     print("=================================")
     print(self.statusFilters)

     if self.jobsArray.count > 0 {
     self.jobsArray.removeAll()
     }
     self.loadItems()
     } else if currentTab == .myInterviews {
     print(response)
     self.interviewTypes = response?.interViewTypes ?? [String]()
     self.interviewStatusFilters = response?.myInterviewsFilters ?? Array<Dictionary<String,Array<String>>>()

     if self.interviewTypes.count == 0 {
     self.interviewTypes.append(.myInterviews)
     }

     print(self.interviewTypes)
     print(self.interviewStatusFilters)

     if self.interviewsArray.count > 0 {
     self.interviewsArray.removeAll()
     }

     if self.tableViewData.count > 0 {
     self.tableViewData.removeAll()
     }


     self.loadMyInterviews()
     }

     } else {
     DispatchQueue.main.async {
     self.noDataView.isHidden = false
     self.dashboardTableView.isHidden = true
     }

     guard let message = error?.message else {return}
     self.handleErrorResponse(message: message)
     }

     }

     } */
}

extension DashboardViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == keyWordsTextField {
            if (string.count ) == 0 {
                //Delete any cases
                if range.length > 1 {
                    //Delete whole word
                }
                else if range.length == 1 {
                    //Delete single letter
                    
                    if textField.text?.count == 1 {
                        self.searchText = ""
                        self.searchKey = ""
                        self.searchButton.isEnabled = false
                        self.searchButton.alpha = 0.5
                        self.loadDataOnViewUpdate(from: "search")
                    }
                } else if range.length == 0 {
                    //Tap delete key when textField empty
                    
                    //  print("Tap delete key when textField empty")
                    
                }
            }
        }
        return true
    }
}

//MARK: Add RefreshController for Jobs and InterviewLists
extension DashboardViewController {
    
    func addPullToRefresh(){
        jobsRefresh = self.makePullToRefreshToTableView(tableName: dashboardTableView, withTitle: "Refresh My Jobs",action: #selector(refreshView))
        interviewsRefresh = self.makePullToRefreshToTableView(tableName: interViewsTableView, withTitle: "Refresh My Interviews",action: #selector(refreshInterviews))
    }
    
    @objc func refreshView() {
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            if self.jobsArray.count > 0 {
                self.jobsArray.removeAll()
            }
            currentPage = 0
            self.showSpinner()
            self.loadItems()
        }
    }
    
    @objc func refreshInterviews() {
        self.currentPage = 0

        self.showSpinner()
        if self.interviewsArray.count > 0 {
            self.interviewsArray.removeAll()
        }
        if self.tableViewData.count > 0 {
            self.tableViewData.removeAll()
        }

        self.loadMyInterviews()

        interviewsRefresh.endRefreshing()

    }

    @objc func clickOnFiltersButton(_ sender: Any) {
        print("Notification called")
    }
    
}

extension DashboardViewController : MyInterviewsTableViewCellDelegate {
    
    func updateError(error: ErrorResponse, withType type: String) {
        self.showBanner(title: "", withMessage: error.message, style: .warning)
    }

    func updateResponseToView(data: Any, withType type: String) {

        

        var segueType = ""

        if let response = data as? [String : Any] {

            if let indexPath = response["indexpath"] as? IndexPath {
                print("Index path updated")
                self.reloadIndexpath = indexPath
            }
            
            if let id = response["job_id"] as? Int {
                self.jobId = id
            }

        }


        switch type {

        // MARK: Interview View Actions
        //MARK: closeInterview 1
        case InterviewActionTypes.closeInterview:
            generateEventLogToAnalytics(eventName: "Close Interview Event", status: "True")
            NotificationCenter.default.addObserver(self, selector: #selector(updateMyInterviewsDashboard(notification:)), name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            segueType = StoryboardSegueIdentifiers.dashboardToCustomMessage

        //MARK: showRating 2
        case InterviewActionTypes.showRating:
            generateEventLogToAnalytics(eventName: "Rate Interview Event", status: "True")
            NotificationCenter.default.addObserver(self, selector: #selector(updateMyInterviewsDashboard(notification:)), name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            segueType = StoryboardSegueIdentifiers.interviewsToRating

        //MARK: showReport 3
        case InterviewActionTypes.showReport:
            generateEventLogToAnalytics(eventName: "Share Report Event", status: "True")
            NotificationCenter.default.addObserver(self, selector: #selector(updateMyInterviewsDashboard(notification:)), name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            segueType = StoryboardSegueIdentifiers.dashboardToReportView

        //MARK: showVideos 4
        case InterviewActionTypes.showVideos:
            segueType = StoryboardSegueIdentifiers.dashboardToShowVideos

        //MARK: withdrawInterview 5
        case InterviewActionTypes.withdrawInterview:
            generateEventLogToAnalytics(eventName: "Candidate Withdraw Event", status: "True")
            NotificationCenter.default.addObserver(self, selector: #selector(updateMyInterviewsDashboard(notification:)), name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            segueType = StoryboardSegueIdentifiers.dashboardToCustomMessage

        //MARK: shareInterview 6
        case InterviewActionTypes.shareInterview:
            segueType = StoryboardSegueIdentifiers.myInterviewsToShare

        //MARK: showAnalytics 7
        case InterviewActionTypes.showAnalytics:
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateMyInterviewsDashboard(notification:)), name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
            segueType = StoryboardSegueIdentifiers.dashboardToAnlaytics

        //MARK: showAvailabilty 8
        case InterviewActionTypes.showAvailabilty:
            segueType = StoryboardSegueIdentifiers.dashboardToCandidateAvailabilty

        //MARK: showReason 9
        case InterviewActionTypes.showReason:
            segueType = StoryboardSegueIdentifiers.dashboardToReason

        //MARK: noShow 10
        case InterviewActionTypes.noShow:
            segueType = StoryboardSegueIdentifiers.dashboardToNoshow

        //MARK: joinVideos 11
        case InterviewActionTypes.joinVideos:
            generateEventLogToAnalytics(eventName: "Join Interview Event", status: "True")
            segueType = ""

        //MARK: showPayments 12
        case InterviewActionTypes.showPayments:
            generateEventLogToAnalytics(eventName: "Payments Event", status: "True")
            segueType = ""

        default:
            print("Default")
        }

        print("=======Perform segue with below identifier===========")
        print(segueType)
        print(data)
        if segueType != "" {
            self.performSegue(withIdentifier: segueType, sender: data)
        }
    }


}
