//
//  FavouriteGame+Mapping.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


extension FavouriteGame {
    var asGame: Game {
        Game(
            id: Int(id),
            name: name ?? "",
            backgroundImage: image,
            rating: rating,
            released: nil   // FavouriteGame doesn't store release date
        )
    }
}
