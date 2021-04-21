//
//  BTPlace+CoreDataClass.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import Foundation
import CoreData

@objc(BTPlace)
public class BTPlace: NSManagedObject {

    override public func awakeFromInsert() {
        self.id = UUID()
    }
        
    static func mapById(_ places: [BTPlace]) -> [NSManagedObjectID] {
        return places.map{ $0.objectID }
    }
}
