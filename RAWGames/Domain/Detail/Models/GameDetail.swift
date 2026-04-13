//
//  GameDetail.swift
//  RAWGames
//
//  Created by Hardik Mehta on 08/04/26.
//


struct GameDetail: Equatable {
    let id: Int
    let name: String
    let description: String
    let backgroundImage: String?
    let rating: Double
    let metacritic: Int?
    let released: String?
    let isFavourite: Bool
    let genres: [String]
    let platforms: [String]
    let developers: [String]
    let publishers: [String]
    let website: String
    let playtime: Int
}

extension GameDetail {
    init(from dto: GameDetailDTO) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description_raw
        self.backgroundImage = dto.background_image
        self.rating = dto.rating
        self.metacritic = dto.metacritic
        self.released = dto.released
        self.playtime = dto.playtime
        self.genres = dto.genres.map { $0.name }
        self.platforms = dto.platforms.map { $0.platform.name }
        self.developers = dto.developers.map { $0.name }
        self.publishers = dto.publishers.map { $0.name }
        self.website = dto.website
        self.isFavourite = false
    }
    
    
    func toGame() -> Game {
        Game(id: id, name: name, backgroundImage: backgroundImage, rating: rating, released: released, isFavorite: isFavourite)
    }
    
    
    func copy(
        id: Int? = nil,
        name: String? = nil,
        description: String? = nil,
        backgroundImage: String? = nil,
        rating: Double? = nil,
        metacritic: Int? = nil,
        released: String? = nil,
        genres: [String]? = nil,
        platforms: [String]? = nil,
        developers: [String]? = nil,
        publishers: [String]? = nil,
        isFavourite: Bool? = nil,
        website: String? = nil,
        playtime: Int? = nil
    ) -> GameDetail {
        GameDetail(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            backgroundImage: backgroundImage ?? self.backgroundImage,
            rating: rating ?? self.rating,
            metacritic: metacritic ?? self.metacritic,
            released: released ?? self.released,
            isFavourite: isFavourite ?? self.isFavourite,
            
            genres: genres ?? self.genres,
            platforms: platforms ?? self.platforms,
            developers: developers ?? self.developers,
            publishers: publishers ?? self.publishers,
            website: website ?? self.website,
            playtime: playtime ?? self.playtime
        )
    }
    
}


