//
//  CachedGame+Mapping.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//

import Foundation

extension CachedGame {
    var asGame: Game {
        Game(
            id: Int(id),
            name: name ?? "",
            backgroundImage: image,
            rating: rating,
            released: released
        )
    }
}
