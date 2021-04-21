//
//  BTTableViewController.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/7/20.
//

import UIKit

class BTPrimaryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Adaptive Background
extension BTPrimaryTableViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUIStyle()
    }
    
    func updateUIStyle() {
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
    }
}
