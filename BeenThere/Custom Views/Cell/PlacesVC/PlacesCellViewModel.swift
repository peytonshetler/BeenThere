//
//  PlacesCellViewModel.swift
//  BeenThere
//
//  Created by Peyton Shetler on 5/14/21.
//

import UIKit


struct PlacesCellViewModel {
    
    var place: BTPlace!
    
    var name: String
    var tag: String
    
    var address: String
    
    var isFavorite: Bool
    var favoriteImage: UIImage!
    
    let favoriteConfig = Helpers.Symbol.imageConfig(size: 30, weight: .regular, scale: .small)
    
    init(place: BTPlace) {
        
        self.place = place
        
        name = place.name
        tag = place.tag != nil ? place.tag!.name : "--"
        isFavorite = place.isFavorite
        
        let city = place.location != nil ? place.location!.locality : ""
        let state = place.location != nil ? place.location!.administrativeArea : ""
        
        if (city.isEmpty || state.isEmpty) {
            address = city + state
        } else {
            address = "\(city), \(state)"
        }
        
        
        if place.isFavorite {
            favoriteImage = UIImage(systemName: SFSymbols.favoriteFill, withConfiguration: favoriteConfig)
        } else {
            favoriteImage = UIImage(systemName: SFSymbols.favorite, withConfiguration: favoriteConfig)
        }
        
    }
}
