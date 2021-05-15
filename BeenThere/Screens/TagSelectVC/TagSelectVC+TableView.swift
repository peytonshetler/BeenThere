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
            
            // selected ALREADY selected cell
            if let selectedTagIndexPath = selectedTagIndexPath, selectedTagIndexPath == indexPath {
                
                // Handle de-checking of previous cell
                let previousTagCell = tableView.cellForRow(at: selectedTagIndexPath) as! TagSelectCell
                previousTagCell.hideCheck()
                
                delegate?.didSelectTag(tag: nil)
                
                return
            } else {
                // selected NEW cell
                delegate?.didSelectTag(tag: tag)
                
                // Handle de-checking of previous cell
                if selectedTagIndexPath != nil {
                    let previousTagCell = tableView.cellForRow(at: selectedTagIndexPath!) as! TagSelectCell
                    previousTagCell.hideCheck()
                }
                
                let newTagCell = tableView.cellForRow(at: indexPath) as! TagSelectCell
                newTagCell.showCheck()
                
                selectedTag = tag
                selectedTagIndexPath = indexPath
            }
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
}
