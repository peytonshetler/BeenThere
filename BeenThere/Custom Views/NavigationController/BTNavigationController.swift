//
//  BTNavigationController.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 2/4/21.
//

import UIKit

class BTNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        navigationBar.prefersLargeTitles = true
        setNavigationBarHidden(false, animated: true)
    }

}
