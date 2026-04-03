//
//  GameNoteDAO.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//
import Foundation

protocol GameNoteDAO {
    func fetchAll() throws -> [GameNote]
    func fetchByGameId(_ gameId: Int) throws -> [GameNote]
    func save(note: GameNoteModel) throws
    func delete(noteId: UUID) throws
}
