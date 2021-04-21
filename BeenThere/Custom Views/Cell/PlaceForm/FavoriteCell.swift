//
//  FavoriteCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/20/20.
//

import UIKit

protocol FavoriteCellDelegate {
    func updateFavoriteStatus(state: Bool)
}

class FavoriteCell: UITableViewCell {

    static var identifier = "FavoriteCell"
    
    var delegate: FavoriteCellDelegate? = nil
    var type: FormItem!
    
    var isFavoriteState: Bool = false {
        didSet {
            delegate?.updateFavoriteStatus(state: isFavoriteState)
        }
    }
    
    let favoriteImageView = UIImageView()
    let favoriteSwitch = UISwitch()
    let imageViewSize: CGFloat = 30
    let symbolSize: CGFloat = 20
    let titleLabel = UILabel()
    
    var padding: CGFloat = 15
    
    var views: [UIView] = []
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    func set(itemType: FormItem, delegate: FavoriteCellDelegate, isFavorite: Bool) {
        self.type = itemType
        self.delegate = delegate
        
        if isFavorite {
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
        selectionStyle = .none
        views = [favoriteImageView, titleLabel, favoriteSwitch]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        favoriteSwitch.addTarget(self, action: #selector(switchDidChange), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular, scale: .small)
        favoriteImageView.image = UIImage(systemName: SFSymbols.favoriteFill, withConfiguration: config)
        favoriteImageView.tintColor = .white
        favoriteImageView.contentMode = .center
        favoriteImageView.backgroundColor = .systemYellow
        favoriteImageView.clipsToBounds = true
        favoriteImageView.layer.cornerRadius = 5
        
        titleLabel.text = "Add to Favorites?"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            favoriteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            favoriteImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 3),
            
            titleLabel.leadingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            favoriteSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding - 2),
            favoriteSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding + 2),
            favoriteSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
    }
}
