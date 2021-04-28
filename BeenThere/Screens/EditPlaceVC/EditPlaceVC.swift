//
//  EditPlaceVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/4/21.
//

import UIKit

protocol EditVCDismissedDelegate {
    func endTableviewEditing()
}

class EditPlaceVC: UITableViewController {
    
    // MARK: - Properties
    var place: BTPlace!
    
    let estimatedRowHeight: CGFloat = 50.0
    let largeSectionHeight: CGFloat = 40
    let smallSectionHeight: CGFloat = 20
    var dataSource: UITableViewDiffableDataSource<EditSection, EditItem>!

    let persistence = PersistenceService.shared
    var delegate: EditVCDismissedDelegate?
    
    let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
    var cancelButton: UIBarButtonItem!
    
    var name: String!
    var note: String!
    var currentTag: BTTag?
    var newTag: BTTag?
    var isFavorite: Bool!
    
    var tagChanged = false
    
    var shouldEnable: Bool {
        return
            (!name.isEmpty && name != place.name) ||
            tagChanged ||
            (isFavorite != place.isFavorite) ||
            (note != place.note) ?
            true :
            false
    }

    
    func handleAddButton() {
        if shouldEnable {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    init(with place: BTPlace) {
        super.init(style: .insetGrouped)
        
        self.place = place
        
        self.name = place.name
        self.currentTag = place.tag != nil ? place.tag! : nil
        self.newTag = currentTag
        self.isFavorite = place.isFavorite
        self.note = place.note
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
    
    @objc func cancelButtonTapped() {
        delegate?.endTableviewEditing()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation Bar
    func configureNavBar() {
        self.title = "Edit"
        saveButton.isEnabled = false
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    @objc func saveButtonTapped() {
        
        if name.isEmpty {
            presentBTErrorAlertOnMainThread(error: .emptyNameField, completion: nil)
            return
        }
        
        place.name = name
        place.isFavorite = isFavorite
        place.note = note
        
        guard let unwrappedTag = newTag else {
            presentBTErrorAlertOnMainThread(error: .generalError, completion: nil)
            return
        }
        
        place.tag = unwrappedTag
        
        persistence.save { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.delegate?.endTableviewEditing()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.delegate?.endTableviewEditing()
                self.presentBTErrorAlertOnMainThread(error: error, completion: nil)
            }
        }
    }
}


extension EditPlaceVC: NameCellDelegate, NoteCellDelegate, FavoriteCellDelegate, TagSelectDelegate {
    
    func updateName(text: String) {
        self.name = text
        handleAddButton()
    }
    
    func didSelectTag(tag: BTTag?) {

        if tag != nil {
            self.newTag = tag!
            let tagCell = tableView.cellForRow(at: [1, 0]) as! PlaceTagCell
            tagCell.label.text = tag!.name
            
            tagChanged = true
        } else {
            self.newTag = nil
            let tagCell = tableView.cellForRow(at: [1, 0]) as! PlaceTagCell
            tagCell.label.text = "Select a Tag"
            
            tagChanged = false
        }

        handleAddButton()
    }
    
    func updateNote(text: String) {
        self.note = text
        handleAddButton()
    }
    
    func updateFavoriteStatus(state: Bool) {
        self.isFavorite = state
        handleAddButton()
    }
}
