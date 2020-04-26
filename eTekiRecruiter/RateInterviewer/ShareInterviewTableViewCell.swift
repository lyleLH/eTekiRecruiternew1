//
//  ShareInterviewTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 10/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class ShareInterviewTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var emailId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
