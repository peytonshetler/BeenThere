//
//  AboutLabelCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/25/21.
//

import UIKit

class BTTextTVCell: UITableViewCell {

    static var identifier = "BTTextTVCell"
    
    let label = UILabel()
    
    var verticalPadding: CGFloat = 16
    var horizontalPadding: CGFloat = 14
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configure()
    }
    
    
    func set(text: String) {
        label.text = text
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.sizeToFit()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
}
