//
//  FetchGameDetailUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//


internal import Foundation

struct FetchGameDetailUseCase: Sendable {

    private let gameDetailRepository: GameDetailRepository
    private let favouritesRepository: FavouritesRepository
    
    init(gameDetailRepository: GameDetailRepository, favouritesRepository: FavouritesRepository) {
        self.gameDetailRepository = gameDetailRepository
        self.favouritesRepository = favouritesRepository
    }

    func execute(id: Int) async throws -> GameDetail {
        async let gameDetailTask =  gameDetailRepository.getGameDetail(id: id)
        async let isFavouriteTask = favouritesRepository.isFavourite(id: id)
        
        var gameDetail = try await gameDetailTask
        let isFavourite = try await isFavouriteTask

        return gameDetail.copy(isFavourite: isFavourite)
    }
}
