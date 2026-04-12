//
//  GameRepositoryImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 08/04/26.
//


final class GameDetailRepositoryImpl: GameDetailRepository {

    private let gameApiService: GamesAPIService
    private let cacheService : GamesCacheService

    init(apiClient: GamesAPIService, gameCacheService: GamesCacheService) {
        self.gameApiService = apiClient
        self.cacheService = gameCacheService
    }

    
    func getGameDetail(id: Int) async throws -> GameDetail {
        
        do {
            if let cached = try await cacheService.fetchGameDetail(id: id) {
                print("detail already exist for id \(id)")
                return cached
            }
            print("detail does not exist for id \(id), fetching via api")
            // API call
            let gameDetail = try await gameApiService.fetchDetail(id: id)
            do {
                _ = try await cacheService.updateGame(game: gameDetail)
            } catch {
                print("Cache update failed for id \(id), error: \(error)")
            }
            return gameDetail
            
        } catch {
            
            print("API failed for id \(id), error: \(error)")
            
            if let cached = try? await cacheService.fetchGameDetail(id: id) {
                print("Returning stale cached data for id \(id)")
                return cached
            }
            
            throw error
        }
    }
}
