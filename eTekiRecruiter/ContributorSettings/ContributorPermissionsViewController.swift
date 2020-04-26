//
//  ContributorPermissionsViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 18/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

class ContributorPermissionsViewController: BaseViewController {
    
    
    @IBOutlet weak var jobViewCheckbox: Checkbox!
    @IBOutlet weak var jobEditCheckBox: Checkbox!
    @IBOutlet weak var jobNotifyCheckbox: Checkbox!
    @IBOutlet weak var candidateViewCheckbox: Checkbox!
    @IBOutlet weak var candidateEditCheckbox: Checkbox!
    @IBOutlet weak var candidateNotifyCheckbox: Checkbox!
    @IBOutlet weak var interviewViewCheckbox: Checkbox!
    @IBOutlet weak var interviewEditCheckbox: Checkbox!
    @IBOutlet weak var interViewNotifyCheckbox: Checkbox!
    var jobPermissions = [:] as Dictionary<String, Any>
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.57)
       view.isOpaque = true
        self.setUpCheckbox(checkBox: jobViewCheckbox)
        self.setUpCheckbox(checkBox: jobEditCheckBox)
        self.setUpCheckbox(checkBox: jobNotifyCheckbox)
        self.setUpCheckbox(checkBox: candidateViewCheckbox)
        self.setUpCheckbox(checkBox: candidateEditCheckbox)
        self.setUpCheckbox(checkBox: candidateNotifyCheckbox)
        self.setUpCheckbox(checkBox: interviewViewCheckbox)
        self.setUpCheckbox(checkBox: interviewEditCheckbox)
        self.setUpCheckbox(checkBox: interViewNotifyCheckbox)
        getContributorPermissions()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
         self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    func setUpCheckbox(checkBox : Checkbox){
        checkBox.borderLineWidth = 1
        checkBox.checkmarkStyle = .tick
        checkBox.isUserInteractionEnabled = false
        checkBox.checkmarkColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        checkBox.uncheckedBorderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.16)
        checkBox.checkedBorderColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    }
    
    func getContributorPermissions(){
        if(jobPermissions[ContributorKeys.candidateEdit] as? Int == 1){
            self.candidateEditCheckbox.isChecked = true
            self.candidateViewCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.candidateNotify]  as? Int == 1){
            self.candidateNotifyCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.candidateView] as? Int == 1){
            self.candidateViewCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.interviewEdit] as? Int == 1){
            self.interviewEditCheckbox.isChecked = true
            self.interviewViewCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.interViewNotify] as? Int == 1){
            self.interViewNotifyCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.interviewView] as? Int == 1){
            self.interviewViewCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.jobEdit] as? Int == 1){
            self.jobEditCheckBox.isChecked = true
            self.jobViewCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.jobNotify] as? Int == 1){
            self.jobNotifyCheckbox.isChecked = true
        }
        
        if(jobPermissions[ContributorKeys.jobView] as? Int == 1){
            self.jobViewCheckbox.isChecked = true
        }
    }
}
