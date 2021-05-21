//
//  TagSelectVC+UI.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 4/11/21.
//

import UIKit
import CoreData

extension TagSelectVC {
    
    
    func configureNavBar() {
        self.title = "Select Tag"
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPlusButton())
    }
    
    
    func createPlusButton() -> UIButton {
        let plusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        plusButton.addTarget(self, action: #selector(presentNewTagAlert), for: .touchUpInside)
        
        let plusImageView = UIImageView()
        plusButton.addSubview(plusImageView)
        
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusImageView.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            plusImageView.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor),
            plusImageView.topAnchor.constraint(equalTo: plusButton.topAnchor),
            plusImageView.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor)
        ])

        let imageConfig = Helpers.Symbol.imageConfig(size: 30, weight: .regular, scale: .small)
        plusImageView.image = UIImage(systemName: SFSymbols.plus, withConfiguration: imageConfig)
        plusImageView.contentMode = .center
        
        return plusButton
    }
    
    @objc func showEmptyStateView() {
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        let message = """
            No Tags.
            
            You can create a new tag using the \"plus\" button in the top right corner.
        """
        emptyStateView = BTEmptyStateView(message: message, frame: size)

        tableView.backgroundView = emptyStateView
    }
    
    
    func hideEmptyStateView() {
        tableView.backgroundView = nil
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
