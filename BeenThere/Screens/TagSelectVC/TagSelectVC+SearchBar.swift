//
//  TagSelectVC+SearchBar.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 4/11/21.
//

import UIKit

extension TagSelectVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = searchPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.automaticallyShowsScopeBar = true

        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredTags.removeAll()
            updateSnapshot(on: fetchedResultsController.fetchedObjects ?? [], isFiltering: false)
            return
        }
        
        if fetchedResultsController.fetchedObjects != nil {
            
            filteredTags = fetchedResultsController.fetchedObjects!.filter {
                Helpers.Regex.isMatch(pattern: filter, string: $0.name)
            }
            
            updateSnapshot(on: filteredTags, isFiltering: true)
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
