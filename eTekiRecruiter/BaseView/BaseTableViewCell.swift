//
//  BaseTableViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 03/02/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var viewSpinner : UIView?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BaseTableViewCell {
    
    func showSpinner() {
        
        if viewSpinner != nil {
            
        } else {
            let spinnerView = UIView(frame: self.contentView.frame)
            spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: .whiteLarge)
            ai.startAnimating()
            ai.center = spinnerView.center
            spinnerView.addSubview(ai)
            self.contentView.addSubview(spinnerView)
            self.contentView.bringSubviewToFront(spinnerView)
            viewSpinner = spinnerView
        }
     
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.viewSpinner?.removeFromSuperview()
            self.viewSpinner = nil
        }
    }
}
