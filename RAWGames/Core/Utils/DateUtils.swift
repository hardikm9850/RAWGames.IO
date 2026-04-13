//
//  DateUtils.swift
//  RAWGames
//
//  Created by Hardik Mehta on 12/04/26.
//

import Foundation

func formattedDate(_ date: String?) -> String {
    guard let date else { return "-" }
    
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.calendar = Calendar(identifier: .gregorian)
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    if let d = inputFormatter.date(from: date) {
        let outputFormatter = DateFormatter()
        outputFormatter.locale = .current
        outputFormatter.calendar = Calendar(identifier: .gregorian)
        outputFormatter.timeZone = .current
        outputFormatter.dateFormat = "MMM d, yyyy"
        return outputFormatter.string(from: d)
    }
    return date
}
