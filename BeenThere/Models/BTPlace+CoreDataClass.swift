//
//  BTPlace+CoreDataClass.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import UIKit
import CoreData

@objc(BTPlace)
public class BTPlace: NSManagedObject, Codable {

    override public func awakeFromInsert() {
        self.id = UUID()
    }
    
        
    static func mapById(_ places: [BTPlace]) -> [NSManagedObjectID] {
        return places.map{ $0.objectID }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFavorite
        case name
        case note
        case tag
        case location
    }
    
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataDecodingError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        name = try container.decode(String.self, forKey: .name)
        note = try container.decode(String.self, forKey: .note)
        location = try container.decodeIfPresent(BTLocation.self, forKey: .location)
        tag = try container.decodeIfPresent(BTTag.self, forKey: .tag)
        
        
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(note, forKey: .note)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(tag, forKey: .tag)
    }

}
