//
//  AddCandidateViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 19/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox
import FlagPhoneNumber
import DropDown
import AWSS3
import Amplitude

class AddCandidateViewController: BaseViewController, FPNTextFieldDelegate,UIDocumentPickerDelegate {
    
    @IBOutlet weak var candidateOwnerView: UIView!
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var notifyCheckbox: Checkbox!
    @IBOutlet weak var numberView: FPNTextField!
    @IBOutlet weak var dateField: PaddingTextField!
    @IBOutlet weak var timeField: PaddingTextField!
    @IBOutlet weak var firstNameField: PaddingTextField!
    @IBOutlet weak var lastNameField: PaddingTextField!
    @IBOutlet weak var emailField: PaddingTextField!
    @IBOutlet weak var candidateOwner: PaddingTextField!
    @IBOutlet weak var resumeTextField: PaddingTextField!
    @IBOutlet weak var timeZoneField: PaddingTextField!
    @IBOutlet weak var reportDuelabel: UILabel!
    @IBOutlet weak var smsOPTlabel: UILabel!
    @IBOutlet weak var notifyInterview: UILabel!
    @IBOutlet weak var disclaimer: UILabel!
    @IBOutlet weak var disclaimerMessage: UILabel!
    @IBOutlet weak var uploadFileButton: UIButton!
    @IBOutlet weak var candidateOwnerAnchor: UILabel!
    @IBOutlet weak var jobClosingdateView: UIView!
    @IBOutlet weak var closingDateField: PaddingTextField!
    @IBOutlet weak var smsoptHeader: UIView!
    @IBOutlet weak var smsOPTview: UIView!
    @IBOutlet weak var submitButton: UIButton!
    var extendStatus = false
    var currentEmail = ""
    var lastDueDate = ""
    var isNavigatingFrom = ""
    var isIndependentRecruiter = false
    var resumeFileKey = ""
    var selectedTimeZoneCode = ""
    var ownerID = ""
    var prefferedInterViewTime = ""
    var candidateAPI : CandidatesAPIProtocol.Type =  CandidatesAPI.self
    var profileAPI: ProfileAPIProtocol.Type = ProfileAPI.self
    var jobID  = ""
    var candidateID  = ""
    var candiateOwners = [Dictionary<String,Any>]()
    var candidateDetails = Dictionary<String,Any>()
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let dateExtendPicker = UIDatePicker()
    var pickerMode = ""
    var phoneNumberStatus = false
    var areaCode = ""
    var countryCode = ""
    var jobClosedDate : String = ""
    var reportDueDate : String = ""
    var ownerName = ""
    var mailErrorResponse = ""
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    let dateFormatter = DateFormatter()
    let incrementDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    var defaultTime =  Date()
    var recruiterTime = Date()
    var currentTime = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCheckbox()
        setUpPhoneNumberField()
        
        //Call added to get updated timezone
        self.getProfileAddress()
        
        if isIndependentRecruiter {
            self.candidateOwnerView.isHidden = true
        } else {
            self.candidateOwnerView.isHidden = false
        }
        
