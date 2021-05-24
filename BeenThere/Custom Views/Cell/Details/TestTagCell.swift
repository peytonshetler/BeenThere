//
//  TestTagCell.swift
//  BeenThere
//
//  Created by Peyton Shetler on 5/23/21.
//

import UIKit

class TestTagCell: UICollectionViewCell {
    
    static var identifier = "TestTagCell"
    let imageView = UIImageView()
    let imageViewSize: CGFloat = 30
    let symbolSize: CGFloat = 26
    let label = UILabel()
    
    var views: [UIView] = []

    var verticalPadding: CGFloat = 16.5
    var horizontalPadding: CGFloat = 14
    
    var tagItem: TagItem!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(tag: TagItem) {
        self.tagItem = tag
        label.text = self.tagItem.name
    }
    
    
    func configure() {
        views = [label, imageView]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.layer.cornerRadius = 10
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        
        contentView.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

