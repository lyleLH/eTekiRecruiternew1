//
//  DetailsTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 08/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var availibilityLabel: UILabel!
    
    @IBOutlet weak var candidateNameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var interViewerName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var documentButton: UIButton!
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var interviewerDesignation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
