//
//  BTTabBarController.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 11/28/20.
//

import UIKit

class BTTabBarController: UITabBarController {
    
    private let config = UIImage.SymbolConfiguration(weight: .bold)
    private let iconOffset: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [createPlacesVC(), createFavoritesVC(), createSettingsVC()]
    }
    
    private func createPlacesVC() -> UINavigationController {
        let placesVC = PlacesVC()
        
        placesVC.title = "My Places"
        
        let search = UIImage(systemName: SFSymbols.search, withConfiguration: config)
        placesVC.tabBarItem.image = search!.withBaselineOffset(fromBottom: iconOffset)
        
        return UINavigationController(rootViewController: placesVC)
    }
    
    private func createFavoritesVC() -> UINavigationController {
        let favoriteVC = FavoritesVC()

        favoriteVC.title = "Favorites"
        
        let star = UIImage(systemName: SFSymbols.favoriteFill, withConfiguration: config)
        favoriteVC.tabBarItem.image = star!.withBaselineOffset(fromBottom: iconOffset)
        
        return UINavigationController(rootViewController: favoriteVC)
    }
    
    private func createSettingsVC() -> UINavigationController {
        let settingsVC = SettingsVC()

        settingsVC.title = "Settings"
        
        let gear = UIImage(systemName: SFSymbols.gear, withConfiguration: config)
        settingsVC.tabBarItem.image = gear!.withBaselineOffset(fromBottom: iconOffset)
        
        return UINavigationController(rootViewController: settingsVC)
    }
}
