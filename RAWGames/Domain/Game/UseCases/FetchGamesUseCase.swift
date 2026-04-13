//
//  FetchGamesUseCase.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//



struct FetchGamesUseCase: Sendable {

    private let repository: GamesRepository

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

