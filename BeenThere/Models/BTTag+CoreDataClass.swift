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
public class BTTag: NSManagedObject, Codable {

    override public func awakeFromInsert() {
        self.id = UUID()
    }
    
    static func mapById(_ tags: [BTTag]) -> [NSManagedObjectID] {
        return tags.map{ $0.objectID }
    }
    
    static func mapByName(_ tags: [BTTag]) -> [String] {
        return tags.map{ $0.name }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        //case places
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataDecodingError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
//        if let unwrappedPlaces = try container.decodeIfPresent([BTPlace].self, forKey: .places) {
//            places = NSSet(array: unwrappedPlaces)
//        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        //try container.encodeIfPresent(places?.allObjects as? [BTPlace], forKey: .places)
    }
}
