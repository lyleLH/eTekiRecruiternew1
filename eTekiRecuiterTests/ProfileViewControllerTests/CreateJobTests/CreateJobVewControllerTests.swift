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
    
    func testProperties(){
        let font =  UIFont(name: "Roboto-Regular", size: 16.0)
        XCTAssertEqual(createJobController.jobTitle.font, font)
        XCTAssertEqual(createJobController.jobTitle.frame.height, 47.0)
        XCTAssertEqual(createJobController.companyLogo.font, font)
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
        XCTAssertEqual(createJobController.requisitionNumber.frame.height, 47.0)
        XCTAssertNotEqual(createJobController.requisitionNumber.keyboardType, UIKeyboardType.numberPad)
        XCTAssertEqual(createJobController.jobDescription.font, font)
        XCTAssertEqual(createJobController.jobDescription.frame.height, 47.0)
        XCTAssertEqual(createJobController.areaOfExpertise.font, font)
        XCTAssertEqual(createJobController.areaOfExpertise.frame.height, 47.0)
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
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.lineHeight, 5.0)
        XCTAssertEqual(createJobController.progressBarWithDifferentDimensions.progressRadius, 18.0)
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
        XCTAssertEqual(createJobController.saveButton.titleLabel?.font, UIFont(name: "Roboto-Regular", size: 18.0))
        XCTAssertFalse(createJobController.saveButton.isHidden)
    }
    
    func testdoneDatePicker(){
      createJobController.donedatePicker()
        XCTAssertTrue(createJobController.view.endEditing(true))
    }
    
    func testcancelDatePicker(){
      createJobController.cancelDatePicker()
        XCTAssertTrue(createJobController.view.endEditing(true))
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
        createJobController.date.text = "20-09-2019"
        createJobController.jobDescription.text = "desc"
        createJobController.areaOfExpertise.text = "Application/Software"
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
    
    func testPrimaryValidations(){
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
        createJobController.date.text = "20-09-2019"
        createJobController.showBanner(title: "", withMessage: "Job Description Can't be blank", style: .warning)
        createJobController.showValidation(textField: createJobController.jobDescription, currentField: "Job Description")
        createJobController.primaryViewValidations()
        XCTAssertEqual(createJobController.date.text, "20-09-2019")
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
        createJobController.date.text = "20-09-2019"
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
        XCTAssertEqual(createJobController.upload_image_button.titleLabel?.font, UIFont(name: "Roboto-Regular", size: 12.0))
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
    
    func testUpdatecreatejobApiforSkills(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 1
        createJobController.requiredListView.addTag("C")
        createJobController.requiredListView.addTag("Java")
        let v = createJobController.skillsViewValidation()
        if(v == true){
            createJobController.showPreferenceView()
        }
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
    
    func testUpdatecreatejobApiforPreferences(){
        createJobController.progressBarWithDifferentDimensions.currentIndex = 2
        createJobController.showSpinner()
        let manager = CreateJobManager(clientCompanyName: "Company1", codingRequired: true, description: "https://eteki.com", dueDate: "20-09-2019", experirenceRequired: "2", expertiseCategory: "Application", idRequired: true, interViewMode: "video", AreasOfExpertise: "Software", whiteboradRequired: true)
        createJobController.viewModel.updateCreateJob(createJobManager: manager, requestType: "Update Create Job")
        createJobController.updateCreateJobAPI(0)
    }
    
    func testuploadImage(){
      UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
      createJobController.choosLogoAction(createJobController.upload_image_button)
        let picker = UIImagePickerController()
//        let url = NSURL(fileURLWithPath: "https://eteki.com")
//        let image = UIImage(named: "user")
//        let info = [UIImagePickerController.InfoKey.imageURL : url ]
        createJobController.imagePickerController(picker, didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey : Any]())
    }
    
    func testUploadFile(){
        createJobController.chooseDocumentAction(0)
    }
    
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

    func testApiCallOfAreasOfExpertise(){
//        let server_url = Environments().configuration(PlistKey.ServerURL)
//        let path = ServerAttributes.areaOfExpertise
//        let basePath =  server_url+ServerAttributes.interViewersPath + path
//
//        let parameters: [String: Any] = ["":""]
//      let session = RequestBuilder.shared.getSession()
//        let request =  RequestBuilder.shared.getRequestURLWithBody(inputString: basePath, method: "GET", parameters: parameters) as! URLRequest
//        let task = session?.dataTask(with: request) { (data, response, error) in
//      
//
//            }.resume()
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 2.5)
      createJobController.viewModel.getExpertiseData(requestType: "/list_categories" )
       
    //createJobController.onGetAPIResponse(response: , requestType: "Primary")
    }
    
    func testGetResponseofAreasofExpertise(){
        let response = CreateJobResponse(json: ["categories": [["name" : "Application"] , ["name" : "Software"]]], success: true, message: "200 ok")
        let exp1 = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp1.fulfill()
            self.createJobController.removeSpinner()
        }
        wait(for: [exp1], timeout: 2.5)
        createJobController.onGetAPIResponse(response: response, requestType: "/list_categories")
        print(response)
//        XCTAssertEqual(createJobController.areasDropdown.dataSource, response.categories)
    }
    
    override func setUp() {
        createJobController = mainStoryboard.instantiateViewController(withIdentifier: "CreateJobViewController") as? CreateJobViewController
        createJobNavigationController = UINavigationController(rootViewController: createJobController)
        createJobController.view.layoutIfNeeded()
        createJobNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = createJobNavigationController
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
