//
//  FavoritesVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 11/28/20.
//

import UIKit
import CoreData

private enum Section { case main }

private class BTFavoritesDiffibleDataSource: UITableViewDiffableDataSource<Section, NSManagedObjectID> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

class FavoritesVC: BTPrimaryTableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    let searchPlaceholder = "Search Favorites"
    let rowHeight: CGFloat = 100
    let headerHeight: CGFloat = 20
    var emptyStateView: BTEmptyStateView?
    
    // MARK: - Animation Checks
    var animateSearchBar: Bool = false
    var viewHasLoaded: Bool = false
    var tableViewVisible: Bool = false
    
    private var dataSource: BTFavoritesDiffibleDataSource!
    var fetchedResultsController: NSFetchedResultsController<BTPlace>!
    
    let persistence = PersistenceService.shared
    var filteredPlaces: [BTPlace] = []
    var searchBarScopes: [SearchBarScope] = [.name, .location, .tag]
    
    var selectedSearchScope: SearchBarScope = .name
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureSearchController()
        configureTableView()
        configureDataSource()
        fetchPlaces()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableViewVisible = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableViewVisible = false
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        
        guard let dataSource = tableView?.dataSource as? UITableViewDiffableDataSource<Section, NSManagedObjectID> else {
                assertionFailure("The data source has not implemented snapshot support while it should")
                return
            }
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>

        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemID in
            guard let currentIndex = currentSnapshot.indexOfItem(itemID), let index = snapshot.indexOfItem(itemID), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemID), existingObject.isUpdated else { return nil }
            return itemID
        }
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            showEmptyStateView()
        } else {
            hideEmptyStateView()
        }
        
        snapshot.reloadItems(reloadIdentifiers)

        let tableViewHasSections = tableView?.numberOfSections != 0
        let shouldAnimate = tableViewHasSections && tableViewVisible && viewHasLoaded
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>, animatingDifferences: shouldAnimate)
        viewHasLoaded = true
    }
    
    
    func fetchPlaces() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<BTPlace>(entityName: "BTPlace")
            let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            request.predicate = predicate
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistence.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            updateSnapshot(on: fetchedResultsController.fetchedObjects ?? [])
            
        } catch {
            presentBTErrorAlertOnMainThread(error: .errorRetrievingResults, completion: nil)
        }
    }
    
    
    func configureDataSource() {
        dataSource = BTFavoritesDiffibleDataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as! PlaceCell
            let place = self.fetchedResultsController.object(at: indexPath)
            cell.set(place: place)
            return cell
        }
    }
    
    
    func updateSnapshot(on places: [BTPlace], isFiltering: Bool = false) {
        let objectIDs = BTPlace.mapById(places)
        var snapshot = NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(objectIDs)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: self.animateSearchBar) }

        updateUI(with: objectIDs, isFiltering: isFiltering)
    }
}
