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
    let apiService: GamesAPIService
    
    // Actor — one instance shared across the app
    let cacheService: GamesCacheService
    
    // MARK: - Repositories
    private let gamesRepository: GamesRepository
    private let favouritesRepository: FavouritesRepository
    
    // MARK: - Use Cases
    private let fetchGamesUseCase: FetchGamesUseCase
    private let searchGamesUseCase: SearchGamesUseCase
    
    // MARK: - ViewModel
    let gamesListViewModel: GamesListViewModel
    let favouritesViewModel: FavouritesViewModel
    
    private init() {
        coreDataStack = CoreDataStack.shared
        httpClient = HTTPClient()
        apiService = GamesAPIService(client: httpClient)
        
        // GamesCacheService gets a background context — NOT the viewContext
        // This means cache reads/writes never block the UI context
        cacheService = GamesCacheService(
            container:  coreDataStack.container
        )
        
        favouritesRepository = FavouritesRepositoryImpl(
            context: coreDataStack.viewContext
        )
        gamesRepository = GamesRepositoryImpl(
                    apiService: apiService,
                    cacheService: cacheService
                )
        
        fetchGamesUseCase = FetchGamesUseCase(repository: gamesRepository)
        searchGamesUseCase = SearchGamesUseCase(repository: gamesRepository)
        
        self.gamesListViewModel = GamesListViewModel(
            fetchGamesUseCase: fetchGamesUseCase,
                       searchGamesUseCase: searchGamesUseCase,
                       favouritesRepository: favouritesRepository
        )
        self.favouritesViewModel = FavouritesViewModel(apiService: apiService, favouritesRepository: favouritesRepository)
    }
}
