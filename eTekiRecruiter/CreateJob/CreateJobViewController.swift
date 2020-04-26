//
//  CreateJobViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 17/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import DropDown
import MobileCoreServices
import TagListView
import SimpleCheckbox
import AWSS3
import GrowingTextView
import Amplitude

class CreateJobViewController: BaseViewController, FlexibleSteppedProgressBarDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {
    
    var isNavigatingFrom = ""
    var jobID = ""
    var currentTagList : TagListView?
    var currentTitle = ""
    var companyLogoS3Key = ""
    var companyLogoAWSString = ""
    var companyFileS3Key = ""



    var selectedImage = UIImage()
    let logoPlaceHolder = UIImage(named: "logo_placeholder")
    var currentJobDueDate = ""
    @IBOutlet weak var primaryTableView: UITableView!
    var newJDHeight = 50.0
    var skillsSpecHeight = 100.0
    @IBOutlet weak var skillsTableView: UITableView!
    
    @IBOutlet weak var noteSuggestSkill: UITextView!
    @IBOutlet weak var requiredSkills: UITextField!
    @IBOutlet weak var optionalSkills: UITextField!
    @IBOutlet weak var requiredListView: TagListView!
    @IBOutlet weak var optionalSkillsListView: TagListView!
    
    @IBOutlet var codingSamples: Checkbox!
    @IBOutlet var whiteBoard: Checkbox!
    @IBOutlet var candidatePicture: Checkbox!
    
    @IBOutlet weak var specificationTextView: UITextView!
    @IBOutlet weak var pagingScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var skillsView: UIView!
    @IBOutlet weak var preferenceView: UIView!
    @IBOutlet weak var interviewModeField: UITextField!
    @IBOutlet weak var interviewLocationField: UITextField!
    @IBOutlet weak var interviewlLanguageField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    var maxIndex = -1
    var viewModel = CreateJobViewModel()
    
    private lazy var imagePicker = ImagePicker()

    var createJobResponse = CreateJobResponse()
    
    
    let requiredSkillsDropDown = DropDown()
    let optionalSkillsDropDown = DropDown()
    
    var requiredSkillArray : [String] = []
    var optionalSkillArray : [String] = []
    
    @IBOutlet weak var requiredSkillsAnchor: UILabel!
    @IBOutlet weak var optionalSkillsAnchor: UILabel!
    
    @IBOutlet weak var interviewModeAnchor: UILabel!
    let interViewModeDropDown  = DropDown()
    let interViewLanguageDropDown = DropDown()

    var createJobAPI: CreateJobAPIProtocol.Type = CreateJobAPI.self
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
    var jobListingAPI: JobListingAPIProtocol.Type = JobListingAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBarWithDifferentDimensions()
        setupDropDown()
        showPrimaryView()
        setNavigationBarColor(color: AppTheme.statusBarDefaultColor)
        automaticallyAdjustsScrollViewInsets = false

        
//        self.requiredListView.isHidden = true
//        self.optionalSkillsListView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLangauge(notfication:)), name: Notification.Name("LanguageSearch"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateArea(notfication:)), name: Notification.Name("AreasExpertise"), object: nil)
        
        //        self.upload_image_button.tag = 1
        //        self.upload_description.tag = 1
        //        self.upload_image_button.setTitle(.upload, for: .normal)
        //        self.upload_description.setTitle(.upload, for: .normal)

        if self.isNavigatingFrom == .editJob || self.isNavigatingFrom == .copyJob {
            self.showSpinner()
            self.jobListingAPI.getJobDetails(jobDetails: JobsManager(jobID: self.jobID)) { (response, errorResponse) in
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    self.onGetJobDetailsReponse(response: response)
                }
            }
        }
        if self.isNavigatingFrom == .editJob {
            generateEventLogToAnalytics(eventName: "Edit Job Event", status: "True")
            self.navigationItem.title = .editJob
        } else if self.isNavigatingFrom == .copyJob {
            generateEventLogToAnalytics(eventName: "Copy Job Event", status: "True")
            self.navigationItem.title = .copyJob
        } else {
            self.navigationItem.title = .createJob
        }
