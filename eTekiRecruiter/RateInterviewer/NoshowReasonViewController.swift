//
//  NoshowReasonViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 23/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class NoshowReasonViewController: BaseViewController {

    @IBOutlet weak var reasonLabel: UILabel!
     @IBOutlet weak var reasonTitle: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var reason = ""
    var isNavigatingFrom = ""
    var report_status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
        view.isOpaque = true
        print(self.isNavigatingFrom)
        reasonLabel.light(size: 18)
        reasonTitle.bold(size: 18)
        cancelButton.bold(size: 18)
        if self.isNavigatingFrom == RevertReport.revert {
            self.reasonTitle.text = "Quality Control Inprogress"
            if report_status == RevertReport.requestEditsRecruiter {
                self.reasonLabel.text = RevertReport.requestEditsRecruiterMessage
            } else if report_status == RevertReport.requestEditsAdmin{
                self.reasonLabel.text = RevertReport.requesEditAdminMessage
            } else if report_status == RevertReport.pendingAdminApproval {
                self.reasonLabel.text = RevertReport.pendingAdminApprovalMessage
            }
            self.reasonLabel.textAlignment = .center
        } else {
            self.reasonTitle.text = "No Show Reason"
            self.reasonLabel.text = reason
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if isNavigatingFrom == RevertReport.revert {
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        } else {
            self.dismiss(animated: false, completion: nil)
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
