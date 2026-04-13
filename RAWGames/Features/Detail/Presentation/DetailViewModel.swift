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
    var state: ViewState<GameDetail> = .idle
    let gameId : Int
    private var isTogglingFavourite = false
    
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
        state = .loading

        do {
            let gameDetail = try await fetchGameDetailUseCase.execute(id: gameId)
            state = .loaded(gameDetail)
            print("DetailViewModel : received game detail. Updating the state")
        } catch {
            state = .failed("Unable to load game details. Please try again.")
            print("Error while retrieving game details for id \(gameId): \(error.localizedDescription)")
        }
    }

    func retryLoadGameDetail() {
        Task {
            await loadGameDetail()
        }
    }
    
    func onFavouriteTapped() {
        guard !isTogglingFavourite else { return } // prevent double tap
        
        Task {
            await toggleFavourite()
        }
    }
    
    private func toggleFavourite() async {
        guard !isTogglingFavourite, case let .loaded(current) = state else { return }
        
        isTogglingFavourite = true
        defer { isTogglingFavourite = false }
        
        
        let newValue = !current.isFavourite
        state = .loaded(current.copy(isFavourite: newValue))
        
        do {
            let confirmed = try await updateFavouriteGameUseCase.execute(id: current.id)
            state = .loaded(current.copy(isFavourite: confirmed))
        } catch {
            state = .loaded(current)
            print("Error occurred while favoriting the game \(gameId) \(error.localizedDescription)")
        }
    }
}
