//
//  AddCandidateViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 04/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
import NotificationBannerSwift

class AddCandidateViewControllerTests: XCTestCase {
    
    var addCandidateController = AddCandidateViewController()
    var addCandidateNavigationController: UINavigationController!
    let currentDate = "04-11-2019"
    
    override func setUp() {
        addCandidateController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIdentifiers.addCandidateViewController) as! AddCandidateViewController
        addCandidateNavigationController = UINavigationController(rootViewController: addCandidateController)
        CandidateStubApi.getOwners = ["recruiters" : [["full_name": "anusha", "id" : 3968] , ["full_name": "anusha", "id" : 3968]]] as [String : Any]
        addCandidateController.candidateAPI = CandidateStubApi.self
        addCandidateController.jobClosedDate = "2020-12-02"
        addCandidateController.view.layoutIfNeeded()
        addCandidateNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = addCandidateNavigationController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testFpnDidSelectCountry(){
        addCandidateController.fpnDidSelectCountry(name: "", dialCode: "+91", code: ".IN")
    }
    
    func testFpnDidValidateNumber(){
        addCandidateController.fpnDidValidatePhoneNumber(textField: addCandidateController.numberView, isValid: true)
    }
    
    func testshowPickerIsDate(){
        addCandidateController.jobClosedDate = "2019-12-30"
        addCandidateController.pickerMode = "date"
        addCandidateController.showPicker(mode: "date")
    }
    
    func testshowPickerIsTime(){
        addCandidateController.jobClosedDate = "2019-12-30"
        addCandidateController.pickerMode = "time"
        addCandidateController.showPicker(mode: "time")
    }
    
    func testshowPickerIsDateExtend(){
        addCandidateController.jobClosedDate = "2019-12-30"
        addCandidateController.pickerMode = "dateExtend"
        addCandidateController.showPicker(mode: "dateExtend")
    }
    
    func testCancelDatePicker(){
        addCandidateController.cancelDatePicker()
    }
    
    func testShowDatePicker(){
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.showDatePicker(0)
        
        addCandidateController.jobClosedDate = "2019-10-15"
        addCandidateController.showDatePicker(0)
    }
    
    func testShowTimePicker(){
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.showTimePicker(0)
        
        addCandidateController.jobClosedDate = "2019-10-15"
        addCandidateController.showTimePicker(0)
        
    }
    
    func testExtendClosingDateAction(){
        addCandidateController.jobClosedDate = "2019-10-12"
        addCandidateController.dateFormatter.dateFormat = Formats.dateFormat
        addCandidateController.dateExtendPicker.date = Date()
        addCandidateController.extendClosingdateAction(0)
    }
    
    func testSubmitAction(){
        addCandidateController.jobClosedDate = "2019-10-12"
        addCandidateController.submitAction(0)
        
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsFirstnameNotnull(){
        XCTAssertNotNil(addCandidateController.firstNameField)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsLastnameNotnull(){
        XCTAssertNotNil(addCandidateController.lastNameField)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsEmailFieldNotnull(){
        XCTAssertNotNil(addCandidateController.emailField)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@@"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsEmailFieldValid(){
        XCTAssertNotNil(addCandidateController.emailField)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsCandidateOwnerValid(){
        XCTAssertNotNil(addCandidateController.candidateOwner)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsNumberViewNotnull(){
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsNumberViewValid(){
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsResumeFieldNotnull(){
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsTimezoneFieldnull(){
        let notification = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : ["(GMT-11:00)" : "American Samoa, Midway Island"]])
        addCandidateController.updateTimeZone(notfication: notification)
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.timeZoneField.text = ""
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
        let notification1 = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : []])
        addCandidateController.updateTimeZone(notfication: notification1)
        let notification2 = NSNotification(name: .AppEventsLoggingResult, object: nil)
        addCandidateController.updateTimeZone(notfication: notification2)
    }
    
    func testSubmitIsTimezoneFieldNotnull(){
        let notification = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : ["(GMT-11:00)" : "American Samoa, Midway Island"]])
        addCandidateController.updateTimeZone(notfication: notification)
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.timeZoneField.text = "(GMT-11:00) American Samoa, Midway Island"
        addCandidateController.dateField.text  = ""
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
        let notification1 = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : []])
        addCandidateController.updateTimeZone(notfication: notification1)
        let notification2 = NSNotification(name: .AppEventsLoggingResult, object: nil)
        addCandidateController.updateTimeZone(notfication: notification2)
    }
    
