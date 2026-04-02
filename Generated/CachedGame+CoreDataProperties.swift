//
//  CachedGame+CoreDataProperties.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//
//

public import Foundation
public import CoreData


public typealias CachedGameCoreDataPropertiesSet = NSSet

extension CachedGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedGame> {
        return NSFetchRequest<CachedGame>(entityName: "CachedGame")
    }

    @NSManaged public var cachedAt: Date?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var released: String?

}

extension CachedGame : Identifiable {

}