        guard let pickerDate =  Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: incrementDate) else {return}
        defaultTime = pickerDate
        
        if isNavigatingFrom == .editCandidate {
            self.getCandidateDetails()
            self.navigationItem.title = .editCandidate
            self.submitButton.setTitle(.update, for: .normal)
            //setUpEditCandidateMaxDate()
            
        } else {
            self.navigationItem.title = .addCandidate
            self.submitButton.setTitle("Submit", for: .normal)
            
            if !isIndependentRecruiter {
                //self.getOwners() Commented as it may not require now
            }
            
            for dict in LocalCountry.timezoneList {
//                for (key,value) in dict {
//                    if key == "US/Michigan" {
//                        self.timeZoneField.text = value
//                    }
//                } Swift Lint comment Implemented
                for timezoneKeys in dict where timezoneKeys.key == "US/Michigan" {
                    self.timeZoneField.text = timezoneKeys.value
                }

            }
            self.candidateOwner.text = self.ownerName
            self.notifyCheckbox.isChecked = true
        }
        
        jobClosingdateView.isHidden = true
        self.uploadFileButton.tag = 1
        self.uploadFileButton.setTitle(.upload, for: .normal)
        
        self.numberView.addDoneButtonOnKeyboard(self, action: #selector(doneEditNumber))
        self.navigationItem.setLeftBarButtonItems(self.backItem, animated: false)

        notifyInterview.light(size: 16.0)


    }
    
    // setup Reportdue max date while its navigating from Edit candidate
    func setUpEditCandidateMaxDate() {
        generateEventLogToAnalytics(eventName: "Edit Candidate Event", status: "True")
        let timeWithEightandHalf1 = Date().string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let utcTime1 = self.localToUTC(date: timeWithEightandHalf1, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime1 = self.convertUTCToLocalTimeZone(date: utcTime1)
        self.currentTime = recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
        
        let newDate = Calendar.current.date(byAdding: .hour, value: 8, to: Date())
          guard let tomorrowDate = Calendar.current.date(byAdding: .minute, value: 30, to: newDate ?? Date()) else{return}
          
        let timeWithEightandHalf = tomorrowDate.string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let utcTime = self.localToUTC(date: timeWithEightandHalf, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime = self.convertUTCToLocalTimeZone(date: utcTime)
        
        let presentDate = setPresentTime()
        let thirtyDaysDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
        
              let jobDuedate = jobClosedDate.changeDate(jobClosedDate).toDate()
              // Setting maximum date
        print(jobDuedate)

              self.recruiterTime = recruiterTime.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
        
              if( jobDuedate < thirtyDaysDate ?? Date()) {
                  if(Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: jobDuedate) == Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: currentTime)) {
                      datePicker.minimumDate = recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
                    datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 45, second: 00, of: datePicker.minimumDate!)
                  }else {
                    if(datePicker.date < currentTime) {
                            datePicker.minimumDate = Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: currentTime)
                    } else {
                           datePicker.minimumDate = presentDate
                    }
                    datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 45, second: 00, of: jobDuedate) ?? Date()
                  }
              } else {
                if(datePicker.date < currentTime) {
                        datePicker.minimumDate = Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: currentTime)
                } else {
                       datePicker.minimumDate = presentDate
                }
                  datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: thirtyDaysDate ?? Date())
              }
        self.updateFeedBackDate()
    }
    
    
    func setPresentTime() -> Date{
        let timeWithEightandHalf = Date().string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let utcTime = self.localToUTC(date: timeWithEightandHalf, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime = self.convertUTCToLocalTimeZone(date: utcTime)
        let presentDate = recruiterTime.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
        return presentDate
    }
    // setup Reportdue minDate and maxDate while its navigating from Add candidate
    func setUpDateandTime() {
    
        let timeWithEightandHalf1 = Date().string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let utcTime1 = self.localToUTC(date: timeWithEightandHalf1, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime1 = self.convertUTCToLocalTimeZone(date: utcTime1)
        self.currentTime = recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
        
        let date = Calendar.current.date(byAdding: .hour, value: 8, to: Date())
        guard let tomorrowDate = Calendar.current.date(byAdding: .minute, value: 30, to: date ?? Date()) else{return}

        let timeWithEightandHalf = tomorrowDate.string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let utcTime = self.localToUTC(date: timeWithEightandHalf, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime = self.convertUTCToLocalTimeZone(date: utcTime)
        self.recruiterTime = recruiterTime.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
        
        if recruiterTime != "" {
            dateField.text = recruiterTime
            datePicker.date = recruiterTime.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
            datePicker.minimumDate = datePicker.date
            
            let thirtyDaysDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
      
            let jobDuedate = jobClosedDate.changeDate(jobClosedDate).toDate()
            // Setting maximum date
            if( jobDuedate < thirtyDaysDate ?? Date()) {
                if(Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: jobDuedate) == Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: currentTime)) {
                    datePicker.minimumDate = recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
                    datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 45, second: 00, of: datePicker.minimumDate ?? Date())
                }else {
                  datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 45, second: 00, of: jobDuedate) ?? Date()
                }
            } else {
                datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: thirtyDaysDate ?? Date())
            }

        }
    }
    
    func setUpPhoneNumberField() {
        
        numberView.font = UIFont.appLightFontWith(size: 18.0)
        numberView.hasPhoneNumberExample = true
        numberView.translatesAutoresizingMaskIntoConstraints = false
        numberView.delegate = self
        numberView.flagButtonSize = CGSize(width: 44, height: 44)
        numberView.keyboardType = .numberPad
        numberView.displayMode = .list // .picker by default
        listController.setup(repository: numberView.countryRepository)
        listController.didSelect = { [weak self] country in
         self?.numberView.setFlag(countryCode: country.code)
        }
    }
    
    func setUpCheckbox() {
        notifyCheckbox.borderLineWidth = 1
        notifyCheckbox.layer.cornerRadius = 5
        notifyCheckbox.checkmarkStyle = .tick
        notifyCheckbox.checkmarkColor = AppTheme.textColor
        notifyCheckbox.uncheckedBorderColor = AppTheme.fieldsBorderColor
        notifyCheckbox.checkedBorderColor = AppTheme.fieldsBorderColor
    }
    
    override func viewDidLayoutSubviews() {
        bgScrollView.contentSize = CGSize(width: view.frame.size.width, height: contentView.frame.size.height)
    }

    func showPicker(mode : String) {
        
        dateFormatter.dateFormat = Formats.dateWithTimeZone
        let date = jobClosedDate.changeDate(jobClosedDate)
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        dateExtendPicker.datePickerMode = .date
        dateExtendPicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: datePicker.maximumDate ?? Date())
        
        print(date)
        self.pickerMode = mode
        
        // current date is converting into recruiter time zone
        let timeWithEightandHalf1 = Date().string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let utcTime1 = self.localToUTC(date: timeWithEightandHalf1, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let recruiterTime1 = self.convertUTCToLocalTimeZone(date: utcTime1)
        self.currentTime = recruiterTime1.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
        
        
        let toolbar = self.setUpToolBar()
        
        
        if(mode == "date") {
            dateField.inputAccessoryView = toolbar
            dateField.inputView = datePicker
            self.dateField.becomeFirstResponder()
        }
        else{
            closingDateField.inputAccessoryView = toolbar
            closingDateField.inputView = dateExtendPicker
            self.closingDateField.becomeFirstResponder()
        }
    }
    
    @objc func doneEditNumber() {
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker() {
        if(self.pickerMode == "dateExtend") {
            closingDateField.text = dateExtendPicker.date.toString(format: Formats.dateFormat)
            // set Extended date as due date maximum date
            let thirtyDaysDate = Calendar.current.date(byAdding: .day, value: 30, to: currentTime)
            if( dateExtendPicker.date < thirtyDaysDate ?? Date()) {
                  datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 45, second: 00, of: dateExtendPicker.date) ?? Date()
            } else {
                  datePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: thirtyDaysDate ?? Date())
            }
            jobClosedDate = dateExtendPicker.date.toString(format: Formats.reverseDateFormat)
            self.extendStatus = true
            self.view.endEditing(true)
        }
        else{
            let _ = validateDateAndTime(callingFrom : "donPicker")
        }
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    func validateDateAndTime(callingFrom: String) -> Bool {
        
        if jobClosedDate != "" {
            
            let status : Bool
            dateFormatter.dateFormat = Formats.dateFormat
            guard (dateField.text?.components(separatedBy: " ")) != nil else {return false}
            setCurrentTime()
            let feedBackDate = jobClosedDate.changeDate(jobClosedDate).toDate()
//            if datePicker.maximumDate ?? Date() > jobClosedDate.changeDate(jobClosedDate).toDate() {
//                feedBackDate = datePicker.maximumDate ?? Date()
//            }
            let dueDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: feedBackDate) ?? Date()
            
            let mindate = Calendar.current.date(bySettingHour: 20, minute: 45, second: 00, of: datePicker.date) ?? Date()
            
            let pickerDate = Calendar.current.dateComponents([.day , .month , .year], from: datePicker.date)
            let feedbackDueDate = Calendar.current.dateComponents([.day , .month , .year], from: feedBackDate)
            let closingDate = Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: feedBackDate)
            let presentDate = Calendar.current.date(bySettingHour: 01, minute: 00, second: 00, of: Calendar.current.date(byAdding: .day, value: 30, to: currentTime) ?? Date())
            let extendDate = Calendar.current.date(byAdding: .hour, value: -1, to: dateExtendPicker.date) ?? feedBackDate
            let thirtysDate = Calendar.current.date(byAdding: .day, value: 30, to: currentTime) ?? Date()
                     
            if(datePicker.date < recruiterTime || dueDate < currentTime || datePicker.date > dueDate) {
                if(pickerDate == feedbackDueDate  && datePicker.date > mindate)  || datePicker.date > dueDate  {
                    
                    if !jobClosingdateView.isHidden {
                        if (pickerDate == feedbackDueDate  ) {
                            status = false
                            showDateValidation(message: "Candidate preferred interview time should be 3 hours less than job due date" , status: false)
                        }else {
//                            jobClosingdateView.isHidden = true
                           status = true
                        }
                    }else {
                        status = false
                        showDateValidation(message: "Candidate preferred interview time should be 3 hours less than job due date" , status: false)
                    }
                } else {
                    showDateValidation(message: "Candidate preferred interview time should be 8 hours 30 minutes greater than current time" , status: true)
                    status = false
                }
            }else if( pickerDate == feedbackDueDate  && datePicker.date > mindate )  {
                
                if !jobClosingdateView.isHidden {
                    if (pickerDate == feedbackDueDate ) {
                        status = false
                        showDateValidation(message: "Candidate preferred interview time should be 3 hours less than job due date" , status: false)
                        }else {
//                        jobClosingdateView.isHidden = true
                       status = true
                       }
                }else {
                    showDateValidation(message: "Candidate preferred interview time should be 3 hours less than job due date" , status: false)
                    status = false
                }
                
            } else {
                status = true
                if callingFrom != "submit" {
                    self.jobClosingdateView.isHidden = true
                }
            }
            
            if(callingFrom != "submit") {
                print(datePicker.date.string(format: Formats.date_timeFormat))
                dateField.text = datePicker.date.string(format: Formats.date_timeFormat)
            }
            
            self.view.endEditing(true)
            return status
            
        } else {
            return false
        }
        
    }
    
    func setCurrentTime() {
        let newDate = Calendar.current.date(byAdding: .hour, value: 8, to: Date())
                guard let tomorrowDate = Calendar.current.date(byAdding: .minute, value: 30, to: newDate ?? Date()) else{return}
        
              let timeWithEightandHalf = tomorrowDate.string(format: "yyyy-MM-dd'T'HH:mm:ssZ")
              let utcTime = self.localToUTC(date: timeWithEightandHalf, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
              let recruiterTime = self.convertUTCToLocalTimeZone(date: utcTime)
              self.recruiterTime = recruiterTime.toDateAndTime(withFormat: "dd-MMMM-yyyy hh:mm a")
    }
    
    func showDateValidation(message: String , status: Bool) {
        self.showBanner(title: "", withMessage: message, style: .warning)
        jobClosingdateView.isHidden = status
//        if(status == false) {
//            closingDateField.text = ""
//        }
    }
    
    @IBAction func showDatePicker(_ sender: Any) {
        dateFormatter.dateFormat = Formats.dateFormat
        print(jobClosedDate)
        let date = jobClosedDate.changeDate(jobClosedDate)
        print(date)
        if(date.toDate() < dateFormatter.string(from: Date()).toDate()) {
            self.showBanner(title: "", withMessage: "Job due date expired", style: .warning)
            
        }else {
            self.showPicker(mode: "date")
        }
        
    }
    
    @IBAction func showTimePicker(_ sender: Any) {
        dateFormatter.dateFormat = Formats.dateFormat
        let date = jobClosedDate.changeDate(jobClosedDate)
        if(date.toDate() < dateFormatter.string(from: Date()).toDate()) {
            self.showBanner(title: "", withMessage: "Job due date expired", style: .warning)
            
        }else {
            self.showPicker(mode: "time")
        }
    }
    
    @IBAction func extendClosingdateAction(_ sender: Any) {
        self.showPicker(mode: "dateExtend")
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        dateFormatter.dateFormat = Formats.dateFormat
        
        let validEmail = self.emailField.isValidEmail(emailStr: emailField.text ?? "")
        if(firstNameField.text == "") {
            self.showValidation(textField: firstNameField, currentField: "First Name")
        } else if(lastNameField.text == "") {
            self.showValidation(textField: lastNameField, currentField: "Last Name")
        } else if(emailField.text == "") {
            self.showValidation(textField: emailField, currentField: "Email")
        } else if(validEmail != true) {
            self.showBanner(title: "", withMessage: validationMessages.enterValidEmail, style: .warning)
        } else if (mailErrorResponse != "") {
            self.showBanner(title: "", withMessage: mailErrorResponse, style: .warning)
        } else if(candidateOwner.text == "") {
            self.showValidation(textField: candidateOwner, currentField: "Candidate Owner")
        } else if(numberView.text == "") {
            
            self.showValidation(textField: numberView, currentField: "Phone number")
            
        } else if(phoneNumberStatus == false) {
            self.numberView.set(phoneNumber: "")
            self.showBanner(title: "", withMessage: "Invalid Phone number", style: .warning)
            
        }else if(resumeTextField.text == "") {
            
            self.showValidation(textField: resumeTextField, currentField: "Upload Resume")
            
        }else if(timeZoneField.text == "") {
            
            showValidation(textField: timeZoneField, currentField: "Time Zone")
            
        } else if(dateField.text == "") {
            
            showValidation(textField: dateField, currentField: "Date")
            
        }  else if(jobClosingdateView.isHidden == false && closingDateField.text == "") {
            
            showValidation(textField: closingDateField, currentField: "Job Closing date")
            
        } else {
            
            if validEmail {
                let domain = self.getEmailDomain(email: emailField.text ?? "")
                if domain.lowercased() == "mailinator" {
                    self.showBanner(title: "", withMessage: "MAILINATOR_NOT_ALLOWED".localized, style: .danger)
                    return
                }
            }
            
            pickerMode = "Validate"
            let res =  validateDateAndTime(callingFrom: "submit")
            let timezonekeys = LocalCountry.timezoneList
            
            for timezoneDict in timezonekeys {


                for (key,value) in timezoneDict {
                    
                    if value == self.timeZoneField.text {
                        print("==========key============\(key)")
                        print("==========value============\(value)")
                        self.selectedTimeZoneCode = key
                    }
                }
            }
            
            if(res) {
                           generateEventLogToAnalytics(eventName: "Add Candidate Event", status: "True")

                self.addCandidateAPI()
            } else {
                
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailField {
            
            if emailField.text != "" {
                
                let isValid = emailField.isValidEmail(emailStr: emailField.text ?? "")
                
                if isValid {
                    let domain = self.getEmailDomain(email: emailField.text ?? "")
                    
                    if domain.lowercased() == "mailinator" {
                        self.showBanner(title: "", withMessage: "Mailinator domains are not allowed.", style: .danger)
                        return
                    }
                    
                    if self.currentEmail != self.emailField.text {
                        self.showSpinner()
                        self.candidateAPI.getCandidateExistance(candidatesManager: CandidatesManager(email: self.emailField.text ?? "", jobID: self.jobID)) { (response, errorResponse) in
                            
                            if errorResponse != nil {
                                guard let message = errorResponse?.message else {return}
                                
                                DispatchQueue.main.async {
                                    if message == ErrorHandler.tokenExpired {
                                        self.removeSpinner()
                                        self.mailErrorResponse = message
                                        //self.showBanner(title: "", withMessage: message, style: .danger)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                            RequestBuilder.shared.resetToSignInOnTokenExpire()
                                            self.removeSpinner()
                                        })
                                    } else if message == "Candidate already exists for this job." {
                                        
                                        DispatchQueue.main.async {
//                                            self.emailField.text = ""
                                            self.mailErrorResponse =  message
                                            self.removeSpinner()
                                            //self.showBanner(title: "", withMessage: message, style: .danger)
                                        }
                                        
                                    } else {
                                        
                                        DispatchQueue.main.async {
                                            self.removeSpinner()
                                            self.mailErrorResponse = message
                                            //self.showBanner(title: "", withMessage: message, style: .warning)
                                        }
                                    }
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    self.mailErrorResponse = ""
                                    self.removeSpinner()
                                }
                            }
                        }
                    }
                    
                } else {
                    self.showBanner(title: "", withMessage: validationMessages.enterValidEmail, style: .warning)
                    self.emailField.text = ""
                }
                
            }
            
        }
    }
    
    
    func showValidation(textField : UITextField,currentField : String) {
        self.showBanner(title: "", withMessage: "\(currentField) can't be blank.", style: .warning)
        textField.text = ""
        textField.becomeFirstResponder()
    }
    
    func addCandidateAPI() {
        self.showSpinner()
        let candidate = self.setParametersForAPI()
        
        
        self.candidateAPI.postCandidate(candidateManager: candidate) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                DispatchQueue.main.async {
                    let successMessage = response?["message"] as? [String] ?? ["Success"]
                    self.showBanner(title: "", withMessage: successMessage[0], style: .success)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.removeSpinner()
                    if self.isNavigatingFrom == .editCandidate {
                        NotificationCenter.default.post(name: Notification.Name("updateCandidates"), object: nil, userInfo:["requestType":""])
                        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                    } else if self.isNavigatingFrom == "ToAddNewCandidate" {
                        NotificationCenter.default.post(name: Notification.Name("updateCandidates"), object: nil, userInfo:["requestType":""])
                        self.dismiss(animated: false, completion: nil)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("RefreshDashboard"), object: nil, userInfo:nil)
                        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.addCandidateToDashboard, sender: self)
                    }
                })
            }
        }
    }
    
    func setParametersForAPI() -> CandidatesManager? {
        
        self.countryCode = self.numberView.selectedCountry?.phoneCode ?? ""
        self.areaCode = self.numberView.selectedCountry?.code.rawValue ?? ""

        let token = self.countryCode.components(separatedBy: "+").last
        self.countryCode = token ?? ""
        
        let utcDate = self.localToUTC(date: dateField.text ?? "")
        
        if jobClosingdateView.isHidden != true || self.extendStatus != false{
            
            if self.closingDateField.text != "" {
                self.lastDueDate = self.jobClosedDate
                //let date = Calendar.current.date(byAdding: .hour, value: 0, to: dateExtendPicker.date)
                //self.jobClosedDate = date?.toString(format: Formats.reverseDateFormat) ?? ""
            
            }
        } else {
            
            if self.lastDueDate != "" {
                self.jobClosedDate = self.lastDueDate
            }
        }
        
        self.lastDueDate = self.jobClosedDate
        
        //Line commented to check server validations
       // self.jobClosedDate = dateExtendPicker.date.toString(format: Formats.reverseDateFormat)
        
        if jobClosedDate != "" {
            let date = jobClosedDate.changeDate(jobClosedDate)
            if(date.toDate() < dateFormatter.string(from: Date()).toDate()) {
                self.showBanner(title: "", withMessage: "Job due date expired", style: .warning)
                return nil
            }
        }
        
        var requestType = ""
        if isNavigatingFrom == .editCandidate {
            requestType = .editCandidate
        }
        
        
        let candidate = CandidatesManager(jobID: self.jobID, firstName: self.firstNameField.text ?? "", lastName: self.lastNameField.text ?? "", email: self.emailField.text ?? "", phone: self.numberView.text ?? "", resumeURL: self.resumeFileKey, preferredInterviewTime : utcDate , timeZone: self.selectedTimeZoneCode, smsOPT: self.notifyCheckbox.isChecked, ownerFullName: self.candidateOwner.text ?? "", jobDueDate: self.jobClosedDate , areaCode: self.areaCode, countryCode: self.countryCode, ownerId: self.ownerID,requestType: requestType,candidateID: self.candidateID)
        return candidate
    }
    
    //MARK: Commented as it may not required as flow updated