    func testSubmitIsDateFieldNotnull(){
        let notification = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : ["(GMT-11:00)" : "American Samoa, Midway Island"]])
        addCandidateController.updateTimeZone(notfication: notification)
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = CannedDataConstant.firstName
        addCandidateController.lastNameField.text = CannedDataConstant.lastName
        addCandidateController.emailField.text = CannedDataConstant.email
        addCandidateController.candidateOwner.text = CannedDataConstant.canidateOwner
        addCandidateController.numberView.text = CannedDataConstant.contactNumber
        addCandidateController.resumeTextField.text = CannedDataConstant.resumeField
        addCandidateController.timeZoneField.text = CannedDataConstant.timeZone
        addCandidateController.dateField.text = CannedDataConstant.dateField
        addCandidateController.jobClosedDate = CannedDataConstant.jobClosedDate
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsTimeFieldNotnull(){
        let notification = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : ["(GMT-11:00)" : "American Samoa, Midway Island"]])
        addCandidateController.updateTimeZone(notfication: notification)
        addCandidateController.phoneNumberStatus = true
        addCandidateController.jobClosingdateView.isHidden = false
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.timeZoneField.text = "(GMT-11:00) American Samoa, Midway Island"
        addCandidateController.dateField.text = "28-November-2021"
        addCandidateController.timeField.text = "9:00 AM"
        addCandidateController.closingDateField.text = ""
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitIsJobClosedFieldNotnull(){
        let notification = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : ["(GMT-11:00)" : "American Samoa, Midway Island"]])
        addCandidateController.updateTimeZone(notfication: notification)
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.jobClosingdateView.isHidden = true
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mailinator.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.timeZoneField.text = "(GMT-11:00) American Samoa, Midway Island"
        addCandidateController.dateField.text = "28-November-2021"
        addCandidateController.timeField.text = "09:00 AM"
        addCandidateController.closingDateField.text = "29-November-2021"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.submitAction(0)
    }
    
    func testSubmitActionValid(){
        let notification = NSNotification(name: .AppEventsLoggingResult, object: nil, userInfo: ["timezone" : ["(GMT-11:00)" : "American Samoa, Midway Island"]])
        addCandidateController.updateTimeZone(notfication: notification)
        addCandidateController.phoneNumberStatus = true
        XCTAssertNotNil(addCandidateController.numberView)
        addCandidateController.jobClosingdateView.isHidden = true
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "afrin@mail.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.timeZoneField.text = "(GMT10:00) Hawaii"
        addCandidateController.dateField.text = "28-November-2021"
        addCandidateController.timeField.text = "09:00 AM"
        addCandidateController.closingDateField.text = "29-November-2021"
        addCandidateController.jobClosedDate = ""
        addCandidateController.submitAction(0)
    }
    
    func testDoneDatePicker(){
        addCandidateController.pickerMode = "dateExtend"
        addCandidateController.donedatePicker()
    }
    
    func testValidateDateAndTime(){
        addCandidateController.jobClosedDate = ""
        let _ = addCandidateController.validateDateAndTime(callingFrom: "donPicker")
        addCandidateController.jobClosedDate = currentDate
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: addCandidateController.datePicker.date) ?? Date()
        let _ =  addCandidateController.validateDateAndTime(callingFrom: "donPicker")
        addCandidateController.jobClosedDate = currentDate
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 22, minute: 45, second: 00, of: Date()) ?? Date()
        addCandidateController.jobClosingdateView.isHidden = false
        let _ =  addCandidateController.validateDateAndTime(callingFrom: "donPicker")
        addCandidateController.jobClosedDate = "2019-10-03"
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 22, minute: 45, second: 00, of: Date()) ?? Date()
        addCandidateController.jobClosingdateView.isHidden = true
        let _ =  addCandidateController.validateDateAndTime(callingFrom: "donPicker")
        addCandidateController.jobClosedDate = currentDate
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 22, minute: 45, second: 00, of: Date()) ?? Date()
        addCandidateController.jobClosingdateView.isHidden = true
        let _ =  addCandidateController.validateDateAndTime(callingFrom: "donPicker")
        addCandidateController.jobClosedDate = "2020-12-12"
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 22, minute: 45, second: 00, of: Date()) ?? Date()
        addCandidateController.jobClosingdateView.isHidden = true
        let _ =  addCandidateController.validateDateAndTime(callingFrom: "donPicker")
    }
    
    func testDoneDatePickerForDateExtend(){
        addCandidateController.pickerMode = "dateExtend"
        addCandidateController.donedatePicker()
    }
    
    func testAddCandidateApi(){
        addCandidateController.jobClosedDate = ""
        _ = CandidatesManager(jobID: "3968", firstName: "Candidate", lastName: "name123", email: "afrinshaik521@gmail.com", phone: "9949649324", resumeURL: "r7ToOZGCFNF8.pdf", preferredInterviewTime: "2019-12-09T13:59:38+0530", timeZone: "(GMT-11:00) American Samoa, Midway Island", smsOPT: true, ownerFullName: "Anusha", jobDueDate: "12-December-2020", areaCode: "IN", countryCode: "+91", ownerId: "", requestType: "", candidateID: "")
        let response = ["message": "successfully created" , "success": true] as [String : Any]
        CandidateStubApi.postCandidate = response
        addCandidateController.lastDueDate = "2020-May-12"
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 4.5)
        self.addCandidateController.addCandidateAPI()
        
        addCandidateController.isNavigatingFrom = .editCandidate
        CandidateStubApi.postCandidate = response
        addCandidateController.extendStatus = true
        addCandidateController.closingDateField.text = "2020-May-12"
        let exp2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 4.5)
        self.addCandidateController.addCandidateAPI()
        
        addCandidateController.isNavigatingFrom = "ToAddNewCandidate"
        CandidateStubApi.postCandidate = response
        let exp3 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
            exp3.fulfill()
        }
        wait(for: [exp3], timeout: 4.5)
        self.addCandidateController.addCandidateAPI()
    }
    
