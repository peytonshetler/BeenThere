//
//  DetailFavoriteCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/24/21.
//

import UIKit

protocol DetailFavoriteCellDelegate {
    func updateFavoriteStatus(state: Bool)
}

class DetailFavoriteCell: UICollectionViewCell {

    static var identifier = "FavoriteCell"
    
    var delegate: DetailFavoriteCellDelegate? = nil
    var type: DetailItem!
    var place: BTPlace!
    
    var isFavoriteState: Bool = false {
        didSet {
            delegate?.updateFavoriteStatus(state: isFavoriteState)
        }
    }
    
    let favoriteImageView = UIImageView()
    let favoriteSwitch = UISwitch()
    let imageViewSize: CGFloat = 30
    let symbolSize: CGFloat = 26
    let titleLabel = UILabel()
    
    var padding: CGFloat = 15
    
    var views: [UIView] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    
    func set(itemType: DetailItem, place: BTPlace, delegate: DetailFavoriteCellDelegate) {
        self.type = itemType
        self.delegate = delegate
        self.place = place
        
        if self.place.isFavorite {
            favoriteSwitch.isOn = true
        } else {
            favoriteSwitch.isOn = false
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func switchDidChange() {
        if favoriteSwitch.isOn {
            isFavoriteState = true
        } else {
            isFavoriteState = false
        }
    }
    
   
    func configure() {
        views = [favoriteImageView, titleLabel, favoriteSwitch]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        favoriteSwitch.addTarget(self, action: #selector(switchDidChange), for: .touchUpInside)
        
        contentView.layer.cornerRadius = 10
        
        let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular, scale: .small)
        favoriteImageView.image = UIImage(systemName: SFSymbols.favoriteFill, withConfiguration: config)
        favoriteImageView.tintColor = .systemYellow
        favoriteImageView.contentMode = .center
        favoriteImageView.backgroundColor = .clear
        favoriteImageView.clipsToBounds = true
        favoriteImageView.layer.cornerRadius = 5
        
        titleLabel.text = "Favorite"
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.sizeToFit()
        
        updateUIStyle()
        
        NSLayoutConstraint.activate([
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            favoriteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            favoriteImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 4),
            
            titleLabel.leadingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favoriteSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
    }
}


// MARK: - Adaptive Background
extension DetailFavoriteCell {
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
