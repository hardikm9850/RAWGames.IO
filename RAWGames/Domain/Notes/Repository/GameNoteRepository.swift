//
//  GameNoteRepository.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//

import Foundation

protocol GameNoteRepository {
    func getAllNotes() async throws -> [GameNoteModel]
    func getNotes(for gameId: UUID) async throws -> [GameNoteModel]
    func save(note: GameNoteModel) async throws
    func delete(noteId: UUID) async throws
}