//        self.requiredSkills.placeholder = "Required Skills*"
//        self.requiredSkills.light(size: 18.0)
//
//        self.optionalSkills.placeholder = "Optional Skills"
//        self.optionalSkills.light(size: 18.0)
//
//        specificationTextView.textColor = AppTheme.placeHolderColor
//        specificationTextView.delegate = self
//        specificationTextView.contentInset = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 0)
        //        descriptionView.delegate = self
        //        descriptionView.textColor = AppTheme.placeHolderColor
        //self.updateSuggestSkillTextView()
        
        self.setUpCheckBox()
        //self.yearsOfExperience.addCancelButtonOnKeyboard(self, action: #selector(cancelDatePicker))
        //self.numberOfCandidates.addCancelButtonOnKeyboard(self, action: #selector(cancelDatePicker))
        self.updateFonts()

    }

    func updateFonts() {
        interviewModeField.light(size: 18.0)
        interviewlLanguageField.light(size: 18.0)
        interviewLocationField.light(size: 18.0)
        saveButton.bold(size: 18.0)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.present(parent: self, sourceType: sourceType)
    }
    
    @objc func photoButtonTapped(_ sender: UIButton) { imagePicker.photoGalleryAsscessRequest() }
    @objc func cameraButtonTapped(_ sender: UIButton) { imagePicker.cameraAsscessRequest() }
    
    func bindViewModel() {
        // viewModel.dateTextField = self.date
    }
    
    @objc func updateLangauge(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            
            if let selectedLanguage = info["selectedLangauge"] as? String {
                self.interviewlLanguageField.text = selectedLanguage
            }else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
    }
    
    @objc func updateArea(notfication: NSNotification) {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 9, section: 0)) as? PrimaryTableViewCell
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            
            if let selectedArea = info["selectedArea"] as? String {
                cell?.areasOfExpertise?.text = selectedArea
                createJobResponse.expertiseCategory = selectedArea
            }else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
    }
    
    @objc func updateCountry(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            
            if let selectedCountry = info["selectedCountry"] as? String {
                self.interviewLocationField.text = selectedCountry
            }else {
                print("no value for key\n")
            }
        }
        else {
            print("wrong userInfo type")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CountriesSearch"), object: nil)
    }
    
    
    func setUpCheckBox() {
        
        codingSamples.borderLineWidth = 1
        codingSamples.layer.cornerRadius = 5
        codingSamples.checkmarkStyle = .tick
        codingSamples.checkmarkColor = AppTheme.textColor
        codingSamples.uncheckedBorderColor = AppTheme.fieldsBorderColor
        codingSamples.checkedBorderColor = AppTheme.fieldsBorderColor
        
        whiteBoard.borderLineWidth = 1
        whiteBoard.layer.cornerRadius = 5
        whiteBoard.checkmarkStyle = .tick
        whiteBoard.checkmarkColor = AppTheme.textColor
        whiteBoard.uncheckedBorderColor = AppTheme.fieldsBorderColor
        whiteBoard.checkedBorderColor = AppTheme.fieldsBorderColor
        
        candidatePicture.borderLineWidth = 1
        candidatePicture.layer.cornerRadius = 5
        candidatePicture.checkmarkStyle = .tick
        candidatePicture.checkmarkColor = AppTheme.textColor
        candidatePicture.uncheckedBorderColor = AppTheme.fieldsBorderColor
        candidatePicture.checkedBorderColor = AppTheme.fieldsBorderColor
        
    }
    
    @objc func requiredSkillsEditing(textfield: UITextField) {
        let cell = skillsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SkillsCell
        if textfield.text != "" {
            if self.requiredSkillArray.count == 5 {
                self.showBanner(title: "", withMessage: "Required skills should not exceed more than 5", style: .warning)
                return
            } else {
                
                self.createJobAPI.getSkillsAutoComplete(createJobManager: CreateJobManager(skillsAutoCompleteText: textfield.text ?? "")) { (response, errorResponse) in
                    
                    if errorResponse != nil {
                        guard let message = errorResponse?.message else {return}
                        self.handleErrorResponse(message: message)
                    } else {
                        DispatchQueue.main.async {
                            if let requiredSkills = response?.autoSkills {
                                
                                if !(textfield.text?.isEmpty ?? true) {
                                    cell?.requiredSkillsListView.isHidden = false
                                    self.dismissKeyboard()
                                    self.requiredSkillsDropDown.dataSource = requiredSkills
                                    self.requiredSkillsDropDown.reloadAllComponents()
                                    self.requiredSkillsDropDown.show()
                                } else {
                                    self.requiredSkillsDropDown.hide()
                                    self.requiredSkillsDropDown.dataSource = []
                                }
                            }
                            self.removeSpinner()
                        }
                    }
                }
            }
            
        } else {
            self.requiredSkillsDropDown.hide()
        }
        
        self.requiredSkillsDropDown.anchorView = cell?.requiredSkillsListView
        requiredSkillsDropDown.textColor = AppTheme.textColor

        requiredSkillsDropDown.textFont = UIFont.appLightFontWith(size: 18.0)

        
        self.requiredSkillsSelection(field: textfield)
        
//        var contentSize = pagingScrollView.contentSize
//        //contentSize.height = contentSize.height + 20
//        contentSize.height += 20
//        pagingScrollView.contentSize = contentSize
        
    }
    
    func requiredSkillsSelection(field : UITextField) {
        let cell = skillsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SkillsCell
        requiredSkillsDropDown.selectionAction = { (index , item ) in
            field.text = ""
            
            let skillExistInOptional = self.optionalSkillArray.contains(obj: item)
            if skillExistInOptional {
                self.showBanner(title: "", withMessage: "Already added as optional skill.", style: .warning)
                return
            }
            
            let skillExistInRequired = self.requiredSkillArray.contains(obj: item)
            if skillExistInRequired {
                self.showBanner(title: "", withMessage: "Required Skill already added", style: .warning)
                return
            } else {
                self.requiredSkillArray.append(item)
                let selectedItem = "\(item)"
                cell?.requiredSkillsListView.addTag(selectedItem)
                DispatchQueue.main.async {
                    cell?.requiredSkillsListView.reloadInputViews()
                    self.skillsTableView.reloadData()
                }
            }
        }
    }
    
    @objc func optionalSkillsEditing(textfield: UITextField) {
         let cell = skillsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SkillsCell
        if textfield.text != "" {
            
            self.createJobAPI.getSkillsAutoComplete(createJobManager: CreateJobManager(skillsAutoCompleteText: textfield.text ?? "")) { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    
                    DispatchQueue.main.async {
                        if let optionalSkills = response?.autoSkills {
                            
                            if !(textfield.text?.isEmpty ?? false) {
                                cell?.optionalSkillsListView.isHidden = false
                                self.dismissKeyboard()
                                self.optionalSkillsDropDown.dataSource = optionalSkills
                                self.optionalSkillsDropDown.reloadAllComponents()
                                self.optionalSkillsDropDown.show()
                                
                            } else {
                                self.optionalSkillsDropDown.hide()
                                self.optionalSkillsDropDown.dataSource = []
                            }
                            
                        }
                        self.removeSpinner()
                    }
                }
            }
            
        } else {
            self.optionalSkillsDropDown.hide()
        }
        
        optionalSkillsDropDown.anchorView = cell?.optionalSkillsListView
        optionalSkillsDropDown.textColor = AppTheme.textColor
        
        optionalSkillsDropDown.textFont = UIFont.appLightFontWith(size: 18.0)

        self.optionalSkillsSelection(textfield: textfield)
        
