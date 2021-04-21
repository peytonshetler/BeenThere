//
//  MapSearchResultsCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/28/20.
//

import UIKit

class MapSearchResultsCell: UITableViewCell {
    
    static let identifier = "MapSearchResultsCell"
    
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let pinImageView = UIImageView()
    
    let textStackView = UIStackView()
   
    
    let pinConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .small)
    
    let padding: CGFloat = 10
    let locationImageSize: CGFloat = 20
    var views: [UIView] = []
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        configure()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String, subtitle: String) {
        self.nameLabel.text = title
        self.addressLabel.text = subtitle
    }
    
    
    func configure() {
        views = [pinImageView, nameLabel, addressLabel]

        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        pinImageView.backgroundColor = .clear
        pinImageView.tintColor = .systemOrange
        pinImageView.contentMode = .center
        pinImageView.image = UIImage(systemName: SFSymbols.mapPinCircleFill, withConfiguration: pinConfig)
        
        nameLabel.textAlignment = .left
        nameLabel.textColor = .label
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        addressLabel.textAlignment = .left
        addressLabel.textColor = .secondaryLabel
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    
    
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            pinImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            pinImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            pinImageView.widthAnchor.constraint(equalToConstant: 50),
            pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            nameLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            addressLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: padding),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding / 2),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
}
