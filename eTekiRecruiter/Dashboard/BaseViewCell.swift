//
//  BaseViewCell.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 03/03/20.
//  Copyright © 2020 amzurtech. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class BaseViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BaseViewCell {

    func convertUTCToLocalTimeZone(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale.current
            if let result = UserDefaults.standard.value(forKey: "RecruiterTimeZone") as? Dictionary<String, String> {
                dateFormatter.timeZone = TimeZone(identifier: result.keys.first ?? "")
            }
            dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
            return dateFormatter.string(from: dt)
        } else {
            return "N/A"
        }
    }

    func showBanner(title:String, withMessage message:String, style : BannerStyle) {
        if message == "" {
            return
        }
        let banner = GrowingNotificationBanner(title: "", subtitle: message, style: style)
        // banner.backgroundColor = AppTheme.brandColor
        banner.titleLabel?.light(size: 18.0)
        banner.show()
        banner.duration = 2.0
        banner.remove()
    }
}
