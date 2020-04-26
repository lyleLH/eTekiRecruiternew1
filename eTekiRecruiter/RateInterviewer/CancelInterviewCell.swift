//
//  CancelInterviewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 17/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox

class CancelInterviewCell: UITableViewCell {

    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var dropdownImage: UIImageView!
    @IBOutlet weak var dropdownButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
