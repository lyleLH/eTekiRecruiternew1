//
//  MatchedInterviewsCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 05/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import Cosmos
class MatchedInterviewsCell: UITableViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var interviewerImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var bottomBorder: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        interviewerImage.layer.cornerRadius = interviewerImage.frame.size.width/2
        interviewerImage.clipsToBounds = true
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