//    func getOwners() {
//
//        if isNavigatingFrom != .editCandidate {
//            self.showSpinner()
//        }
//        self.candidateAPI.getOwners(candidatesManager: CandidatesManager(jobID: jobID)) { (response, errorResponse) in
//
//            if errorResponse != nil {
//
//                guard let message = errorResponse?.message else {return}
//                self.handleErrorResponse(message: message)
//
//            } else {
//
//                DispatchQueue.main.async {
//                    if let recruiters = response?["recruiters"] as? [Dictionary<String,Any>] {
//                        self.candiateOwners = recruiters
//
//                        print(self.ownerID)
//                        print(self.candiateOwners)
//
//                        for recruiter in self.candiateOwners {
//                            guard let name  = recruiter["full_name"] as? String else {return}
//                            guard let ownerID  = recruiter["id"] as? Int else {return}
//                            self.candidateOwnersDropDown.dataSource.append(name)
//                            if name == self.ownerName {
//                                self.ownerID = "\(ownerID)"
//                            }
//                        }
//                    }
//                    self.removeSpinner()
//                }
//            }
//        }
//    }
    
    func getCandidateDetails() {

        self.showSpinner()
        self.candidateAPI.getCandidateDetails(candidatesManager: CandidatesManager(candidateID: self.candidateID)) { (response, errorResponse) in
            
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                DispatchQueue.main.async {
                    
                    
                    if let recruitertTimeZone = response?["recruiter_time_zone"]  as? String {
                        
                        for dict in LocalCountry.timezoneList {
                            for (key,value) in dict {
                                if key == recruitertTimeZone {
                                    let dict:[String:String] = [key:value]
                                    UserDefaults.standard.set(dict, forKey: "RecruiterTimeZone")
                                }
                            }
                        }
                    }
                    
                    if let candidateDetails = response?["candidate"] as? Dictionary<String,Any> {
                        
                        self.candidateDetails = candidateDetails
                        
                        
                        if let firstName = candidateDetails["first_name"]  as? String {
                            self.firstNameField.text = firstName
                        }
                        
                        if let lastName = candidateDetails["last_name"]  as? String {
                            self.lastNameField.text = lastName
                        }
                        
                        if let owner = candidateDetails["owner_name"]  as? String {
                            self.candidateOwner.text = owner
                        }
                        
                        if let email = candidateDetails["email"]  as? String {
                            self.emailField.text = email
                            self.currentEmail = email
                        }
                        
                        
                        if let resume = candidateDetails["resume"]  as? String {
                            
                            //let resumeURL = URL(string: resume)
                            let resumeURL = URL(string: resume.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                            
                            if resumeURL?.pathExtension != "" {
                                self.resumeFileKey = resumeURL?.absoluteString ?? ""
                                self.resumeTextField.text = resumeURL?.lastPathComponent
                            }
                            
                        }
                        
                        if let timeZone = candidateDetails["time_zone"]  as? String {
                            
                            for dict in LocalCountry.timezoneList {
                                for (key,value) in dict {
                                    if key == timeZone {
                                        self.timeZoneField.text = value
                                        self.selectedTimeZoneCode = key
                                    }
                                }
                            }
                            
                        }
                        
                        if let jobDueDate = candidateDetails["job_due_at"]  as? String {
                            self.jobClosedDate = jobDueDate
                        }
                        
                        if let jobTitle = candidateDetails["job_title"]  as? String {
                            self.navigationItem.title = jobTitle
                        }
                        
                        
                        if let reportDueBy = candidateDetails["feedback_due_by"]  as? String {
                            
                            self.prefferedInterViewTime = reportDueBy
                            self.setUpEditCandidateMaxDate()
                            
                            
                            /*
                             self.dateFormatter.dateFormat = Formats.date_timeFormat
                             self.reportDueDate = reportDueBy
                             print(self.reportDueDate)
                             let dateformatter = DateFormatter()
                             dateformatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
                             guard let formattedDueDate = dateformatter.date(from: self.reportDueDate) else {return}
                             dateformatter.dateFormat =  "dd-MMMM-yyyy hh:mm a"
                             self.dateField.text = dateformatter.string(from: formattedDueDate)
                             self.datePicker.date = formattedDueDate */
                        }
                        
                        if let jobID = candidateDetails["job_id"]  as? Int {
                            self.jobID = "\(jobID)"
                        }
                        
                        if let ownerID = candidateDetails["owner_id"]  as? Int {
                            self.ownerID = "\(ownerID)"
                        }
                        
                        if let areaCode = candidateDetails["area_code"]  as? String {
                            self.numberView.setFlag(countryCode: FPNCountryCode(rawValue: areaCode.uppercased())!)
                            if let phone = candidateDetails["phone"]  as? String {
                                self.numberView.set(phoneNumber: phone)
                            }
                        }
                        
                        if let isIndependentRecruiter = candidateDetails["independent_recruiter"] as? Bool {
                            self.isIndependentRecruiter = isIndependentRecruiter
                            if isIndependentRecruiter {
                                self.candidateOwnerView.isHidden = true
                            } else {
                                self.candidateOwnerView.isHidden = false
                            }
                        }
                        
                        self.smsOPTview.isHidden = true
                        self.smsoptHeader.isHidden = true
                        
                        
                        if self.resumeTextField.text != "" {
                            self.uploadFileButton.tag = 2
                            self.uploadFileButton.setTitle(.remove, for: .normal)
                        } else {
                            self.uploadFileButton.tag = 1
                            self.uploadFileButton.setTitle(.upload, for: .normal)
                        }
                        
                       // self.getOwners() // Commented as it may not require now as we redirecting to separate view for owners
                        
                        self.removeSpinner()
                    } else {
                        self.removeSpinner()
                    }
                }
            }
        }
    }
}

