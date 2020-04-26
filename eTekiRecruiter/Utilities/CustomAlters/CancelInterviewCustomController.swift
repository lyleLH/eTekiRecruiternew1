//
//  CancelInterviewCustomController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 13/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class CancelInterviewCustomController: BaseViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var customMessage: UILabel!
    var infoData = [String: Any]()
    var interviewId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = true
        self.customMessage.text = infoData["message"] as? String ?? ""
        if let id = infoData["id"] as? String {
           self.interviewId = id
        }
        yesButton.bold(size: 18.0)
        noButton.bold(size: 18.0)
        customMessage.light(size: 18.0)
        customTitle.bold(size: 18.0)
        noButton.titleLabel?.textColor = AppTheme.textColor
        // Do any additional setup after loading the view.
    }

    @IBAction func noAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func yesAction(_ sender: Any) {
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.cancelCustomToCancelInterview, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.cancelCustomToCancelInterview{
             let navVC = segue.destination as? UINavigationController
            if let cancelInterviewViewController = navVC?.viewControllers.first as? CancelInterviewViewController {
                cancelInterviewViewController.interviewID = self.interviewId
                cancelInterviewViewController.infoData = self.infoData
            }
        }
    }

}
