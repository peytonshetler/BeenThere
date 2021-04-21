//
//  LabelTVCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/27/21.
//

import UIKit

class BTBasicTVCell: UITableViewCell {

    static var identifier = "BTBasicTVCell"
    
    let label = UILabel()
    
    var verticalPadding: CGFloat = 14
    var horizontalPadding: CGFloat = 14
    
    var views: [UIView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(text: String) {
        self.label.text = text
    }
    
    func configure() {
        views = [label]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.sizeToFit()
        label.textAlignment = .left
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
}
