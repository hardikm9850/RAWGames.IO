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
    var route: Route?
    var hasLoadedInitialGames = false
    
    // MARK: - Dependencies — use cases, not services
    private let fetchGamesUseCase: FetchGamesUseCase
    private let searchGamesUseCase: SearchGamesUseCase
    private let updateFavouriteGameUseCase: UpdateFavouriteGameUseCase
    private let fetchFavouritesUseCase: FetchFavouritesUseCase
    private let clearCachedGamesUseCase: ClearCachedGamesUseCase
    
    init(fetchGamesUseCase: FetchGamesUseCase,
         searchGamesUseCase: SearchGamesUseCase,
         updateFavouriteGameUseCase: UpdateFavouriteGameUseCase,
         fetchFavouritesUseCase: FetchFavouritesUseCase,
         clearCachedGamesUseCase : ClearCachedGamesUseCase
    ) {
        
        self.fetchGamesUseCase = fetchGamesUseCase
        self.searchGamesUseCase = searchGamesUseCase
        self.updateFavouriteGameUseCase = updateFavouriteGameUseCase
        self.fetchFavouritesUseCase = fetchFavouritesUseCase
        self.clearCachedGamesUseCase = clearCachedGamesUseCase
    }
    
    func loadGames() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let games = fetchGamesUseCase.execute()
            async let favourites = fetchFavouritesUseCase.execute()
            
            let (fetchedGames, fetchedFavourites) = try await (games, favourites)
            self.favouriteIDs = Set(
                fetchedFavourites.map { fav in
                    fav.id
                }
            )
            
            self.games = fetchedGames.map { game in
                var updatedGame = game
                updatedGame.isFavorite = favouriteIDs.contains(game.id)
                return updatedGame
            }
            hasLoadedInitialGames = true
        } catch {
            errorMessage = error.localizedDescription
            
            print("error occurred while retrieving games \(errorMessage)")
        }
        
        isLoading = false
    }
    
    func search() async {
        errorMessage = nil
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
        try? await clearCachedGamesUseCase.execute()
        await loadGames()
    }
    
    // MARK: - Favourites
    func loadFavouriteIDs() async {
        let favourites = try? await fetchFavouritesUseCase.execute() // return favourites or nil
        
        favouriteIDs = Set(favourites?.map(\.id) ?? []) // check for nulity 
    }
    
    func toggleFavourite(_ game: Game) async {
        errorMessage = nil
        
        do {
            let isFavourite = try await updateFavouriteGameUseCase.execute(id: game.id)
            
            if isFavourite {
                favouriteIDs.insert(game.id)
            } else {
                favouriteIDs.remove(game.id)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        updateGameFavouriteState(game.id)
    }
    
    private func updateGameFavouriteState(_ gameID: Int) {
        games = games.map { game in
            var updatedGame = game
            updatedGame.isFavorite = favouriteIDs.contains(game.id)
            return updatedGame
        }
    }
    
    func onGameClicked(_ game: Game) {
        print("viewmodel updates the state")
        route = .detail(game.id)
    }
}
