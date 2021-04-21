//
//  TagSelectCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 4/9/21.
//

import UIKit

protocol TagSelectedDelegate {
    func tagSelected(tag: BTTag)
}

class TagSelectCell: UITableViewCell {

    static var identifier = "TagSelectCell"
    
    let label = UILabel()
    let tagImageView = UIImageView()
    let imageViewSize: CGFloat = 30
    let checkImageView = UIImageView()
    let symbolSize: CGFloat = 22
    var placeTag: BTTag!
    
    var delegate: TagSelectedDelegate?
    
    var isSelectedTag: Bool = false {
        didSet {
            handleSelect(isSelected: isSelectedTag)
        }
    }
    
    var verticalPadding: CGFloat = 16
    var horizontalPadding: CGFloat = 14
    
    var views: [UIView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    func set(tag: BTTag, shouldShowCheck: Bool? = false) {
        label.text = tag.name
        self.placeTag = tag
        
        if shouldShowCheck! {
            showCheck()
        } else {
            hideCheck()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleSelect(isSelected: Bool? = false) {
        if isSelected! {
            showCheck()
        } else {
            hideCheck()
        }
        
        delegate?.tagSelected(tag: placeTag)
    }
    
    
    func showCheck() {
        checkImageView.isHidden = false
    }
    
    func hideCheck() {
        checkImageView.isHidden = true
    }
    
    func configure() {
        views = [tagImageView, label, checkImageView]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.selectionStyle = .none
        let typeConfig = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular, scale: .small)
        tagImageView.image = UIImage(systemName: SFSymbols.tag, withConfiguration: typeConfig)
        tagImageView.tintColor = .secondaryLabel
        tagImageView.contentMode = .center
        tagImageView.backgroundColor = .clear
        tagImageView.clipsToBounds = true
        
        let checkConfig = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .medium, scale: .small)
        checkImageView.image = UIImage(systemName: SFSymbols.checkmark, withConfiguration: checkConfig)
        checkImageView.tintColor = .systemBlue
        checkImageView.contentMode = .center
        checkImageView.backgroundColor = .clear
        checkImageView.clipsToBounds = true
        
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            tagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            tagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            tagImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 4),
            
            checkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            checkImageView.widthAnchor.constraint(equalToConstant: imageViewSize - 4),
            
            label.leadingAnchor.constraint(equalTo: tagImageView.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: checkImageView.leadingAnchor, constant: -4),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