//        var contentSize = pagingScrollView.contentSize
//        //contentSize.height = contentSize.height + 20
//        contentSize.height += 20
//        pagingScrollView.contentSize = contentSize
        
    }
    
    func optionalSkillsSelection(textfield: UITextField) {
        let cell = skillsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SkillsCell
        optionalSkillsDropDown.selectionAction = { (index , item ) in
            
            textfield.text = ""
            let skillExistInRequired = self.requiredSkillArray.contains(obj: item)
            if skillExistInRequired {
                self.showBanner(title: "", withMessage: "Already added as required skill.", style: .warning)
                return
            }
            
            let skillExistInOptional = self.optionalSkillArray.contains(obj: item)
            if skillExistInOptional {
                self.showBanner(title: "", withMessage: "Optional Skill already added", style: .warning)
                return
            } else {
                self.optionalSkillArray.append(item)
                let selectedItem = "\(item)"
                cell?.optionalSkillsListView.addTag(selectedItem)
                DispatchQueue.main.async {
                           cell?.optionalSkillsListView.reloadInputViews()
                           self.skillsTableView.reloadData()
                       }
            }
            
        }
       
    }

    func setupDropDown() {
        
        requiredSkillsDropDown.direction = .bottom
        requiredSkillsDropDown.bottomOffset = CGPoint(x: 0, y: 10)
        //requiredListView.delegate = self
        requiredSkillsDropDown.backgroundColor = AppTheme.appBackgroundColor


        optionalSkillsDropDown.direction = .bottom
        optionalSkillsDropDown.bottomOffset = CGPoint(x: 0, y: 10)
        //optionalSkillsListView.delegate = self
        optionalSkillsDropDown.backgroundColor = AppTheme.appBackgroundColor
        
        interViewModeDropDown.dataSource = ["Web Conference (Video)","Tele Conference (Audio)"]
        
        interViewModeDropDown.customCellConfiguration = {(index, item,dropDownCell) in
            if index == 1 {
                dropDownCell.optionLabel.isEnabled = false
            }
            dropDownCell.optionLabel.font = UIFont.appLightFontWith(size: 18.0)

        }



        //interViewModeDropDown.reloadAllComponents()
        
        self.interviewModeField.text = interViewModeDropDown.dataSource[0]
    }

    @objc func chooseDocumentAction(_ sender: UIButton) {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 8, section: 0)) as? PrimaryTableViewCell
        if sender.tag == 1 {
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: eTekiAWSSupport.documentTypes, in: UIDocumentPickerMode.import)
            
            documentPicker.modalPresentationStyle = .formSheet
            // documentPicker.navigationController?.modalPresentationStyle = .fullScreen
            
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
            
        } else {
            
            
            cell?.jobDescUploadButton.tag = 1
            cell?.jobDescUploadButton.setTitle(.upload, for: .normal)

            
            if companyFileS3Key != "" {
                
                self.showSpinner()
                
                let s3 = AWSS3.default()
                let deleteObjectRequest = AWSS3DeleteObjectRequest()
                deleteObjectRequest?.bucket = S3Configuration.BUCKETNAMEDOCUMENTS.rawValue
                deleteObjectRequest?.key = self.companyFileS3Key
                s3.deleteObject(deleteObjectRequest ?? AWSS3DeleteObjectRequest()).continueWith { (task:AWSTask) -> AnyObject? in
                    if let error = task.error {
                        print("Error occurred: \(error)")
                        return nil
                    }
                    
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        cell?.jobDescriptionUploadFile?.text = ""
                        self.createJobResponse.jobDescriptionAwsurl = ""
                        self.showBanner(title: "", withMessage: "File Removed Successfully.", style: .success)
                        self.companyFileS3Key = ""
                    }
                    
                    return nil
                }
                
            } else {
                cell?.jobDescriptionUploadFile?.text = ""
                self.companyFileS3Key = ""
            }
        }
        
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 8, section: 0)) as? PrimaryTableViewCell
        let newUrls = urls.compactMap { (url: URL) -> URL? in
            // Create file URL to temporary folder
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            // Apend filename (name+extension) to URL
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                // Move file from app_id-Inbox to tmp/filename
                
                try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                return tempURL
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        print(newUrls)
        if (newUrls != []) {
            let newPath = newUrls[0].absoluteString
            //newPath = newPath.replacingOccurrences(of: "file:/", with: "")
            if let filePath = URL(string: newPath) {
                
                cell?.jobDescriptionUploadFile?.text = filePath.lastPathComponent
                do {
                    let fileData = try Data(contentsOf: filePath,options: [])
                    if eTekiAWSSupport.supportedDocs.contains(obj: filePath.pathExtension) {
                        self.showSpinner()
                        self.uploadFile(fileData: fileData,fileUrl : filePath)
                        return
                    } else {
                        cell?.jobDescriptionUploadFile?.text = ""
                        self.showBanner(title: "", withMessage: "Unsupported file format.", style: .danger)
                        return
                    }
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        }
        
    }
    
    
    @IBAction func countrySelection(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCountry(notfication:)), name: Notification.Name("CountriesSearch"), object: nil)
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.createJobToCountrySearch, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navVC = segue.destination as? UINavigationController
        let searchVc = navVC?.viewControllers.first as? SearchViewController
        
        if segue.identifier == StoryboardSegueIdentifiers.createJobToLangaugeSearch {
            searchVc?.currentSearch = StoryboardSegueIdentifiers.createJobToLangaugeSearch
            searchVc?.selectedItem = self.interviewlLanguageField.text ?? ""
        } else if segue.identifier == StoryboardSegueIdentifiers.createJobToAreaExpertise {
            let cell = primaryTableView.cellForRow(at: IndexPath(row: 9, section: 0)) as? PrimaryTableViewCell
            searchVc?.currentSearch = StoryboardSegueIdentifiers.createJobToAreaExpertise
            searchVc?.selectedItem = cell?.areasOfExpertise?.text ?? ""

        } else if segue.identifier == StoryboardSegueIdentifiers.createJobToCountrySearch {
            searchVc?.currentSearch = StoryboardSegueIdentifiers.createJobToCountrySearch
            searchVc?.selectedItem = self.interviewLocationField.text ?? ""

        } else if segue.identifier == StoryboardSegueIdentifiers.createJobToContributorSettings {
            
            if isNavigatingFrom == .createJob {
                NotificationCenter.default.addObserver(self, selector: #selector(createJobReload(notfication:)), name: Notification.Name("ClearCreateJob"), object: nil)
            }
            
            let contributorsController = navVC?.viewControllers.first as?  ContributorSettingsViewController
            contributorsController?.jobID = self.jobID
            contributorsController?.isNavigatingFrom = StoryboardSegueIdentifiers.createJobToContributorSettings
        } else if segue.identifier == "CreateJobToCustomMessage" {
            if let navVC = segue.destination as? CustomAlertViewController {
                // print(currentAnalyticStatus)
                navVC.isNavigatingFrom = "CreateJobToCustomMessage"
                navVC.currentTagList = currentTagList
                navVC.tittle =  self.currentTitle
                NotificationCenter.default.addObserver(self, selector: #selector(removeTagConfirmAction(notfication:)), name: Notification.Name("CreateJobToCustomMessage"), object: nil)
            }
        }
        
    }
    
    @objc func removeTagConfirmAction(notfication: NSNotification) {
        
        let cell = skillsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SkillsCell
        let cell1 = skillsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SkillsCell
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            
            if let tagList = info["listview"] as? TagListView {
                
                if tagList == cell?.requiredSkillsListView {

                    cell?.requiredSkillsListView.removeTag(currentTitle)
                    requiredSkillArray.remove(object: currentTitle)

                } else if tagList == cell1?.optionalSkillsListView {

                    cell1?.optionalSkillsListView.removeTag(currentTitle)
                    optionalSkillArray.remove(object: currentTitle)
                }
                DispatchQueue.main.async {
                    self.skillsTableView.reloadData()
                }
                
            }
            // Check if value present before using it
            NotificationCenter.default.removeObserver(self, name: Notification.Name("CreateJobToCustomMessage"), object: nil)
        }
    }

    @objc func createJobReload(notfication: NSNotification) {
        showPrimaryView()
        //self.jobTitle.text = ""
        //self.companyLogo.text = ""
        //self.companyName.text = ""
        //self.yearsOfExperience.text = ""
        //self.date.text = ""
        //self.numberOfCandidates.text = ""
        //self.requisitionNumber.text = ""
        //self.jobDescription.text = ""
        //self.descriptionView.text = "JOB_DESCRIPTION_PLACEHOLDER_TEXT".localized
//        self.companyFileS3Key = ""
//        //self.areaOfExpertise.text = ""
//        self.requiredSkills.text = ""
//        self.requiredSkillArray = []
//        self.optionalSkills.text = ""
//        self.optionalSkillArray = []
//        self.specificationTextView.text = "SPECIFICATION_PLACEHOLDER_TEXT".localized
//        self.interviewLocationField.text = ""
//        self.interviewlLanguageField.text = ""
//        self.codingSamples.isChecked = false
//        self.whiteBoard.isChecked = false
//        self.candidatePicture.isChecked = false
//        self.requiredListView.removeAllTags()
//        self.optionalSkillsListView.removeAllTags()
//        self.companyLogoS3Key = ""
//        specificationTextView.textColor = AppTheme.placeHolderColor
//        specificationTextView.delegate = self
//        specificationTextView.contentInset = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 0)
//        //  descriptionView.delegate = self
//        self.companyLogoAWSString = ""
        //  descriptionView.textColor = AppTheme.placeHolderColor
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ClearCreateJob"), object: nil)
    }
    
    @IBAction func laguagePreferecesAction(_ sender: Any) {
        
        interViewLanguageDropDown.show()
        interViewLanguageDropDown.anchorView = self.interviewlLanguageField
        interViewLanguageDropDown.selectionAction = { (index , item ) in
            let selectedItem = item
            self.interviewlLanguageField.text = selectedItem
        }
    }
    
    @IBAction func interviewModeAction(_ sender: Any) {
        interViewModeDropDown.show()
        interViewModeDropDown.anchorView = self.interviewModeAnchor
        interViewModeDropDown.selectionAction = { (index , item ) in
            if(index == 0) {
                let selectedItem = item
                self.interviewModeField.text = selectedItem
            }
        }
        
    }
    
    @objc func choosLogoAction(_ sender: UIButton) {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PrimaryTableViewCell
        if sender.tag == 1 {
            
            self.imagePicker.delegate = self
            self.imagePicker.photoGalleryAsscessRequest()
            
        } else {
            cell?.uploadLogo?.tag = 1
            cell?.uploadLogo?.setTitle(.upload, for: .normal)
            if companyLogoS3Key != "" {
                
                self.showSpinner()
                let awsInstance = AWSS3.default()
                let deleteObjectRequest = AWSS3DeleteObjectRequest()
                deleteObjectRequest?.bucket = S3Configuration.BUCKETNAME.rawValue
                deleteObjectRequest?.key = self.companyLogoS3Key
                awsInstance.deleteObject(deleteObjectRequest ?? AWSS3DeleteObjectRequest()).continueWith { (task:AWSTask) -> AnyObject? in
                    if let error = task.error {
                        print("Error occurred: \(error)")
                        return nil
                    }
                    
                    print("Deleted successfully.")
                    
                    // self.downloadImage()
                    
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        //self.logoImageView.image = self.logoPlaceHolder
                        self.companyLogoS3Key = ""
                        self.companyLogoAWSString = ""
                        self.createJobResponse.companyLogo = ""
                        self.showBanner(title: "", withMessage: "Logo Removed Successfully.", style: .success)
                        cell?.hiringCompanyLogo?.text = ""
                    }
                    
                    return nil
                }
                
            } else {
                // self.logoImageView.image = self.logoPlaceHolder
                self.companyLogoS3Key = ""
                self.companyLogoAWSString = ""
                cell?.hiringCompanyLogo?.text = ""
            }
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        pagingScrollView.setContentOffset(.zero, animated: true)
        let index = progressBarWithDifferentDimensions.currentIndex
        switch index {
        case 0:
            NotificationCenter.default.post(name: Notification.Name("RefreshDashboard"), object: nil, userInfo:nil)
            if isNavigatingFrom != .createJob {
                self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        case 1:
            showPrimaryView()
        case 2:
            showSkillsView()
        default:
            showPrimaryView()
        }
    }

    @IBAction func updateCreateJobAPI(_ sender: Any) {
        
        pagingScrollView.setContentOffset(.zero, animated: true)
        if (progressBarWithDifferentDimensions.currentIndex == 0) {

            let result = primaryViewValidations()
            if result {
                showSkillsView()
                progressBarWithDifferentDimensions.currentIndex = 1
            }
            
            
        } else if (progressBarWithDifferentDimensions.currentIndex == 1) {
            
            
            let isValid = self.skillsViewValidation()
            
            if isValid {
                showPreferenceView()
                progressBarWithDifferentDimensions.currentIndex = 2
            }
            
            
            
        } else if (progressBarWithDifferentDimensions.currentIndex == 2) {
            
            self.showSpinner()
            
            let requiredSkills = requiredSkillArray.map { String($0) }
                .joined(separator: ",")
            
            let optionalSkills = optionalSkillArray.map { String($0) }
                .joined(separator: ",")
            
            
            var specialInstructionText = createJobResponse.specialInstructions ?? ""
            if specialInstructionText == "SPECIFICATION_PLACEHOLDER_TEXT".localized {
                specialInstructionText = ""
            }
            
            var description = createJobResponse.jobDescription ?? ""
            if description == "JOB_DESCRIPTION_PLACEHOLDER_TEXT".localized {
                description = ""
            }
            print(description)
            
            var requestType = ""
            
            if isNavigatingFrom == .editJob {
                requestType = .editJob
            } else {
                requestType = .createJob
            }

            let experienceRequired = createJobResponse.experirenceRequired ?? ""
            let numberOfCandidates = createJobResponse.numberOfProspects ?? ""
            let expertiseCategory  = createJobResponse.expertiseCategory ?? ""
            let jobTitle = createJobResponse.jobTitle ?? ""
            let languagePref = self.interviewlLanguageField.text ?? ""
            let locationPref = self.interviewLocationField.text ?? ""


            let createJobManager = CreateJobManager(clientCompanyName: createJobResponse.clientCompanyName, codingRequired: codingSamples.isChecked, description: description, dueDate: self.currentJobDueDate, experirenceRequired: experienceRequired, expertiseCategory: expertiseCategory, idRequired: candidatePicture.isChecked, interViewMode: "Video", whiteboradRequired: whiteBoard.isChecked, numberOfProspects: numberOfCandidates, specialInstructions: specialInstructionText, preferedSkillSet: optionalSkills, skillset: requiredSkills, jobTitle: jobTitle, jobDescriptionAwsurl: companyFileS3Key, interViewLanguagePreference: languagePref, interViewLocationPreference: locationPref, jobCode: createJobResponse.jobCode ?? "", companyLogo: self.companyLogoAWSString, requestType: requestType, jobID: self.jobID)
            
            var newJobDetailsDict = [String:String]()
            let amplitudeInstance = Amplitude()
            amplitudeInstance.initializeApiKey("e3b77be60e7267be70c74f7e26876569")
           
            
            amplitudeInstance.setUserProperties(newJobDetailsDict)
            //amplitudeInstance.logEvent("Creating Job Event")
            newJobDetailsDict["company name"] = createJobResponse.clientCompanyName
            newJobDetailsDict["job title"] = createJobResponse.jobTitle
            newJobDetailsDict["required skill"] = createJobResponse.skillset
            newJobDetailsDict["optional skill"] = createJobResponse.preferedSkillSet

            newJobDetailsDict["user name"] = UserDefaults.standard.string(forKey: "displayName") ?? ""
            newJobDetailsDict["user type"] = UserDefaults.standard.string(forKey: "Role") ?? ""
            
            amplitudeInstance.logEvent("Create Job Event", withEventProperties: newJobDetailsDict)
            
            amplitudeInstance.uploadEvents()
            
            amplitudeInstance.printEventsCount()
            

            self.createJobAPI.updateCreateJob(createJobManager: createJobManager) { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                    
                } else {
                    if response?.success ?? false {
                        
                        DispatchQueue.main.async {
                            self.jobID = response?.jobId ?? ""
                            self.showBanner(title: "", withMessage: response?.message ?? "Job Created.", style: .success)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.removeSpinner()
                            
                            // self.performSegue(withIdentifier: StoryboardSegueIdentifiers.createJobToDashboard, sender: self)

                            if (self.isNavigatingFrom == .editJob || response?.isIndependentRecruiter ?? false) {
                                self.performSegue(withIdentifier: StoryboardSegueIdentifiers.createJobToDashboard, sender: self)
                            } else {
                                self.performSegue(withIdentifier: StoryboardSegueIdentifiers.createJobToContributorSettings, sender: self)

                            }
                        })
                    }
                }
            }
        }
    }
    
}

