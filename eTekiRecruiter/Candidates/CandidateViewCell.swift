//
//  CandidateViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 22/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class CandidateViewCell: UITableViewCell {

    @IBOutlet weak var candiateNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var candidateProfileImage: UIImageView!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.candidateProfileImage.makeRounded()
        
        self.statusLabel.text = None
        self.candiateNameLabel.text = None
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
