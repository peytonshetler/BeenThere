//
//  OtherCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/21/20.
//

import UIKit

class OtherCell: UITableViewCell {

    static var identifier = "OtherCell"
    
    let titleLabel = UILabel()
    
    var verticalPadding: CGFloat = 16
    var horizontalPadding: CGFloat = 14
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    func configure() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Other"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.sizeToFit()
        titleLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
        ])
    }
}

