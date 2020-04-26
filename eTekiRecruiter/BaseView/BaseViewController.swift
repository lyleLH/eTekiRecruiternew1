//
//  BaseViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 11/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import Reachability
import NotificationBannerSwift
import SideMenu
import Instabug


class BaseViewController: UIViewController, UITextFieldDelegate {
    
    var windowSpinner : UIView?
    var viewSpinner : UIView?
    
    lazy var backItem: Array = { () -> [UIBarButtonItem] in
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 12.0, width: 12.0, height: 20.5))
        imageView.image = UIImage(named: "Back")
        imageView.contentMode = .scaleAspectFit
        let back = UIButton(type: .custom)
        back.frame.size.width = 50.0
        back.frame.size.height = 44.0
        back.addTarget(self, action: #selector(clickOnBackBtn(_:)), for: .touchUpInside)
        customView.addSubview(imageView)
        customView.addSubview(back)
        let item = UIBarButtonItem(customView: customView)
        return [item]
    }()
    
    lazy var menuItem: Array = { () -> [UIBarButtonItem] in
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 13.0, width: 24.0, height: 16.8))
        imageView.image = UIImage(named: "menu")
        imageView.contentMode = .scaleAspectFit
        let menu = UIButton(type: .custom)
        menu.frame.size.width = 50.0
        menu.frame.size.height = 44.0
        menu.addTarget(self, action: #selector(clickOnMenuBtn(_:)), for: .touchUpInside)
        customView.addSubview(imageView)
        customView.addSubview(menu)
        let item = UIBarButtonItem(customView: customView)
        return [item]
    }()
    
    lazy var  notificationItem: Array = { () -> [UIBarButtonItem] in
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let imageView = UIImageView(frame: CGRect(x: 17.0, y: 12.5, width: 16.0, height: 19.0))
        imageView.image = UIImage(named: "help_icon")
        imageView.contentMode = .scaleAspectFit
        let notify = UIButton(type: .custom)
        notify.frame.size.width = 50.0
        notify.frame.size.height = 44.0
        notify.isEnabled = true
        notify.addTarget(self, action: #selector(clickOnNotifcationButton(_:)), for: .touchUpInside)
        imageView.alpha = 1.0
        notify.isUserInteractionEnabled = true
        customView.addSubview(imageView)
        customView.addSubview(notify)
        let item = UIBarButtonItem(customView: customView)
        return [item]
    }()
    
    @IBInspectable
    var navigationBar: Bool = false
    
    @IBInspectable
    var statusBar: Bool = false
    
    var authenticaionAPI: AuthenticationAPIProtocol.Type = AuthenticationApi.self
    var searchAPI: SearchAPIProtocol.Type = SearchAPI.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.modalPresentationStyle = .fullScreen
        viewSetup()
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setRightBarButtonItems(self.notificationItem, animated: true)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
       let attributes = [NSAttributedString.Key.font: UIFont(name: APPFonts.romanFont, size: 18.0)]
       UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]
    }
    
    func viewSetup() {
        self.view.backgroundColor = AppTheme.appBackgroundColor
        hideKeyboardWhenTappedAround()
    }
    
    override var prefersStatusBarHidden: Bool {
        return !statusBar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func isValidSocialLink(socialLink : String) -> Bool {
        let socialRegEx = "(https?://)([-a-z0-9]{1,63}\\.)*?[a-z0-9A-Z][-a-z0-9A-Z]{0,61}[a-z0-9A-Z]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let socialLinkEval = NSPredicate(format: "SELF MATCHES %@", argumentArray: [socialRegEx])
        return socialLinkEval.evaluate(with: socialLink)
    }
    
    //MARK: Update time zones from server.
    func updateTimeZones() {
        //self.showSpinner()
        self.searchAPI.getTimeZones { (response, errorResponse) in
            if errorResponse != nil {
                guard let message = errorResponse?.message else {return}
                self.handleErrorResponse(message: message)
            } else {
                
                guard let timezoneResponse = response else {
                    //self.removeSpinner()
                    return
                }
                
                if let timeZones = timezoneResponse["time_zones"] as? Array<Dictionary<String,String>> {
                    LocalCountry.timezoneList = timeZones
                } else {
                    //self.removeSpinner()
                    // self.showBanner(title: "", withMessage: "Unable to fetch timezones", style: .danger)
                }
            }
        }
    }
}

extension BaseViewController {
    
    func showSpinner() {
        
        if viewSpinner != nil {
            
        } else {
            let spinnerView = UIView(frame: self.view.frame)
            spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: .whiteLarge)
            ai.startAnimating()
            ai.center = spinnerView.center
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
            self.view.bringSubviewToFront(spinnerView)
            viewSpinner = spinnerView
        }
        
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.viewSpinner?.removeFromSuperview()
            self.viewSpinner = nil
        }
    }
}

