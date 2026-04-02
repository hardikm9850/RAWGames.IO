//
//  simultaneously.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import CoreData

// Note for self :
// Actor [thread-safe class] protects Swift memory
// Core Data protects its own queue
// 'actor' keyword — all stored properties and methods are serialised
// No two callers can execute inside this actor simultaneously


// Data Layer [Handles queuries, caching logic, expiry logic]
actor GamesCacheService { // actor is a swift task
    
    private let context: NSManagedObjectContext // Belongs to core data, not a thread safe
    private let cacheMaxAge: TimeInterval = 300 // Valid time of 5 minutes
    
    
    init(container: NSPersistentContainer) {
        self.context = container.newBackgroundContext()
    }
    
    // MARK: - Write
    
    // Returns cached games regardless of age — used as offline fallback
    func fetchStaleGames() async throws -> [Game]? {
        try await context.perform {
            let request = CachedGame.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \CachedGame.name, ascending: true)
            ]
            let results = try self.context.fetch(request)
            guard !results.isEmpty else { return nil }
            return results.map(\.asGame)
        }
    }
    
    
    func saveGames(_ games: [Game]) async throws {
        try await context.perform {
            
            let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedGame")
            let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
            
            try self.context.execute(batchDelete)
            
            for game in games {
                let cached = CachedGame(context: self.context)
                cached.id = Int64(game.id)
                cached.name = game.name
                cached.image = game.backgroundImage
                cached.rating = game.rating
                cached.released = game.released
                cached.cachedAt = Date()
            }
            
            try self.context.save()
        }
    }
    
    // MARK: - Read
    
    func fetchCachedGames() async throws -> [Game]? {
        
        try await context.perform {
            
            let request = CachedGame.fetchRequest()
            
            let cutoff = Date().addingTimeInterval(-self.cacheMaxAge)
            request.predicate = NSPredicate(
                format: "cachedAt > %@", cutoff as NSDate
            )
            request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
            
            let results = try self.context.fetch(request)
            
            guard !results.isEmpty else { return nil }
            
            return results.map { cached in
                Game(
                    id: Int(cached.id),
                    name: cached.name ?? "",
                    backgroundImage: cached.image,
                    rating: cached.rating,
                    released: cached.released
                )
            }
        }
    }
    
    // MARK: - Validity check
    
    func isCacheValid() async throws -> Bool {
        try await context.perform {
            let request = CachedGame.fetchRequest()
            let cutoff = Date().addingTimeInterval(-self.cacheMaxAge)
            request.predicate = NSPredicate(
                format: "cachedAt > %@", cutoff as NSDate
            )
            request.fetchLimit = 1 // we only need to know if one exists
            return try !self.context.fetch(request).isEmpty
        }
    }
    
    // Wipes the entire cache — used for pull-to-refresh
    func clearAll() async throws {
        try await context.perform {
            let deleteRequest = NSFetchRequest<NSFetchRequestResult>(
                entityName: "CachedGame"
            )
            let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
            batchDelete.resultType = .resultTypeObjectIDs
            
            let result = try self.context.execute(batchDelete) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                into: [self.context]
            )
        }
    }
    }
    
}
