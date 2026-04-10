//
//  GameStatsSection.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//

import SwiftUI

struct GameStatsSection: View {
    let game: GameDetail
    
    var body: some View {
        HStack(spacing: 0) {
            
            StatItem(
                icon: "star.fill",
                title: "Reviews",
                value: "\(game.rating)"
            )
            
            StatItem(
                icon: "calendar",
                title: "Released",
                value: formattedDate(game.released)
            )
            
            StatItem(
                icon: "clock",
                title: "Game time",
                value: "\(game.playtime) Hours"
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            
            Image(systemName: icon)
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.footnote)
                
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

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
