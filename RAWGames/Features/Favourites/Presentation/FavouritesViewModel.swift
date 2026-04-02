//
//  FavouritesViewModel.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


import Foundation

@Observable
@MainActor
final class FavouritesViewModel {
    
    var favourites: [Game] = []
    var errorMessage: String?
    
    
    // Add these to GamesListViewModel
    var favouriteIDs: Set<Int> = []
    private let favouritesRepository: FavouritesRepository
    private let apiService: GamesAPIService
    
    // Update init
    init(apiService: GamesAPIService,
         favouritesRepository: FavouritesRepository) {
        self.apiService = apiService
        self.favouritesRepository = favouritesRepository
    }
    
    func toggleFavourite(_ game: Game) async {
        do {
            let isCurrentlyFav = try await favouritesRepository.isFavourite(id: game.id)
            if isCurrentlyFav {
                try await favouritesRepository.removeFavourite(id: game.id)
                favouriteIDs.remove(game.id)
            } else {
                try await favouritesRepository.addFavourite(game)
                favouriteIDs.insert(game.id)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadFavouriteIDs() async {
        let favourites = try? await favouritesRepository.fetchFavourites()
        favouriteIDs = Set(favourites?.map(\.id) ?? [])
    }
    
    func loadFavourites() async {
        do {
            favourites = try await favouritesRepository.fetchFavourites()
            favouriteIDs = Set(favourites.map(\.id))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func remove(_ game: Game) async {
        do {
            try await favouritesRepository.removeFavourite(id: game.id)
            // Remove optimistically from local state — instant UI response
            favourites.removeAll { $0.id == game.id }
        } catch {
            errorMessage = error.localizedDescription
            // On failure, reload from source of truth
            await loadFavourites()
        }
    }
}
