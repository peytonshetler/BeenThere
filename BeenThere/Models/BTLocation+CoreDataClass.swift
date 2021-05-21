//
//  BTLocation+CoreDataClass.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//
//

import Foundation
import CoreData

@objc(BTLocation)
public class BTLocation: NSManagedObject, Codable {
    
    
    enum CodingKeys: String, CodingKey {
        case administrativeArea
        case country
        case latitude
        case longitude
        case locality
        case phoneNumber
        case postalCode
        case subThoroughfare
        case thoroughfare
        case url
        case place
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataDecodingError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        administrativeArea = try container.decode(String.self, forKey: .administrativeArea)
        country = try container.decode(String.self, forKey: .country)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        locality = try container.decode(String.self, forKey: .locality)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        subThoroughfare = try container.decode(String.self, forKey: .subThoroughfare)
        thoroughfare = try container.decode(String.self, forKey: .thoroughfare)
        url = try container.decode(String.self, forKey: .url)
        place = try container.decodeIfPresent(BTPlace.self, forKey: .place)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(administrativeArea, forKey: .administrativeArea)
        try container.encode(country, forKey: .country)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(locality, forKey: .locality)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(postalCode, forKey: .postalCode)
        try container.encode(subThoroughfare, forKey: .subThoroughfare)
        try container.encode(thoroughfare, forKey: .thoroughfare)
        try container.encode(url, forKey: .url)
        
        try container.encodeIfPresent(place, forKey: .place)
    }
}
