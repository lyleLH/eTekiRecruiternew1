//
//  CodeTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 29/01/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import WebKit

class CodeTableViewCell: UITableViewCell {
    @IBOutlet weak var codeTitle: UILabel!
    @IBOutlet weak var codeDropdownImage: UIImageView!
    @IBOutlet weak var headerBottomBorder: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
