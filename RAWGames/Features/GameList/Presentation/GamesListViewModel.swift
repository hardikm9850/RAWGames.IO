//
//  runs.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import Foundation

@Observable
@MainActor
final class GamesListViewModel {
    
    
    var games: [Game] = []
    var isLoading = false
    var errorMessage: String?
    var searchQuery = ""
    var isSearching = false
    var favouriteIDs: Set<Int> = []
    
    // MARK: - Dependencies — use cases, not services
    private let fetchGamesUseCase: FetchGamesUseCase
    private let searchGamesUseCase: SearchGamesUseCase
    private let favouritesRepository: FavouritesRepository

    
    init(fetchGamesUseCase: FetchGamesUseCase,
         searchGamesUseCase: SearchGamesUseCase,
         favouritesRepository: FavouritesRepository,
         //apiService :GamesAPIService
    ) {
        self.fetchGamesUseCase = fetchGamesUseCase
        self.searchGamesUseCase = searchGamesUseCase
        self.favouritesRepository = favouritesRepository
    }
    
    func loadGames() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let games = fetchGamesUseCase.execute()
            async let favourites = favouritesRepository.fetchFavourites()
            
            let (fetchedGames, fetchedFavourites) = try await (games, favourites)
            
            self.games = fetchedGames
            self.favouriteIDs = Set(fetchedFavourites.map(\.id))
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func search() async {
        guard !searchQuery.isEmpty else {
            await loadGames()
            return
        }
        isSearching = true
        isLoading = true
        do {
            games = try await searchGamesUseCase.execute(query: searchQuery)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
        isSearching = false
    }
    
    func refresh() async {
        try? await fetchGamesUseCase.repository.clearCache()
        await loadGames()
    }
    
    // MARK: - Favourites
    func loadFavouriteIDs() async {
        let favourites = try? await favouritesRepository.fetchFavourites()
        favouriteIDs = Set(favourites?.map(\.id) ?? [])
    }
    
    func toggleFavourite(_ game: Game) async {
        do {
            if favouriteIDs.contains(game.id) {
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
}
