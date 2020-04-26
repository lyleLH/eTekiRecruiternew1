//
//  SkillsTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 28/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import Cosmos

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionBorderLabel: UILabel!
    @IBOutlet weak var automationLabel: UILabel!
    @IBOutlet weak var experienceRatingView: CosmosView!
    @IBOutlet weak var competancyRatingView: CosmosView!
    @IBOutlet weak var skillsDetailsView: UIView!
    @IBOutlet weak var skillsTitle: UILabel!
    @IBOutlet weak var skillsDropdownImage: UIImageView!
    @IBOutlet weak var cellBorderLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var competancyLabel: UILabel!
    @IBOutlet weak var skillNameLabel: UILabel!
    var isOpen = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
