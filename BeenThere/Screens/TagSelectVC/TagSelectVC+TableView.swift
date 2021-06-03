//
//  TagSelectVC+TableView.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 4/11/21.
//

import UIKit

extension TagSelectVC {
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = rowHeight
        tableView.delegate = self
        tableView.register(TagSelectCell.self, forCellReuseIdentifier: TagSelectCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTap(tableView: tableView, indexPath: indexPath)
    }
    
    
    func handleTap(tableView: UITableView, indexPath: IndexPath) {
        
        if !(fetchedResultsController.fetchedObjects ?? []).isEmpty {
            
            let tag = fetchedResultsController.fetchedObjects![indexPath.row]
            
            // selected an ALREADY selected cell
//            if let selectedTagIndexPath = selectedTagIndexPath, selectedTagIndexPath == indexPath {
//
//                // Handle de-checking of previous cell
//                let previousTagCell = tableView.cellForRow(at: selectedTagIndexPath) as! TagSelectCell
//                previousTagCell.hideCheck()
//
//                delegate?.didSelectTag(tag: [nil])
//
//                return
//            } else {
//                // selected NEW cell
//                delegate?.didSelectTag(tag: tag)
//
//                // Handle de-checking of previous cell
//                if selectedTagIndexPath != nil {
//                    let previousTagCell = tableView.cellForRow(at: selectedTagIndexPath!) as! TagSelectCell
//                    previousTagCell.hideCheck()
//                }
//
//                let newTagCell = tableView.cellForRow(at: indexPath) as! TagSelectCell
//                newTagCell.showCheck()
//
//                selectedTag = tag
//                selectedTagIndexPath = indexPath
//            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! TagSelectCell

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            
            let actionSheet = UIAlertController(title: nil, message: "Delete this tag?", preferredStyle: .actionSheet)
            
            let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
                guard let self = self else { return }
                
                self.persistence.context.delete(cell.placeTag)
    
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
    
        
        let configuration =  UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
}
