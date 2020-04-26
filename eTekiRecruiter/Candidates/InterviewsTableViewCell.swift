//
//  InterviewsTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 06/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class InterviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var interViewDesination: UILabel!
    @IBOutlet weak var interviewer: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var availibilityLabek: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
