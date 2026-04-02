//
//  GamesRepository.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


protocol GamesRepository: Sendable {
    func fetchGames(page: Int) async throws -> [Game]
    func fetchDetail(id: Int) async throws -> Game
    func searchGames(query: String) async throws -> [Game]
    func clearCache() async throws
}
