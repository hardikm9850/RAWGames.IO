//
//  DateUtils.swift
//  RAWGames
//
//  Created by Hardik Mehta on 12/04/26.
//

import Foundation

func formattedDate(_ date: String?) -> String {
    guard let date else { return "-" }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    if let d = formatter.date(from: date) {
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: d)
    }
    
    return date
}
