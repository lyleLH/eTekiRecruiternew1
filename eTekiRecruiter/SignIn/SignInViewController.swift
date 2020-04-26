//
//  SignInViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 15/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import FBSDKLoginKit
import Amplitude

class SignInViewController: BaseViewController, SignInModelDelegate {
    
    @IBOutlet weak var showPasswordIcon: UIImageView!
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet var contentView: UIView!
    /*! @brief This property contains SignIn Fields Stack. */
    @IBOutlet weak var signInContainerView: UIView!
    @IBOutlet weak var signInBackgroundScrollView: UIScrollView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var resendEmailConfirmationButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var socialLoginContainer: UIView!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    var viewModel = SignInViewModel()
    
    private var _fbLoginManager: LoginManager?
    
    var fbLoginManager: LoginManager {
        get {
            if _fbLoginManager == nil {
                _fbLoginManager = LoginManager()
                
            }
            return _fbLoginManager!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setUpView()
        emailTextField.borderStyle = .none
        passwordField.borderStyle = .none

        self.emailTextField.light(size: 18.0)
        self.passwordField.light(size: 18.0)
        self.signInButton.bold(size: 20.0)
        self.forgotPasswordButton.light(size: 14.0)
        self.resendEmailConfirmationButton.light(size: 14.0)
        self.orLabel.roman(size: 14.0)

        appDelegate.onFirstLaunch = true
        self.showPasswordIcon.alpha = 0.5

    }
    
    /*! @brief This function Customize the SignIn Fields Stack View*/
    
    func setUpView() {
        signInContainerView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        signInContainerView.clipsToBounds = true
        signInContainerView.layer.borderWidth = 1
        signInContainerView.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 1
        
        socialLoginContainer.layer.borderColor = AppTheme.containerBorderColor.cgColor
        socialLoginContainer.layer.borderWidth = 1
        socialLoginContainer.layer.cornerRadius = 5
        socialLoginContainer.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        signInBackgroundScrollView.contentSize = CGSize(width: view.frame.size.width, height: contentView.frame.size.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fbLogOut()
        linkedInLogOut()
    }
    
    func bindViewModel() {
        viewModel.emailTextField = self.emailTextField
        viewModel.passwordTextField = self.passwordField
        viewModel.delegate = self
        self.viewModel.addImagesToTextFields()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /*! @brief This function calls before view performs the Navigation to other Screens */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == StoryboardIdentifiers.signInSegue {
            DispatchQueue.main.async {
                self.showSpinner()
            }
            let result = viewModel.shouldValidateCredentials()
            if result.0 {
                return false
            } else {
                showBanner(title: "", withMessage: result.1, style: .warning)
                removeSpinner()
                return result.0
            }
        } else if identifier == StoryboardSegueIdentifiers.loginToForgotPasswordSegue {
            return true
        } else if identifier == StoryboardSegueIdentifiers.loginToResendConfirmation {
            return true
        } else if identifier == StoryboardSegueIdentifiers.facebookToDashboard {
            DispatchQueue.main.async {
                self.showSpinner()
                self.fbLogOut()
                self.callFacebookAction()
            }
            return false
            
        } else if identifier ==  StoryboardIdentifiers.signInToLinkedInWebView {

            self.showSpinner()
            NotificationCenter.default.addObserver(self, selector: #selector(parseLinkedInResponse(notfication:)), name: Notification.Name("LinkedInProfileResponse"), object: nil)

            return true
        }
        return false
    }
    
    @IBAction func tooglePasswordAction(_ sender: UIButton) {
        
        self.passwordField.isSecureTextEntry = !self.passwordField.isSecureTextEntry
        if self.passwordField.isSecureTextEntry {
            self.showPasswordIcon.image = UIImage(named: "password_show")
        } else {
            self.showPasswordIcon.image = UIImage(named: "password_hide")
        }
    }
    
    func navigateToDashBoard() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dashboardViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardNavigationController") as! UINavigationController
        //dashboardViewController.navigationController?.isNavigationBarHidden = false
        UIApplication.topViewController()?.present(dashboardViewController, animated: false, completion: nil)
    }
    
    func callFacebookAction() {
        
        fbLoginManager.loginBehavior = LoginBehavior.browser
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if let isCancelled = result?.isCancelled {
                if isCancelled {
                    self.fbLogOut()
                    
                    DispatchQueue.main.async {
                        self.removeSpinner()
                    }
                    
                    print("User has cancelled the facebook login process")
                    return
                }
            }
            
            if (error==nil) {
                if result?.grantedPermissions != nil {
                    
                    self.callFacebookGraphRequest()
                    
                } else {
                    self.fbLogOut()
                }
            } else {
                self.fbLogOut()
            }
        }
    }
    
    func fbLogOut() {
        self.fbLoginManager.logOut()
        self._fbLoginManager = nil
        removeCookies()
    }
    
    func linkedInLogOut() {
        removeCookies()
    }
    
    func removeCookies(){
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    func callFacebookGraphRequest() {
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {(connection, result, error) -> Void in
            
            if error == nil {
                //print(json)
                if let dictFromJSON = result as? [String:Any] {
                    var socialSignInResponse = SocialSignInResponse(json: dictFromJSON, success: true)
                    socialSignInResponse.provider = "facebook"
                    self.viewModel.callOathLogingAPI(socialSignInResponse: socialSignInResponse)
                }
                
            } else {
                
                self.showBanner(title: "", withMessage: error?.localizedDescription ?? "Facebook API Error", style: .danger)
            }
        })
    }
}

extension SignInViewController {
    
