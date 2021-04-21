//
//  BTMapViewNavigationController.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/30/20.
//

import UIKit

class BTMapViewNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        
        navigationBar.standardAppearance = navAppearance
        navigationBar.scrollEdgeAppearance = navAppearance
        navigationController?.navigationBar.compactAppearance = navAppearance
    }
}
