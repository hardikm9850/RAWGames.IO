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
        guard let url = APIEndpoint.games(page: page).url else {
            throw NetworkError.invalidURL
        }
        let response: GamesResponseDTO = try await client.get(url: url)
        return response.results.map { game in
            game.toDomain()
        }
    }

    func fetchDetail(id: Int) async throws -> Game {
        guard let url = APIEndpoint.gameDetail(id: id).url else {
            throw NetworkError.invalidURL
        }
        let dto: GameDTO = try await client.get(url: url)
        return dto.toDomain()
    }

    func searchGames(query: String) async throws -> [Game] {
        guard let url = APIEndpoint.searchGames(query: query).url else {
            throw NetworkError.invalidURL
        }
        let response: GamesResponseDTO = try await client.get(url: url)
        return response.results.map { $0.toDomain() }
    }
}
