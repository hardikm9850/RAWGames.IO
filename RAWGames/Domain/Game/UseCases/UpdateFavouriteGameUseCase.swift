//
//  UpdateFavouriteGameUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//

struct UpdateFavouriteGameUseCase: Sendable {

    private let favouritesRepository: FavouritesRepository

    init(repository: FavouritesRepository) {
        self.favouritesRepository = repository
    }

    func execute(id: Int) async throws -> Bool {
        let games = try await favouritesRepository.toggleFavourite(id: id)

        return games            
    }
}