extension CreateJobViewController {
    
    func showSkillsView() {
        primaryTableView.isHidden = true
        skillsTableView.isHidden = false
        preferenceView.isHidden = true
        saveButton.setTitle(.saveAndContinue, for: .normal)
        progressBarWithDifferentDimensions.currentIndex = 1
    }
    
    func showPreferenceView() {
        
        if isNavigatingFrom == .editJob {
            self.saveButton.setTitle(.update, for: .normal)
        } else if isNavigatingFrom == .copyJob {
            self.saveButton.setTitle(.copyJob, for: .normal)
        } else {
            self.saveButton.setTitle(.createJob, for: .normal)
            self.showSpinner()
            self.profileAPI.getProfileDetails(profileManager: ProfileManager(type: Profile.companyDetails)) { (response, errorResponse) in
                
                if errorResponse != nil {
                    guard let message = errorResponse?.message else {return}
                    self.handleErrorResponse(message: message)
                } else {
                    
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        if response?.idRequired ?? false {
                            self.candidatePicture.isChecked = true
                            self.candidatePicture.isEnabled = false
                        } else {
                            self.candidatePicture.isChecked = false
                            self.candidatePicture.isEnabled = true
                        }
                    }
                }
                
            }
        }
        primaryTableView.isHidden = true
        skillsTableView.isHidden = true
        preferenceView.isHidden = false
        
