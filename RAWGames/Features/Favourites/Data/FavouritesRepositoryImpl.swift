//
//  FavouritesRepositoryImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


import CoreData

// actor — protects NSManagedObjectContext from concurrent access
import CoreData

actor FavouritesRepositoryImpl: FavouritesRepository {
    
    private let context: NSManagedObjectContext
    private let cacheService: GamesCacheService
    
    init(context: NSManagedObjectContext,cacheService: GamesCacheService ) {
        self.context = context
        self.cacheService = cacheService
    }
    
    // MARK: - Read
    
    func fetchFavourites() throws -> [Game] {
        var result: [Game] = []
        var fetchError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
            request.sortDescriptors = [
                NSSortDescriptor(key: "addedAt", ascending: false)
            ]
            do {
                result = try self.context.fetch(request).map { fav in
                    Game(
                        id: Int(fav.id),
                        name: fav.name ?? "",
                        backgroundImage: fav.image,
                        rating: fav.rating,
                        released: nil
                    )
                }
            } catch {
                fetchError = error
            }
        }
        
        if let fetchError { throw fetchError }
        return result
    }
    
    func isFavourite(id: Int) async throws -> Bool {
        var result = false
        var fetchError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
            request.predicate = NSPredicate(
                format: "id == %@",
                NSNumber(value: Int64(id))
            )
            request.fetchLimit = 1
            do {
                result = try !self.context.fetch(request).isEmpty
            } catch {
                fetchError = error
            }
        }
        
        if let fetchError { throw fetchError }
        return result
    }
    
    // MARK: - Write
    
    func addFavourite(id: Int) async throws {
        guard let game = try await cacheService.fetchGameById(id: id) else {
            throw CacheError.gameNotFound(id: id)
        }
        
        var saveError: Error?
        
        context.performAndWait { // performAndWait runs on context's queue — safe to set properties
            
            let request = NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
            request.predicate = NSPredicate(
                format: "id == %@",
                NSNumber(value: Int64(id))
            )
            request.fetchLimit = 1
            
            do {
                guard try context.fetch(request).isEmpty else { return } // duplicate detection
                
                let favourite = FavouriteGame(context: context)
                favourite.id = Int64(game.id)
                favourite.name = game.name
                favourite.image = game.backgroundImage
                favourite.rating = game.rating
                favourite.addedAt = Date()
                
                try context.save()
            } catch {
                saveError = error
            }
        }
        
        if let saveError { throw saveError }
    }
    
    func removeFavourite(id: Int) throws {
        var saveError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
            request.predicate = NSPredicate(
                format: "id == %@",
                NSNumber(value: Int64(id))
            )
            do {
                let results = try self.context.fetch(request)
                results.forEach { self.context.delete($0) }
                try self.context.save()
            } catch {
                saveError = error
            }
        }
        
        if let saveError { throw saveError }
    }
    
    func toggleFavourite(id: Int) async throws -> Bool {
        let current = try await isFavourite(id: id)
        
        if current {
            try removeFavourite(id: id)
        } else {
            try await addFavourite(id: id)
        }
        
        return !current
    }
}
