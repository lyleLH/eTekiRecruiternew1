//
//  PaymentViewController.swift
//  eTekiRecuiter
//
//  Created by Siva Sagar Palakurthy on 15/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItems(self.menuItem, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarColor(color: AppTheme.statusBarDefaultColor)
    }

}
