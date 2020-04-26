//
//  CreateJobVewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 26/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
class CreateJobVewControllerTests: XCTestCase {
    var createJobController: CreateJobViewController!
    var createJobNavigationController: UINavigationController!
    var moreActionsController: MoreActionsViewController!
    var moreActionscell = MoreActionsCell()
    var primaryTableCell = PrimaryTableViewCell()
    func testProperties(){
        let font =  UIFont(name: "HelveticaLTStd-Light", size: 18.0)
        XCTAssertEqual(primaryTableCell.jobTitle.font, font)
        XCTAssertEqual(primaryTableCell.jobTitle.frame.height, 47.0)
        XCTAssertEqual(primaryTableCell.hiringCompanyLogo.font, font)
        XCTAssertEqual(createJobController.companyLogo.frame.height, 48.0)
        XCTAssertEqual(createJobController.companyName.font, font)
        XCTAssertEqual(createJobController.companyName.frame.height, 47.0)
        XCTAssertEqual(createJobController.yearsOfExperience.font, font)
        XCTAssertEqual(createJobController.yearsOfExperience.keyboardType, UIKeyboardType.numberPad)
        XCTAssertEqual(createJobController.yearsOfExperience.frame.height, 48.0)
        XCTAssertEqual(createJobController.date.font, font)
        XCTAssertEqual(createJobController.date.frame.height, 47.0)
        XCTAssertEqual(createJobController.numberOfCandidates.font, font)
        XCTAssertEqual(createJobController.numberOfCandidates.frame.height, 47.0)
        XCTAssertEqual(createJobController.numberOfCandidates.keyboardType, UIKeyboardType.numberPad)
        XCTAssertEqual(createJobController.requisitionNumber.font, font)
        XCTAssertEqual(createJobController.requisitionNumber.frame.height, 48.0)
        XCTAssertNotEqual(createJobController.requisitionNumber.keyboardType, UIKeyboardType.numberPad)
        XCTAssertEqual(createJobController.jobDescription.font, font)
        XCTAssertEqual(createJobController.jobDescription.frame.height, 48.0)
        XCTAssertEqual(createJobController.areaOfExpertise.font, font)
        XCTAssertEqual(createJobController.areaOfExpertise.frame.height, 48.0)
    }
    
