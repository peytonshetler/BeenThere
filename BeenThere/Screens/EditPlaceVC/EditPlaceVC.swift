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
//    var currentTag: BTTag?
//    var newTag: BTTag?
    var selectedTags: [BTTag] = []
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
        self.isFavorite = place.isFavorite
        self.note = place.note
        
        if place.tags != nil && place.tags!.count > 0 {
            let tagArray = place.tags?.allObjects as? [BTTag]
            
            if tagArray != nil {
                self.selectedTags = tagArray!
            }
            
        }
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
        
        var tags: [BTTag] = []

        if let unwrappedNote = note, !unwrappedNote.isEmpty {
            place.note = note!
            
            let tagStrings = note!.getHashtags()
            
            for nameString in tagStrings {
                
                let existingTag = persistence.getTagIfExists(name: nameString)
                
                if existingTag != nil {
                    tags.append(existingTag!)
                } else {
                    let newTag = BTTag(context: persistence.context)
                    newTag.name = nameString
                    
                    tags.append(newTag)
                }
            }
        }

        
        if tags.isEmpty {
            place.tags = nil
        } else if tags.count == 1 {
            place.addToTags(tags[0])
        } else {
            
            let tagSet = NSSet(array: tags)
            place.addToTags(tagSet)
        }
        
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
    
    func didSelectTags(tags: [BTTag]) {
        
        let tagCell = tableView.cellForRow(at: [1, 0]) as! PlaceTagCell
        tagChanged = true
        
        // set selected tag aray to tags done
        
        // handle current/new tags done
        
        selectedTags = tags
        
        if tags.count > 0 {
            tagCell.label.text = "\(tags.count) tags selected"
        } else {
            tagCell.label.text = "Select a Tag"
        }
        
        handleAddButton()
    }
    
//    func didSelectTags(tag: BTTag?) {
//
//        let tagCell = tableView.cellForRow(at: [1, 0]) as! PlaceTagCell
//        tagChanged = true
//
//        if tag != nil {
//            self.newTag = tag!
//            tagCell.label.text = tag!.name
//        } else {
//            self.newTag = nil
//            tagCell.label.text = "Select a Tag"
//        }
//
//        handleAddButton()
//    }
    
    func updateNote(text: String) {
        self.note = text
        handleAddButton()
    }
    
    func updateFavoriteStatus(state: Bool) {
        self.isFavorite = state
        handleAddButton()
    }
}
