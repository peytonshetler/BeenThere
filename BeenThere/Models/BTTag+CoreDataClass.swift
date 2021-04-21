//
//  BTTag+CoreDataClass.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import Foundation
import CoreData

@objc(BTTag)
public class BTTag: NSManagedObject {

    override public func awakeFromInsert() {
        self.id = UUID()
    }
    
    static func mapById(_ tags: [BTTag]) -> [NSManagedObjectID] {
        return tags.map{ $0.objectID }
    }
    
    static func mapByName(_ tags: [BTTag]) -> [String] {
        return tags.map{ $0.name }
    }
}
