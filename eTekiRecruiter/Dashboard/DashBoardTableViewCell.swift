//
//  DashBoardTableViewCell.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 18/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class DashBoardTableViewCell: UITableViewCell {
    
    
    var isCandidateAnimating = false
    @IBOutlet weak var addCandidateImageView: UIImageView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var closeImageView: UIImageView!

    @IBOutlet weak var closingDateLabel: UILabel!
    @IBOutlet weak var pendingCountLabel: UILabel!
    @IBOutlet weak var completedCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var jobTitlelabel: UILabel!
    
    @IBOutlet weak var candidateAvailabity: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var jobActionStackView: UIStackView!
    @IBOutlet weak var reactivateStackView: UIStackView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var closeJob: UIButton!
    @IBOutlet weak var addCandidateButton: UIButton!
    
    @IBOutlet weak var flagIconButton: UIButton!
    @IBOutlet weak var reactivateButton: UIButton!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var cellbackgroundView: UIView!
    @IBOutlet weak var candidateDetailsButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        cellbackgroundView.layer.borderWidth = 1.0
        cellbackgroundView.clipsToBounds = true
        cellbackgroundView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
        self.addCandidateButton.clipsToBounds = true
        self.completedCountLabel.text = "-"
        self.pendingCountLabel.text = "-"
        self.totalCountLabel.text = "-"
       // self.editJobButton.startBlink()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

