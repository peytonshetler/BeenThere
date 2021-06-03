//
//  AddPlaceVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 11/28/20.
//

import UIKit
import CoreData
import MapKit


class AddPlaceVC: UITableViewController {

    // MARK: - Properties
    var item: MKMapItem!
    
    let estimatedRowHeight: CGFloat = 50.0
    let largeSectionHeight: CGFloat = 40
    let smallSectionHeight: CGFloat = 20
    var dataSource: UITableViewDiffableDataSource<FormSection, FormItem>!

    let persistence = PersistenceService.shared

    let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))

    var name: String = ""
    var note: String?
    var selectedTags: [BTTag] = []
    var isFavorite: Bool = false
    
    var tagChanged: Bool = false
    
    var shouldEnable: Bool {
        return (!name.isEmpty && item != nil) ? true : false
    }
    
    func handleAddButton() {
        if shouldEnable {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
    
    init(with item: MKMapItem) {
        super.init(style: .insetGrouped)
        
        populate(item: item)
    }

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureDataSource()
        updateSnapshot()
        configureTableView()
    }
    
    func populate(item: MKMapItem) {
        self.item = item

        self.name = item.name ?? ""
    }


    // MARK: - Navigation Bar
    func configureNavBar() {
        self.title = "New Place"

        navigationItem.rightBarButtonItem = addButton
    }


    @objc func addButtonTapped() {
        
        // TO DO: Move all of this into savePlace function
        if name.isEmpty {
            presentBTErrorAlertOnMainThread(error: .emptyNameField, completion: nil)
            return
        }
        
        let placeExists = persistence.placeExists(name: name)
        
        if placeExists {
            presentBTErrorAlertOnMainThread(error: .duplicatePlace, completion: nil)
            return
        }
        
        // TO DO: turn this into a dictionary
        persistence.savePlace(name: name, isFavorite: isFavorite, note: note, item: item) { (result) in

            switch result {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
            }
        }
    }
}


extension AddPlaceVC: NameCellDelegate, NoteCellDelegate, FavoriteCellDelegate, TagSelectDelegate {
    
    func didSelectTags(tags: [BTTag]) {
        
        let tagCell = tableView.cellForRow(at: [1, 0]) as! PlaceTagCell
        tagChanged = true
        
        selectedTags = tags
        
        if tags.count > 0 {
            tagCell.label.text = "\(tags.count) tags selected"
        } else {
            tagCell.label.text = "Select a Tag"
        }
        
        handleAddButton()
    }
    
    func updateName(text: String) {
        self.name = text
        handleAddButton()
    }
    
    func updateNote(text: String) {
        self.note = text
    }
    
    func updateFavoriteStatus(state: Bool) {
        self.isFavorite = state
    }
}

