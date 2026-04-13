//
//  GamesAPIService.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import Foundation

struct GamesAPIService: Sendable {
    private let client: HTTPClient

    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }

    func fetchGames(page: Int = 1) async throws -> [Game] {
        guard let url = GameRoute.games(page: page).url else {
            throw NetworkError.invalidURL
        }
        do {
            let response: GamesResponseDTO = try await client.get(url: url)
            return response.results.map { game in
                game.toDomain()
            }
        } catch {
            print("Error while getting games \(error.localizedDescription)")
        }
        return []
    }

    func fetchDetail(id: Int) async throws -> GameDetail {
        guard let url = GameRoute.gameDetail(id: id).url else {
            throw NetworkError.invalidURL
        }
        
        let dto: GameDetailDTO = try await client.get(url: url)
        
        let model: GameDetail = GameDetail(from: dto)
        
        return model
    }

    func searchGames(query: String) async throws -> [Game] {
        guard let url = GameRoute.searchGames(query: query).url else {
            throw NetworkError.invalidURL
        }
        let response: GamesResponseDTO = try await client.get(url: url)
        return response.results.map { $0.toDomain() }
    }
}
