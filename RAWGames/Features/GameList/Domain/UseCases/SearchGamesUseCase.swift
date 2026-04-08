//
//  SearchGamesUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 03/04/26.
//


internal import Foundation

struct SearchGamesUseCase: Sendable {

    private let repository: GamesRepository

    init(repository: GamesRepository) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Game] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            throw UseCaseError.queryTooShort
        }
        return try await repository.searchGames(query: trimmed)
    }
}
