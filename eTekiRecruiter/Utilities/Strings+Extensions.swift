//
//  Strings+Extensions.swift
//  eTekiRecruiter
//
//  Created by Siva Sagar Palakurthy on 19/09/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import Foundation

extension String {
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
}

extension String {
    func changeDate(_ mydate:String) -> String {

        if mydate != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.dateFormat = Formats.reverseDateFormat
            guard let convertedDate = dateFormatter.date(from: mydate) else {return ""}
            dateFormatter.dateFormat = Formats.dateFormat
            let date = dateFormatter.string(from: convertedDate)
            return date
        } else {
            return ""
        }
    }

    func changeCurrentDate(_ mydate:String) -> String {

        if mydate != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.dateFormat = Formats.reverseDateFormat
            guard let convertedDate = dateFormatter.date(from: mydate) else {return ""}
            dateFormatter.dateFormat = Formats.dateFormat_withoutMonth
            let date = dateFormatter.string(from: convertedDate)
            return date
        } else {
            return ""
        }
    }

    func getDateFromDate(_ mydate:String, fromFormat : String, ToFormat : String) -> String {

        if mydate != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.dateFormat = fromFormat
            guard let convertedDate = dateFormatter.date(from: mydate) else {return ""}
            dateFormatter.dateFormat = ToFormat
            let date = dateFormatter.string(from: convertedDate)
            return date
        } else {
            return ""
        }
    }


    func toDate(withFormat format: String = Formats.dateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        if self != "" {
            guard let date = dateFormatter.date(from: self) else {
                preconditionFailure("Take a look to your format")
            }
            return date
        }

        return Date()
    }

    func toDateGeneric(withFormat format: String = "dd-MMMM-yyyy hh:mm a") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format


        if self != "" {
            guard let date = dateFormatter.date(from: self) else {
                preconditionFailure("Take a look to your format")
            }
            return date
        }

        return Date()
    }

    func toDateAndTime(withFormat format: String = Formats.dateMonthAndTimeFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        print(self)

        if self != "" {
            guard let date = dateFormatter.date(from: self) else {
                preconditionFailure("Take a look to your format")
            }
            return date
        }
        return Date()
    }
}
