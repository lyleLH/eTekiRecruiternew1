//
//  AppDelegate.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 10/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import IQKeyboardManagerSwift
import AWSS3
import Instabug
import Amplitude


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait

    var onFirstLaunch = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let amplitudeInstance = Amplitude()
        amplitudeInstance.trackingSessionEvents = true
        amplitudeInstance.initializeApiKey("e3b77be60e7267be70c74f7e26876569")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        AWSManager.shared.regiesterUitilty()

        Instabug.start(withToken: "5fefb25a1b94c139b1b8c23852c865a4", invocationEvents: [.shake, .screenshot , .twoFingersSwipeLeft])

        CrashReporting.enabled = true

        self.setupGlobalAppearance()

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let token = UserDefaults.standard.value(forKey: "authentication_token") as? String ?? ""
        if token != "" {

            onFirstLaunch = false
            
            if let dashboardViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIdentifiers.dashboardViewController) as? DashboardViewController {
                           let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "DashboardNavigationController") as? UINavigationController ?? UINavigationController()
                           nvc.viewControllers = [dashboardViewController]
                           window?.rootViewController = nvc
                           window?.makeKeyAndVisible()
            }
        } else {

            onFirstLaunch = true

            if let signInViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIdentifiers.signInViewController) as? SignInViewController {
                let nvc:UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "SignInNavigationController") as? UINavigationController ?? UINavigationController()
                nvc.viewControllers = [signInViewController]
                window?.rootViewController = nvc
                window?.makeKeyAndVisible()
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        //  Will print the identifer you have set at the enum: .CALLBACK_KEY
        print("Identifier: " + identifier)
        //  Stores the completion handler.
        AWSS3TransferUtility.interceptApplication(application,
                                                  handleEventsForBackgroundURLSession: identifier,
                                                  completionHandler: completionHandler)
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "eTekiRecuiter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }

    func setupGlobalAppearance(){

       //global Appearance settings

       // UILabel.appearance().substituteFontName = APPFonts.lightFont

        UITextField.appearance().substituteFontName = APPFonts.lightFont

     }


}



