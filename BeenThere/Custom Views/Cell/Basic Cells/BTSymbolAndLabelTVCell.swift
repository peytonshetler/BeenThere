//
//  SettingsCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/27/21.
//

import UIKit

class BTSymbolAndLabelTVCell: UITableViewCell {

    static var identifier = "BTSymbolAndLabelTVCell"
    
    let label = UILabel()
    let symbolImageView = UIImageView()
    let imageViewSize: CGFloat = 32
    
    let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small)
    
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
    
    
    func set(symbol: String, text: String, color: UIColor? = .systemBlue) {
        
        symbolImageView.image = UIImage(systemName: symbol, withConfiguration: config)
        label.text = text
        symbolImageView.tintColor = color
    }
    
    func configure() {
        views = [label, symbolImageView]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        symbolImageView.contentMode = .center
        symbolImageView.backgroundColor = .clear
        symbolImageView.clipsToBounds = true
        
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.sizeToFit()
        label.textAlignment = .left
        
        NSLayoutConstraint.activate([
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            symbolImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbolImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            symbolImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 8),
            
            label.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
}
