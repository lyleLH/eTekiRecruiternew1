//
//  CancellationConfirmedViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 20/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class CancellationConfirmedViewController: BaseViewController {

    var infoData : Dictionary<String, Any> = [:]
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var withdrawnButton: UIButton!
    var isNavigatingFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isNavigatingFrom == StoryboardSegueIdentifiers.customAlertToCancelInterview) {
         view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
         view.isOpaque = true
        } else {
         view.backgroundColor = .clear
        }
        headerLabel.bold(size: 18)
        contentLabel.light(size: 20)
        rescheduleButton.bold(size: 18)
        withdrawnButton.bold(size: 18)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("MyInterviewsRefreshDashboard"), object: nil)
        if(isNavigatingFrom == StoryboardSegueIdentifiers.customAlertToCancelInterview) {
          self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }else {
          self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func rescheduleAction(_ sender: Any) {
      
    }
    
    @IBAction func withdrawAction(_ sender: Any) {
        self.performSegue(withIdentifier: StoryboardSegueIdentifiers.cancelConfirmToWithdrawn, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegueIdentifiers.cancelConfirmToWithdrawn {
            if let navVc = segue.destination as? WithDrawnViewController {
                if(self.isNavigatingFrom == StoryboardSegueIdentifiers.customAlertToCancelInterview) {
                    navVc.isNavigatingFrom = self.isNavigatingFrom
                } else {
                   navVc.isNavigatingFrom = "cancelConfirmed"
                }
                if let id  =  infoData["candidate_id"] as? Int{
                  navVc.candidateId = "\(id)"
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
