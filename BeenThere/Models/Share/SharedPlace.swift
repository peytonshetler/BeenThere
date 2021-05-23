//
//  SharedPlace.swift
//  BeenThere
//
//  Created by Peyton Shetler on 5/22/21.
//

import Foundation

struct SharedPlace: Codable {
    
    var id: UUID
    var isFavorite: Bool
    var name: String
    var note: String
    var tag: SharedTag?
    var location: SharedLocation?
    
    init(place: BTPlace) {
        self.id = place.id!
        self.isFavorite = place.isFavorite
        self.name = place.name
        self.note = place.note
        
        if let tag = place.tag {
            self.tag = SharedTag(tag: tag)
        }
        
        if let location = place.location {
            self.location = SharedLocation(location: location)
        }
    }
}


extension SharedPlace {
    
    
    static func exportToURL(place: SharedPlace) -> URL? {

        guard let encoded = try? JSONEncoder().encode(place) else {
            print("error while encoding")
            return nil
        }

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        guard let path = documents?.appendingPathComponent("/\(place.name).beenthere") else { return nil }

        do {
            try encoded.write(to: path, options: .atomicWrite)
            return path
        } catch {
            return nil
        }
    }


    static func importData(from url: URL) {

        guard let data = try? Data(contentsOf: url) else {
            print("ERROR WITH DATA")
            return
        }
        
        do {
            let place = try JSONDecoder().decode(SharedPlace.self, from: data)
            // decoding works, now need to convert to a ManagedObject!
        } catch {
            
        }

      try? FileManager.default.removeItem(at: url)
    }
}







