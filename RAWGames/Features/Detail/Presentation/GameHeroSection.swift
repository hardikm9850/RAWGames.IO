//
//  GameHeroSection.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//

import SwiftUI

struct GameHeroSection: View {
    let game: GameDetail
    
    var body: some View {
        ZStack {
            
            RemoteImageView(url: game.backgroundImage ?? "")
                .scaledToFill()
                .frame(height: 230)
                .clipped()
            
            LinearGradient(
                colors: [.clear, .black],
                startPoint: .center,
                endPoint: .bottom
            )
            
            
            VStack(alignment: .center, spacing: 8) {
                Spacer()
                
                Text(game.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}



#Preview {
    GameHeroSection(game: mockGame)
}

private let mockGame = GameDetail(
    id: 1,
    name: "Grand Theft Auto V1",
    description: "Open world action game",
    backgroundImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkbHvId-VCmkpZBUMLYuR2YLhS3CB76XHoRg&s",
    rating: 4.5,
    metacritic: 92,
    released: "2013-09-17",
    isFavourite: true,
    genres: ["Action", "Adventure"],
    platforms: ["PC", "PlayStation"],
    developers: ["Rockstar North"],
    publishers: ["Rockstar Games"],
    website: "www.google.com",
    playtime: 40
)
