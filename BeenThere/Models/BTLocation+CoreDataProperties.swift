//
//  BTLocation+CoreDataProperties.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import Foundation
import CoreData


extension BTLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTLocation> {
        return NSFetchRequest<BTLocation>(entityName: "BTLocation")
    }

    @NSManaged public var administrativeArea: String
    @NSManaged public var country: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locality: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var postalCode: String
    @NSManaged public var subThoroughfare: String
    @NSManaged public var thoroughfare: String
    @NSManaged public var url: String
    @NSManaged public var place: BTPlace?

}

extension BTLocation : Identifiable {

}
