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
    var tag: BTTag?
    var isFavorite: Bool = false
    
    var shouldEnable: Bool {
        return (!name.isEmpty && tag != nil && tag!.id != nil && item != nil) ? true : false
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
        addButton.isEnabled = false

        navigationItem.rightBarButtonItem = addButton
    }


    @objc func addButtonTapped() {
        
        if name.isEmpty {
            presentBTErrorAlertOnMainThread(error: .emptyNameField, completion: nil)
            return
        }
        
        let placeExists = persistence.placeExists(name: name)
        
        if placeExists {
            presentBTErrorAlertOnMainThread(error: .duplicatePlace, completion: nil)
            return
        }
        
        guard let unwrappedTag = tag else {
            presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
            return
        }
        
        persistence.savePlace(name: name, isFavorite: isFavorite, note: note, tag: unwrappedTag, item: item) { (result) in

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
    
    func didSelectTag(tag: BTTag) {
        self.tag = tag
        let tagCell = tableView.cellForRow(at: [1, 0]) as! PlaceTagCell
        tagCell.label.text = tag.name
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
