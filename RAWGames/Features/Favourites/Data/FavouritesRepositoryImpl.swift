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

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Read

    func fetchFavourites() throws -> [Game] {
        var result: [Game] = []
        var fetchError: Error?

        context.performAndWait {
            // Manually construct — avoids calling @MainActor fetchRequest()
            let request = NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
            // String-based sort descriptor — avoids @MainActor keypath
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

    func isFavourite(id: Int) throws -> Bool {
        var result = false
        var fetchError: Error?

        context.performAndWait {
            let request = NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
            request.predicate = NSPredicate(format: "id == %d", id)
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

    func addFavourite(_ game: Game) throws {
        guard try !isFavourite(id: game.id) else { return }

        var saveError: Error?

        context.performAndWait {
            let favourite = FavouriteGame(context: self.context)
            // performAndWait runs on context's queue — safe to set properties
            favourite.id = Int64(game.id)
            favourite.name = game.name
            favourite.image = game.backgroundImage
            favourite.rating = game.rating
            favourite.addedAt = Date()

            do {
                try self.context.save()
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
            request.predicate = NSPredicate(format: "id == %d", id)

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
}