extension AddCandidateViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardSegueIdentifiers.addCandidateToTimeZone {
            let navVC = segue.destination as? UINavigationController
            let searchVc = navVC?.viewControllers.first as? SearchViewController
            NotificationCenter.default.addObserver(self, selector: #selector(updateTimeZone(notfication:)), name: Notification.Name("SearchTimeZones"), object: nil)
            searchVc?.currentSearch = "SearchTimeZones"
            searchVc?.selectedItem = self.timeZoneField.text ?? ""

        } else if segue.identifier == StoryboardSegueIdentifiers.addCandidateToCandidateOwner {
            let navVC = segue.destination as? UINavigationController
            let searchVc = navVC?.viewControllers.first as? SearchViewController
            searchVc?.currentSearch = StoryboardSegueIdentifiers.addCandidateToCandidateOwner
            searchVc?.ownerName = self.candidateOwner.text ?? ""
            searchVc?.selectedItem = self.candidateOwner.text ?? ""
            NotificationCenter.default.addObserver(self, selector: #selector(updateOwner(notfication:)), name: Notification.Name("GET_OWNERS"), object: nil)
            searchVc?.jobID = self.jobID
        }
        
    }
    
    @objc func updateOwner(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let searchData = info["owners"] as? Dictionary<String,String> {
                print(searchData)
                for (key,value) in searchData {
                    self.candidateOwner.text = value
                    self.ownerID = key
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("GET_OWNERS"), object: nil)
    }
    
    @objc func updateTimeZone(notfication: NSNotification) {
        
        if let info = notfication.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if let searchData = info["timezone"] as? Dictionary<String,String> {
                print(searchData)
                for (key,value) in searchData {
                    self.timeZoneField.text = value
                    self.selectedTimeZoneCode = key
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SearchTimeZones"), object: nil)
        
    }
}

extension AddCandidateViewController {
    
    @IBAction func chooseDocumentAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: eTekiAWSSupport.documentTypes, in: UIDocumentPickerMode.import)
            documentPicker.modalPresentationStyle = .formSheet
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
            
        } else {
            
            
            self.uploadFileButton.tag = 1
            self.uploadFileButton.setTitle(.upload, for: .normal)
            
            if resumeFileKey != "" {
                
                self.showSpinner()
                
                let s3 = AWSS3.default()
                let deleteObjectRequest = AWSS3DeleteObjectRequest()
                deleteObjectRequest?.bucket = S3Configuration.BUCKETNAMEDOCUMENTS.rawValue
                deleteObjectRequest?.key = self.resumeFileKey
                s3.deleteObject(deleteObjectRequest ?? AWSS3DeleteObjectRequest()).continueWith { (task:AWSTask) -> AnyObject? in
                    if let error = task.error {
                        print("Error occurred: \(error)")
                        return nil
                    }
                    
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.resumeTextField.text = ""
                        self.showBanner(title: "", withMessage: "File Removed Successfully.", style: .success)
                        self.resumeFileKey = ""
                    }
                    return nil
                }
                
            } else {
                self.resumeTextField.text = ""
                self.resumeFileKey = ""
            }
        }
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
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
        
