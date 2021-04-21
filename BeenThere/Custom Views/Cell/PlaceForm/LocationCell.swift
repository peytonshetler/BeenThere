//
//  LocationCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/18/20.
//

import UIKit

protocol LocationCellDelegate {
    func updateLocation(text: String)
}

class LocationCell: UITableViewCell {

    static var identifier = "LocationCell"
    
    var delegate: LocationCellDelegate? = nil
    var type: FormItem!
    
    let locationImageView = UIImageView()
    let imageViewSize: CGFloat = 30
    let addressLabel = UILabel()
    let symbolSize: CGFloat = 20
    
    var verticalPadding: CGFloat = 17
    var horizontalPadding: CGFloat = 14
    
    var spacer: CGFloat = 12
    
    var views: [UIView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func set(itemType: FormItem, address: String) {
        self.type = itemType
        self.addressLabel.text = address
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configure() {
        selectionStyle = .none
        
        views = [locationImageView, addressLabel]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular, scale: .small)
        locationImageView.image = UIImage(systemName: SFSymbols.location, withConfiguration: config)
        locationImageView.tintColor = .white
        locationImageView.contentMode = .center
        locationImageView.backgroundColor = .systemBlue
        locationImageView.clipsToBounds = true
        locationImageView.layer.cornerRadius = 5
        
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            locationImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            locationImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            locationImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            locationImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 3),
            
            addressLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: spacer),
            addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -horizontalPadding)
        ])
    }
}
