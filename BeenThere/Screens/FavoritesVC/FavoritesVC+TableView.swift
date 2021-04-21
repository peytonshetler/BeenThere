//
//  FavoritesVC+TableView.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 1/30/21.
//

import UIKit

extension FavoritesVC {
    
    func showEmptyStateView() {
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        emptyStateView = BTEmptyStateView(message: "No Favorites", frame: size)

        tableView.backgroundView = emptyStateView
    }
    
    func hideEmptyStateView() {
        tableView.backgroundView = nil
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = rowHeight
        tableView.delegate = self
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }


    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal, title: "Remove") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            let cell = tableView.cellForRow(at: indexPath) as! PlaceCell
            cell.place.isFavorite = false
            
            do {
                try self.persistence.context.save()
            } catch {
                self.presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
            }
            
            completion(true)
        }
        
        action.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(fetchedResultsController.fetchedObjects ?? []).isEmpty {
            
            let selectedPlace = fetchedResultsController.fetchedObjects![indexPath.row]
            navigationController?.pushViewController(DetailsVC(place: selectedPlace), animated: true)
        }
    }
}