        if (newUrls != []) {
            let newPath = newUrls[0].absoluteString
            //newPath = newPath.replacingOccurrences(of: "file:/", with: "")
            if let filePath = URL(string: newPath) {
                
                self.resumeTextField.text = filePath.lastPathComponent
                do {
                    let fileData = try Data(contentsOf: filePath,options: [])
                    if eTekiAWSSupport.supportedDocs.contains(obj: filePath.pathExtension) {
                        self.showSpinner()
                        self.uploadFile(fileData: fileData,fileUrl : filePath)
                        return
                    } else {
                        self.resumeTextField.text = ""     
                        self.showBanner(title: "", withMessage: "Unsupported file format.", style: .danger)
                        return
                    }
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        }
        
    }
    
    func clearLocalDirectory() {
        let fileManager = FileManager()
        fileManager.clearTmpDirectory()
    }
    
    func uploadFile(fileData : Data,fileUrl : URL) {
        
        var awskey = ""
        if jobID != "" {
            awskey =  "jobs/" + "\(jobID)/" + "resumes/"
        } else {
            self.showBanner(title: "", withMessage: "Unable to upload file.", style: .danger)
            return
        }
        
        AWSManager.shared.multipartFileUpload(fileData: fileData, name: fileUrl.pathExtension, awsLocationKey: awskey, progressHandler: { (progress) in
            
            if progress.fractionCompleted == 1.0 {
                DispatchQueue.main.async {
                    self.uploadFileButton.setTitle(.remove, for: .normal)
                    self.uploadFileButton.tag = 2
                    self.clearLocalDirectory()
                    self.removeSpinner()
                }
            }
            
        }, s3UrlHandler: { (url, remoteName) in
            self.resumeFileKey = url?.absoluteString ?? ""
            DispatchQueue.main.async {
                //  self.showBanner(title: "", withMessage: "Upload Success" , style: .success)
                self.resumeTextField.text = url?.lastPathComponent ?? ""
            }
            
        }) { (error) in
            
            if let error  = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.uploadFileButton.setTitle(.upload, for: .normal)
                    self.uploadFileButton.tag = 1
                    self.showBanner(title: "", withMessage: error.localizedDescription , style: .danger)
                    self.removeSpinner()
                }
            }
        }
    }
    
}

