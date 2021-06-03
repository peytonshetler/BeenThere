//
//  TagSelectVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 4/9/21.
//

import UIKit
import CoreData

protocol TagSelectDelegate {
    func didSelectTags(tags: [BTTag])
}

private enum Section { case main }

private class BTTagSelectDiffibleDataSource: UITableViewDiffableDataSource<Section, NSManagedObjectID> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}


class TagSelectVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    let rowHeight: CGFloat = 50
    
    private var dataSource: BTTagSelectDiffibleDataSource!
    
    var emptyStateView: BTEmptyStateView?
    
    weak var actionToEnable : UIAlertAction?
    
    var delegate: TagSelectDelegate?

    let persistence = PersistenceService.shared
    var fetchedResultsController: NSFetchedResultsController<BTTag>!
    let searchPlaceholder = "Search Tags"
    
    var place: BTPlace?
    var filteredTags: [BTTag] = []
    
    var selectedTags: [BTTag] = [] {
        didSet {
            delegate?.didSelectTags(tags: selectedTags)
//            if selectedTags != nil {
//                delegate?.didSelectTags(tags: selectedTags!)
//            }
        }
    }
    
    var selectedTagIndexPath: IndexPath?
    var selectedTagIndexPaths: [IndexPath] = []
    
    var tagNames: [String] {
        return BTTag.mapByName(fetchedResultsController.fetchedObjects ?? [])
    }
    
    // MARK: - Animation Checks
    var animateSearchBar: Bool = false
    var viewHasLoaded: Bool = false
    var tableViewVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureSearchController()
        configureTableView()
        configureDataSource()
        fetchTags()
    }

    
    init(place: BTPlace? = nil, tags: [BTTag] = []) {
        super.init(style: .insetGrouped)
        self.place = place
        
        self.selectedTags = tags
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    func configureDataSource() {
        dataSource = BTTagSelectDiffibleDataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: TagSelectCell.identifier, for: indexPath) as! TagSelectCell
            cell.delegate = self
            let tag = self.fetchedResultsController.object(at: indexPath)
            
            var isSelected: Bool = false
            
            if self.selectedTags.count > 0 {
                isSelected = self.selectedTags.contains(where: { $0.id == tag.id })
                // OLD WAY
                //isSelected = self.selectedTag!.objectID === tag.objectID ? true : false
            }
            
            if isSelected {
                self.selectedTagIndexPath = indexPath
            }
            
            cell.set(tag: tag, shouldShowCheck: isSelected)
            return cell
        }
    }
    
    func updateSnapshot(on tags: [BTTag], isFiltering: Bool = false) {
        let objectIDs = BTTag.mapById(tags)
        var snapshot = NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(objectIDs)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: self.animateSearchBar) }

        updateUI(with: objectIDs, isFiltering: isFiltering)
    }
    
    
    func fetchTags() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<BTTag>(entityName: "BTTag")
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistence.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            updateSnapshot(on: fetchedResultsController.fetchedObjects ?? [], isFiltering: false)
        } catch {
            presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
        }
    }
    
    
    func createTag(text: String) {
        let tag = BTTag(context: persistence.context)
        tag.name = text
        
        persistence.save { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success: return ()
            case .failure(let error):
                self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
            }
        }
    }
    
    
    @objc func textChanged(sender: UITextField) {
        if let text = sender.text, !text.isEmpty, !tagNames.contains(text) {
            self.actionToEnable?.isEnabled = true
        } else {
            self.actionToEnable?.isEnabled = false
        }
    }
    
    @objc func presentNewTagAlert() {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Create Tag", message: nil, preferredStyle: .alert)

            let defaultAction = UIAlertAction(title: "Create", style: .default) { (action) in
                if let textfield = alert.textFields?[0], let text = textfield.text, !text.isEmpty {
                    self.createTag(text: text)
                }
            }
            alert.addAction(defaultAction)
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            alert.addTextField { (textField) in
                textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
            }

            self.actionToEnable = defaultAction
            alert.actions[0].isEnabled = false
            self.present(alert, animated: true)
        }
    }
}


extension TagSelectVC: TagSelectedDelegate {
    
    func tagSelected(tag: BTTag) {
        selectedTags.append(tag)
    }
}
