//
//  DetailViewModel.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//

import Foundation

@Observable
@MainActor
class DetailViewModel  {
    
    private let fetchGameDetailUseCase: FetchGameDetailUseCase
    private let updateFavouriteGameUseCase: UpdateFavouriteGameUseCase
    var gameDetail : GameDetail?
    let gameId : Int
    
    
    init(
        fetchGameDetailUseCase: FetchGameDetailUseCase,
        updateFavoruiteUseCase: UpdateFavouriteGameUseCase,
        gameId: Int
    ) {
        self.gameId = gameId
        self.fetchGameDetailUseCase = fetchGameDetailUseCase
        self.updateFavouriteGameUseCase = updateFavoruiteUseCase
    }
    
    func loadGameDetail() async {
        do {
            gameDetail = try await fetchGameDetailUseCase.execute(id: gameId)
            print("DetailViewModel : received game detail. Updating the state")
        } catch {
            print("Error while retrieving game details for id %d", gameId)
        }
    }
    
    func onFavouriteTapped() {
        Task {
            await toggleFavourite()
        }
    }
    
    private func toggleFavourite() async {
        guard let current = gameDetail else { return }
        print("current fav \(current.isFavourite)")
        let newValue = !current.isFavourite
        gameDetail = current.copy(isFavourite: newValue)
        print("post updating fav \(gameDetail!.isFavourite)")
        
        do {
            let confirmed = try await updateFavouriteGameUseCase.execute(id: current.id)
            print("result from repo \(confirmed)")
            gameDetail = current.copy(isFavourite: confirmed)
        } catch {
            gameDetail = current
            print("Error occurred while favoriting the game \(gameId) \(error.localizedDescription)")
        }
    }
}
