//
//  MenuTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 07/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuTitleLabel: PaddingLabel!
    @IBOutlet weak var iConView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
