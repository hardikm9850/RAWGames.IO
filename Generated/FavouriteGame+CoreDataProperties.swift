//
//  FavouriteGame+CoreDataProperties.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//
//

public import Foundation
public import CoreData


public typealias FavouriteGameCoreDataPropertiesSet = NSSet

extension FavouriteGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteGame> {
        return NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
    }

    @NSManaged public var addedAt: Date?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double

}

extension FavouriteGame : Identifiable {

}
