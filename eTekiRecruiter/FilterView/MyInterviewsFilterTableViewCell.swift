//
//  MyInterviewsFilterTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 30/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import SimpleCheckbox
class MyInterviewsFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dropdownImageButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var filterCheckBox: Checkbox!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var headerBoderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
