//
//  JobDetailsCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 07/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class JobDetailsCell: UITableViewCell {

    @IBOutlet weak var detailsKey: UILabel!
    @IBOutlet weak var detailsValues: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
