//
//  InterviewerProfileTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 10/12/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import Cosmos
class InterviewerProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var noOfInterviews: UILabel!
    @IBOutlet weak var completedInterviews: UILabel!
    @IBOutlet weak var cancelledInterviews: UILabel!
    @IBOutlet weak var noShowsCount: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var interviewsHeader: UILabel!
    @IBOutlet weak var completedHeader: UILabel!
    @IBOutlet weak var cancelledHeader: UILabel!
    @IBOutlet weak var noshowsHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
