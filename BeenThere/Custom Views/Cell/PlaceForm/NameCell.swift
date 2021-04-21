//
//  NameCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/15/20.
//

import UIKit

protocol NameCellDelegate {
    func updateName(text: String)
}

class NameCell: UITableViewCell {

    static var identifier = "NameCell"
    
    var delegate: NameCellDelegate? = nil
    var type: FormItem!
    
    let textField = UITextField()
    var verticalPadding: CGFloat = 16
    var horizontalPadding: CGFloat = 14
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func set(itemType: FormItem, name: String, delegate: NameCellDelegate) {
        self.delegate = delegate
        self.type = itemType
        self.textField.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configure() {
        selectionStyle = .none
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        textField.becomeFirstResponder()
        
        textField.placeholder = "Name"
        textField.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
        
    }
}

extension NameCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let previousText = textField.text ?? ""
        let updatedText = NSString(string: previousText).replacingCharacters(in: range, with: string)
        
        delegate?.updateName(text: updatedText)
        return true
    }
}
