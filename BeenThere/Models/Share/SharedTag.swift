//
//  SharedTag.swift
//  BeenThere
//
//  Created by Peyton Shetler on 5/22/21.
//

import Foundation


struct SharedTag: Codable {
    
    var id: UUID
    var name: String
    
    init(tag: BTTag) {
        self.id = tag.id!
        self.name = tag.name
    }
}