        progressBarWithDifferentDimensions.currentIndex = 2
    }
    
    func showPrimaryView() {
        primaryTableView.isHidden = false
        skillsTableView.isHidden = true
        preferenceView.isHidden = true
        saveButton.setTitle(.saveAndContinue, for: .normal)
        progressBarWithDifferentDimensions.currentIndex = 0
        primaryTableView.reloadData()
    }
}

extension CreateJobViewController {
    
    func primaryViewValidations() -> Bool {
        var status = true

        var jobDescription = ""
        for i in 0..<10 {
            let cell = primaryTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PrimaryTableViewCell
            switch i {
            case 0:
                if cell?.jobTitle?.text == "" {
                    status = false
                    showValidation(textField: cell?.jobTitle ?? UITextField(), currentField: "Job Title")
                    cell?.jobTitle?.becomeFirstResponder()
                    break
                } else {
                    if let jobTitle = cell?.jobTitle?.text {
                        if !jobTitle.isEmpty {
                            createJobResponse.jobTitle = jobTitle
                        }
                    }
                }

            case 1:

                if !self.companyLogoAWSString.isEmpty {
                    createJobResponse.companyLogo = self.companyLogoAWSString
                }

            case 2:
                if(cell?.hiringCompanyName?.text == "") {
                    status = false
                    showValidation(textField: cell?.hiringCompanyLogo ?? UITextField(), currentField: "Hiring Company Name")
                    cell?.hiringCompanyName?.becomeFirstResponder()
                    break
                } else {
                    if let clientCompany = cell?.hiringCompanyName.text {
                        if !clientCompany.isEmpty {
                            createJobResponse.clientCompanyName = clientCompany
                        }
                    }
                }
            case 3:
                if(cell?.yearsOfExperience?.text == "") {
                    status = false
                    showValidation(textField: cell?.yearsOfExperience ?? UITextField(), currentField: "Years of Experience")
                    cell?.yearsOfExperience?.becomeFirstResponder()
                    break
                } else {

                    if let yearsOFexp = cell?.yearsOfExperience.text {
                        if !yearsOFexp.isEmpty {
                            createJobResponse.experirenceRequired = yearsOFexp
                        }
                    }
                }
            case 4:
                if(cell?.jobDueDate?.text == "") {
                    status = false
                    self.showBanner(title: "", withMessage: "Job Closing Date can't be blank.", style: .warning)
                    break
                } else {

                    if let currentSelectedDate = cell?.jobDueDate?.text  {

                        if currentSelectedDate != "" {
                            //print(self.date.text ?? "")

                            let currentDate = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = Formats.date_monthFormat
                            let todaysDate = formatter.string(from: currentDate).toDate()
                            let selectedDate =  currentSelectedDate.toDate()

                            if selectedDate.compare(todaysDate) == .orderedSame {
                                print("Both dates are same")
                                self.showBanner(title: "", withMessage: .jobDateCantTodaysDate, style: .warning)
                                cell?.jobDueDate?.text = ""
                                status = false

                            } else if selectedDate.compare(todaysDate) == .orderedAscending {

                                print("Date is less than current date")
                                self.showBanner(title: "", withMessage: .jobDateCantBeLessthanTodaysDate, style: .warning)
                                cell?.jobDueDate?.text = ""
                                status = false
                            } else {
                                status = true
                                self.currentJobDueDate = currentSelectedDate
                            }
                        }
                    }
                }
            case 5:
                if (cell?.numberOfCandidates?.text == "") {
                    status = false
                    showValidation(textField: cell?.numberOfCandidates ?? UITextField(), currentField: "Projected number of candidates")
                    cell?.numberOfCandidates?.becomeFirstResponder()
                    break
                } else if (cell?.numberOfCandidates?.text == "0") {
                    status = false
                    cell?.numberOfCandidates?.text = ""
                    self.showBanner(title: "", withMessage: "Projected number of candidates should be more than 0", style: .warning)
                    cell?.numberOfCandidates?.becomeFirstResponder()
                    break
                } else {

                    if let numberOfCandidates = cell?.numberOfCandidates.text {
                        if !numberOfCandidates.isEmpty {
                            createJobResponse.numberOfProspects = numberOfCandidates
                        }
                    }
                }

            case 6:

                if let jobCode = cell?.jobRequistionNumber.text {
                    if !jobCode.isEmpty {
                        createJobResponse.jobCode = jobCode
                    }
                }

            case 7:
                if (cell?.jobDescriptionTextView.text == "JOB_DESCRIPTION_PLACEHOLDER_TEXT".localized && companyFileS3Key.isEmpty) {
                    status = false
                    self.showBanner(title: "", withMessage: "Please upload file or write the description.", style: .warning)
                    break
                } else {

                    if cell?.jobDescriptionTextView.text != "JOB_DESCRIPTION_PLACEHOLDER_TEXT".localized {
                        if let jobDesc = cell?.jobDescriptionTextView.text {
                            if !jobDesc.isEmpty {
                                createJobResponse.jobDescription = jobDesc
                                jobDescription = jobDesc
                            }
                        }
                    }
                }
            case 8:

                if cell?.jobDescriptionUploadFile.text?.isEmpty ?? true && jobDescription.isEmpty {
                    status = false
                    self.showBanner(title: "", withMessage: "Please upload file or write the description.", style: .warning)
                    cell?.jobDescriptionUploadFile.becomeFirstResponder()
                }

                if !self.companyFileS3Key.isEmpty {
                    createJobResponse.jobDescriptionAwsurl  = self.companyFileS3Key
                }


            case 9:

                if isNavigatingFrom == .editJob || isNavigatingFrom == .copyJob {
                    status = true
                    break
                } else if isNavigatingFrom == .createJob {

                    if (createJobResponse.expertiseCategory?.isEmpty ?? true) {
                        status = false
                        self.showBanner(title: "", withMessage: .areasOfExpertiseErrorMessage, style: .warning)
                        break

                    }

                } else {
                    status = true
                    if let areasOFExpertise = cell?.areasOfExpertise.text {
                        if !areasOFExpertise.isEmpty {
                            createJobResponse.expertiseCategory = areasOFExpertise
                        }
                    }
                }

            default:
                break
            }
            if !status {
                break
            }
        }
        return status
    }
    
