//
//  GameDAOImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 08/04/26.
//

import CoreData


final class GameDAOImpl: GameDAO {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetch(id: Int) -> CachedGame? {
        let request = CachedGame.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        guard let entity = try? context.fetch(request).first else {
            return nil
        }
        
        return entity
    }

    func save(game: CachedGame) {
        // TODO save game in cache
        try? context.save()
    }
}
