//
//  GameRepository.swift
//  RAWGames
//
//  Created by Hardik Mehta on 08/04/26.
//


protocol GameDetailRepository : Sendable {
    func getGameDetail(id: Int) async throws -> GameDetail
}