    func skillsViewValidation() -> Bool {
        let cell = skillsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SkillsCell
        if !(cell?.requiredSkillsListView.tagViews.isEmpty ?? false) {
            return true
        } else {
            cell?.requiredSkillsField.becomeFirstResponder()
            self.showBanner(title: "", withMessage: "Please add Required Skills.", style: .warning)
        }
        
        return false
    }
    
    func showValidation(textField : UITextField,currentField : String) {
        self.showBanner(title: "", withMessage: "\(currentField) can't be blank.", style: .warning)
        textField.text = ""
        textField.becomeFirstResponder()
        
    }
    
}

extension CreateJobViewController {
    
    func setupProgressBarWithDifferentDimensions() {
        viewModel.steppedProgressBar = progressBarWithDifferentDimensions
        progressBarWithDifferentDimensions.delegate = self
        viewModel.updatedSteppedBar()        
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
            
            print(progressBar.completedTillIndex)
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                case 0:
                    return "Primary"
                case 1:
                    return "Skills"
                case 2:
                    return "Preferences"
                default: return "Date"
                }
            }
        }
        return ""
    }
    
}

extension CreateJobViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == specificationTextView {
            if textView.textColor == AppTheme.placeHolderColor {
                textView.text = ""
                textView.textColor = AppTheme.textColor
            }
        } else {

            textView.textColor = AppTheme.textColor

            //            if textView.text != "" {
            //                textView.text = ""
            //                textView.textColor = AppTheme.textColor
            //            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 77 {
            createJobResponse.jobDescription = textView.text
            //            let fixedWidth = textView.frame.size.width
            //            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            //            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            //            var newFrame = textView.frame
            //            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            //            textView.frame = newFrame
        } else if textView.tag == 78 {
            createJobResponse.specialInstructions = textView.text
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == specificationTextView{
            if textView.text.isEmpty {
                textView.text = "SPECIFICATION_PLACEHOLDER_TEXT".localized
                textView.textColor = AppTheme.placeHolderColor
            }
        } else if textView.tag == 77 {
            primaryTableView.reloadData()
        } else if textView.tag == 78 {
            textView.scrollsToTop = true
//            textView.isScrollEnabled = false
            skillsTableView.reloadData()
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

extension CreateJobViewController {
    
    func onGetJobDetailsReponse(response : CreateJobResponse?) {
        
        DispatchQueue.main.async {
            self.removeSpinner()

            self.createJobResponse = response ?? CreateJobResponse()

            if !self.primaryTableView.isHidden {
                self.primaryTableView.reloadData()
            }

            if let required = response?.skillset {
                let cell = self.skillsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SkillsCell
                let requiredSkills = required.components(separatedBy: ",")
                for skill in requiredSkills {
                    if skill != "" {
                        cell?.requiredSkillsListView.isHidden = false
                        self.requiredSkillArray.append(skill)
                    }
                }
                cell?.requiredSkillsListView.addTags(self.requiredSkillArray)
            }
            
            if let optional = response?.preferedSkillSet {
                let cell = self.skillsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SkillsCell
                let optionalSkills = optional.components(separatedBy: ",")
                for skill in optionalSkills {
                    if skill != "" {
                        cell?.optionalSkillsListView.isHidden = false
                        self.optionalSkillArray.append(skill)
                    }
                }
            cell?.optionalSkillsListView.addTags(self.optionalSkillArray)
             
            }
            
            if !self.skillsTableView.isHidden {
                self.skillsTableView.reloadData()
            }
            
            self.interviewLocationField.text = response?.interViewLocationPreference ?? ""
            self.interviewlLanguageField.text = response?.interViewLanguagePreference ?? ""
            
            if response?.idRequired ?? false {
                self.candidatePicture.isChecked = true
                self.candidatePicture.isEnabled = false
            } else {
                self.candidatePicture.isChecked = false
                self.candidatePicture.isEnabled = true
            }
            
            if response?.whiteboradRequired ?? false {
                self.whiteBoard.isChecked = true
            } else {
                self.whiteBoard.isChecked = false
            }
            
            if response?.whiteboradRequired ?? false {
                self.whiteBoard.isChecked = true
            } else {
                self.whiteBoard.isChecked = false
            }
            
            if response?.codingRequired ?? false {
                self.codingSamples.isChecked = true
            } else {
                self.codingSamples.isChecked = false
            }
        }
        
    }
    
}


extension CreateJobViewController : TagListViewDelegate {
    
    func didSelect(image: UIImage?, imageName: URL?) {
        // Logo selection
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        currentTagList = sender
        currentTitle = title
        self.performSegue(withIdentifier: "CreateJobToCustomMessage", sender: tagView)
        
    }
    
}


extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

extension CreateJobViewController {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let cell = skillsTableView.cellForRow(at: IndexPath(row: 1, section: 0 )) as? SkillsCell
        if textField == cell?.requiredSkillsField {
            if (string.count ) == 0 {
                //Delete any cases
                if range.length > 1 {
                    //Delete whole word
                    print("Delete whole word")
                } else if range.length == 1 {
                    //Delete single letter
                    print("Delete single letter")
                    self.requiredSkillsDropDown.dataSource = []
                    self.requiredSkillsDropDown.hide()
                } else if range.length == 0 {
                    //Tap delete key when textField empty
                    print("Tap delete key when textField empty")
                }
            }
            return true
        } else {
            return true
        }
    }
}

extension CreateJobViewController {
    
    func updateSuggestSkillTextView() {
        
        let range = (noteSuggestSkill.text as NSString).range(of: "here.")
        let range1 = (noteSuggestSkill.text as NSString).range(of: "Note:")
        
        let attribute = NSMutableAttributedString(string: noteSuggestSkill.text)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.appBoldFontWith(size: 14.0) , range: range1)
        attribute.addAttribute(NSAttributedString.Key.link, value: "here." , range: range)
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: AppTheme.brandColor,
            NSAttributedString.Key.underlineColor: AppTheme.brandColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        noteSuggestSkill.linkTextAttributes = linkAttributes
        noteSuggestSkill.attributedText = attribute
        
        noteSuggestSkill.isEditable = false
        noteSuggestSkill.isSelectable = true
        noteSuggestSkill.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.createJobToSuggestSkill, sender: self)
        return false
    }
}

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension CreateJobViewController: ImagePickerDelegate {
    
    func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker) {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PrimaryTableViewCell
        selectedImage = image.resizedImage(newSize: CGSize(width: 80, height: 80))
        //        self.logoImageView.image = selectedImage
        cell?.uploadLogo?.setTitle(.remove, for: .normal)
        cell?.uploadLogo?.tag = 2
        self.showSpinner()
        self.uploadImageToAWS()
        imagePicker.dismiss()
    }
    
    
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker) { imagePicker.dismiss() }
    
    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed { presentImagePicker(sourceType: .photoLibrary) } else {print("No Access")}
    }
    
    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        // works only on real device (crash on simulator)
        if accessIsAllowed { presentImagePicker(sourceType: .camera) } else {
            print("No Access")
        }
    }
}

extension CreateJobViewController {
    
