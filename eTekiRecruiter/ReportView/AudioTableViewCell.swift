//
//  AudioTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 30/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var cellbackgroundView: UIView!
    @IBOutlet weak var audioLabel: UILabel!
    
    override func prepareForReuse() {
    }
    
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
    }
}
