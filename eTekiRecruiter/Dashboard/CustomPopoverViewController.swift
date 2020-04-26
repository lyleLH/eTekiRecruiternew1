//
//  CustomPopoverViewController.swift
//  eTekiRecruiter
//
//  Created by Afreen Shaik on 15/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class CustomPopoverViewController: BaseViewController {

    @IBOutlet weak var ownerNameLabel: UILabel!
    var contriutorLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        ownerNameLabel.text = contriutorLabel
        ownerNameLabel.bold(size: 16.0)
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // your code here
            self.dismiss(animated: true, completion: nil)
        }
    }
}
