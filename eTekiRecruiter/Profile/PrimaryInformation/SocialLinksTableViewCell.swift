//
//  SocialLinksTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 10/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class SocialLinksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var socialLinkField: UITextField!
    @IBOutlet weak var socialLinkIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
