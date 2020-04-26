//
//  AnalyticsViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 06/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//
import UIKit
import JZCalendarWeekView

class EventCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    var event: DefaultEvent!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBasic()
    }

    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        self.backgroundColor = UIColor(hex: 0xEEF7FF)
        borderView.backgroundColor = UIColor(hex: 0x0899FF)
    }

    func configureCell(event: DefaultEvent) {
        self.event = event
        print("============configureCell=====")
        titleLabel.text = event.title
    }

}