    func testProgressBarProperties(){
        let progress1 = createJobController.progressBar(createJobController.progressBarWithDifferentDimensions, textAtIndex: 0, position: .bottom)
        XCTAssertEqual(progress1, "Primary")
        let progress2 = createJobController.progressBar(createJobController.progressBarWithDifferentDimensions, textAtIndex: 1, position: .bottom)
        XCTAssertEqual(progress2, "Skills")
        let progress3 = createJobController.progressBar(createJobController.progressBarWithDifferentDimensions, textAtIndex: 2, position: .bottom)
        XCTAssertEqual(progress3, "Preferences")
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.displayStepText, false)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.numberOfPoints, 3)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.lineHeight, 4.0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.progressRadius, 17.0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.viewBackgroundColor, AppTheme.appBackgroundColor)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.selectedBackgoundColor, CreateJobFonts.selectedBackgoundColor)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentSelectedCenterColor, CreateJobFonts.currentSelectedCenterColor)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentSelectedTextColor, CreateJobFonts.currentSelectedTextColor)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.stepTextColor, CreateJobFonts.stepTextColor)
    }
    
    func testSaveAndContinueUI(){
        XCTAssertNotNil(createJobController.saveButton)
        XCTAssertEqual(createJobController.saveButton.borderWidth, 1)
        XCTAssertEqual(createJobController.saveButton.cornerRadius, 5)
        XCTAssertEqual(createJobController.saveButton.currentTitle, "Save and Continue")
        XCTAssertEqual(createJobController.saveButton.currentTitleColor, UIColor.white)
        XCTAssertEqual(createJobController.saveButton.frame.height, 50)
        XCTAssertFalse(createJobController.saveButton.isHidden)
    }
    
    func testdoneDatePicker(){
        createJobController.donedatePicker()
        XCTAssertTrue(createJobController.view.endEditing(true))
    }
    
    func testcancelDatePicker(){
        createJobController.cancelDatePicker()
    }
    
    func testonDateSelect(){
        createJobController.showDatePicker()
        createJobController.onDateSelect(0)
    }
    func testPrimaryMandatoryFields(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 0
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyName.text = "company1"
        createJobController.yearsOfExperience.text = "24"
        createJobController.date.text = "20-sep-2019"
        createJobController.jobDescription.text = "desc"
        createJobController.numberOfCandidates.text = "23"
        createJobController.areaOfExpertise.text = "Application/Software"
        createJobController.jobDescription.text = "text"
        let v = createJobController.primaryViewValidations()
        if(v == true){
            createJobController.showSkillsView()
        }
        createJobController.updateCreateJobAPI(0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 1)
        XCTAssertTrue(createJobController.primaryView.isHidden)
        XCTAssertFalse(createJobController.skillsView.isHidden)
        XCTAssertTrue(createJobController.preferenceView.isHidden)
    }
    
    func testUpdateCountry(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedCountry": "India"])
        createJobController.updateCountry(notfication: notification)
        
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["country": "India"])
        createJobController.updateCountry(notfication: notification1)
        
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: [:])
        createJobController.updateCountry(notfication: notification2)
        
        let notification3 = NSNotification(name: .AccessTokenDidChange, object: nil)
        createJobController.updateCountry(notfication: notification3)
    }
    
    func testCountrySelection(){
        createJobController.countrySelection(0)
    }
    
    func testUpdateCreateJobAPI(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 2
        createJobController.requiredSkillArray = ["c", "Java", "c++", "database", "php"]
        createJobController.optionalSkillArray = ["dbms"]
        createJobController.specificationTextView.text = "SPECIFICATION_PLACEHOLDER_TEXT".localized
        createJobController.descriptionView.text = "JOB_DESCRIPTION_PLACEHOLDER_TEXT".localized
        createJobController.companyName.text = "company"
        createJobController.codingSamples.isChecked = true
        createJobController.date.text = "24-December-2019"
        createJobController.yearsOfExperience.text = "2"
        createJobController.areaOfExpertise.text = "Designer"
        createJobController.candidatePicture.isChecked = true
        createJobController.whiteBoard.isChecked = true
        createJobController.numberOfCandidates.text = "2"
        createJobController.jobTitle.text = "title"
        createJobController.jobID = "3345"
        createJobController.interviewLocationField.text = "India"
        createJobController.interviewlLanguageField.text = "English"
        createJobController.requisitionNumber.text = "23"
        createJobController.companyFileS3Key = "companyFileS3Key"
        createJobController.companyLogoAWSString = "companyFileS3Key"
        createJobController.isNavigatingFrom = .editJob
        let stubData = ["message": "Job Created", "success": true] as [String : Any]
        let expectation = XCTestExpectation(description: "test")

               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                   expectation.fulfill()
               }

               wait(for: [expectation], timeout: 3.0)
        CreateJobStubApi.getAreasOfExpertise = CreateJobResponse.stubResponse(json: stubData, code: true, message: "JobCreated")
        createJobController.saveButton.sendActions(for: .touchUpInside)
    }
    
    func testPrimaryValidations() {
        createJobController.showBanner(title: "", withMessage: "Job Title Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.jobTitle, currentField: "Job Title")
        createJobController.primaryViewValidations()
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.showBanner(title: "", withMessage: "Hiring Company Name Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.companyName, currentField: "Hiring Company Name")
        let res11 = createJobController.primaryViewValidations()
        XCTAssertFalse(res11)
        XCTAssertEqual(createJobController.jobTitle.text, "Data Scientist")
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyLogo.text = "Logo"
        createJobController.companyName.text = "company1"
        createJobController.showBanner(title: "", withMessage: "Years of Experience Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.yearsOfExperience, currentField: "Years of Experience")
        let res2 = createJobController.primaryViewValidations()
        XCTAssertFalse(res2)
        XCTAssertEqual(createJobController.companyName.text, "company1")
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyLogo.text = "Logo"
        createJobController.yearsOfExperience.text = "24"
        createJobController.showBanner(title: "", withMessage: "Closing date Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.date, currentField: "Closing date")
        let res3 = createJobController.primaryViewValidations()
        XCTAssertFalse(res3)
        XCTAssertEqual(createJobController.yearsOfExperience.text, "24")
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyLogo.text = "Logo"
        createJobController.yearsOfExperience.text = "24"
        createJobController.date.text = "20-sep-2019"
        createJobController.showBanner(title: "", withMessage: "Job Description Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.jobDescription, currentField: "Job Description")
        createJobController.primaryViewValidations()
        XCTAssertEqual(createJobController.date.text, "20-sep-2019")
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyLogo.text = "Logo"
        createJobController.yearsOfExperience.text = "24"
        createJobController.date.text = "20-09-2019"
        createJobController.jobDescription.text = "desc"
        createJobController.showBanner(title: "", withMessage: "Areas of Expertise Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.areaOfExpertise, currentField: "Areas of Expertise")
        createJobController.primaryViewValidations()
        XCTAssertEqual(createJobController.jobDescription.text, "desc")
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyLogo.text = "Logo"
        createJobController.yearsOfExperience.text = "24"
        createJobController.date.text = "20-sep-2019"
        createJobController.numberOfCandidates.text = "0"
        createJobController.jobDescription.text = "desc"
        createJobController.areaOfExpertise.text = "Application"
        createJobController.showBanner(title: "", withMessage: "Projected number of candidates should be more than 0", style: .warning)
        let res = createJobController.primaryViewValidations()
        XCTAssertFalse(res)
        XCTAssertEqual(createJobController.areaOfExpertise.text, "Application")
        XCTAssertEqual(createJobController.numberOfCandidates.text, "")
    }
    
    func testUploadImage(){
        XCTAssertNotNil(createJobController.upload_image_button)
        XCTAssertEqual(createJobController.upload_image_button.currentTitle, "Upload")
        XCTAssertEqual(createJobController.upload_image_button.titleLabel?.font, UIFont(name: "HelveticaLTStd-Roman", size: 14.0))
        XCTAssertEqual(createJobController.saveButton.borderWidth, 1)
        XCTAssertEqual(createJobController.saveButton.cornerRadius, 5)
        XCTAssertEqual(createJobController.saveButton.currentTitleColor, UIColor.white)
        createJobController.choosLogoAction(createJobController.upload_image_button)
    }
    
    func testdate(){
        let date = Date()
        createJobController.datePicker.date = Date()
        createJobController.datePicker.minimumDate = date
        createJobController.datePicker.datePickerMode = UIDatePicker.Mode.date
        createJobController.showDatePicker()
    }
    
    func testbackAction(){
        createJobController.backAction(0)
        createJobController.progressBarWithDifferentDimensions.currentIndex = 1
        createJobController.backAction(0)
        createJobController.progressBarWithDifferentDimensions.currentIndex = 2
        createJobController.backAction(0)
    }
    
    func testShowSkills(){
        createJobController.showSkillsView()
        XCTAssertEqual(createJobController.skillsView.isHidden, false)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 1)
    }
    
    func testShowPreferences(){
        createJobController.showPreferenceView()
        XCTAssertEqual(createJobController.preferenceView.isHidden, false)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 2)
    }
    
    func testShowPrimary(){
        createJobController.showPrimaryView()
        XCTAssertEqual(createJobController.primaryView.isHidden, false)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 0)
    }
    
    func testsetupProgressBarWithDifferentDimensions(){
        createJobController.viewModel.updatedSteppedBar()
        createJobController.setupProgressBarWithDifferentDimensions()
        XCTAssertEqual(createJobController.viewModel.steppedProgressBar , createJobController.progressBarWithDifferentDimensions)
    }
    
    func testProgressBarDidselectAt(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 1
        createJobController.progressBar(createJobController.progressBarWithDifferentDimensions, didSelectItemAtIndex: 0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.completedTillIndex , createJobController.progressBarWithDifferentDimensions.currentIndex)
    }
    
    func testtextViewDidBeginEditing(){
        createJobController.specificationTextView.textColor = AppTheme.placeHolderColor
        createJobController.textViewDidBeginEditing(createJobController.specificationTextView)
        XCTAssertEqual(createJobController.specificationTextView.textColor , AppTheme.textColor)
        createJobController.descriptionView.textColor = AppTheme.placeHolderColor
        createJobController.textViewDidBeginEditing(createJobController.descriptionView)
        XCTAssertEqual(createJobController.descriptionView.textColor , AppTheme.textColor)
    }
    
    func testtextViewDidEndEditing(){
        createJobController.specificationTextView.text = ""
        createJobController.textViewDidEndEditing(createJobController.specificationTextView)
        XCTAssertEqual(createJobController.specificationTextView.text , "For example, request a specific code snippet or white board sample. Suggesting subtopics of Skills to be Assessed above is permissible, however, please refrain from detailing the exact line of questioning.")
        XCTAssertEqual(createJobController.specificationTextView.textColor , AppTheme.placeHolderColor)
        createJobController.descriptionView.text = ""
        createJobController.textViewDidEndEditing(createJobController.descriptionView)
        XCTAssertEqual(createJobController.descriptionView.text , "Job Description*")
        XCTAssertEqual(createJobController.descriptionView.textColor , AppTheme.placeHolderColor)
    }
    
//    func testCreateJobResponse(){
//        let respone = ProfileResponse(json: ["company_details": ["email" : "afrinshaik521@gmail.com", "id_required": true, "contact2": "13223434", "same_as_billing_address" : true, "contact1": "9993847455", "website": "eteki.com" , "name": "Afreen", "address1": "address", "address2": "address", "city": "city", "country": "country", "state": "state", "time_zone": "time_zone", "zip" : "531116"]], success: true, message: "Success")
//        createJobController.onGetProfileResponse(response: respone, requestType: ServerAttributes.getProfileDetails)
//        let respone1 = ProfileResponse(json: ["company_details": ["email" : "afrinshaik521@gmail.com", "id_required": false, "contact2": "13223434", "same_as_billing_address" : true, "contact1": "9993847455", "website": "eteki.com" , "name": "Afreen", "address1": "address", "address2": "address", "city": "city", "country": "country", "state": "state", "time_zone": "time_zone", "zip" : "531116"]], success: true, message: "Success")
//        createJobController.onGetProfileResponse(response: respone1, requestType: ServerAttributes.getProfileDetails)
//        let respone2 = ProfileResponse(json: ["company_details": [ "id_required": false ]], success: true, message: "Success")
//        createJobController.onGetProfileResponse(response: respone2, requestType: ServerAttributes.getProfileDetails)
//    }
//
    
    func testUpdatecreatejobApiforSkills(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 1
        createJobController.requiredListView.addTag("C")
        createJobController.requiredListView.addTag("Java")
        createJobController.updateCreateJobAPI(0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 2)
        XCTAssertTrue(createJobController.primaryView.isHidden)
        XCTAssertTrue(createJobController.skillsView.isHidden)
        XCTAssertFalse(createJobController.preferenceView.isHidden)
        
        createJobController.progressBarWithDifferentDimensions.currentIndex = 1
        createJobController.requiredListView.removeAllTags()
        let v1 = createJobController.skillsViewValidation()
        if(v1 != true){
            createJobController.showBanner(title: "", withMessage: "Please add Required Skills.", style: .warning)
        }
        createJobController.updateCreateJobAPI(0)
        XCTAssertNotEqual(createJobController.progressBarWithDifferentDimensions.currentIndex, 2)
    }
    

    func testOnGetResponse(){
        let response = CreateJobResponse(json: ["job":["agent" : self, "auto_source" : true, "client_company_name": "Afreen", "coding_required": true, "company_logo": "https://s3-us-west-2.amazonaws.com/iconf-profile-upload/zijqIS9OWbqk.png", "description": "description", "due_at": "2019-12-12", "experience_required": 3, "expertise_category": "developer", "interview_max_price": "maxPrice", "interview_min_price":"minPrice", "id_required": true, "id": "3098", "interview_mode": "video", "interviewer_language_preference": "English", "interviewer_location_preference": "India", "interviewers_count": 20, "job_code": "44", "job_description_file": "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/VWizD4rYbqnb.pdf", "number_of_prospects": 12, "preferred_skillset": "c", "recording_enabled": true, "skillset": "database", "special_instructions": "instructions", "status": "Active", "title": "title", "whiteboard_required": true]], success: true, message: "Successfully Job created")
        let exp1 = XCTestExpectation(description: "test")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    exp1.fulfill()
                    self.createJobController.removeSpinner()
                }
                wait(for: [exp1], timeout: 2.5)
        createJobController.onGetJobDetailsReponse(response: response)
        let response1 = CreateJobResponse(json: ["job":["agent" : self, "auto_source" : false, "client_company_name": "", "coding_required": false, "company_logo": "", "description": "", "due_at": "2019-12-12", "experience_required": 0, "expertise_category": "", "interview_max_price": "", "interview_min_price":"", "id_required": false, "id": "", "interview_mode": "", "interviewer_language_preference": "", "interviewer_location_preference": "", "interviewers_count": 0, "job_code": "", "job_description_file": "", "number_of_prospects": 0, "preferred_skillset": "", "recording_enabled": false, "skillset": "", "special_instructions": "", "status": "", "title": "", "whiteboard_required": false]], success: true, message: "Successfully Job created")
        let exp = XCTestExpectation(description: "test")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    exp.fulfill()
                    self.createJobController.removeSpinner()
                }
                wait(for: [exp], timeout: 2.5)
        createJobController.onGetJobDetailsReponse(response: response1)
        let response2 = CreateJobResponse(json: ["job":["due_at": "2019-12-12"]], success: true, message: "Successfully Job created")
        let exp2 = XCTestExpectation(description: "test")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    exp2.fulfill()
                    self.createJobController.removeSpinner()
                }
                wait(for: [exp2], timeout: 2.5)
        createJobController.onGetJobDetailsReponse(response: response2)
        let response3 = CreateJobResponse(json: ["job":[]], success: true, message: "Successfully Job created")
        let exp3 = XCTestExpectation(description: "test")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    exp3.fulfill()
                    self.createJobController.removeSpinner()
                }
                wait(for: [exp3], timeout: 2.5)
        createJobController.onGetJobDetailsReponse(response: response3)
    } 
    
    /*
    func testUpdatecreatejobApiforPreferences(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 2
        createJobController.showSpinner()
        let manager = CreateJobManager(clientCompanyName: "Company1", codingRequired: true, description: "https://eteki.com", dueDate: "20-09-2019", experirenceRequired: "2", expertiseCategory: "Application", idRequired: true, interViewMode: "video", AreasOfExpertise: "Software", whiteboradRequired: true, numberOfProspects: "1", specialInstructions: "instructionas", preferedSkillSet: "Database", skillset: "JUnit", jobTitle: "Developer", jobDescriptionAwsurl: "", interViewLanguagePreference: "English", interViewLocationPreference: "India", jobCode: "", companyLogo: "",requestType: "", jobID: "3695")
        createJobController.viewModel.updateCreateJob(createJobManager: manager, requestType: "Update Create Job")
        createJobController.updateCreateJobAPI(0)
    }  */
    
    func testDownloadImageAws(){
        createJobController.downloadImageAWS(key: "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3557/resumes/1575975378eteki.testmail@gmail.com")
    }
    
    func testClearLocaldirectory(){
        createJobController.clearLocalDirectory()
    }
    
    func testDownloadFileForObject(){
        createJobController.downloadFileForfileObject(url: "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3557/resumes/1575975378eteki.testmail@gmail.com")
    }
    
    func testOpenSelectedDocment(){
        createJobController.openSelectedDocumentFromURL(documentURLString: "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/3557/resumes/1575975378eteki.testmail@gmail.com")
    }
    
    func testDocumentInteraction(){
        createJobController.documentInteractionControllerViewControllerForPreview(UIDocumentInteractionController())
    }
    
    func testdateExtensions(){
        Date().isEqualTo(Date())
        Calendar.current.date(byAdding: .hour, value: 1, to: Date())?.isGreaterThan(Calendar.current.date(byAdding: .hour, value: -1, to: Date())!)
        Calendar.current.date(byAdding: .hour, value: -1, to: Date())?.isSmallerThan(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
        let str = "24-12-2020"
        str.getDateFromDate(str, fromFormat: "dd-MM-yyyy", ToFormat: "dd-MMM-yyyy")
        str.getDateFromDate("", fromFormat: "dd-MM-yyyy", ToFormat: "dd-MMM-yyyy")
    }
    
    func testcreateJonUpdateApiforPrimary(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 0
       createJobController.jobTitle.text = "Data Scientist"
       createJobController.companyName.text = "company1"
       createJobController.yearsOfExperience.text = "24"
       createJobController.date.text = "20-sep-2019"
       createJobController.jobDescription.text = "desc"
        createJobController.descriptionView.text = "descriptionView"
       createJobController.numberOfCandidates.text = "23"
       createJobController.areaOfExpertise.text = "Application/Software"
        createJobController.updateCreateJobAPI(0)
        createJobController.progressBarWithDifferentDimensions.currentIndex = 0
        let date = DateFormatter()
        date.dateFormat = "dd-MMM-yyyy"
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyName.text = "company1"
        createJobController.yearsOfExperience.text = "24"
        createJobController.date.text = date.string(from: Date())
        createJobController.jobDescription.text = "desc"
        createJobController.numberOfCandidates.text = "23"
        createJobController.areaOfExpertise.text = "Application/Software"
         createJobController.updateCreateJobAPI(0)
        createJobController.jobTitle.text = "Data Scientist"
        createJobController.companyName.text = "company1"
        createJobController.yearsOfExperience.text = "24"
        createJobController.date.text = date.string(from:  Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        createJobController.jobDescription.text = "desc"
        createJobController.numberOfCandidates.text = "23"
        createJobController.areaOfExpertise.text = "Application/Software"
         createJobController.updateCreateJobAPI(0)
    }
    
    func testuploadImage(){
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        createJobController.choosLogoAction(createJobController.upload_image_button)
        let picker = UIImagePickerController()
        //        let url = NSURL(fileURLWithPath: "https://eteki.com")
        //        let image = UIImage(named: "user")
        //        let info = [UIImagePickerController.InfoKey.imageURL : url ]

        //createJobController.imagePickerController(picker, didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey : Any]())
    }
    
    func testDidSelect(){
        let image = UIImage(named: "zijqIS9OWbqk")
        let url = URL(fileURLWithPath:"https://s3-us-west-2.amazonaws.com/iconf-profile-upload/zijqIS9OWbqk.png")
        createJobController.didSelect(image: image, imageName: url)
    }
    
    func testTagPressed(){
            createJobController.tagPressed("tag1", tagView:createJobController.requiredListView.addTag("tag1") , sender: createJobController.requiredListView)
    }
    
    func testshouldChangewithurl(){
        let url = URL(fileURLWithPath: "https://s3-us-west-2.amazonaws.com/iconf-documents/jobs/VWizD4rYbqnb.pdf")
        let range = NSRange()
        createJobController.textView(createJobController.descriptionView, shouldInteractWith: url, in: range)
    }
    
    func testResizedImage(){
        createJobController.selectedImage.resizedImage(newSize: CGSize(width: 200, height: 200))
    }
    
    func testImagePickerDelegate(){
        let picker = ImagePicker()
        let image = createJobController.selectedImage
        createJobController.imagePickerDelegate(didSelect: image, delegatedForm: picker)
        createJobController.imagePickerDelegate(didCancel: picker)
        createJobController.imagePickerDelegate(canUseGallery: true, delegatedForm: picker)
    }
    
//    func testUploadImageToAWS(){
//        createJobController.selectedImage =  UIImage(named:"zijqIS9OWbqk.png") ?? createJobController.selectedImage
//        createJobController.uploadImageToAWS()
//    }
    
//    func testUploadFile(){
////        createJobController.chooseDocumentAction()
//    }
    
    func testbindViewModal(){
        createJobController.bindViewModel()
        XCTAssertEqual(createJobController.viewModel.dateTextField, createJobController.date)
    }
    
    func testUpdatearea(){
        let notification = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedArea" : "Application/software"])
        createJobController.updateArea(notfication: notification)
        XCTAssertEqual(createJobController.areaOfExpertise.text, "Application/software")
        let notification1 = NSNotification(name: .AccessTokenDidChange, object: nil)
        createJobController.updateArea(notfication: notification1)
        let notification2 = NSNotification(name: .AccessTokenDidChange, object: nil, userInfo: ["selectedArea" : []])
        createJobController.updateArea(notfication: notification2)
    }
    
    func testImageTapped(){
        createJobController.cameraButtonTapped(UIButton())
        createJobController.photoButtonTapped(UIButton())
    }
//    func testApiCallOfAreasOfExpertise(){
//        //        let server_url = Environments().configuration(PlistKey.ServerURL)
//        //        let path = ServerAttributes.areaOfExpertise
//        //        let basePath =  server_url+ServerAttributes.interViewersPath + path
//        //
//        //        let parameters: [String: Any] = ["":""]
//        //      let session = RequestBuilder.shared.getSession()
//        //        let request =  RequestBuilder.shared.getRequestURLWithBody(inputString: basePath, method: "GET", parameters: parameters) as! URLRequest
//        //        let task = session?.dataTask(with: request) { (data, response, error) in
//        //
//        //
//        //            }.resume()
//        let exp1 = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            exp1.fulfill()
//        }
//        wait(for: [exp1], timeout: 2.5)
//        createJobController.viewModel.getExpertiseData(requestType: "/list_categories" )
//        
//        //createJobController.onGetAPIResponse(response: , requestType: "Primary")
//    }
    
    func testGetResponseofAreasofExpertise(){
        let response = CreateJobResponse(json: ["categories": [["name" : "Application"] , ["name" : "Software"]]], success: true, message: "200 ok")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.createJobController.removeSpinner()
        }
        wait(for: [exp1], timeout: 2.5)
       // createJobController.onGetAPIResponse(response: response, requestType: "/list_categories")
        print(response)
        //        XCTAssertEqual(createJobController.areasDropdown.dataSource, response.categories)
    }
    
    func testShoukdChangeChars(){
        let range = NSRange()
        createJobController.textField(createJobController.yearsOfExperience, shouldChangeCharactersIn: range, replacementString: "")
        createJobController.textField(createJobController.numberOfCandidates, shouldChangeCharactersIn: range, replacementString: "")
        createJobController.textField(createJobController.jobDescription, shouldChangeCharactersIn: range, replacementString: "")
    }
    override func setUp() {
        createJobController = mainStoryboard.instantiateViewController(withIdentifier: "CreateJobViewController") as? CreateJobViewController
        createJobNavigationController = UINavigationController(rootViewController: createJobController)
        createJobController.view.layoutIfNeeded()
        createJobNavigationController.view.layoutIfNeeded()
        createJobController.createJobAPI = CreateJobStubApi.self
        UIApplication.shared.keyWindow?.rootViewController = createJobNavigationController
        moreActionsController = mainStoryboard.instantiateViewController(withIdentifier: "MoreActionsViewController") as? MoreActionsViewController
        moreActionsController.view.layoutIfNeeded()
        
    }
    
    func testChooseDocumentAction(){
        createJobController.showSpinner()
        createJobController.chooseDocumentAction(UIButton())
        createJobController.companyFileS3Key = "key-1234445"
        createJobController.showSpinner()
        createJobController.chooseDocumentAction(UIButton())
        createJobController.chooseDocumentAction(createJobController.upload_description)
    }
    
    func testDocumentPicker(){
        let url = URL(fileURLWithPath: "https://s3-us-west-2.amazonaws.com/iconf-profile-upload/rrhjMqlcytZ7.png")
        let controller = UIDocumentPickerViewController(documentTypes: [".pdf"], in: .import)
        createJobController.documentPicker(controller, didPickDocumentsAt: [url])
    }
    
    func testChooseLogoAction(){
        createJobController.choosLogoAction(UIButton())
         createJobController.companyLogoS3Key = "key-1234445"
        createJobController.showSpinner()
         createJobController.choosLogoAction(UIButton())
        createJobController.choosLogoAction(createJobController.upload_image_button)
    }
    
    func testShoulChangeTextIn(){
        let range = NSRange("text")
        createJobController.textView(createJobController.descriptionView, shouldChangeTextIn: range ?? NSRange(), replacementText: "\n")
        
        let range1 = NSRange("text")
        createJobController.textView(createJobController.descriptionView, shouldChangeTextIn: range1 ?? NSRange(), replacementText: "text")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
