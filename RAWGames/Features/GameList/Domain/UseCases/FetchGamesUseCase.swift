//
//  FetchGamesUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


import Foundation

struct FetchGamesUseCase: Sendable {

    let repository: GamesRepository

    init(repository: GamesRepository) {
        self.repository = repository
    }

    func execute(page: Int = 1) async throws -> [Game] {
        let games = try await repository.fetchGames(page: page)

        return games
            .filter { !$0.name.isEmpty }
            .sorted { $0.rating > $1.rating }
    }
}

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

enum UseCaseError: LocalizedError {
    case queryTooShort

    var errorDescription: String? {
        switch self {
        case .queryTooShort:
            return "Search query must be at least 2 characters."
        }
    }
}
