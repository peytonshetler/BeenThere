//
//  PlaceCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 11/30/20.
//

import UIKit

class PlaceCell: UITableViewCell {

    static let identifier = "PlaceCell"
    var place: BTPlace!
    
    let nameLabel = UILabel()
    let favoriteImageView = UIImageView()
   
    let addressLabel = UILabel()
    let tagImageView = UIImageView()
    let tagLabel = UILabel()
    
    let tagConfig = Helpers.Symbol.imageConfig(size: 22, weight: .regular, scale: .small)
    let favoriteConfig = Helpers.Symbol.imageConfig(size: 30, weight: .regular, scale: .small)
    
    let tagStackView = UIStackView()
    let mainStack = UIStackView()
    
    let padding: CGFloat = 20
    let favoriteImageSize: CGFloat = 26
    let tagImageSize: CGFloat = 22
    let locationImageSize: CGFloat = 20
    var views: [UIView] = []
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(place: BTPlace) {
        self.place = place
        
        nameLabel.text = place.name
        tagLabel.text = place.tag != nil ? place.tag!.name : "--"
        
        let city = place.location != nil ? place.location!.locality : ""
        let state = place.location != nil ? place.location!.administrativeArea : ""
        
        if (city.isEmpty || state.isEmpty) {
            addressLabel.text = city + state
        } else {
            addressLabel.text = "\(city), \(state)"
        }
        
        
        if place.isFavorite == true {
            favoriteImageView.image = UIImage(systemName: SFSymbols.favoriteFill, withConfiguration: favoriteConfig)
        } else {
            favoriteImageView.image = UIImage(systemName: SFSymbols.favorite, withConfiguration: favoriteConfig)
        }
    }
    
    
    func configure() {
        views = [mainStack, favoriteImageView]

        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        nameLabel.textAlignment = .left
        nameLabel.textColor = .label
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        favoriteImageView.contentMode = .center
        favoriteImageView.tintColor = .systemYellow
        
        addressLabel.textAlignment = .left
        addressLabel.textColor = .secondaryLabel
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        tagImageView.image = UIImage(systemName: SFSymbols.tag, withConfiguration: tagConfig)
        tagImageView.contentMode = .center
        tagImageView.tintColor = .secondaryLabel

        tagLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tagLabel.textAlignment = .left
        tagLabel.textColor = .secondaryLabel
        tagLabel.lineBreakMode = .byTruncatingTail
        
        tagStackView.axis = .horizontal
        tagStackView.alignment = .leading
        tagStackView.spacing = 4
        tagStackView.sizeToFit()
        tagStackView.addArrangedSubview(tagImageView)
        tagStackView.addArrangedSubview(tagLabel)
        
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.sizeToFit()
        mainStack.addArrangedSubview(nameLabel)
        mainStack.addArrangedSubview(addressLabel)
        mainStack.addArrangedSubview(tagStackView)
    }
    
    
    
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: favoriteImageView.leadingAnchor, constant: -padding),
            
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            favoriteImageView.heightAnchor.constraint(equalToConstant: favoriteImageSize + 6),
            favoriteImageView.widthAnchor.constraint(equalToConstant: favoriteImageSize),
            
            tagImageView.heightAnchor.constraint(equalToConstant: tagImageSize + 4),
            tagImageView.widthAnchor.constraint(equalToConstant: tagImageSize),
            tagImageView.centerYAnchor.constraint(equalTo: tagStackView.centerYAnchor),
            
            tagLabel.centerYAnchor.constraint(equalTo: tagStackView.centerYAnchor),
        ])
    }
}
