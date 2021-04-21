//
//  BTTag+CoreDataProperties.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import Foundation
import CoreData


extension BTTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTTag> {
        return NSFetchRequest<BTTag>(entityName: "BTTag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var places: NSSet?

}

// MARK: Generated accessors for places
extension BTTag {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: BTPlace)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: BTPlace)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

extension BTTag : Identifiable {

}
