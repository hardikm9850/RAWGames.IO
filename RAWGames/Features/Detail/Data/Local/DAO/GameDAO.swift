//
//  GameDAO.swift
//  RAWGames
//
//  Created by Hardik Mehta on 08/04/26.
//


protocol GameDAO {
    func save(game: CachedGame)
    func fetch(id: Int) -> CachedGame?
}
