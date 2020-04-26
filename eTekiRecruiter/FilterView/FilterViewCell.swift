//
//  FilterViewCell.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 17/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

class FilterViewCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var checkIcon: UIButton!
    @IBOutlet weak var checkBoxView: Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        checkBoxView.borderLineWidth = 1
        checkBoxView.layer.cornerRadius = 5
        checkBoxView.checkmarkStyle = .tick
        checkBoxView.checkmarkColor = AppTheme.textColor
        checkBoxView.uncheckedBorderColor = AppTheme.fieldsBorderColor
        checkBoxView.checkedBorderColor = AppTheme.fieldsBorderColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
