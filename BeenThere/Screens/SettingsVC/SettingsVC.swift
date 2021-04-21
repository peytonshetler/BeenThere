//
//  SettingsVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 12/22/20.
//

import UIKit

class SettingsVC: BTPrimaryTableViewController {
    
    var doneButton: UIBarButtonItem!

    let estimatedRowHeight: CGFloat = 50.0
    let smallSectionHeight: CGFloat = 20
    let largeSectionHeight: CGFloat = 30
    var dataSource: UITableViewDiffableDataSource<SettingsSection, SettingsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureDataSource()
        updateSnapshot()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        
        if let roundedTitleDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.rounded)?
            .withSymbolicTraits(.traitBold) {
            navigationController?.navigationBar
                .largeTitleTextAttributes = [
                    .font: UIFont(descriptor: roundedTitleDescriptor, size: 0)
                ]
        }

    }
    
    
    func configureNavBar() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
