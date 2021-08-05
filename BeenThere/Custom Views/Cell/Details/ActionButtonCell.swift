//
//  ActionButtonsCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/3/21.
//

import UIKit

class ActionButtonCell: UICollectionViewCell {
    
    static var identifier = "ActionButtonCell"
    let imageView = UIImageView()
    
    var item: DetailItem!
    var place: BTPlace!
    let config = Helpers.Symbol.imageConfig(size: 30, weight: .regular, scale: .small)
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: DetailItem, place: BTPlace) {
        self.item = item
        self.place = place
        
        switch item {
        case .phone:
            imageView.image = UIImage(systemName: SFSymbols.phoneFill, withConfiguration: config)
            
            if let location = place.location, !location.phoneNumber.isEmpty {
                imageView.tintColor = .systemBlue
            } else {
                imageView.tintColor = .secondaryLabel
            }
            
        case .safari:
            imageView.image = UIImage(systemName: SFSymbols.safari, withConfiguration: config)

            if let location = place.location, !location.url.isEmpty {
                imageView.tintColor = .systemBlue
            } else {
                imageView.tintColor = .secondaryLabel
            }
            
        case .share:
            imageView.image = UIImage(systemName: SFSymbols.squareArrowUp, withConfiguration: config)
            imageView.tintColor = .systemBlue
        case .navigate:
            imageView.image = UIImage(systemName: SFSymbols.locationFill, withConfiguration: config)
            imageView.tintColor = .systemBlue
        case .map, .favorite, .note, .tag: return ()
        }
        
    }
    
    
    func configure() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        updateUIStyle()
        
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}


// MARK: - Adaptive Background
extension ActionButtonCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUIStyle()
    }
    
    func updateUIStyle() {
        if traitCollection.userInterfaceStyle == .light {
            imageView.backgroundColor = .systemBackground
        } else {
            imageView.backgroundColor = .secondarySystemBackground
        }
    }
}
