//
//  CandidatesViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 21/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import DropDown
import SDWebImage

class CandidatesViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UISearchBarDelegate {
    
    lazy var customBackItem: Array = { () -> [UIBarButtonItem] in
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 12.0, width: 12.0, height: 20.5))
        imageView.image = UIImage(named: "Back")
        imageView.contentMode = .scaleAspectFit
        let back = UIButton(type: .custom)
        back.frame.size.width = 50.0
        back.frame.size.height = 44.0
        back.addTarget(self, action: #selector(customBackAction(_:)), for: .touchUpInside)
        customView.addSubview(imageView)
        customView.addSubview(back)
        let item = UIBarButtonItem(customView: customView)
        return [item]
    }()
    
    @IBOutlet weak var searchContatinerView: UIView!
    @IBOutlet weak var candidatesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var anchorView: UIView!
    @IBOutlet weak var selectStatusButton: UIButton!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var addCandidateButton: UIButton!
    var candidatesAPI: CandidatesAPIProtocol.Type = CandidatesAPI.self
    var currentPage = 0
    var totalCandidatesCount = 0
    var jobStatus = ""
    var isFromSearch = false
    let statusDropDown = DropDown()
    var filterKey  = ""
    var jobID  = ""
    var jobClosingDate  = ""
    var candidatesArray = [[String : Any]]()
    var responseArray = [[String : Any]]()
    var searchText = ""
    var candidateName = ""
    var candidateID : Int = 0
    var statusKey = ""
    var jobPermissions: Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listContainerView.isHidden = true
        self.noDataView.isHidden = false
        self.searchBar.delegate = self
        
        if filterKey == "Pending" {
            statusKey = "candidate_status"
        } else {
            statusKey = "status"
        }
        self.selectStatusButton.setTitle(filterKey,for: .normal)
    self.selectStatusButton.setTitleColor(AppTheme.textColor, for: .normal)
        self.setUpView()
        self.setupDropDowns()
        self.loadCandidates()
       self.navigationItem.setLeftBarButtonItems(self.customBackItem, animated: true)
        self.selectStatusButton.light(size: 18.0)
        self.searchBar.change(textFont: UIFont.appLightFontWith(size: 18.0))
        
    }
    
    @objc func reload() {
        self.currentPage = 0
        if !candidatesArray.isEmpty {
            self.candidatesArray.removeAll()
        }
        self.loadCandidates()
    }
    
    func loadCandidates() {
        self.showSpinner()
        currentPage += 1
        
        self.candidatesAPI.getCandidates(manager: CandidatesManager(jobID: jobID, status: filterKey,page: "\(currentPage)",perPage: "\(10)",searchKeyWord: searchText,statusKey: statusKey)) { (response, error) in
            
            let success = response?["success"] as? Bool ?? false
            
            if success {
                
                self.totalCandidatesCount = response?["total_count"] as? Int ?? 0
                self.jobStatus = response?["status"] as? String ?? ""
                
                if let candidates = response?["candidates"] as? [Dictionary<String,Any>] {
                    
                    if self.isFromSearch {
    
                        DispatchQueue.main.async {
                            
                            print("candidates=========\(candidates)")
                            
                            self.candidatesArray = candidates
                            print("==========candidates.count")
                            print(candidates.count)

                            print(self.candidatesArray.count)
                            
                            self.candidatesTableView.reloadData()
                            
                            self.isFromSearch = false
                            if let jobTitle = response?["job_title"]  as? String {
                                self.navigationItem.title = jobTitle
                            }
                            
                            if self.jobStatus == .active {
                                self.addCandidateButton.isHidden = false
                            } else {
                                self.addCandidateButton.isHidden = true
                            }
                            
                            let candidateEdit = self.jobPermissions[ContributorKeys.candidateEdit] as? Int ?? 0
                            
                            if  !candidateEdit.boolValue {
                                self.addCandidateButton.isHidden = true
                            } else {
                                self.addCandidateButton.isHidden = false
                            }
                       
                            if !self.candidatesArray.isEmpty {
                                self.listContainerView.isHidden = false
                                self.noDataView.isHidden = true
                                self.candidatesTableView.reloadData()
                                self.candidatesTableView.scrollsToTop = true
                            } else {
                                self.listContainerView.isHidden = true
                                self.noDataView.isHidden = false
                            }
                            
                            self.removeSpinner()
                        }
                    } else {
                        
                        self.responseArray = candidates
                        
                        if !self.responseArray.isEmpty {
                            self.candidatesArray.append(contentsOf: self.responseArray)
                        }

                        print("==========candidates.count")
                        print(self.candidatesArray.count)
                        
                        DispatchQueue.main.async {
                             
                            if self.jobStatus == .active {
                                self.addCandidateButton.isHidden = false
                            } else {
                                self.addCandidateButton.isHidden = true
                            }
                            
                            let candidateEdit = self.jobPermissions[ContributorKeys.candidateEdit] as? Int ?? 0
                            
                            if  !candidateEdit.boolValue {
                                self.addCandidateButton.isHidden = true
                            } else {
                                self.addCandidateButton.isHidden = false
                            }

                            if !self.candidatesArray.isEmpty {
                                self.listContainerView.isHidden = false
                                self.noDataView.isHidden = true
                                self.candidatesTableView.reloadData()
                                self.candidatesTableView.scrollsToTop = true
                            } else {
                                self.listContainerView.isHidden = true
                                self.noDataView.isHidden = false
                            }
                            
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
    
    /*! @brief This function Customize the Search Container  View*/
    
    func setUpView() {
        searchContatinerView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        searchContatinerView.clipsToBounds = true
        searchContatinerView.layer.borderWidth = 1
        searchContatinerView.layer.cornerRadius = 10
        searchContatinerView.layer.borderWidth = 1
        candidatesTableView.tableFooterView = UIView()
    }
    
    func setupDropDowns() {
        
        // The view to which the drop down will appear on
        statusDropDown.anchorView = self.anchorView
        statusDropDown.dataSource = [.all,"Pending",.pendingInterview,.waitingForInterview, .cancelled, .waitingForCandidate,.scheduled,.completed,.withdrawn,.noShow]
        statusDropDown.backgroundColor = AppTheme.appBackgroundColor
        statusDropDown.selectionBackgroundColor = AppTheme.brandColor
        statusDropDown.customCellConfiguration = {(index, text, cell) in
            cell.backgroundColor = AppTheme.appBackgroundColor
            cell.optionLabel.font = UIFont.appLightFontWith(size: 18.0)
        }
        statusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectStatusButton.setTitle(item,for: .normal)
            self.selectStatusButton.setTitleColor(AppTheme.textColor, for: .normal)
            self.statusKey = "status"
            switch item {
            case .all:
                self.filterKey = ""
                self.filterKey = item
            case "Pending":
                self.statusKey = "candidate_status"
                self.filterKey = item
            default: self.filterKey = item
            }
            self.reload()
        }
    }
    
    @IBAction func selectStatusAction(_ sender: Any) {
        self.statusDropDown.show()
    }
    
    @objc func customBackAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("RefreshDashboard"), object: nil, userInfo:nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func moreActions(_ sender : UIButton) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCandidates(notfication:)), name: Notification.Name("updateCandidates"), object: nil)
        let moreActions = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.moreActionsViewController) as?
        MoreActionsViewController ?? MoreActionsViewController()
        
        let dict = candidatesArray[sender.tag]
        if let candidateID = dict["id"] as? Int {
            print(candidatesArray)
            print(candidateID)
            moreActions.candidateID = "\(candidateID)"
        }

        moreActions.jobID = self.jobID
        moreActions.jobDueDate = self.jobClosingDate
        moreActions.jobPermissions = self.jobPermissions
        
        if let activeStatus = dict["status"] as? String {
            moreActions.activeStatus = "\(activeStatus)"
            if(activeStatus == "Scheduled") {
                moreActions.preferredContentSize = CGSize(width: 180, height: 96)
            } else {
                moreActions.preferredContentSize = CGSize(width: 180, height: 144)
            }
        } else {
            moreActions.preferredContentSize = CGSize(width: 180, height: 192)
            print("Status Not parsed")
        }
        moreActions.modalPresentationStyle = .popover
        moreActions.currentSelection = StoryboardIdentifiers.candidatesViewController
        //        moreActions.preferredContentSize = CGSize(width: 180, height: 195)
        let ppc = moreActions.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.delegate = self
        ppc?.sourceView = sender
        ppc?.containerView?.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        ppc?.containerView?.clipsToBounds = true
        ppc?.containerView?.layer.borderWidth = 1
        ppc?.containerView?.layer.cornerRadius = 10
        ppc?.containerView?.layer.borderWidth = 1
        present(moreActions, animated: true, completion: nil)
    }
    
    @objc func updateCandidates(notfication: NSNotification) {
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            
            guard let requestType = info["requestType"] as? String else {return}
            
            if requestType == "revertWithdraw" {
                guard let status = info["withdrawStatus"] as? Bool else {return}
                guard let  id = info["candidateId"] as? String else {return}
                self.showSpinner()
                let manager = CandidatesManager(withdrawReason: "", candidateID: id , withdrawStatus: status )
                self.candidatesAPI.withdrawCandidate(candidatesManager: manager) {(response , error) in
                    
                    if(response != nil) {
                        let success = response?["success"] as? Bool ?? false
                        if(success){
                            let successMessage = response?["message"] as? [String] ?? ["Success"]
                            DispatchQueue.main.async {
                                self.showBanner(title: "", withMessage: successMessage[0] , style: .success)
                                self.removeSpinner()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                self.reload()
                            })
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
            } else {
                self.reload()
            }
            
        }
        NotificationCenter.default.removeObserver(self,name: Notification.Name("updateCandidates"), object: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == StoryboardSegueIdentifiers.toAddNewCandidate {
            if jobClosingDate != "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Formats.dateFormat
                let date = jobClosingDate.changeDate(jobClosingDate)
                if(date.toDate() < dateFormatter.string(from: Date()).toDate()){
                    self.showBanner(title: "", withMessage: "Job due date expired", style: .warning)
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardSegueIdentifiers.candidateToDetails {
            
            let navigation = segue.destination as? UINavigationController
            navigation?.presentingViewController?.modalPresentationStyle = .fullScreen
            let candidateDetailsViewController = navigation?.viewControllers.first as? CandidateDetailsViewController
            candidateDetailsViewController?.candidateName = candidateName
            candidateDetailsViewController?.id = candidateID
            candidateDetailsViewController?.jobPermissions = self.jobPermissions
            
        }
        
        if segue.identifier == StoryboardSegueIdentifiers.toAddNewCandidate {
            NotificationCenter.default.addObserver(self, selector: #selector(updateCandidates(notfication:)), name: Notification.Name("updateCandidates"), object: nil)
            let navVC = segue.destination as? UINavigationController
            let addCandidateViewController = navVC?.viewControllers.first as? AddCandidateViewController
            addCandidateViewController?.isNavigatingFrom = StoryboardSegueIdentifiers.toAddNewCandidate
            addCandidateViewController?.jobID =  self.jobID
            addCandidateViewController?.jobClosedDate = self.jobClosingDate
        }
    }
}

extension CandidatesViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        isFromSearch = true
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 2.0)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            self.searchText = ""
            self.reload()
            print("nothing to search")
            return
        }
        self.searchText = query
        self.currentPage = 0
        if !candidatesArray.isEmpty {
            candidatesArray.removeAll()
        }
        candidatesTableView.reloadData()

        self.loadCandidates()
    }
}

extension CandidatesViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidatesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.candidateViewCell, for: indexPath) as? CandidateViewCell ?? CandidateViewCell()
        cell.selectionStyle = .none
        let dict = candidatesArray[indexPath.row]
        
        if let profilePic = dict["profile_pics"] as? Dictionary<String,String> {
            
            if let profileStr = profilePic["profile_thumb_url"] {
                // cell.candidateProfileImage.dowloadFromServer(link: profileStr)
                cell.candidateProfileImage.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: "NoImage"))
                cell.candidateProfileImage.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
                
            }
        }
        
        if let status = dict["status"] as? String {
            cell.statusLabel.text = status
        }
        cell.statusLabel.light(size: 16.0)
        
        if let fullName = dict["full_name"] as? String {
            cell.candiateNameLabel.text = fullName
        }

        cell.candiateNameLabel.bold(size: 18.0)

        if self.jobStatus != .inActive {
            cell.moreButton.isHidden = false
            cell.moreImageView.isHidden = false
            cell.moreButton.addTarget(self, action: #selector(moreActions(_:)), for: .touchUpInside)
            cell.moreButton.tag = indexPath.row
        } else {
            cell.moreButton.isHidden = true
            cell.moreImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = candidatesArray[indexPath.row]
        if let candidateID = dict["id"] as? Int {
            self.candidateID = candidateID
        }
        if let candidatename = dict["full_name"] as? String {
            self.candidateName = candidatename
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCandidates(notfication:)), name: Notification.Name("updateCandidates"), object: nil)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.candidateToDetails, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == candidatesTableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if totalCandidatesCount > candidatesArray.count { // more items to fetch
                    self.loadCandidates()
                }
            }
        }
    }
    
}
