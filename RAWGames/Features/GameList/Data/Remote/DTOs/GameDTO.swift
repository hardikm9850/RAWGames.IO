//
//  GameDTO.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//

import Foundation


struct GamesResponseDTO: Decodable {
    let count: Int
    let next: String?
    let results: [GameDTO]
}

struct GameDTO: Decodable {
    let id: Int
    let name: String
    let background_image: String?
    let rating: Double
    let released: String?
    let genres: [GenreDTO]?

    // Mapper — converts API shape to clean domain model
    func toDomain() -> Game {
        Game(
            id: id,
            name: name,
            backgroundImage: background_image,
            rating: rating,
            released: released
        )
    }
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}
