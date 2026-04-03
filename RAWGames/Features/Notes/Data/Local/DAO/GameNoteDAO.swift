//
//  GameNoteDAO.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//
import Foundation

protocol GameNoteDAO {
    func fetchAll() async throws -> [GameNoteModel]
    func fetchByGameId(_ gameId: Int) async throws -> [GameNoteModel]
    func save(note: GameNoteModel) async throws
    func delete(noteId: UUID) async throws
}
