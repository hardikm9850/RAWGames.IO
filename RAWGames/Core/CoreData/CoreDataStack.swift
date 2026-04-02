//
//  CoreDataStack.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import CoreData

// Infrestructure Layer [Handles container, contexts, threading helpers]
final class CoreDataStack {
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    // The main context — for UI reads and @FetchRequest
    // Must only be accessed on the main thread
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "RAWGModel") // Initialize the database
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { _, error in
            if let error {
                // In production you'd handle this gracefully
                // For learning: fatalError surfaces the problem immediately
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }
    
    // Creates a fresh background context for heavy work
    // Each call returns a new context — never share contexts across Tasks
    func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
    
    // Modern async background task — context is created, used, and discarded
    // Note for self :
    // _ block: (NSManagedObjectContext) throws -> T : this is a closure i.e higher order function
    // there are 2 types
    // 1. non-escaping - returns immediately
    // 2. escaping - executes closure later
    //
    // since container.performBackgroundTask does not run immediately, we have to mark the closure as escaping
    func performBackgroundTask<T: Sendable>(
        _ block: @escaping @Sendable (NSManagedObjectContext) throws -> T
    ) async throws -> T {
        
        try await withCheckedThrowingContinuation { continuation in
            
            container.performBackgroundTask { context in
                do {
                    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    let result = try block(context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @MainActor
    func saveViewContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            // In a real app, surface this to the user
            print("viewContext save failed: \(error)")
        }
    }
}