extension BaseViewController {
    func  showErrorMessage(message : String, withTitle title : String, okButtonTitle : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okButtonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            /** What we write here???????? **/
            //  print("you pressed No, thanks button")
            self.removeSpinner()
            
            // call method whatever u need
        })
        alert.addAction(okButton)
        present(alert, animated: false, completion: nil)
    }
    
    func showBanner(title:String, withMessage message:String, style : BannerStyle) {
        if message == "" {
            return
        }
        let banner = GrowingNotificationBanner(title: "", subtitle: message, style: style)
        // banner.backgroundColor = AppTheme.brandColor
        banner.titleLabel?.light(size: 18.0)
        banner.show()
        banner.duration = 2.0
        banner.remove()
    }
    
    func changeCurrentDate(_ mydate:String,toFormat : String,fromFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat =  fromFormat// Formats.reverseDateFormat
        let convertedDate = dateFormatter.date(from: mydate)
        dateFormatter.dateFormat = toFormat
        let date = dateFormatter.string(from: convertedDate!)
        return date
    }
    
}

extension BaseViewController {
    
    @IBAction func revealMenuAction(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogout(notfication:)), name: Notification.Name("UserShouldLoggedOut"), object: nil)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuTableViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController ?? MenuTableViewController()

        print("Is Navigating from")
        print(self.navigationItem.title)

        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuTableViewController)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        leftMenuNavigationController.navigationBar.isHidden = true
        leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
        
        leftMenuNavigationController.presentationStyle = .viewSlideOutMenuPartialIn
        leftMenuNavigationController.statusBarEndAlpha = 0
        leftMenuNavigationController.leftSide = true
        
        present(leftMenuNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func userLogout(notfication: NSNotification) {
        
        generateEventLogToAnalytics(eventName: "Sign Out Event", status: "True")
        
        let token = UserDefaults.standard.value(forKey: "authentication_token") as? String ?? ""
        self.showSpinner()
        
        self.authenticaionAPI.logout(credentials: CredentialsManager(accessToken: token)) { (response, errorResponse) in
            
            DispatchQueue.main.async {
                if response?.success ?? false {
                    self.removeSpinner()
                    self.showBanner(title: "", withMessage: "User logged Out", style: .success )
                    UserDefaults.standard.set("", forKey: "authentication_token")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
                    UIApplication.shared.keyWindow?.rootViewController = signInViewController
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                } else {
                    DispatchQueue.main.async {
                        guard let message = errorResponse?.message else {return}
                        self.showBanner(title: "", withMessage: message, style: .danger)
                        self.removeSpinner()
                    }
                }
            }
            
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UserShouldLoggedOut"), object: nil)
        
        
    }
    
    func handleErrorResponse(message : String) {
        DispatchQueue.main.async {
            self.showBanner(title: "", withMessage: message, style: .danger)
            if message != ErrorHandler.tokenExpired {self.removeSpinner()}
        }
        if message == ErrorHandler.tokenExpired {
            self.showBanner(title: "", withMessage: "Session Expired, Please login again.", style: .danger)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                RequestBuilder.shared.resetToSignInOnTokenExpire()
                self.removeSpinner()
            })
        }
    }
    
}

extension BaseViewController {
    
    func convertUTCToLocalTimeZone(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale.current
            if let result = UserDefaults.standard.value(forKey: "RecruiterTimeZone") as? Dictionary<String, String> {
                dateFormatter.timeZone = TimeZone(identifier: result.keys.first ?? "")
            }
            dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
            return dateFormatter.string(from: dt)
        } else {
            return "N/A"
        }
    }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
        // dateFormatter.calendar = NSCalendar.current
        
        if let result = UserDefaults.standard.value(forKey: "RecruiterTimeZone") as? Dictionary<String, String> {
            dateFormatter.timeZone = TimeZone(identifier: result.keys.first ?? "")
        }
        
        let dt = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        
        return dateFormatter.string(from: dt)
    }
    
    func localToUTC(date:String,withFormat format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // dateFormatter.calendar = NSCalendar.current
        
        if let result = UserDefaults.standard.value(forKey: "RecruiterTimeZone") as? Dictionary<String, String> {
            dateFormatter.timeZone = TimeZone(identifier: result.keys.first ?? "")
        }
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        
        return dateFormatter.string(from: dt!)
    }
    
    func convertUTCToLocalTimeZone(date: String,withTimeZone zone : TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = zone
            dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
            return dateFormatter.string(from: dt)
        } else {
            return "Unknown date"
        }
    }
    
    func localToUTC(date:String, withTimeZone zone : TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
        // dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = zone
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        
        return dateFormatter.string(from: dt!)
    }
    
}

extension BaseViewController {
    
    @objc func clickOnBackBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func clickOnMenuBtn(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogout(notfication:)), name: Notification.Name("UserShouldLoggedOut"), object: nil)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuTableViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController ?? MenuTableViewController()

        if let title = self.navigationItem.title {
            menuTableViewController.isNavigatingFrom = title
        }

        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuTableViewController)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        leftMenuNavigationController.navigationBar.isHidden = true
        leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
        
        leftMenuNavigationController.presentationStyle = .viewSlideOutMenuPartialIn
        leftMenuNavigationController.statusBarEndAlpha = 0
        leftMenuNavigationController.leftSide = true
        
        present(leftMenuNavigationController, animated: true, completion: nil)
    }
    
    @objc func clickOnNotifcationButton(_ sender: Any) {
        print("Notification called")
        Instabug.show()
    }
    
    //MARK: To hide notification button in navigation
    func hideNotificationButton()  {
        print("hide alert Button function called")
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
    }
    
}
