//
//  ContributorSettingsViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 11/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

struct NotificationConstants {
    static let viewBox = "ViewBox"
    static let editBox = "EditBox"
    static let notifyBox = "NotifyBox"
}

class ContributorSettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noDataView: UIView!
    var viewModel = DashBoardViewModel()
    @IBOutlet weak var addFieldView: UIView!
    @IBOutlet weak var contributorSegmentControl: UISegmentedControl!
    @IBOutlet weak var contributorTableView: UITableView!
    @IBOutlet weak var skipButton: UIBarButtonItem!
    @IBOutlet weak var noRecruitersLabel: UILabel!
    @IBOutlet weak var applyDefaultButton: UIButton!
    @IBOutlet weak var saveDefaultButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var jobTitle: UILabel!
    var openedSections = [IndexPath]()
    var selectedIndexPath: IndexPath?
    var extraHeight: CGFloat = 80
    var contributorsArray = [Dictionary<String,Any>]()
    var searchArray = [Dictionary<String,Any>]()
    var jobID = ""
    var contributorSettingsAPI : ContributorSettingsAPIProtocol.Type =  ContributorSettingsAPI.self
    var permissionsArray = [Dictionary<String,Any>]()
    var currentPermission = ""
    var defaultContributors = [Dictionary<String,[String]>]()
    var isNavigatingFrom = ""
    var searchText = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewModel.segmentContoller = self.contributorSegmentControl
        viewModel.setUpView()
        self.setUpNavigationBar()
        setupView()
        self.searchBar.setCustomBackgroundColor(color: AppTheme.appBackgroundColor)
        self.noDataView.isHidden = false
        self.contributorTableView.isHidden = true

        self.searchBar.change(textFont: UIFont.appLightFontWith(size: 18.0))
        searchBar.delegate = self
        contributorTableView.layer.borderWidth = 1
        contributorTableView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        contributorTableView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewBox(notfication:)), name: Notification.Name(NotificationConstants.viewBox), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateEditBox(notfication:)), name: Notification.Name(NotificationConstants.editBox), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotifyBox(notfication:)), name: Notification.Name(NotificationConstants.notifyBox), object: nil)
        
        self.getCompanyRecruiters()
        if(isNavigatingFrom != StoryboardSegueIdentifiers.createJobToContributorSettings) {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.skipButton
            self.skipButton.isEnabled = true
        }
    }

    func setupView() {
        clearButton.roman(size: 16.0)
        applyDefaultButton.bold(size: 14.0)
        saveDefaultButton.bold(size: 14.0)
        updateButton.bold(size: 18.0)
        jobTitle.roman(size: 16.0)
        noRecruitersLabel.light(size: 18.0)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("RefreshDashboard"), object: nil, userInfo:nil)
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.contributorSettingsToDashboard, sender: nil)
    }
    
    @objc func updateViewBox(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Int> {
            // Check if value present before using it
            guard let index = info["Index"] else {return}
            
            var key = ""
            if contributorSegmentControl.selectedSegmentIndex == 0 {
                key = ContributorKeys.jobView
            } else if contributorSegmentControl.selectedSegmentIndex == 1 {
                key = ContributorKeys.candidateView
            } else if contributorSegmentControl.selectedSegmentIndex == 2 {
                key = ContributorKeys.interviewView
            }
            currentPermission = NotificationConstants.viewBox
            self.updatePermissionArray(index: index, forKey: key)
            
        }
        
        //NotificationCenter.default.removeObserver(self, name: Notification.Name("ViewBox"), object: nil)
        
    }
    
    @objc func updateEditBox(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Int> {
            // Check if value present before using it
            guard let index = info["Index"] else {return}
            
            var key = ""
            if contributorSegmentControl.selectedSegmentIndex == 0 {
                key = ContributorKeys.jobEdit
            } else if contributorSegmentControl.selectedSegmentIndex == 1 {
                key = ContributorKeys.candidateEdit
            } else if contributorSegmentControl.selectedSegmentIndex == 2 {
                key = ContributorKeys.interviewEdit
            }
            currentPermission = NotificationConstants.editBox
            self.updatePermissionArray(index: index, forKey: key)
        }
    }
    
    @objc func updateNotifyBox(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? [String : Int] {
            // Check if value present before using it
            guard let index = info["Index"] else {return}
            var key = ""
            if contributorSegmentControl.selectedSegmentIndex == 0 {
                key = ContributorKeys.jobNotify
            } else if contributorSegmentControl.selectedSegmentIndex == 1 {
                key = ContributorKeys.candidateNotify
            } else if contributorSegmentControl.selectedSegmentIndex == 2 {
                key = ContributorKeys.interViewNotify
            }
            
            currentPermission = NotificationConstants.notifyBox
            self.updatePermissionArray(index: index, forKey: key)
            
        }
    }
    
    func updatePermissionArray(index: Int, forKey key : String) {
        var dict = contributorsArray[index]["job_permissions"] as? [String : Int]
        let cell = self.contributorTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ContributorsCell
        if currentPermission == NotificationConstants.viewBox {
            dict?[key] = cell?.viewBox.isChecked.intValue
        } else if currentPermission == NotificationConstants.editBox {
            dict?[key] = cell?.editBox.isChecked.intValue
        } else if currentPermission == NotificationConstants.notifyBox {
            dict?[key] = cell?.notifyBox.isChecked.intValue
        }
        
        if cell?.editBox.isChecked ?? false {
            if(self.contributorSegmentControl.selectedSegmentIndex == 0) {
                dict?[ContributorKeys.jobView] = cell?.editBox.isChecked.intValue
            } else if(self.contributorSegmentControl.selectedSegmentIndex == 1) {
                dict?[ContributorKeys.candidateView] = cell?.editBox.isChecked.intValue
            } else {
                dict?[ContributorKeys.interviewView] = cell?.editBox.isChecked.intValue
            }
        }

        var responeDict = contributorsArray[index]
        responeDict["job_permissions"] = dict
        contributorsArray[index] = responeDict
        for index in 0..<self.searchArray.count {
            if let contributorID = self.searchArray[index]["id"] as? Int {
                if(contributorID == contributorsArray[index]["id"] as? Int) {
                    searchArray[index] = contributorsArray[index]
                }
            }
        }
        self.contributorTableView.reloadData()

    }
    
    @IBAction func rolesSegmentAction(_ sender: Any) {
        contributorTableView.reloadData()
    }
    
    func getCompanyRecruiters() {
        self.showSpinner()
        contributorSettingsAPI.getCompanyRecruiters(jobID: JobsManager(jobID: jobID)) {(response, errorResponse) in
            if response != nil {
                DispatchQueue.main.async {
                    
                    if let contriButors = response?["recruiters"] as? [[String : Any]] {
                        self.contributorsArray = contriButors
                        self.searchArray = contriButors
                        for index in 0..<contriButors.count {
                            let dict = contriButors[index]
                            if let permissions = dict["job_permissions"] as? [String : Any] {
                                self.permissionsArray.append(permissions)
                            }
                        }
                    }
                    
                    if let title = response?["job_title"] as? String {
                        self.jobTitle.text = title
                    }
                    
                    if self.searchArray.isEmpty {
                        self.noDataView.isHidden = false
                        self.contributorTableView.isHidden = true
                        self.updateControls(status: false, val: 0.5)
                        self.searchBar.isUserInteractionEnabled = false
                        self.searchBar.setPlaceholderText(color: AppTheme.placeHolderColor)

                    } else {
                        self.contributorTableView.isHidden = false
                        self.noDataView.isHidden = true
                        self.updateControls(status: true, val: 1.0)
                        self.searchBar.isUserInteractionEnabled = true
                        self.searchBar.setPlaceholderText(color: AppTheme.textColor)

                    }
                    
                    self.contributorTableView.reloadData()
                    self.removeSpinner()
                }
                
            } else {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    func getContributorSettings() {
        self.showSpinner()
        contributorSettingsAPI.getContributorSettings(jobID: JobsManager(jobID: jobID)) {(response, errorResponse) in
            if response != nil {
                
                if let contriButors = response?["recruiters"] as? [[String : Any]] {
                    self.searchArray = contriButors
                    for index in 0..<contriButors.count {
                        let dict = contriButors[index]
                        if let permissions = dict["job_permissions"] as? [String : Any] {
                            self.permissionsArray.append(permissions)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    if(self.searchText != "") {
                        self.searchRecruiters()
                    } else {
                        self.contributorsArray = self.searchArray
                    }
                    
                    if self.contributorsArray.isEmpty {
                        self.noDataView.isHidden = false
                        self.contributorTableView.isHidden = true
                    } else {
                        self.contributorTableView.isHidden = false
                        self.noDataView.isHidden = true
                    }
                    self.showBanner(title: "", withMessage: "Default settings loaded successfully.", style: .success)
                    self.contributorTableView.reloadData()
                    self.removeSpinner()
                }
                
            } else {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            }
        }
    }
    
    @IBAction func applyDefaultAction(_ sender: UIButton) {
        performSegue(withIdentifier: StoryboardSegueIdentifiers.contributorsToCustomMessage, sender: sender)
    }
    
    @IBAction func saveDefaultAction(_ sender: UIButton) {
        performSegue(withIdentifier: StoryboardSegueIdentifiers.contributorsToCustomMessage, sender: sender)
    }
    
    @IBAction func updateSettingsAction(_ sender: Any) {
        self.saveSettings(saveAsDefault: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.contributorsToCustomMessage {
            if let navVC = segue.destination as? CustomAlertViewController {
                navVC.isNavigatingFrom = StoryboardSegueIdentifiers.contributorsToCustomMessage
                navVC.jobId = self.jobID
                
                if let button = sender as? UIButton {
                    navVC.infoData = ["settingsName" : button.titleLabel?.text ?? ""]
                }
                
                NotificationCenter.default.addObserver(self, selector: #selector(settingsAction(notfication:)), name: Notification.Name(StoryboardSegueIdentifiers.contributorsToCustomMessage), object: sender as? String)
            }
        }
    }
    
    func saveSettings(saveAsDefault : Bool) {
        self.showSpinner()
        updatePermissions()
        print(defaultContributors)
        contributorSettingsAPI.saveDefaultSettings(jobManager: JobsManager(jobID: self.jobID, recruiters: self.defaultContributors, saveAsDefault: saveAsDefault)) { (response, errorResponse) in
            
            DispatchQueue.main.async {
                if response != nil {
                    let successMessage = response?["message"] as? [String] ?? ["Success"]
                    self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                } else {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.removeSpinner()
                
                if !saveAsDefault {
                    
                    
                    if self.isNavigatingFrom != "MoreToEditContributors" {
                        if response != nil {
                            NotificationCenter.default.post(name: Notification.Name("RefreshDashboard"), object: nil, userInfo:nil)
                            self.performSegue(withIdentifier: StoryboardSegueIdentifiers.contributorSettingsToDashboard, sender: nil)
                        }
                        
                    }
                    
                    
                }
                
                
            })
            
        }
        
    }
    
    @objc func settingsAction(notfication: NSNotification) {
        if let info = notfication.object as? String {
            if info == "Apply Default"{
                getContributorSettings()
            } else {
                saveDefaultSettings()
            }
            NotificationCenter.default.removeObserver(self, name: Notification.Name(StoryboardSegueIdentifiers.contributorsToCustomMessage), object: nil)
        }
    }
    
    func saveDefaultSettings() {
        self.saveSettings(saveAsDefault: true)
    }
    
    func updatePermissions() {
        
        for index in 0..<searchArray.count {
            var contributorId = ""
            var permission = [String]()
            if let id = searchArray[index]["id"] as? Int {
                contributorId = "\(id)"
            }
            
            if let permissions = searchArray[index]["job_permissions"] as? Dictionary<String,Any> {
                
                if(permissions[ContributorKeys.candidateEdit] as? Int == 1) {
                    permission.append(ContributorKeys.candidateEdit)
                }
                
                if(permissions[ContributorKeys.candidateNotify]  as? Int == 1) {
                    permission.append(ContributorKeys.candidateNotify)
                }
                
                if(permissions[ContributorKeys.candidateView] as? Int == 1) {
                    permission.append(ContributorKeys.candidateView)
                }
                
                if(permissions[ContributorKeys.interviewEdit] as? Int == 1) {
                    permission.append(ContributorKeys.interviewEdit)
                }
                
                if(permissions[ContributorKeys.interViewNotify] as? Int == 1) {
                    permission.append(ContributorKeys.interViewNotify)
                }
                
                if(permissions[ContributorKeys.interviewView] as? Int == 1) {
                    permission.append(ContributorKeys.interviewView)
                }
                
                if(permissions[ContributorKeys.jobEdit] as? Int == 1) {
                    permission.append(ContributorKeys.jobEdit)
                }
                
                if(permissions[ContributorKeys.jobNotify] as? Int == 1) {
                    permission.append(ContributorKeys.jobNotify)
                }
                
                if(permissions[ContributorKeys.jobView] as? Int == 1) {
                    permission.append(ContributorKeys.jobView)
                }
            }
            let val = [contributorId : permission]
            self.defaultContributors.append(val)
        }
    }
    
    @IBAction func checkButtonViewAction(_ sender: Any) {
    }
    
    @IBAction func clearAllPermissions(_ sender: Any) {
        DispatchQueue.main.async {
            for index in 0..<self.searchArray.count {
                if var permissions = self.searchArray[index]["job_permissions"] as? [String : Any] {
                    permissions[ContributorKeys.candidateEdit] = 0
                    permissions[ContributorKeys.candidateNotify] = 0
                    permissions[ContributorKeys.candidateView] = 0
                    permissions[ContributorKeys.interviewEdit] = 0
                    permissions[ContributorKeys.interViewNotify] = 0
                    permissions[ContributorKeys.interviewView] = 0
                    permissions[ContributorKeys.jobEdit] = 0
                    permissions[ContributorKeys.jobNotify] = 0
                    permissions[ContributorKeys.jobView] = 0
                    self.searchArray[index]["job_permissions"] = permissions
                    self.permissionsArray[index] = permissions
                }
            }
            if(self.searchText != "") {
                self.searchRecruiters()
            } else {
                self.contributorsArray = self.searchArray
            }
            self.contributorTableView.reloadData()
        }
        
    }
    
    func searchRecruiters() {
        searchBar.text = self.searchText
        searchBar(searchBar, textDidChange: self.searchText)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if(isNavigatingFrom == StoryboardSegueIdentifiers.createJobToContributorSettings) {
            NotificationCenter.default.post(name: Notification.Name("ClearCreateJob"), object: nil, userInfo:nil)
            self.dismiss(animated: false, completion: nil)
        }else {
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributorsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(openedSections.contains(obj: indexPath)) {
            return 137
        }
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contributorTableView.dequeueReusableCell(withIdentifier: "contributorCell") as? ContributorsCell ?? ContributorsCell()
        
        let dict = contributorsArray[indexPath.row]
        
        if let fullName = dict["full_name"] as? String {
            cell.recruiterNameLabel.text = fullName
        } else {
            cell.recruiterNameLabel.text = "-"
        }
        cell.recruiterNameLabel.light(size: 18)
        if(openedSections.contains(obj: indexPath)) {
            cell.borderLabel.isHidden = false
            cell.headerBorderLabel.isHidden = true
        } else {
            cell.borderLabel.isHidden = true
            cell.headerBorderLabel.isHidden = false
        }
        cell.editBox.tag = indexPath.row
        cell.viewBox.tag = indexPath.row
        cell.notifyBox.tag = indexPath.row
        
        if let permissions = dict["job_permissions"] as? [String : Any] {
            
            if contributorSegmentControl.selectedSegmentIndex == 0 {
                let jobEdit = permissions[ContributorKeys.jobEdit] as? Int ?? 0
                let jobNotify = permissions[ContributorKeys.jobNotify] as? Int ?? 0
                let jobView = permissions[ContributorKeys.jobView] as? Int ?? 0
                cell.editBox.isChecked = jobEdit.boolValue
                cell.notifyBox.isChecked = jobNotify.boolValue
                cell.viewBox.isChecked = jobView.boolValue
                
            } else if contributorSegmentControl.selectedSegmentIndex == 1 {
                
                let candidateEdit = permissions[ContributorKeys.candidateEdit] as? Int ?? 0
                let candidateNotify = permissions[ContributorKeys.candidateNotify] as? Int ?? 0
                let candidateView = permissions[ContributorKeys.candidateView] as? Int ?? 0
                cell.editBox.isChecked = candidateEdit.boolValue
                cell.notifyBox.isChecked = candidateNotify.boolValue
                cell.viewBox.isChecked = candidateView.boolValue
                
            } else if contributorSegmentControl.selectedSegmentIndex == 2 {
                let interViewNotify = permissions[ContributorKeys.interViewNotify] as? Int ?? 0
                let interViewEdit = permissions[ContributorKeys.interviewEdit] as? Int ?? 0
                let interviewView = permissions[ContributorKeys.interviewView] as? Int ?? 0
                cell.editBox.isChecked = interViewEdit.boolValue
                cell.notifyBox.isChecked = interViewNotify.boolValue
                cell.viewBox.isChecked = interviewView.boolValue
            }
            
            if cell.editBox.isChecked {
                cell.viewBox.isChecked = true
                cell.viewBox.alpha = 0.5
                cell.viewLabel.alpha = 0.5
                cell.viewBox.isUserInteractionEnabled = false
            } else {
                cell.viewBox.alpha = 1.0
                cell.viewLabel.alpha = 1.0
                cell.viewBox.isUserInteractionEnabled = true
            }
            
            cell.viewLabel.roman(size: 16)
            cell.editLabel.roman(size: 16)
            cell.notifyLabel.roman(size: 16)
            self.updateViewLabel(cell: cell)
            
        }
        
        if let profilePic = dict["profile_pics"] as? [String : String] {
            if let profileStr = profilePic["profile_thumb_url"] {
                cell.contributorImageView.sd_setImage(with: URL(string: profileStr), placeholderImage: UIImage(named: "NoImage"))
                cell.contributorImageView.backgroundColor = UIColor(red: 210.0/255.0, green: 217.0/255.0, blue: 221.0/255.0, alpha: 1.0)
            }
        }
        
        return cell
    }
    
    func updateViewLabel(cell : ContributorsCell) {
        if !cell.viewBox.isChecked {
            cell.viewLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        } else {
            cell.viewLabel.textColor = AppTheme.contributorPermissionsTextColor
        }
        
        if !cell.editBox.isChecked {
            cell.editLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        } else {
            cell.editLabel.textColor = AppTheme.contributorPermissionsTextColor
        }
        
        if !cell.notifyBox.isChecked {
            cell.notifyLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        } else {
            cell.notifyLabel.textColor = AppTheme.contributorPermissionsTextColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = contributorTableView.cellForRow(at: indexPath) as? ContributorsCell ?? ContributorsCell()
        
        if !cell.isOpen {
            cell.dropdownImage.image = UIImage(named: "downArrow")
            openedSections.append(indexPath)
            cell.isOpen = true
        } else {
            cell.isOpen = false
            cell.dropdownImage.image = UIImage(named: "dropdownarrow")
            openedSections.remove(object: indexPath)
        }
        
        tableView.reloadData()
    }
    
}

extension ContributorSettingsViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("searchBarCancelButtonClicked")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if !contributorsArray.isEmpty {
            contributorsArray.removeAll()
        }
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            contributorsArray = searchArray
            //self.getCompanyRecruiters()
            print("nothing to search")
            reloadData()
            return
        }
        
        let searchList = searchArray
        
        for index in 0..<searchList.count {
            let name = searchList[index]["full_name"] as? String
            if(name?.uppercased().contains(searchText.uppercased()) ?? false) {
                contributorsArray.append(searchList[index])
            }
        }
        
        reloadData()
    }
    
    func reloadData() {
        
        if contributorsArray.isEmpty {
            noDataView.isHidden = false
            noRecruitersLabel.text = "There are no recruiters to show"
            self.contributorTableView.isHidden = true
            updateControls(status: false, val: 0.5)
            self.searchBar.setPlaceholderText(color: AppTheme.placeHolderColor)
            //self.searchBar.isUserInteractionEnabled = false

        } else {
            noDataView.isHidden = true
            self.contributorTableView.isHidden = false
            updateControls(status: true, val: 1.0)
            self.searchBar.setPlaceholderText(color: AppTheme.textColor)
            //self.searchBar.isUserInteractionEnabled = true
        }
        contributorTableView.reloadData()
    }
    
    func updateControls(status: Bool, val: CGFloat) {
        self.applyDefaultButton.isEnabled = status
        self.applyDefaultButton.alpha = val
        self.saveDefaultButton.isEnabled = status
        self.saveDefaultButton.alpha = val
        self.updateButton.isEnabled = status
        self.updateButton.alpha = val
        self.clearButton.isEnabled = status
        self.clearButton.alpha = val
    }
}

extension Int {
    var boolValue: Bool { return self != 0 }
}
