//
//  GameNoteRepositoryImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//

import Foundation

final class GameNoteRepositoryImpl: GameNoteRepository {
    
    private let dao: GameNoteDAO
    
    init(dao: GameNoteDAO) {
        self.dao = dao
    }
    
    func getAllNotes() async throws -> [GameNoteModel] {
        try dao.fetchAll().map { $0.toDomain() }
    }
    
    func getNotes(for gameId: Int) async throws -> [GameNoteModel] {
        try dao.fetchByGameId(gameId).map { $0.toDomain() }
    }
    
    func save(note: GameNoteModel) async throws {
        try dao.save(note: note)
    }
    
    func delete(noteId: UUID) async throws {
        try dao.delete(noteId: noteId)
    }
}

extension GameNote {
    func toDomain() -> GameNoteModel {
        GameNoteModel(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            content: self.content ?? "",
            createdAt: self.createdAt ?? Date(),
            updatedAt: self.modifiedAt ?? Date()
        )
    }
}
