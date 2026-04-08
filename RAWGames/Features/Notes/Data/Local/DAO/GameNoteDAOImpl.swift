//
//  GameNoteDAOImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//

import CoreData


final class GameNoteDAOImpl: GameNoteDAO {
    
    // Each NSManagedObjectContext is bound to one queue/thread only [Executors.newSingleThreadExecutor()]
    // A crash may occur if we touch context from a wrong thread
    
    // context.perform {} === handler.post {}
    // context.perform forces the code to run on the correct queue internally
    
    private let context: NSManagedObjectContext // <-- this is not thread-safe.
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() async throws -> [GameNoteModel] {
        try await context.perform { // Send this work to the context’s private queue and execute it serially.
            let request: NSFetchRequest<GameNote> = GameNote.fetchRequest()
            let entities = try self.context.fetch(request)
            
            return entities.map { $0.toDomain() }
        }
    }
    
    func fetchByGameId(_ gameId: UUID) async throws -> [GameNoteModel] {
        try await context.perform {
            let request: NSFetchRequest<GameNote> = GameNote.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", gameId as CVarArg)
            
            let entities = try self.context.fetch(request)
            
            return entities.map { $0.toDomain() }
        }
    }
    
    func save(note: GameNoteModel) async throws {
        try await context.perform {
            _ = note.toEntity(context: self.context)
            
            try self.context.save()
        }
    }

    func delete(noteId: UUID) async throws {
        try await context.perform {
            let request: NSFetchRequest<GameNote> = GameNote.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)
            
            let results = try self.context.fetch(request)
            results.forEach { self.context.delete($0) }
            
            try self.context.save()
        }
    }
}

extension GameNoteModel {
    func toEntity(context: NSManagedObjectContext) -> GameNote {
        let entity = GameNote(context: context)
        entity.id = id
        entity.title = title
        entity.content = content
        entity.createdAt = createdAt
        entity.modifiedAt = updatedAt
        return entity
    }
}
