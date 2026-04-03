//
//  GameNoteDAOImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//

import CoreData


final class GameNoteDAOImpl: GameNoteDAO {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() throws -> [GameNote] {
        let request: NSFetchRequest<GameNote> = GameNote.fetchRequest()
        return try context.fetch(request)
    }
    
    func fetchByGameId(_ gameId: Int) throws -> [GameNote] {
        let request: NSFetchRequest<GameNote> = GameNote.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", gameId)
        return try context.fetch(request)
    }
    
    func save(note: GameNoteModel) throws {
        _ = note.toEntity(context: context)
        try context.save()
    }
    
    func delete(noteId: UUID) throws {
        let request: NSFetchRequest<GameNote> = GameNote.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)
        
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        
        try context.save()
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
