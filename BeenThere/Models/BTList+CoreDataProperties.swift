//
//  BTList+CoreDataProperties.swift
//  BeenThere
//
//  Created by Peyton Shetler on 5/24/21.
//
//

import Foundation
import CoreData


extension BTList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTList> {
        return NSFetchRequest<BTList>(entityName: "BTList")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var places: NSSet?

}

// MARK: Generated accessors for places
extension BTList {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: BTPlace)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: BTPlace)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

extension BTList : Identifiable {

}