    func uploadImageToAWS() {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PrimaryTableViewCell
        AWSManager.shared.uploadS3(image: selectedImage, name: "CompanyLogo", progressHandler: { (progress) in
            DispatchQueue.main.async(execute: {
                print(progress)
                if progress.fractionCompleted == 1.0  {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                    }
                }
            })
        }, s3UrlHandler: { (s3ImageUrl,remoteName)  in
            
            self.companyLogoS3Key = remoteName ?? ""
            self.companyLogoAWSString = s3ImageUrl?.absoluteString ?? ""
            self.createJobResponse.companyLogo = self.companyLogoAWSString

            
            DispatchQueue.main.async {
                // self.showBanner(title: "", withMessage: "Upload Success", style: .success)
                cell?.hiringCompanyLogo?.text = self.companyLogoS3Key
            }
            
            print("Upload Completed ==================\(self.companyLogoS3Key)")
            
            // self.downloadImage()
            
        }) { (error) in
            DispatchQueue.main.async {
                self.showBanner(title: "", withMessage: "Image Upload Failed", style: .warning)
                //                self.logoImageView.image = self.logoPlaceHolder
                self.removeSpinner()
            }
            
        }
    }
    
    
    func downloadImageAWS(key : String) {
        AWSManager.shared.downloadImageWithKey(key: key, progressHandler: { (progress) in
            
            if progress.fractionCompleted == 1.0 {
                print(progress)
            }
            
        }, downloadedImage: { (image) in
            
            //self.logoImageView.image = image
            
        }) { (error) in
            
            // self.logoImageView.image = self.logoPlaceHolder
        }
        
    }
    
    func clearLocalDirectory() {
        let fileManager = FileManager()
        fileManager.clearTmpDirectory()
    }
    
    func uploadFile(fileData : Data,fileUrl : URL) {
        let cell = primaryTableView.cellForRow(at: IndexPath(row: 8, section: 0)) as? PrimaryTableViewCell
        AWSManager.shared.multipartFileUpload(fileData: fileData, name: fileUrl.pathExtension, awsLocationKey: "jobs/", progressHandler: { (progress) in
            
            if progress.fractionCompleted == 1.0 {
                DispatchQueue.main.async {
                    cell?.jobDescUploadButton.setTitle(.remove, for: .normal)
                    cell?.jobDescUploadButton.tag = 2
                    self.clearLocalDirectory()
                    self.removeSpinner()
                }
            }
        }, s3UrlHandler: { (url, remoteName) in
            
            print("===========================\(String(describing: url))")
            print("===========================\(String(describing: remoteName))")
            
            self.companyFileS3Key = url?.absoluteString ?? ""
            self.createJobResponse.jobDescriptionAwsurl = self.companyFileS3Key
            DispatchQueue.main.async {
                //  self.showBanner(title: "", withMessage: "Upload Success" , style: .success)
                cell?.jobDescriptionUploadFile?.text = url?.lastPathComponent ?? ""
            }
            
        }) { (error) in
            
            if let error  = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    cell?.jobDescUploadButton.setTitle(.upload, for: .normal)
                    cell?.jobDescUploadButton.tag = 1
                    self.showBanner(title: "", withMessage: error.localizedDescription , style: .danger)
                    self.removeSpinner()
                    
                }
            }
        }
    }
    
    func downloadFileForfileObject(url: String) { //Download pdf File asynchronosly
        let documentURL = NSURL(string: url)
        let documentsURLPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        
        let fileExtension = ((documentURL!.pathComponents)?.last)! as String
        let request: URLRequest = URLRequest(url: documentURL! as URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        let fileURLPath = documentsURLPath.appendingPathComponent("\(fileExtension)")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let teask = session.dataTask(with: request) { (data, response, error) in
            if (error == nil) {
                // Success
                self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
            } else {
                if let error  = error {
                    print(error.localizedDescription)
                }
                
            }
        }
        teask.resume()
    }
    
    func openSelectedDocumentFromURL(documentURLString: String) {
        let documentURL: NSURL = NSURL(fileURLWithPath: documentURLString)
        var documentInteractionController = UIDocumentInteractionController()
        documentInteractionController = UIDocumentInteractionController(url: documentURL as URL)
        documentInteractionController.delegate = self
        documentInteractionController.presentPreview(animated: true)
    }
    // MARK: - UIDocumentInteractionViewController delegate methods
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}


