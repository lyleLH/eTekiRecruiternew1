//
//  ContributorsCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 11/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

class ContributorsCell: UITableViewCell {
    
    @IBOutlet weak var viewBox: Checkbox!
    @IBOutlet weak var editBox: Checkbox!
    @IBOutlet weak var notifyBox: Checkbox!
    var isOpen = false
    
    @IBOutlet weak var recruiterNameLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var dropdownImage: UIImageView!
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var headerBorderLabel: UILabel!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var contributorsDetailsCell: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contributorImageView.layer.cornerRadius = contributorImageView.frame.size.height/2
        contributorImageView.layer.masksToBounds = true
        viewBox.isChecked = false
        editBox.isChecked = false
        notifyBox.isChecked = false
        self.viewBox.alpha = 1.0
        self.viewLabel.alpha = 1.0


        self.viewLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        self.editLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        self.notifyLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        self.setUpCheckbox()
        
    }
    
    func setUpCheckbox(){
        viewBox.borderLineWidth = 1
        viewBox.checkmarkStyle = .tick
        viewBox.checkmarkColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        viewBox.uncheckedBorderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.16)
        viewBox.checkedBorderColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        
        editBox.borderLineWidth = 1
        editBox.checkmarkStyle = .tick

        editBox.checkmarkColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        editBox.uncheckedBorderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.16)
        editBox.checkedBorderColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        
        notifyBox.borderLineWidth = 1
        notifyBox.checkmarkStyle = .tick
        notifyBox.checkmarkColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        notifyBox.uncheckedBorderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.16)
        notifyBox.checkedBorderColor = UIColor(red: 101.0/255.0, green: 168.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    }
    
    @IBAction func viewBoxAction(_ sender: Checkbox) {
        
        if !sender.isChecked {
            self.viewLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        } else {
            self.viewLabel.textColor = AppTheme.contributorPermissionsTextColor
        }
        
        NotificationCenter.default.post(name: Notification.Name("ViewBox"), object: sender, userInfo: ["Index":sender.tag])
    }
    
    @IBAction func editBoxAction(_ sender: Checkbox) {
        
        if !sender.isChecked {
            self.editLabel.textColor = AppTheme.contributorPermissionsUncheckColor
            self.viewBox.isUserInteractionEnabled = true
            self.viewBox.alpha = 1.0
            self.viewLabel.alpha = 1.0


        } else {
            self.editLabel.textColor = AppTheme.contributorPermissionsTextColor
            self.viewLabel.textColor = AppTheme.contributorPermissionsTextColor
            self.viewBox.isUserInteractionEnabled = false
            self.viewBox.alpha = 0.5
            self.viewLabel.alpha = 0.5
            self.viewBox.isChecked = true
        }
               
        NotificationCenter.default.post(name: Notification.Name("EditBox"), object: sender, userInfo: ["Index":sender.tag])
    }
    
    @IBAction func notifyBoxAction(_ sender: Checkbox) {
                
        if !sender.isChecked {
            self.notifyLabel.textColor = AppTheme.contributorPermissionsUncheckColor
        } else {
            self.notifyLabel.textColor = AppTheme.contributorPermissionsTextColor
        }
        NotificationCenter.default.post(name: Notification.Name("NotifyBox"), object: sender, userInfo: ["Index":sender.tag])
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
