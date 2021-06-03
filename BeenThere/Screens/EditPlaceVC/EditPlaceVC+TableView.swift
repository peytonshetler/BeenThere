//
//  EditPlaceVC+UI.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/9/21.
//

import UIKit
import MapKit

extension EditPlaceVC {
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<EditSection, EditItem>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in

            switch item {
            case .name:
                let cell = tableView.dequeueReusableCell(withIdentifier: NameCell.identifier, for: indexPath) as! NameCell

                cell.set(itemType: .name, name: self.name, delegate: self)
                
                return cell
            case .notes:
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
                
                cell.set(itemType: .notes, delegate: self, previousNotes: self.note)
                
                return cell
            case .tag:
                let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTagCell.identifier, for: indexPath) as! PlaceTagCell
                
                cell.set(itemType: .tag, tagCount: self.selectedTags.count)
                
                return cell
            case .favorite:
                let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
                
                cell.set(itemType: .favorite, delegate: self, isFavorite: self.isFavorite)
                
                return cell
            }
        }
    }


    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<EditSection, EditItem>()
        snapshot.appendSections(EditSection.allCases)

        for section in EditSection.allCases {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }


    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.delegate = self
        tableView.register(NameCell.self, forCellReuseIdentifier: NameCell.identifier)
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
        tableView.register(PlaceTagCell.self, forCellReuseIdentifier: PlaceTagCell.identifier)
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        tableView.register(OtherCell.self, forCellReuseIdentifier: OtherCell.identifier)
    }


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? smallSectionHeight : 0
    }
    

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return smallSectionHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .tag:
            let destVC = TagSelectVC(place: place, tags: selectedTags)
            destVC.delegate = self
            navigationController?.pushViewController(destVC, animated: true)
        case .name, .notes, .favorite: return ()
        }
    }
}

enum EditSection: CaseIterable {
    case nameAndNotes
    case tag
    case favorite

    var items: [EditItem] {
        switch self {
        case .nameAndNotes: return [.name, .notes]
        case .tag: return [.tag]
        case .favorite: return [.favorite]
        }
    }
}

enum EditItem: CaseIterable {
    case name
    case notes
    case tag
    case favorite
}
