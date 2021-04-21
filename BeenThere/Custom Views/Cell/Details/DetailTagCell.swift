//
//  DetailListCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/19/21.
//

import UIKit

class DetailTagCell: UICollectionViewCell {
    
    static var identifier = "TagCell"
    let imageView = UIImageView()
    let imageViewSize: CGFloat = 30
    let symbolSize: CGFloat = 26
    let label = UILabel()
    
    var views: [UIView] = []

    var verticalPadding: CGFloat = 16.5
    var horizontalPadding: CGFloat = 14
    
    var item: DetailItem!
    var placeTag: BTTag?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: DetailItem, tag: BTTag?) {
        self.item = item
        
        if tag != nil {
            self.placeTag = tag
            label.text = self.placeTag!.name
        }
    }
    
    
    func configure() {
        views = [label, imageView]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        updateUIStyle()
        contentView.layer.cornerRadius = 10
        
        let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular, scale: .small)
        imageView.image = UIImage(systemName: SFSymbols.tagFill, withConfiguration: config)
        imageView.tintColor = .systemOrange
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: imageViewSize - 4),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}


// MARK: - Adaptive Background
extension DetailTagCell {
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
