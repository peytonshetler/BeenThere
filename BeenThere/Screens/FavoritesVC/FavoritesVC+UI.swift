//
//  FavoritesVC+UI.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/1/21.
//

import UIKit
import CoreData

extension FavoritesVC {
    
    func configureNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.isToolbarHidden = true
        title = "Favorites"
    }
    
    
    func updateUI(with objectIDs: [NSManagedObjectID], isFiltering: Bool = false) {
        if !isFiltering {
            if objectIDs.isEmpty {
                showEmptyStateView()
            } else {
                hideEmptyStateView()
            }
        } else {
            hideEmptyStateView()
        }
    }
}
