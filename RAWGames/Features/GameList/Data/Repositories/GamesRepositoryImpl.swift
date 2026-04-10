//
//  GamesRepositoryImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


import Foundation

// actor — coordinates two non-thread-safe resources:
//   1. GamesCacheService  (wraps NSManagedObjectContext)
//   2. GamesAPIService    (stateless struct — but we control request deduplication here)
//
// Being an actor means only one fetch/write can execute at a time.
// No two Tasks can race to simultaneously write stale data over fresh data.

actor GamesRepositoryImpl: GamesRepository {
    
    private let cacheService: GamesCacheService // local
    private let apiService: GamesAPIService // remote
    
    
    init(apiService: GamesAPIService,
         cacheService: GamesCacheService) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    // MARK: - GamesRepository
    
    func fetchGames(page: Int = 1) async throws -> [Game] {
        
        let cached = try await cacheService.fetchCachedGames()
        
        if let cached {
            Task {
                if let fresh = try? await apiService.fetchGames(page: page) {
                    try? await cacheService.saveGames(fresh)
                }
            }
            return cached
        }
        
        let games = try await apiService.fetchGames(page: page)
        try await cacheService.saveGames(games)
        return games
    }
    
    
    func searchGames(query: String) async throws -> [Game] {
        try await apiService.searchGames(query: query)
    }
    
    func clearCache() async throws {
        try await cacheService.clearAll()
    }
}
