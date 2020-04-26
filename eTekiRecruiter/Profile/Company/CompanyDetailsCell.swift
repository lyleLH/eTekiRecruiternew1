//
//  CompanyDetailsCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class CompanyDetailsCell: UITableViewCell {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
