//
//  ClearCachedGamesUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//

struct ClearCachedGamesUseCase: Sendable {

    private let repository: GamesRepository

    init(repository: GamesRepository) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.clearCache()
    }
}

