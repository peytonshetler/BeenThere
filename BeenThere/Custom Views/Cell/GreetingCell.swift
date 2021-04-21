//
//  WelcomeCell.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/23/21.
//

import UIKit

class GreetingCell: UITableViewCell {

    static var identifier = "GreetingCell"
    
    let label = UILabel()
    let typeImageView = UIImageView()
    let imageViewSize: CGFloat = 36
    let symbolSize: CGFloat = 34
    
    var verticalPadding: CGFloat = 12
    var horizontalPadding: CGFloat = 14

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.sizeToFit()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
            Hey there 👋

            If you experience any issues or want to leave a feature request, don't hesitate to reach out!

            -Peyton, Developer of Been There.
            """
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
}
