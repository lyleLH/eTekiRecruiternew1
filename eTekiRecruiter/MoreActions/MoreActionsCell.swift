//
//  MoreActionsCell.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 22/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class MoreActionsCell: UITableViewCell {
    @IBOutlet weak var actionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