//    func testSetApiforParams(){
//        addCandidateController.jobClosingdateView.isHidden = true
//        addCandidateController.lastDueDate = "12-09-2019"
//        addCandidateController.jobClosedDate = ""
//        addCandidateController.setParametersForAPI()
//    }
//    func testSetapiParams(){
//        addCandidateController.jobClosingdateView.isHidden = false
//        addCandidateController.closingDateField.text = "12-12-2020"
//        addCandidateController.jobClosedDate = ""
//        addCandidateController.setParametersForAPI()
//    }
    func testsetapiParams(){
        addCandidateController.jobClosingdateView.isHidden = true
        addCandidateController.jobClosedDate = ""
        let _ =  addCandidateController.setParametersForAPI()
    }
    
    func testPrepareForSegue(){
        let segue = UIStoryboardSegue(identifier: StoryboardSegueIdentifiers.addCandidateToTimeZone, source: addCandidateController, destination: SearchViewController())
        addCandidateController.prepare(for: segue, sender: nil)
    }
    
    func testChooseDocumentAction(){
        addCandidateController.chooseDocumentAction(addCandidateController.uploadFileButton)
        addCandidateController.chooseDocumentAction(addCandidateController.submitButton)
        addCandidateController.resumeFileKey = "OFrkvOX52Z7Z.pdf"
        addCandidateController.chooseDocumentAction(addCandidateController.submitButton)
    }
    
    func testDocumentPicker(){
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3343/resumes/OFrkvOX52Z7Z.pdf")
        let controller = UIDocumentPickerViewController(urls: [url!], in: .exportToService)
        addCandidateController.documentPicker(controller, didPickDocumentsAt: [url!])
    }
    
    func testClearlocalDirectory(){
        addCandidateController.clearLocalDirectory()
    }
    
    func testUploadFile(){
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3343/resumes/OFrkvOX52Z7Z.pdf")
        let data = Data(repeating: 0, count: 2)
        addCandidateController.uploadFile(fileData: data , fileUrl: url!)
    }
    
    func testGetEmailDomain(){
        let _ = addCandidateController.getEmailDomain(email: "afrinshaik521@gmail.com")
    }
    
    /*! @brief Scenario Get details APi call*/
    func testgetDetails(){
        addCandidateController.resumeTextField.text = "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3376/resumes/EV Web-Mobile App_BRD1_1.7V_17.10.2019.pdf"
        let stubData : [String : Any] = ["candidate" : [
            "availabilities" : ["2019-11-12T10:00:00.000Z",
                                "2019-11-13T04:30:00.000Z",
                                "2019-11-13T05:00:00.000Z",
                                "2019-11-13T05:30:00.000Z"],
            "contact" : "+12015552639","created_at" : "2019-11-11T11:24:13.000Z",
            "email" : "kkk@gmail.com","feedback_due_by" : "2019-11-11T22:30:00.000Z","full_name" : "kkk",
            "first_name" : "kkk",
            "last_name" : "kkk",
            "time_zone" : "Asia/Calcutta",
            "job_due_at" : "2019-12-12",
            "job_id" : 3968,
            "owner_id" : 3168,
            "owner_name" : "Ajay ",
            "area_code" : "IN",
            "phone" : "9949640332",
            "resume" : "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3376/resumes/EV Web-Mobile App_BRD1_1.7V_17.10.2019.pdf",
            "status" : "Withdrawn", "withdraw_reason" : "Dfg.   ",
            ], "recruiter_time_zone": "US/Hawaii", "success" : true,"total_count" : 0]
        CandidateStubApi.getCandidatesresponse = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        addCandidateController.getCandidateDetails()
    }
    
    /*! @brief Scenario Get details APi call with empty data*/
    func testgetDetailsWithEmptyData(){
        
        let stubData : [String : Any] = ["candidate" : [
            "availabilities" : ["2019-11-12T10:00:00.000Z",
                                "2019-11-13T04:30:00.000Z",
                                "2019-11-13T05:00:00.000Z",
                                "2019-11-13T05:30:00.000Z"],
            "contact" : "+12015552639","created_at" : "2019-11-11T11:24:13.000Z",
            "feedback_due_by" : "2019-11-11T22:30:00.000Z","full_name" : "kkk",
            "time_zone" : "Asia/Calcutta",
            "job_due_at" : "2019-12-12",
            "job_id" : 3968,
            "owner_id" : 3168,
            "area_code" : "IN",
            "phone" : "9949640332",
            "resume" : "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3376/resumes/EV Web-Mobile App_BRD1_1.7V_17.10.2019.pdf",
            "status" : "Withdrawn", "withdraw_reason" : "Dfg.   ",
            ],"success" : true,"total_count" : 0]
        CandidateStubApi.getCandidatesresponse = stubData
        
        addCandidateController.getCandidateDetails()
        
        
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
        
        let stubData1 : [String : Any] = ["message" : "Success","success" : true,"total_count" : 0]
        CandidateStubApi.getCandidatesresponse = stubData1
        let exp2 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 2.5)
        addCandidateController.getCandidateDetails()
    }
    
    /*! @brief Scenario Get verify Mailinators  call*/
    func testEmaifieldWithMailinatorDomain() {
        
        addCandidateController.firstNameField.text = "Afreen"
        addCandidateController.lastNameField.text = "Shaik"
        addCandidateController.emailField.text = "test@mailinator.com"
        addCandidateController.candidateOwner.text = "Anusha"
        addCandidateController.numberView.text = "9939927889"
        addCandidateController.resumeTextField.text = "XyzklPjdcdd.jpg"
        addCandidateController.timeZoneField.text = "(GMT-11:00) American Samoa, Midway Island"
        addCandidateController.dateField.text = "28-November-2021"
        addCandidateController.timeField.text = "09:00 AM"
        addCandidateController.closingDateField.text = "29-November-2021"
        addCandidateController.jobClosedDate = "2021-12-30"
        addCandidateController.uploadFileButton.sendActions(for: .touchUpInside)
        
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        
        
    }
    
    func testTextFieldDidEndEditing(){
        addCandidateController.emailField.text = "afrinshaik521@mailinator.com"
        addCandidateController.textFieldDidEndEditing(addCandidateController.emailField)
        
        addCandidateController.emailField.text = "afrinshaik521@gmail.com"
        addCandidateController.jobID = "3388"
        let stubData =  ["success": true, "message": "Candidate already exists for this job."] as [String : Any]
        CandidateStubApi.getCandidatesExistence = stubData
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 3.5)
        addCandidateController.textFieldDidEndEditing(addCandidateController.emailField)
        
        addCandidateController.emailField.text = "afrinshaik52@mailinatocom"
        addCandidateController.textFieldDidEndEditing(addCandidateController.emailField)
    }
    
    func testNavigatingToEditcandidateWithData() {
        
        let stubData : [String : Any] = ["candidate" : [
            "availabilities" : ["2019-11-12T10:00:00.000Z",
                                "2019-11-13T04:30:00.000Z",
                                "2019-11-13T05:00:00.000Z",
                                "2019-11-13T05:30:00.000Z"],
            "contact" : "+12015552639","created_at" : "2019-11-11T11:24:13.000Z",
            "email" : "test@mailinator.com","feedback_due_by" : "2019-11-11T22:30:00.000Z","full_name" : "kkk",
            "first_name" : "kkk",
            "last_name" : "kkk",
            "time_zone" : "Asia/Calcutta",
            "job_due_at" : "2019-12-12",
            "job_id" : 3968,
            "owner_id" : 3168,
            "owner_name" : "Ajay ",
            "area_code" : "IN",
            "phone" : "9949640332",
            "resume" : "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/2321/resumes/DKNFxLYrCnFY.pdf",
            "status" : "Withdrawn", "withdraw_reason" : "Dfg.   ",
            "independent_recruiter" : true,
            "job_title" : "title"
            ],"success" : true,"total_count" : 0]
        

        CandidateStubApi.getCandidatesresponse = stubData
        CandidateStubApi.getOwners = ["recruiters" : [["full_name": "anusha", "id" : 3968] , ["full_name": "anusha", "id" : 3968]]] as [String : Any]

        addCandidateController.candidateAPI = CandidateStubApi.self
        addCandidateController.getCandidateDetails()
        

        
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            XCTAssertEqual(self.addCandidateController.emailField.text,"test@mailinator.com","EmailId Mismtach" )
            self.addCandidateController.submitButton.sendActions(for: .touchUpInside)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                
                
                print("=========================Banner")
                print(self.addCandidateController.view.subviews)
                
                
                expectation.fulfill()
            }
            
        }
        wait(for: [expectation], timeout: 4.5)
    }
    
}

