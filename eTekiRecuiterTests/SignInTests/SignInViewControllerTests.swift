//
//  SignInViewControllerTests.swift
//  eTekiRecruiterTests
//
//  Created by Siva Sagar Palakurthy on 31/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest
@testable import eTekiRecruiter
import DropDown

class SignInViewControllerTests: XCTestCase {
    
    var signInViewController: SignInViewController!
    var signInNavigationController: UINavigationController!
    var isKeyBoardVisible = false
    
    override func setUp() {
        super.setUp()
        signInViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        signInNavigationController = UINavigationController(rootViewController: signInViewController)
        signInViewController.view.layoutIfNeeded()
        signInNavigationController.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)

        UIApplication.shared.keyWindow?.rootViewController = signInNavigationController
    }
    
    override func tearDown() {
        signInViewController = nil
        signInNavigationController = nil
        UIApplication.shared.keyWindow?.rootViewController = nil
        super.tearDown()
    }
    
    func testInstance() {
        XCTAssertNotNil(signInViewController, "Not able to create SignInViewController Instance.")
        XCTAssertNotNil(signInViewController.signInContainerView, "Not able to create signInContainerView Instance.")
        XCTAssertNotNil(signInViewController.signInBackgroundScrollView, "Not able to create signInBackgroundScrollView Instance.")
        XCTAssertNotNil(signInViewController.logoTopConstraint, "Not able to create logoTopConstraint Instance.")
        XCTAssertNotNil(signInViewController.loginStackViewHeight, "Not able to create loginStackViewHeight Instance.")
        XCTAssertNotNil(signInViewController.passwordField, "Not able to create passwordField Instance.")
        XCTAssertNotNil(signInViewController.emailTextField, "Not able to create emailTextField Instance.")
        XCTAssertNotNil(signInViewController.signInButton, "Not able to create signInButton Instance.")
        XCTAssertNotNil(signInViewController.forgotPasswordButton, "Not able to create forgotPasswordButton Instance.")
        XCTAssertNotNil(signInViewController.orLabel, "Not able to create orLabel Instance.")
        XCTAssertNotNil(signInViewController.resendEmailConfirmationButton, "Not able to create resendEmailConfirmationButton Instance.")
        XCTAssertNotNil(signInViewController.logoImageView, "Not able to create logoImageView Instance.")
        XCTAssertTrue(signInNavigationController.isNavigationBarHidden, "Navigation Bar is visible")

    }
    
    func testLogingStackView() {
        XCTAssertEqual(128, signInViewController.loginStackViewHeight.constant, "login stack view height broken")
    }
    
    func testEmailTextField() {
        signInViewController.emailTextField.setBottomBorderOnlyWith(color: CreateJobFonts.selectedBackgoundColor.cgColor)
        signInViewController.emailTextField.isError(baseColor: CreateJobFonts.selectedBackgoundColor.cgColor, numberOfShakes: 0.2, revert: true)
        signInViewController.emailTextField.maxLength = 12
        signInViewController.emailTextField.fix(textField: signInViewController.emailTextField)
        let leftView = signInViewController.emailTextField.leftView
        let imageContentView = leftView?.subviews[0]
        let imageView = imageContentView?.subviews[0] as? UIImageView
//        XCTAssertNotNil(imageView, "imageView view is nil")
//        XCTAssertEqual(imageView?.image, UIImage(named: "email"), "email icon is broken")
    }
    
    func testPasswordTextField() {
        let leftView = signInViewController.passwordField.leftView
        let imageContentView = leftView?.subviews[0]
        let imageView = imageContentView?.subviews[0] as? UIImageView
//        XCTAssertNotNil(imageView, "imageView view is nil")
//        XCTAssertEqual(imageView?.image, UIImage(named: "password"), "password  icon is broken")
    }
    
    func testForgotPasswordButton() {
        let frame = signInViewController.forgotPasswordButton.frame

        XCTAssertEqual(24.0, frame.height, "Forgot password height broken")
        signInViewController.forgotPasswordButton.sendActions(for: .touchUpInside)
        
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard let forgotPasswordViewController = UIApplication.topMostViewController() as? ForgotPasswordViewController else {
                XCTFail("ForgotPasswordViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(forgotPasswordViewController, "Not able to Navigate ForgotPasswordViewController, instance is nil.")
            forgotPasswordViewController.view.layoutIfNeeded()
            XCTAssertNotNil(forgotPasswordViewController.backToLogin, "backToLogin instance is nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 6.0)

        
    }
    
    func testResendButton() {
        let frame = signInViewController.resendEmailConfirmationButton.frame
        XCTAssertEqual(36.0, frame.height, "Resend Email height broken")
        
        signInViewController.resendEmailConfirmationButton.sendActions(for: .touchUpInside)
        
//        let expectation = XCTestExpectation(description: "test")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            guard let resendConfirmationLinkViewController = UIApplication.topMostViewController() as? ResendConfirmationLinkViewController else {
//                XCTFail("ResendConfirmationLinkViewController is not Top most view controller.")
//                return
//            }
//            XCTAssertNotNil(resendConfirmationLinkViewController, "Not able to Navigate ResendConfirmationLinkViewController, instance is nil.")
//            resendConfirmationLinkViewController.view.layoutIfNeeded()
//            
//            XCTAssertNotNil(resendConfirmationLinkViewController.backToLogin, "backToLogin instance is nil")
//            expectation.fulfill()
//            
//        }
//        wait(for: [expectation], timeout: 3.5)

    }
    
    func testSignInButtonWithInvalidEmailFormat() {
        signInViewController.viewModel.emailTextField.text = "siva"
        signInViewController.viewModel.passwordTextField.text = "Secret@16"
        signInViewController.signInButton.sendActions(for: .touchUpInside)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            guard let signInViewController = UIApplication.topMostViewController() as? SignInViewController else {
                XCTFail("SignInViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(signInViewController, "Not able to Navigate SignInViewController, instance is nil.")
            signInViewController.view.layoutIfNeeded()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSignInButtonWithValidCredentials() {
        signInViewController.viewModel.emailTextField.text = "siva@mail.com"
        signInViewController.viewModel.passwordTextField.text = "Secret@16"
        let signInResponse = SignInResponse(json: [:], success: true)
        StubAuthenticationApi.signInResponse = signInResponse
        signInViewController.viewModel.authenticaionAPI = StubAuthenticationApi.self
        signInViewController.signInButton.sendActions(for: .touchUpInside)
//        let expectation = XCTestExpectation(description: "test")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            guard let dashboardViewController = UIApplication.topMostViewController() as? DashboardViewController else {
//                XCTFail("DashboardViewController is not Top most view controller.")
//                return
//            }
//            XCTAssertNotNil(dashboardViewController, "Not able to Navigate DashboardViewController, instance is nil.")
//            dashboardViewController.view.layoutIfNeeded()
//            XCTAssertEqual(dashboardViewController.navigationItem.title, "Dashboard", "DashboardViewController not loaded")
//            expectation.fulfill()
//
//        }
//        wait(for: [expectation], timeout: 2.5)
    }
    
    func testLogoImageView() {
//        XCTAssertEqual(signInViewController.logoImageView.image, UIImage(named: "logo"), "logo image mismatch")
        XCTAssertEqual(54, signInViewController.logoTopConstraint.constant, "Logo stack view top view constraint  broken")
    }

    func testSignInWithValidCredentials() {
        signInViewController.viewModel.emailTextField.text = "siva@mail.com"
        signInViewController.viewModel.passwordTextField.text = "Secret@16"
        signInViewController.bindViewModel()
        let result = signInViewController.shouldPerformSegue(withIdentifier: "SignInSegue", sender: signInViewController.signInButton)
        XCTAssertFalse(result,"Sign in passed the email and password validation")
    }
    
    func testShouldPerformWithUnknowSegue() {
        let result = signInViewController.shouldPerformSegue(withIdentifier: "UnkownIdentifier", sender: self)
        XCTAssertFalse(result, "Segue should fail with Unkown Identifier")
    }
    
    func testShouldPerformWithFromLinkedInToDashboardSegue() {
        let result = signInViewController.shouldPerformSegue(withIdentifier: StoryboardSegueIdentifiers.linkedInToDashboard, sender: self)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        XCTAssertFalse(result, "Segue should fail with Unkown Identifier")
    }
    
    func testShouldPerformWithFromFacebookToDashboardSegue() {
        let result = signInViewController.shouldPerformSegue(withIdentifier: StoryboardSegueIdentifiers.facebookToDashboard, sender: self)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        XCTAssertFalse(result, "Segue should fail with Unkown Identifier")
    }
    
    func testNavigateToDashboard(){
        signInViewController.navigateToDashBoard()
        let expectation = XCTestExpectation(description: "test")

//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            print(UIApplication.topMostViewController())
//            guard let signInViewController = UIApplication.topMostViewController() as? DashboardViewController else {
//                XCTFail("DashboardViewController is not Top most view controller.")
//                return
//            }
//            XCTAssertNotNil(signInViewController, "Not able to Navigate DashboardViewController, instance is nil.")
//            signInViewController.view.layoutIfNeeded()
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 3.5)
    }
    
    func testCallFacebookAction(){
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        signInViewController.callFacebookAction()
    }
    
    func testCallFacebookRequest(){
        signInViewController.callFacebookGraphRequest()
    }


    func testSignInRespoonse(){
        let response = SignInResponse(json: ["message": "Successfully Signed", "selfServiceEnabled": 2, "account_type": "Facebook", "authentication_token": "us-east-1:7f968a1c-d81e-4af4-a379-5be45990eace", "current_subscription": "subscribed", "user": "anusha"], success: true)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        signInViewController.onSignInResponse(response: response)
    }
    
    func testOnApiException(){
        let response = ErrorResponse(responseCode: 404, message: ErrorHandler.tokenExpired, tittle: "")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        signInViewController.onAPIException(errorResponse: response)
    }
    
    func testOnOauthLoginResponse(){
        let response = OAuthLoginResponse(json: ["authentication_token": "us-east-1:7f968a1c-d81e-4af4-a379-5be45990eace", "user": "anusha"], success: true)
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        signInViewController.onOAuthLoginResponse(response: response)

    }
    
    func testSignInWithInValidCredentials() {
        signInViewController.viewModel.emailTextField.text = "siva"
        signInViewController.viewModel.passwordTextField.text = "Secret@16"
        let result = signInViewController.shouldPerformSegue(withIdentifier: "SignInSegue", sender: signInViewController.signInButton)
        XCTAssertFalse(result,"Sign in passed the in valid email and password credentials")
    }
    
    func testApiExceptionWithInvalidCredentials() {
        
        ExceptionAuthenticationApi.errorResponse = ErrorResponse.stubAuthenticationFailed()
        signInViewController.viewModel.authenticaionAPI = ExceptionAuthenticationApi.self
        
        let credentialsManager = CredentialsManager(username: "siva@mail.com" , password: "Secret@6",applicationId: "")
        signInViewController.viewModel.callAuthenticationAPI(credentialsManager: credentialsManager)
        
        let expectation = XCTestExpectation(description: "test")

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            guard let signInViewController = UIApplication.topMostViewController() as? SignInViewController else {
                XCTFail("SignInViewController is not Top most view controller.")
                return
            }
            XCTAssertNotNil(signInViewController, "Not able to Navigate DashboardViewController, instance is nil.")
            signInViewController.view.layoutIfNeeded()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.5)

    }
    
    func testSignInTextField() {
        signInViewController.emailTextField.becomeFirstResponder()
        signInViewController.dismissKeyboard()
        XCTAssertFalse(signInViewController.emailTextField.isFirstResponder,"Keyboard doesn't hide on tap around")
    }
    
    func testTapGesture() {
        signInViewController.passwordField.becomeFirstResponder()
        signInViewController.dismissKeyboard()
        XCTAssertFalse(signInViewController.passwordField.isFirstResponder, "Keyboard doesn't hide on tap around")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(keyboardHeight)
        isKeyBoardVisible = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(keyboardHeight)
        isKeyBoardVisible = false
    }
    
    func testLinkedIn() {
        signInViewController.performSegue(withIdentifier: StoryboardSegueIdentifiers.linkedInToDashboard, sender: nil)  
    }
    
    func testTogglePassword(){
        signInViewController.tooglePasswordAction(UIButton())
        XCTAssertFalse(signInViewController.passwordField.isSecureTextEntry)
        signInViewController.tooglePasswordAction(UIButton())
        XCTAssertTrue(signInViewController.passwordField.isSecureTextEntry)
    }
}
