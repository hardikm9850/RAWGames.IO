//
//  FetchFavouritesUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//

struct FetchFavouritesUseCase {
    private let favouritesRepository: FavouritesRepository
    
    init(favouritesRepository: FavouritesRepository){
        self.favouritesRepository = favouritesRepository
    }
    
    func execute() async throws -> [Game] {
        return try await favouritesRepository.fetchFavourites()
    }
}
