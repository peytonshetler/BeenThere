//
//  PlacesVC+SearchBar.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 1/30/21.
//

import UIKit

// MARK: - Search Bar
extension PlacesVC: UISearchResultsUpdating, UISearchBarDelegate {

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = searchPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.definesPresentationContext = true
        searchController.automaticallyShowsScopeBar = true

        searchController.searchBar.scopeButtonTitles = searchBarScopes.map { $0.rawValue }
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        switch selectedScope {
        case 0: selectedSearchScope = .name
        case 1: selectedSearchScope = .location
        case 2: selectedSearchScope = .tag
        default: selectedSearchScope = .name
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredPlaces.removeAll()
            updateSnapshot(on: fetchedResultsController.fetchedObjects ?? [], isFiltering: false)
            return
        }
        
        if fetchedResultsController.fetchedObjects != nil {
            filterPlacesByScope(scope: selectedSearchScope, filter: filter)
            updateSnapshot(on: filteredPlaces, isFiltering: true)
        }
    }
    

    func filterPlacesByScope(scope: SearchBarScope, filter: String) {
        
        switch scope {
        case .name:
            
            filteredPlaces = fetchedResultsController.fetchedObjects!.filter {
                Helpers.Regex.isMatch(pattern: filter, string: $0.name)
            }
            
        case .location:
            
            filteredPlaces = fetchedResultsController.fetchedObjects!.filter {
                Helpers.Regex.isMatch(pattern: filter, string: $0.location != nil ? $0.location!.locality : "") ||
                    Helpers.Regex.isMatch(pattern: filter, string: $0.location != nil ? $0.location!.administrativeArea : "")
            }
            
        case .tag:
            
            filteredPlaces = fetchedResultsController.fetchedObjects!.filter {
                $0.tag != nil ? Helpers.Regex.isMatch(pattern: filter, string: $0.tag!.name) : false
            }
            
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text != nil {
            animateSearchBar = true
        } else {
            animateSearchBar = false
        }
    }

    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let search = searchBar.text else { return true }
        
        if search.isEmpty {
            animateSearchBar = false
        }
        
        return true
    }
}

