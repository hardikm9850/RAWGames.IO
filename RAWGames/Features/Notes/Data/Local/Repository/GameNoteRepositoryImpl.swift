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
        try await dao.fetchAll()
    }
    
    func getNotes(for gameId: UUID ) async throws -> [GameNoteModel] {
        try await dao.fetchByGameId(gameId)
    }
    
    func save(note: GameNoteModel) async throws {
        try await dao.save(note: note)
    }
    
    func delete(noteId: UUID) async throws {
        try await dao.delete(noteId: noteId)
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
