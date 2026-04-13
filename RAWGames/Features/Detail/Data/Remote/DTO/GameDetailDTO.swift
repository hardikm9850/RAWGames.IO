//
//  GameDetailDTO.swift
//  RAWGames
//
//  Created by Hardik Mehta on 08/04/26.
//


struct GameDetailDTO: Decodable {
    let id: Int
    let name: String
    let description_raw: String
    let background_image: String?
    let rating: Double
    let metacritic: Int?
    let released: String?
    let website: String
    let playtime: Int
    let genres: [GenreDTO]
    let platforms: [PlatformWrapperDTO]
    let developers: [NameDTO]
    let publishers: [NameDTO]
    
}


struct PlatformWrapperDTO: Decodable {
    let platform: PlatformDTO
}

struct PlatformDTO: Decodable {
    let name: String
}

struct NameDTO: Decodable {
    let name: String
}
