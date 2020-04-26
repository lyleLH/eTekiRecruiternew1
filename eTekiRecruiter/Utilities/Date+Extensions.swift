//
//  Date+Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 30/10/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}

extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { return localizedDescription() }
}

extension Date {
    var fullDate:  String { return localizedDescription(dateStyle: .full, timeStyle: .none)  }
    var shortDate: String { return localizedDescription(dateStyle: .short, timeStyle: .none)  }
    var fullTime:  String { return localizedDescription(dateStyle: .none, timeStyle: .full)  }
    var shortTime: String { return localizedDescription(dateStyle: .none, timeStyle: .short)   }
    var fullDateTime:  String { return localizedDescription(dateStyle: .full, timeStyle: .full)  }
    var shortDateTime: String { return localizedDescription(dateStyle: .short, timeStyle: .short)  }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Date {

    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }

    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }

    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }

    func toString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func toStringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Formats.dateWithTimeZone
        let convertedDate = formatter.string(from: date)
        formatter.dateFormat = Formats.date_timeFormat
        let myDate = formatter.date(from: convertedDate) ?? Date()
        return formatter.string(from: myDate)
    }
}

//Date().string(format: "EEEE, MMM d, yyyy") // Saturday, Oct 21, 2017
//Date().string(format: "MM/dd/yyyy")        // 10/21/2017
//Date().string(format: "MM-dd-yyyy HH:mm")  // 10-21-2017 03:31
//2/6/20, 12:33 PM

//Date().string(format: "MMM d, h:mm a")     // Oct 21, 3:31 AM
//Date().string(format: "MMMM yyyy")         // October 2017
//Date().string(format: "MMM d, yyyy")       // Oct 21, 2017
//
//Date().string(format: "E, d MMM yyyy HH:mm:ss Z") // Sat, 21 Oct 2017 03:31:40 +0000
//Date().string(format: "yyyy-MM-dd'T'HH:mm:ssZ")   // 2017-10-21T03:31:40+0000
//Date().string(format: "dd.MM.yy")