extension CreateJobViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == primaryTableView {
          return 10
        } else {
            return 6
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == primaryTableView {
            if indexPath.row == 7 {
                 // if newJDHeight < 50.0 {newJDHeight = 50.0}
                 return CGFloat(newJDHeight)
             }

            return 50.0
        } else {
            if (indexPath.row == 5 && isNavigatingFrom == .createJob) {
                 return CGFloat(skillsSpecHeight)
            }
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == primaryTableView {
        var cell = primaryTableView.dequeueReusableCell(withIdentifier: "JobTitle") as? PrimaryTableViewCell


        switch indexPath.row {
        case 0:
            //JobTitle
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "JobTitle") as? PrimaryTableViewCell
            cell?.jobTitle.text = createJobResponse.jobTitle ?? ""
            cell?.jobTitle.addTarget(self, action: #selector(updateJobId(textField:)), for: .editingChanged)


        case 1:
            //Hiring Company Logo
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "HiringCompanyLogo") as? PrimaryTableViewCell

            let companyURL = URL(string: createJobResponse.companyLogo ?? "")
            self.companyLogoS3Key = companyURL?.lastPathComponent ?? ""

            if companyURL?.pathExtension != "" {
                // self.downloadImageAWS(key: self.companyLogoS3Key)
                self.companyLogoAWSString = companyURL?.absoluteString ?? ""
                cell?.hiringCompanyLogo.text = companyURL?.lastPathComponent
                if cell?.hiringCompanyLogo.text != "" {
                    cell?.uploadLogo.setTitle(.remove, for: .normal)
                    cell?.uploadLogo.tag = 2
                } else {
                    cell?.uploadLogo.setTitle(.upload, for: .normal)
                    cell?.uploadLogo.tag = 1
                }
            }

            cell?.uploadLogo?.addTarget(self, action: #selector(choosLogoAction(_:)), for: .touchUpInside)

        case 2:
            //Hiring Company Name
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "HiringCompanyName") as? PrimaryTableViewCell
            cell?.hiringCompanyName.text = createJobResponse.clientCompanyName ?? ""
            cell?.hiringCompanyName.addTarget(self, action: #selector(updateHiringCompanyName(textField:)), for: .editingChanged)

        case 3:
            //Years of expirience
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "YearsOfExperience") as? PrimaryTableViewCell
            if let experience = createJobResponse.experirenceRequired {
                cell?.yearsOfExperience.text =  "\(experience)"
            }
            cell?.yearsOfExperience.addDoneButtonOnKeyboard(self, action: #selector(doneEditing))
            cell?.yearsOfExperience.addTarget(self, action: #selector(updateExpirence(textField:)), for: .editingChanged)


        case 4:
            //Job Due Date
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "JobDueDate") as? PrimaryTableViewCell
            cell?.delegate = self

            if !self.currentJobDueDate.isEmpty {
                cell?.jobDueDate.text = self.currentJobDueDate
            } else {
                if let dueDate = createJobResponse.dueDate {
                    let formatedDate = dueDate.changeCurrentDate(dueDate)
                    cell?.jobDueDate.text = formatedDate
                } else {
                    cell?.jobDueDate.text = ""
                }
            }

            cell?.jobDueDate.addTarget(self, action: #selector(updateDueDat(textField:)), for: .editingChanged)



        case 5:
            //Number of Candidates
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "NumberOfCandidates") as? PrimaryTableViewCell
            if let noOfCandidates = createJobResponse.numberOfProspects {
                cell?.numberOfCandidates.text =  "\(noOfCandidates)"
            }

            cell?.numberOfCandidates.addDoneButtonOnKeyboard(self, action: #selector(doneEditing))
            cell?.numberOfCandidates.addTarget(self, action: #selector(updateProjectNumberOfCandidates(textField:)), for: .editingChanged)


        case 6:
            //Job Requistion Number
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "JobRequistionNumber") as? PrimaryTableViewCell
            if let jobCode = createJobResponse.jobCode {
                cell?.jobRequistionNumber?.text = "\(jobCode)"
            }
            cell?.jobRequistionNumber.addTarget(self, action: #selector(updateRequestionNumber(textField:)), for: .editingChanged)


        case 7:
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "JobDescription") as? PrimaryTableViewCell
            cell?.jobDescriptionTextView.tag = 77
            cell?.jobDescriptionTextView.textColor = AppTheme.placeHolderColor
            cell?.jobDescriptionTextView.light(size: 18.0)
            cell?.jobDescriptionTextView.delegate = self
            if let description = createJobResponse.jobDescription {
                cell?.jobDescriptionTextView.text = description
                cell?.jobDescriptionTextView.textColor = AppTheme.textColor
            }
            cell?.jobDescriptionTextView.placeholderColor = AppTheme.placeHolderColor
            cell?.jobDescriptionTextView.isScrollEnabled = true
            cell?.jobDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        case 8:
            //Job Description Upload FIle
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "JobDescriptionUploadFile") as? PrimaryTableViewCell

            self.companyFileS3Key = createJobResponse.jobDescriptionAwsurl ?? ""

            let awsFileURL = URL(string: self.companyFileS3Key)
            cell?.jobDescriptionUploadFile?.text = awsFileURL?.lastPathComponent

            if cell?.jobDescriptionUploadFile?.text != "" {
                cell?.jobDescUploadButton.tag = 2
                cell?.jobDescUploadButton.setTitle(.remove, for: .normal)
            } else {
                cell?.jobDescUploadButton.tag = 1
                cell?.jobDescUploadButton.setTitle(.upload, for: .normal)
            }

            cell?.jobDescUploadButton?.addTarget(self, action: #selector(chooseDocumentAction(_:)), for: .touchUpInside)


        case 9:
            //Area Of Expertise
            cell = primaryTableView.dequeueReusableCell(withIdentifier: "AreasOfExpertise") as? PrimaryTableViewCell
            cell?.areasOfExpertise?.text = createJobResponse.expertiseCategory ?? ""
            // cell?.areasOfExpertise.addTarget(self, action: #selector(updateAreasOfExpertise(textField:)), for: .editingChanged)


        default:
            fatalError("Unandled Error")
        }
        
        return cell ?? PrimaryTableViewCell()
    
       }
       else  {
        var cell = skillsTableView.dequeueReusableCell(withIdentifier: "skillsHeader") as? SkillsCell
          
        switch indexPath.row {
            case 0:
              cell = skillsTableView.dequeueReusableCell(withIdentifier: "skillsHeader") as? SkillsCell
            
            case 1:
              cell = skillsTableView.dequeueReusableCell(withIdentifier: "requiredSkills") as? SkillsCell
                 cell?.requiredSkillsListView.enableRemoveButton = true
                 cell?.requiredSkillsListView.delegate = self
                 cell?.requiredSkillsListView.textFont = UIFont.appBoldFontWith(size: 12.0)
             
              cell?.requiredSkillsField.addTarget(self, action: #selector(requiredSkillsEditing(textfield:)), for: .editingChanged)
            
            case 2:
              cell = skillsTableView.dequeueReusableCell(withIdentifier: "optionalSkills") as? SkillsCell
                   cell?.optionalSkillsListView.enableRemoveButton = true
                   cell?.optionalSkillsListView.delegate = self
                   cell?.optionalSkillsListView.textFont = UIFont.appBoldFontWith(size: 12.0)
              cell?.optionalSkillsField.addTarget(self, action: #selector(optionalSkillsEditing(textfield:)), for: .editingChanged)
            
            case 3:
              cell = skillsTableView.dequeueReusableCell(withIdentifier: "skillsNote") as? SkillsCell
            
            case 4:
              cell = skillsTableView.dequeueReusableCell(withIdentifier: "specificationsHeader") as? SkillsCell
            
            case 5:
              cell = skillsTableView.dequeueReusableCell(withIdentifier: "codingSamples") as? SkillsCell
                cell?.growingTextView.tag = 78
                cell?.growingTextView.textColor = AppTheme.placeHolderColor
                cell?.growingTextView.light(size: 18.0)
                cell?.growingTextView.delegate = self
                 if let description = createJobResponse.specialInstructions {
                        cell?.growingTextView.text = description
                        cell?.growingTextView.textColor = AppTheme.textColor
                }
              if let specifications = createJobResponse.specialInstructions {
                  
                  if specifications == "" || specifications == "\n" {
                      
                    cell?.growingTextView.text = "SPECIFICATION_PLACEHOLDER_TEXT".localized
                    cell?.growingTextView.textColor = AppTheme.placeHolderColor
                      
                  } else {
                      cell?.growingTextView.text = specifications
                      cell?.growingTextView.textColor = AppTheme.textColor
                  }
               }
                cell?.growingTextView.placeholderColor = AppTheme.placeHolderColor
                cell?.growingTextView.isScrollEnabled = true
                cell?.growingTextView.translatesAutoresizingMaskIntoConstraints = false
            
        default:
            fatalError("Unandled Error")
        }
         return cell ?? SkillsCell()
       }
    }

    @objc func doneEditing() {
        self.view.endEditing(true)
    }

}

extension CreateJobViewController : PrimaryTableCellDelegate {

    func updateValue(response: CreateJobResponse?) {
        createJobResponse.dueDate = response?.dueDate
        self.currentJobDueDate = response?.dueDate ?? ""
    }

    @objc func updateJobId(textField: UITextField) {
        createJobResponse.jobTitle = textField.text
    }

    @objc func updateHiringCompanyName(textField: UITextField) {
        createJobResponse.clientCompanyName = textField.text
    }

    @objc func updateExpirence(textField: UITextField) {
        createJobResponse.experirenceRequired = textField.text
    }

    @objc func updateDueDat(textField: UITextField) {
        createJobResponse.dueDate = textField.text
    }

    @objc func updateProjectNumberOfCandidates(textField: UITextField) {
        createJobResponse.numberOfProspects = textField.text
    }

    @objc func updateRequestionNumber(textField: UITextField) {
        createJobResponse.jobCode = textField.text
    }

    @objc func updateJobDescription(textField: UITextField) {
        createJobResponse.jobDescription = textField.text
    }

    @objc func updateAreasOfExpertise(textField: UITextField) {
        createJobResponse.expertiseCategory = textField.text
    }


}

extension CreateJobViewController : GrowingTextViewDelegate {
  
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        let cell = skillsTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? SkillsCell
        if textView == cell?.growingTextView {
            skillsSpecHeight = Double(height)
        } else {
            newJDHeight = Double(height)
                   print(newJDHeight)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

}



