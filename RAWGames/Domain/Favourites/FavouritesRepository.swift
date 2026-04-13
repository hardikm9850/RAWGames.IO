//
//  FavouritesRepository.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


protocol FavouritesRepository: Sendable {
    func fetchFavourites() async throws -> [Game]
    func addFavourite(id: Int) async throws
    func removeFavourite(id: Int) async throws
    func isFavourite(id: Int) async throws -> Bool
    func toggleFavourite(id: Int) async throws -> Bool
}
