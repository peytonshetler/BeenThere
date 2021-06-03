//
//  DetailNoteCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/3/21.
//

import UIKit

protocol DetailNoteCellDelegate {
    func updatePlaceNote(note: String)
}

class DetailNoteCell: UICollectionViewCell {

    static var identifier = "DetailNoteCell"
    
    var note: String!
    
    let label = UILabel()
    let noteTextView = UITextView()
    
    var delegate: DetailNoteCellDelegate?
    
    var padding: CGFloat = 15
    
    var views: [UIView] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    
    func set(note: String?, delegate: DetailNoteCellDelegate) {
        self.note = note
        self.delegate = delegate
        
        noteTextView.text = note
        noteTextView.resolveTags()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func configure() {
        views = [label, noteTextView]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.layer.cornerRadius = 10
        
        label.sizeToFit()
        label.text = "Notes"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        
        noteTextView.textColor = .secondaryLabel
        noteTextView.backgroundColor = .clear
        noteTextView.font = UIFont.systemFont(ofSize: 18)
        noteTextView.textContainerInset = .zero
        noteTextView.textContainer.lineFragmentPadding = 0.0
        noteTextView.delegate = self
        
        updateUIStyle()
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            noteTextView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            noteTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
}


// MARK: - Adaptive Background
extension DetailNoteCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUIStyle()
    }
    
    func updateUIStyle() {
        if traitCollection.userInterfaceStyle == .light {
            contentView.backgroundColor = .systemBackground
            
        } else {
            contentView.backgroundColor = .secondarySystemBackground
        }
    }
}


extension DetailNoteCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let previousText = textView.text ?? ""
        let updatedText = NSString(string: previousText).replacingCharacters(in: range, with: text)
        
        delegate?.updatePlaceNote(note: updatedText)
        
        return true
    }
}
