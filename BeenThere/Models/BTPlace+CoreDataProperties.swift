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
    @NSManaged public var tag: BTTag?
    @NSManaged public var location: BTLocation?

}

extension BTPlace : Identifiable {

}
