//
//  FeedbackTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 10/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var candidateName: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
