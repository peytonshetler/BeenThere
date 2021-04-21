//
//  PlacesVC+UI.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/1/21.
//

import UIKit
import CoreData

extension PlacesVC {
    
    func configureVC() {
        tableViewVisible = true
       
        title = "My Places"
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [
            createPlusButton(),
            spacer,
            createFavoritesButton()
        ]
        
        navigationItem.rightBarButtonItem = createSettingsButton()
    }
    
    
    func createFavoritesButton() -> UIBarButtonItem {
        
        let image = UIImage(systemName: SFSymbols.favoriteFill, withConfiguration: Helpers.Symbol.imageConfig(size: barButtonSize - 2, weight: .medium, scale: .small))
        
        favoritesButton.tintColor = .systemYellow
        favoritesButton.setImage(image, for: .normal)
        favoritesButton.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: favoritesButton)
    }
    
    
    func createPlusButton()  -> UIBarButtonItem {
        let plusImageView = UIImageView()
        let image = UIImage(systemName: SFSymbols.magnifyingGlassCircleFill, withConfiguration: Helpers.Symbol.imageConfig(size: barButtonSize, weight: .regular, scale: .small))
        
        plusImageView.image = image
        plusImageView.contentMode = .center
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addSubview(plusImageView)
        
        let plusLabel = UILabel()
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addSubview(plusLabel)
        
        plusLabel.font = Helpers.Font.roundedFont(ofSize: 18, weight: .medium)
        plusLabel.text = "Explore"
        plusLabel.textColor = .systemBlue
        
        NSLayoutConstraint.activate([
            plusImageView.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            plusImageView.topAnchor.constraint(equalTo: plusButton.topAnchor),
            plusImageView.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor),
            plusImageView.widthAnchor.constraint(equalToConstant: barButtonSize),
            
            plusLabel.leadingAnchor.constraint(equalTo: plusImageView.trailingAnchor, constant: 6),
            plusLabel.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor),
            plusLabel.topAnchor.constraint(equalTo: plusButton.topAnchor),
            plusLabel.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor)
        ])
        
        
        plusButton.tintColor = .systemBlue
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: plusButton)
    }
    
    
    func createSettingsButton() -> UIBarButtonItem {
        let image = UIImage(systemName: SFSymbols.gear, withConfiguration: Helpers.Symbol.imageConfig(size: barButtonSize, weight: .bold, scale: .small))
        
        settingsButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(settingsButtonTapped))
        
        settingsButton.tintColor = .secondaryLabel

        return settingsButton
    }
    
    
    @objc func favoritesButtonTapped() {
        navigationController?.pushViewController(FavoritesVC(), animated: true)
    }
    
    
    @objc func settingsButtonTapped() {
        let destVC = BTNavigationController(rootViewController: SettingsVC())
        present(destVC, animated: true, completion: nil)
    }
    
    
    @objc func plusButtonTapped() {
        let destVC = BTMapViewNavigationController(rootViewController: MapSearchVC())
        present(destVC, animated: true, completion: nil)
    }
    
    
    func updateUI(with objectIDs: [NSManagedObjectID], isFiltering: Bool = false) {
        if !isFiltering {
            if objectIDs.isEmpty {
                showEmptyStateView()
            } else {
                hideEmptyStateView()
            }
        } else {
            hideEmptyStateView()
        }
    }
}
