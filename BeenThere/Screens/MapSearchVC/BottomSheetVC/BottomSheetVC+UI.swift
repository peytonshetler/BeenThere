//
//  BottomSheetVC+UI.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 1/30/21.
//

import UIKit

extension BottomSheetVC {

    func layoutUI() {
        view.backgroundColor = .secondarySystemGroupedBackground
        
        views = [mainStackView, addButton, nameLabel, nameAndButtonStackView, separatorView, separator, addressLabel, addressStackView, addressImageView, phoneNumberStackView, phoneImageView, phoneNumberLabel, urlLabel, urlStackView, urlImageView]

        for subView in views {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }


        addButton.layer.cornerRadius = 10
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .systemBlue

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 1
        nameLabel.minimumScaleFactor = 0.7
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.adjustsFontSizeToFitWidth = true
        
        nameAndButtonStackView.axis = .horizontal
        nameAndButtonStackView.alignment = .center
        nameAndButtonStackView.spacing = 14
        nameAndButtonStackView.addArrangedSubview(nameLabel)
        nameAndButtonStackView.addArrangedSubview(addButton)
        
        separator.backgroundColor = .separator
        separatorView.addSubview(separator)
        
        let config = Helpers.Symbol.imageConfig(size: 26, weight: .regular, scale: .small)
        
        addressImageView.contentMode = .top
        addressImageView.image = UIImage.init(systemName: SFSymbols.pin, withConfiguration: config)
        addressImageView.tintColor = .secondaryLabel
        
        addressLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        addressLabel.textAlignment = .left
        addressLabel.textColor = .secondaryLabel
        addressLabel.numberOfLines = 3
        addressLabel.lineBreakMode = .byTruncatingTail
        
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        phoneNumberLabel.textAlignment = .left
        phoneNumberLabel.textColor = .secondaryLabel
        phoneNumberLabel.numberOfLines = 1
        phoneNumberLabel.lineBreakMode = .byTruncatingTail
        
        phoneImageView.contentMode = .top
        phoneImageView.image = UIImage.init(systemName: SFSymbols.phoneFill, withConfiguration: config)
        phoneImageView.tintColor = .secondaryLabel
        
        urlLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        urlLabel.textAlignment = .left
        urlLabel.textColor = .secondaryLabel
        urlLabel.numberOfLines = 2
        urlLabel.lineBreakMode = .byTruncatingTail
        
        urlImageView.contentMode = .top
        urlImageView.image = UIImage.init(systemName: SFSymbols.safariFill, withConfiguration: config)
        urlImageView.tintColor = .secondaryLabel
        
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        //mainStackView.addArrangedSubview(shadowImage)
        mainStackView.addArrangedSubview(nameAndButtonStackView)
        mainStackView.addArrangedSubview(separatorView)
        
        addressStackView.axis = .horizontal
        addressStackView.spacing = 10
        addressStackView.addArrangedSubview(addressImageView)
        addressStackView.addArrangedSubview(addressLabel)
        
        phoneNumberStackView.axis = .horizontal
        phoneNumberStackView.spacing = 10
        phoneNumberStackView.addArrangedSubview(phoneImageView)
        phoneNumberStackView.addArrangedSubview(phoneNumberLabel)
        
        urlStackView.axis = .horizontal
        urlStackView.spacing = 10
        urlStackView.addArrangedSubview(urlImageView)
        urlStackView.addArrangedSubview(urlLabel)
        
        view.addSubview(addressStackView)
        view.addSubview(phoneNumberStackView)
        view.addSubview(urlStackView)
        

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nameAndButtonStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 14),
            nameAndButtonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -14),
            nameAndButtonStackView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameAndButtonStackView.leadingAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: nameAndButtonStackView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 52),
            addButton.widthAnchor.constraint(equalToConstant: 72),
            
            separatorView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 14),
            separatorView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -14),
            separatorView.heightAnchor.constraint(equalToConstant: 14),
            
            separator.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            separator.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.6),
            
            addressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            addressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            addressStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
            
            addressImageView.widthAnchor.constraint(equalToConstant: 30),
            
            phoneNumberStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            phoneNumberStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            phoneNumberStackView.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 15),
            
            phoneImageView.widthAnchor.constraint(equalToConstant: 30),
            
            urlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            urlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            urlStackView.topAnchor.constraint(equalTo: phoneNumberStackView.bottomAnchor, constant: 15),
            
            urlImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    func addShadows() {
        setShadowOpacity()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }


    func roundViews() {
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
    }
}


// MARK: - Adaptive Background
extension BottomSheetVC {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setShadowOpacity()
    }

    func setShadowOpacity() {
        if traitCollection.userInterfaceStyle == .light {
            view.layer.shadowOpacity = 0.15
        } else {
            view.layer.shadowOpacity = 0.30
        }
    }
}
