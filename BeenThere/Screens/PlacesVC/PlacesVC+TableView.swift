//
//  PlacesVC+TableView.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 1/30/21.
//

import UIKit

extension PlacesVC {
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = rowHeight
        tableView.delegate = self
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
    }
    
    
    @objc func showEmptyStateView() {
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        emptyStateView = BTEmptyStateView(message: "No Places", frame: size)

        tableView.backgroundView = emptyStateView
    }
    
    
    func hideEmptyStateView() {
        tableView.backgroundView = nil
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(fetchedResultsController.fetchedObjects ?? []).isEmpty {
            
            let selectedPlace = fetchedResultsController.fetchedObjects![indexPath.row]
            navigationController?.pushViewController(DetailsVC(place: selectedPlace), animated: true)
        }
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
        
        let cell = tableView.cellForRow(at: indexPath) as! PlaceCell

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            
            let actionSheet = UIAlertController(title: nil, message: "Delete \(cell.place.name)?", preferredStyle: .actionSheet)
            
            let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
                guard let self = self else { return }
                
                self.persistence.context.delete(cell.place)
    
                do {
                    try self.persistence.context.save()
                } catch {
                    self.presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
                }
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                actionSheet.dismiss(animated: true, completion: nil)
            }

            actionSheet.addAction(deleteButton)
            actionSheet.addAction(cancelButton)
            
            self.present(actionSheet, animated: true, completion: nil)
            
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completion) in
            self.editButtonTapped(place: cell.place)
        }
        
        editAction.backgroundColor = .systemGray2
        
        let configuration =  UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
    
    @objc func editButtonTapped(place: BTPlace) {
        let editVC = EditPlaceVC(with: place)
        editVC.delegate = self
        
        let destVC = UINavigationController(rootViewController: editVC)
        present(destVC, animated: true, completion: nil)
    }
}

extension PlacesVC: EditVCDismissedDelegate {
    
    func endTableviewEditing() {
        tableView.setEditing(false, animated: true)
    }
}
