//
//  NoteCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/15/20.
//

import UIKit

protocol NoteCellDelegate {
    func updateNote(text: String)
}

class NoteCell: UITableViewCell {

    static var identifier = "NoteCell"
    
    var delegate: NoteCellDelegate? = nil
    var type: FormItem!
    
    let textView = UITextView()
    let placeholderLabel = UILabel()
    var verticalPadding: CGFloat = 14
    var horizontalPadding: CGFloat = 14
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func set(itemType: FormItem, delegate: NoteCellDelegate, previousNotes: String?) {
        self.type = itemType
        self.delegate = delegate
        
        if previousNotes != nil, !previousNotes!.isEmpty {
            textView.text = previousNotes
        } else {
            placeholderLabel.text = "Notes (optional)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configure() {
        selectionStyle = .none
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = .placeholderText
        
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainer.maximumNumberOfLines = 0
        textView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8)
        ])
        
    }

}

extension NoteCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let previousText = textView.text ?? ""
        let updatedText = NSString(string: previousText).replacingCharacters(in: range, with: text)
        
        if !updatedText.isEmpty {
            self.placeholderLabel.isHidden = true
        } else {
            self.placeholderLabel.isHidden = false
        }
        
        delegate?.updateNote(text: updatedText)
        
        return true
    }
}
