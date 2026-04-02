//
//  Game.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


struct Game: Identifiable, Hashable, Sendable {
    // Sendable : any type that is being passed across concurrency boundaries must conform to sendable
    let id: Int
    let name: String
    let backgroundImage: String?
    let rating: Double
    let released: String?
}