extension AddCandidateViewControllerTests {
    func testScenarIfEditCandidateisOpened(){
        addCandidateController.isNavigatingFrom = .editCandidate
        addCandidateController.isIndependentRecruiter = true
        addCandidateController.datePicker.date = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        addCandidateController.viewDidLoad()
        
        addCandidateController.doneEditNumber()
    }
    
    func testScenarIfSetupMaxDateInEditCandidate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        addCandidateController.jobClosedDate = dateFormatter.string(from: Date())
        addCandidateController.setUpEditCandidateMaxDate()
        
        let date = Calendar.current.date(byAdding: .day, value: 31, to: Date()) ?? Date()
        addCandidateController.jobClosedDate = dateFormatter.string(from: date)
        addCandidateController.setUpEditCandidateMaxDate()
        
        let date1 = Calendar.current.date(byAdding: .day, value: 31, to: Date()) ?? Date()
        addCandidateController.jobClosedDate = dateFormatter.string(from: date1)
        addCandidateController.datePicker.date = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        addCandidateController.setUpEditCandidateMaxDate()
    }
    
    func testDonePicker(){
        addCandidateController.pickerMode = "date"
        addCandidateController.donedatePicker()
        
        addCandidateController.pickerMode = "dateExtend"
        addCandidateController.dateExtendPicker.date = Calendar.current.date(byAdding: .day, value: 31, to: Date()) ?? Date()
        addCandidateController.donedatePicker()
    }
    
    func testAddCandidateDateFieldValidation() {
        addCandidateController.datePicker.date = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        let _ = addCandidateController.validateDateAndTime(callingFrom: "donePicker")
        
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 21, minute: 00, second: 00, of: date ?? Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        addCandidateController.jobClosedDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date())
        let _ = addCandidateController.validateDateAndTime(callingFrom: "donePicker")
        
        let date1 = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 21, minute: 00, second: 00, of: date1 ?? Date()) ?? Date()
        addCandidateController.jobClosedDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date())
        addCandidateController.jobClosingdateView.isHidden = false
        let _ = addCandidateController.validateDateAndTime(callingFrom: "donePicker")
        
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        addCandidateController.datePicker.date = Calendar.current.date(bySettingHour: 21, minute: 00, second: 00, of: date2 ?? Date()) ?? Date()
        addCandidateController.jobClosedDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date())
        addCandidateController.dateExtendPicker.date = Calendar.current.date(bySettingHour: 21, minute: 00, second: 00, of: date2 ?? Date()) ?? Date()
        addCandidateController.jobClosingdateView.isHidden = false
        let _ = addCandidateController.validateDateAndTime(callingFrom: "donePicker")
    }
    
    func testNavigationFromAddcandidateToCandidateOwners() {
        let segue = UIStoryboardSegue(identifier: StoryboardSegueIdentifiers.addCandidateToCandidateOwner, source: addCandidateController, destination: SearchViewController())
        addCandidateController.prepare(for: segue, sender: nil)
//        guard let searchController = UIApplication.topMostViewController() as? SearchViewController else {
//                    XCTFail("SearchViewController is not Top most view controller.")
//                            return
//        }
//        XCTAssertNotNil(searchController, "Not able to Navigate SearchViewController, instance is nil.")
    }
    
    func testAddCandidateUpdateOwner() {
        let notification = NSNotification(name: NSNotification.Name(rawValue: "GET_OWNERS"), object: nil, userInfo: ["owners": ["candidate1": "owner1", "candidate2": "owner2"]])
        addCandidateController.updateOwner(notfication: notification)
        addCandidateController.fpnDisplayCountryList()
    }
    
    func testAddCandidate() {
        addCandidateController.setUpToolBarForNumberPad()
    }
}
