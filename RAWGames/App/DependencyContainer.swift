//
//  DependencyContainer.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//

import SwiftUI

@MainActor
@Observable
public final class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    // MARK: - Services (infrastructure)
    let coreDataStack: CoreDataStack
    let httpClient: HTTPClient
    let gamesApiService: GamesAPIService
    
    // Actor — one instance shared across the app
    let cacheService: GamesCacheService
    
    // MARK: - DAO
    private let gameNoteDAO: GameNoteDAO
    
    // MARK: - Repositories
    private let gamesRepository: GamesRepository
    private let favouritesRepository: FavouritesRepository
    private let gameNoteRepository: GameNoteRepository
    private let gameDetailRepository: GameDetailRepository
    
    // MARK: - Use Cases
    private let fetchGamesUseCase: FetchGamesUseCase
    private let searchGamesUseCase: SearchGamesUseCase
    private let fetchGameDetailUseCase : FetchGameDetailUseCase
    private let updateFavouriteUseCase : UpdateFavouriteGameUseCase
    private let clearCachedGamesUseCase: ClearCachedGamesUseCase
    private let fetchFavouritesUseCase: FetchFavouritesUseCase
    
    // MARK: - ViewModel
    let gamesListViewModel: GamesListViewModel
    let favouritesViewModel: FavouritesViewModel
    let notesViewModel: NotesViewModel
    
    private init() {
        coreDataStack = CoreDataStack.shared
        httpClient = HTTPClient()
        gamesApiService = GamesAPIService(client: httpClient)
        
        // GamesCacheService gets a background context — NOT the viewContext
        // This means cache reads/writes never block the UI context
        cacheService = GamesCacheService(
            container:  coreDataStack.container
        )
        gameNoteDAO = GameNoteDAOImpl(context: coreDataStack.newBackgroundContext())
        
        favouritesRepository = FavouritesRepositoryImpl(
            context: coreDataStack.viewContext,
            cacheService: cacheService
        )
        gamesRepository = GamesRepositoryImpl(
            apiService: gamesApiService,
            cacheService: cacheService
        )
        gameNoteRepository = GameNoteRepositoryImpl(dao: gameNoteDAO)
        gameDetailRepository = GameDetailRepositoryImpl(
            apiClient: gamesApiService,
            gameCacheService: cacheService
        )
        
        
        fetchGamesUseCase = FetchGamesUseCase(repository: gamesRepository)
        searchGamesUseCase = SearchGamesUseCase(repository: gamesRepository)
        fetchGameDetailUseCase = FetchGameDetailUseCase(gameDetailRepository: gameDetailRepository, favouritesRepository: favouritesRepository)
        updateFavouriteUseCase = UpdateFavouriteGameUseCase(repository:  favouritesRepository)
        fetchFavouritesUseCase = FetchFavouritesUseCase(favouritesRepository: favouritesRepository)
        clearCachedGamesUseCase = ClearCachedGamesUseCase(repository: gamesRepository)
        
        self.gamesListViewModel = GamesListViewModel(
            fetchGamesUseCase: fetchGamesUseCase,
            searchGamesUseCase: searchGamesUseCase,
            updateFavouriteGameUseCase: updateFavouriteUseCase,
            
            fetchFavouritesUseCase: fetchFavouritesUseCase,
            clearCachedGamesUseCase : clearCachedGamesUseCase
        )
        self.favouritesViewModel = FavouritesViewModel(apiService: gamesApiService, favouritesRepository: favouritesRepository)
        self.notesViewModel = NotesViewModel(repository: gameNoteRepository)
    }
    
    func makeDetailViewModel(gameId: Int) -> DetailViewModel {
        print("container : make detail viewmodel")
        return DetailViewModel(fetchGameDetailUseCase: fetchGameDetailUseCase, updateFavoruiteUseCase: updateFavouriteUseCase, gameId: gameId)
    }
}
