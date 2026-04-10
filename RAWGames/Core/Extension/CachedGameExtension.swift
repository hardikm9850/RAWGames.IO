//
//  CachedGameExtension.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//
import Foundation

extension CachedGame {
    func mapToGame() -> Game {
        return Game(
            id: Int(self.id),
            name: self.name ?? "",
            backgroundImage: self.image,
            rating: self.rating,
            released: self.released
        )
    }
    
    func mapToGameDetail() -> GameDetail {
        return GameDetail(
            id: Int(self.id),
            name: name ?? "",
            description: desc ?? "",
            backgroundImage: image,
            rating: rating,
            metacritic: Int(metacritic),
            released: released,
            isFavourite: false,
            genres: genres?.components(separatedBy: ",") ?? [],
            platforms: platforms?.components(separatedBy: ",") ?? [],
            developers: developers?.components(separatedBy: ",") ?? [],
            publishers: publishers?.components(separatedBy: ",") ?? [],
            website: website ?? "",
            playtime: Int(playtime)
        )
    }
}


