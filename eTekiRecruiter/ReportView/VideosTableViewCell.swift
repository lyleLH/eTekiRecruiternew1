//
//  VideosTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 27/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class VideosTableViewCell: UITableViewCell {

    @IBOutlet weak var cellbackgroundView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        cellbackgroundView.layer.borderWidth = 1.0
        cellbackgroundView.clipsToBounds = true
        cellbackgroundView.layer.borderColor = AppTheme.fieldsBorderColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