    /**
     onSignInResponse is Delegate to handle SignIn Response from Server.
     
     - Parameter response: - Success response of Authentication API and Navigates to Dashboard
     
     - Returns: Void.
     */
    
    func onSignInResponse(response: SignInResponse?) {
        

                     var userLoginDetailsDict = [String:String]()
        generateEventLogToAnalytics(eventName: "testing Event", status: "True")
//                     let amplitudeInstance = Amplitude()
//                     amplitudeInstance.initializeApiKey("e3b77be60e7267be70c74f7e26876569")
//
//                    amplitudeInstance.setUserProperties(userLoginDetailsDict)
//                    //amplitudeInstance.logEvent("Creating Job Event")
//                    userLoginDetailsDict["user type"] = response?.userDetails?.role ?? ""
//                    userLoginDetailsDict["user name"] = response?.userDetails?.displayName ?? ""
//                    amplitudeInstance.logEvent("Login Event", withEventProperties: userLoginDetailsDict)
//
//        
//                    amplitudeInstance.uploadEvents()
//
//                    amplitudeInstance.printEventsCount()
        DispatchQueue.main.async {
            self.removeSpinner()


            self.performSegue(withIdentifier: StoryboardIdentifiers.signInSegue, sender: self)
        }
    }
    
    /**
     onAPIException is Delegate to handle API exception Response from Server.
     
     - Parameter response: - Handles response from Authentication API and updates the UI
     
     - Returns: Void.
     */
    
    func onAPIException(errorResponse: ErrorResponse?) {
        
        guard let message = errorResponse?.message else {return}
        DispatchQueue.main.async {
            self.removeSpinner()
            self.fbLogOut()
            self.showBanner(title: "", withMessage: message, style: .danger)
        }
        
        if message == ErrorHandler.tokenExpired {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                RequestBuilder.shared.resetToSignInOnTokenExpire()
            })
        }
    }
    
    /**
     onOAuthLoginResponse is Delegate to handle API exception Response from Server in OAthLogingProcess.
     
     - Parameter response: - Handles response from Authentication API and updates the UI
     
     - Returns: Void.
     */
    
    func onOAuthLoginResponse(response: OAuthLoginResponse?) {
                    
        DispatchQueue.main.async {
            self.removeSpinner()
            self.navigateToDashBoard()
        }
    }
    
}

extension SignInViewController {
    /**
     Gets LinkedIn Reponse and makes server call
     
     - Parameter response : Response from LinkedIn Profile API.
     
     - Throws: Handles API exception from LinkedIn iOS SDK.
     
     - Returns: Void.
     */

    func updateLinkedInResponse(response : [String : Any]?, email : String) {

        if let dictFromJSON = response {
            var linkedInSignInResponse = SocialSignInResponse(json: dictFromJSON, success: true)
            linkedInSignInResponse.provider = "linkedin"
            linkedInSignInResponse.uID = dictFromJSON["id"] as? String ?? ""
            linkedInSignInResponse.emailID = email
            self.viewModel.callOathLogingAPI(socialSignInResponse: linkedInSignInResponse)

        } else {
            self.onAPIException(errorResponse: ErrorResponse(responseCode: 0, message: "Unable to Get Data from LinkedIn", tittle: ""))
        }

    }

    @objc func parseLinkedInResponse(notfication: NSNotification) {

        if let info = notfication.userInfo as? [String : Any] {
                // Check if value present before using it

                if let response = info["LinkedInResponse"] as? [String : Any] {

                    let email = info["email"] as? String ?? ""
                    self.updateLinkedInResponse(response: response, email: email)

                }
            }

          NotificationCenter.default.removeObserver(self, name: Notification.Name("LinkedInProfileResponse"), object: nil)
      }
    
}


