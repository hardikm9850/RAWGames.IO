//
//  FetchGameDetailUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//


internal import Foundation

struct FetchGameDetailUseCase: Sendable { // Sendable: marks a type as safe to pass across concurrency boundaries
    // i.e., between actors, tasks, or threads — without causing data races.
    
    private let gameDetailRepository: GameDetailRepository
    private let favouritesRepository: FavouritesRepository
    
    init(gameDetailRepository: GameDetailRepository, favouritesRepository: FavouritesRepository) {
        self.gameDetailRepository = gameDetailRepository
        self.favouritesRepository = favouritesRepository
    }
    
    func execute(id: Int) async throws -> GameDetail {
        async let gameDetailTask = gameDetailRepository.getGameDetail(id: id)
        async let isFavouriteTask = favouritesRepository.isFavourite(id: id)
        
        let gameDetail = try await gameDetailTask
        let isFavourite = (try? await isFavouriteTask) ?? false
        
        return gameDetail.copy(isFavourite: isFavourite)
    }
}
