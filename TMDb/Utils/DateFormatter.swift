//
//  DateFormatter.swift
//  TMDb
//
//  Created by Krutika on 2022-05-09.
//

import Foundation
struct DateFormatterHelper {
    // convert string to date
    static func toDate(_ dateString: String) -> Date? {
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "yyyy-mm-dd"
        let date = dateFormater.date(from: dateString)
        return date

    }
    // convert date to string
    static func shortDateFormat(_ date: Date?) -> String{
            // Create Date Formatter
        let dateFormatter = DateFormatter()

            // Set Date/Time Style
        dateFormatter.dateStyle = .medium
      
            // Convert Date to String
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
