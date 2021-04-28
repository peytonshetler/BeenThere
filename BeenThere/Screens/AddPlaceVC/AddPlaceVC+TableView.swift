//
//  AddPlaceVC+TableView.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/1/21.
//

import UIKit
import MapKit

extension AddPlaceVC {
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<FormSection, FormItem>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in

            switch item {
            case .name:
                let cell = tableView.dequeueReusableCell(withIdentifier: NameCell.identifier, for: indexPath) as! NameCell

                cell.set(itemType: .name, name: self.name, delegate: self)
                
                return cell
            case .notes:
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
                
                cell.set(itemType: .notes, delegate: self, previousNotes: nil)
                
                return cell
            case .type:
                let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTagCell.identifier, for: indexPath) as! PlaceTagCell
                
                cell.set(itemType: .type, tag: nil)
                
                return cell
            case .favorite:
                let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
                
                cell.set(itemType: .favorite, delegate: self, isFavorite: false)
                
                return cell
            }
        }
    }


    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<FormSection, FormItem>()
        snapshot.appendSections(FormSection.allCases)

        for section in FormSection.allCases {
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
        configureFooterView(item: item, section: section)
    }
    

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? largeSectionHeight : smallSectionHeight
    }
    
        
    func configureFooterView(item: MKMapItem, section: Int) -> UIView? {
        let footer = UIView()
        var views: [UIView] = []
        
        footer.backgroundColor = .clear
        
        if section == 0 {
            let imageView = UIImageView()
            let label = UILabel()
            
            views = [imageView, label]
            for view in views {
                footer.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let config = Helpers.Symbol.imageConfig(size: 16, weight: .regular, scale: .small)
            imageView.image = UIImage(systemName: SFSymbols.location, withConfiguration: config)
            imageView.backgroundColor = .clear
            imageView.tintColor = .secondaryLabel
            imageView.contentMode = .center
            
            label.textColor = .secondaryLabel
            label.font = UIFont.systemFont(ofSize: 14)
            
            label.text = Helpers.Location.parseAddress(selectedItem: item.placemark)
            label.lineBreakMode = .byTruncatingTail
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 6),
                imageView.topAnchor.constraint(equalTo: footer.topAnchor, constant: 2),
                imageView.heightAnchor.constraint(equalToConstant: 18),
                imageView.widthAnchor.constraint(equalToConstant: 18),
                
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
                label.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -6),
                label.topAnchor.constraint(equalTo: footer.topAnchor, constant: 2)
            ])
            
            return footer
        }
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .type:
            let destVC = TagSelectVC(tag: newTag)
            destVC.delegate = self
            navigationController?.pushViewController(destVC, animated: true)
        case .name, .notes, .favorite: return ()
        }
    }
}


enum FormSection: CaseIterable {
    case nameAndNotes
    case type
    case favorite

    var items: [FormItem] {
        switch self {
        case .nameAndNotes: return [.name, .notes]
        case .type: return [.type]
        case .favorite: return [.favorite]
        }
    }
}

enum FormItem: CaseIterable {
    case name
    case notes
    case type
    case favorite
}
