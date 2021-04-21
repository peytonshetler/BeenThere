//
//  BTPrimaryViewController.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/23/21.
//

import UIKit

class BTPrimaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Adaptive Background
extension BTPrimaryViewController {
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
