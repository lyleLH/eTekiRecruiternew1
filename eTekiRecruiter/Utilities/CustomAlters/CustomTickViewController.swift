//
//  CustomTickViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 12/08/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class CustomTickViewController: UIViewController {

    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var message = ""
    var isSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContentView()
        setCircleView()
    }
    
    func setUpContentView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = AppTheme.containerBorderColor.cgColor
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true

        messageLabel.text = message
        messageLabel.light(size: 18.0)
    }
    
    func setCircleView() {
        tickImageView.layer.borderWidth = 3.0
        tickImageView.layer.masksToBounds = false
        tickImageView.layer.borderColor = UIColor.white.cgColor
        tickImageView.layer.cornerRadius = tickImageView.frame.size.width / 2
        tickImageView.clipsToBounds = true
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    

}
