//
//  AnalyticsViewController.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 06/11/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import UIKit
import JZCalendarWeekView

// If you want to use Move Type LongPressWeekView, you have to inherit from JZLongPressEventCell and update event when you configure cell every time
class LongPressEventCell: JZLongPressEventCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBasic()
        // You have to set the background color in contentView instead of cell background color, because cell reuse problems in collectionview
        // When setting alpha to cell, the alpha will back to 1 when collectionview scrolled, which means that moving cell will not be translucent
        self.contentView.backgroundColor = AppTheme.appBackgroundColor//UIColor(hex: 0xEEF7FF)
    }

    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
    }

    func configureCell(event: AllDayEvent, isAllDay: Bool = false) {
        self.event = event
        titleLabel.text = event.title
        titleLabel.light(size: 12)
    }

}