extension AddCandidateViewController {
    
    func getEmailDomain(email: String) -> String {
        var domain = email.components(separatedBy: "@").last?.components(separatedBy: ".")
        domain?.removeLast()
        return (domain?.last) ?? ""
    }
}

extension AddCandidateViewController {
    
    func updateFeedBackDate() {
        let localDate = self.convertUTCToLocalTimeZone(date: self.prefferedInterViewTime)
        self.dateField.text = localDate
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
        guard let formattedDueDate = dateformatter.date(from: localDate) else {return}
        self.datePicker.date = formattedDueDate
        print("=============Job Closing Date=====")
        print(self.jobClosedDate)
        if formattedDueDate < Date() {
            self.showBanner(title: "", withMessage: "Candidate report due date expired. To provide availability update the candidate report due date.", style: .warning)
        }
    }

}

extension AddCandidateViewController {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        self.areaCode = code
        self.countryCode = dialCode
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.phoneNumberStatus = isValid
    }
    
     func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        present(navigationViewController, animated: true, completion: nil)
     }
    
 
}

extension UIControl {

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inside = super.point(inside: point, with: event)
        if inside != isHighlighted && event?.type == .touches {
            isHighlighted = inside
        }
        return inside
    }
}

extension AddCandidateViewController {
    
    func setUpToolBar() -> UIView {
          
          let customToolBar = UIView()
          customToolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width,
          height: 50)
          
