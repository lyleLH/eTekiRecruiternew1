//
//  SkillsCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 13/03/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import TagListView
import GrowingTextView

class SkillsCell: UITableViewCell {
    @IBOutlet weak var requiredSkillsField: UITextField!
    @IBOutlet weak var requiredSkillsListView: TagListView!
    @IBOutlet weak var optionalSkillsField: UITextField!
    @IBOutlet weak var optionalSkillsListView: TagListView!
    @IBOutlet weak var growingTextView: GrowingTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

