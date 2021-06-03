//
//  PlaceTypeCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/18/20.
//

import UIKit


class PlaceTagCell: UITableViewCell {

    static var identifier = "PlaceTagCell"
    
    var type: FormItem!
    
    let label = UILabel()
    let typeImageView = UIImageView()
    let imageViewSize: CGFloat = 30
    let symbolSize: CGFloat = 20
    
    var verticalPadding: CGFloat = 16.5
    var horizontalPadding: CGFloat = 14
    
    
    var views: [UIView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func set(itemType: FormItem, tagCount: Int) {
        self.type = itemType
        
        label.text = "\(tagCount) tags selected"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure() {
        self.accessoryType = .disclosureIndicator
        views = [typeImageView, label]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular, scale: .small)
        typeImageView.image = UIImage(systemName: SFSymbols.tagFill, withConfiguration: config)
        typeImageView.tintColor = .white
        typeImageView.contentMode = .center
        typeImageView.backgroundColor = .systemOrange
        typeImageView.clipsToBounds = true
        typeImageView.layer.cornerRadius = 5
        
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.text = "Select a Tag"
        
        NSLayoutConstraint.activate([
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            typeImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 4),
            
            label.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
}
