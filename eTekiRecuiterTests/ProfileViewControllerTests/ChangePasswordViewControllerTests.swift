//
//  ChangePasswordViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Afreen Shaik on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter

class ChangePasswordViewControllerTests: XCTestCase {
    var changePasswordController: ChangePasswordViewController!
    var changePasswordNavigationController: UINavigationController!
    override func setUp() {
        changePasswordController = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController
        changePasswordNavigationController = UINavigationController(rootViewController: changePasswordController)
        changePasswordController.view.layoutIfNeeded()
        changePasswordNavigationController.view.layoutIfNeeded()
        UIApplication.shared.keyWindow?.rootViewController = changePasswordController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testBackAction(){
        changePasswordController.dismiss(animated: true, completion: nil)
        changePasswordController.backAction(0)
    }
    func testUpdateApiIsEmpty(){
        changePasswordController.showBanner(title: "", withMessage: "EnterRequiredFields.", style: .danger)
        changePasswordController.updateAPI(0)
    }
    
    func testInstance() {
        XCTAssertNotNil(changePasswordController, "Not able to create changePasswordController Instance.")
        XCTAssertNotNil(changePasswordController.updateButton, "updateButton")
     
    }
    
    func testUpdateApiValid(){
        changePasswordController.oldPassword.text = ""
        changePasswordController.updateButton.sendActions(for: .touchUpInside)
        
        changePasswordController.oldPassword.text = "5553"
        changePasswordController.newPassword.text = ""
        changePasswordController.updateButton.sendActions(for: .touchUpInside)
        
        changePasswordController.oldPassword.text = "3445"
        changePasswordController.newPassword.text = "45454"
        changePasswordController.confirmPassword.text = ""
        changePasswordController.updateButton.sendActions(for: .touchUpInside)
        
        changePasswordController.oldPassword.text = "221"
        changePasswordController.newPassword.text = "222"
        changePasswordController.confirmPassword.text = "222"
        changePasswordController.updateButton.sendActions(for: .touchUpInside)
        
        changePasswordController.oldPassword.text = "22222222"
        changePasswordController.newPassword.text = "222"
        changePasswordController.confirmPassword.text = "222"
        
         changePasswordController.updateButton.sendActions(for: .touchUpInside)
        //changePasswordController.updateAPI(0)
        changePasswordController.oldPassword.text = "22222222"
        changePasswordController.newPassword.text = "22222222"
        changePasswordController.confirmPassword.text = "222"
  

         changePasswordController.updateButton.sendActions(for: .touchUpInside)
//        changePasswordController.updateAPI(0)
        changePasswordController.oldPassword.text = "223333333"
        changePasswordController.newPassword.text = "223333333"
        changePasswordController.confirmPassword.text = "222111111"
        changePasswordController.updateButton.sendActions(for: .touchUpInside)

        changePasswordController.oldPassword.text = "223333333"
              changePasswordController.newPassword.text = "223333333"
              changePasswordController.confirmPassword.text = "223333333"
              changePasswordController.updateButton.sendActions(for: .touchUpInside)
        
        changePasswordController.oldPassword.text = "223344333"
                     changePasswordController.newPassword.text = "223333333"
                     changePasswordController.confirmPassword.text = "223333333"
                     changePasswordController.updateButton.sendActions(for: .touchUpInside)
    }
    
    func testGetProfileResoponse(){
        let response = ProfileResponse()
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            exp.fulfill()
//            self.changePasswordController.showBanner(title: "", withMessage: response.message ?? "PROFILE_UPDATED".localized, style: .success)
//            self.changePasswordController.removeSpinner()
            self.changePasswordController.resetValues()
        }
        wait(for: [exp], timeout: 2.5)
        changePasswordController.onGetProfileResponse(response: response)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOnApiException(){
        let response = ErrorResponse(responseCode: 404, message: "Server Error", tittle: "")
        let exp = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 1.5)
        changePasswordController.onAPIException(errorResponse: response)
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
