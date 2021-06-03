//
//  BTPlace+CoreDataProperties.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import Foundation
import CoreData


extension BTPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTPlace> {
        return NSFetchRequest<BTPlace>(entityName: "BTPlace")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String
    @NSManaged public var note: String
    @NSManaged public var tags: NSSet?
    @NSManaged public var location: BTLocation?
    @NSManaged public var list: BTList?
}

// MARK: Generated accessors for places
extension BTPlace {

    @objc(addTagObject:)
    @NSManaged public func addToTags(_ value: BTTag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTags(_ value: BTTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension BTPlace : Identifiable {

}