          let doneButton = UIButton(frame: CGRect(x: 8, y: 0, width: 50, height: 50))
          doneButton.addTarget(self, action: #selector(donedatePicker), for: .touchUpInside)
          doneButton.light(size: 18.0)
          doneButton.setTitle("Done", for: .normal)
          customToolBar.addSubview(doneButton)
          
          let cancelButton = UIButton(frame: CGRect(x: ScreenSize.width-68, y: 0, width: 60, height: 50))
          cancelButton.addTarget(self, action: #selector(cancelDatePicker), for: .touchUpInside)
          cancelButton.light(size: 18.0)
          cancelButton.setTitle("Cancel", for: .normal)
          customToolBar.addSubview(cancelButton)
          customToolBar.backgroundColor = AppTheme.brandColor
          customToolBar.sizeToFit()
          return customToolBar
      }
    
        func setUpToolBarForNumberPad() -> UIView {
          
          let customToolBar = UIView()
          customToolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width,
          height: 50)
          
          let doneButton = UIButton(frame: CGRect(x: 8, y: 0, width: 50, height: 50))
          doneButton.addTarget(self, action: #selector(self.view.endEditing(_:)), for: .touchUpInside)
          doneButton.light(size: 18.0)
          doneButton.setTitle("Done", for: .normal)
          customToolBar.addSubview(doneButton)
          customToolBar.backgroundColor = AppTheme.brandColor
          customToolBar.sizeToFit()
          return customToolBar
      }
}

extension AddCandidateViewController {
    
    func getProfileAddress() {
        self.showSpinner()
        self.profileAPI.getProfileDetails(profileManager: ProfileManager(type: Profile.addressDetails)) { (response, errorResponse) in
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else  {
                self.updateTimeZone(searchText: response?.timeZone ?? "")
            }
        }
        
    }
    
    func updateTimeZone(searchText : String) {
        for dict in LocalCountry.timezoneList {
            for (key,value) in dict {
                if value == searchText {
                    let dict:[String:String] = [key:value]
                    UserDefaults.standard.set(dict, forKey: "RecruiterTimeZone")
                    DispatchQueue.main.async {
                        
                        if self.isNavigatingFrom != .editCandidate {
                          self.setUpDateandTime()
                        }
                    }

                }
            }
        }
        self.removeSpinner()
    }
}
